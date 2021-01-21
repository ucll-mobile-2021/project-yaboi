import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/models/user.dart';
import 'package:cobok/screens/search/result_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String email) async {
    return await userCollection.document(uid).setData({
      'email': email,
    });
  }

  Future addUserGroceryList(List<Ingredient> list, String recipeName) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    list.forEach((element) async {
      return await userCollection.document(user.uid).updateData({
        'groceryList': FieldValue.arrayUnion([
          {
            'name': element.name,
            'measurement': element.measurement,
            'amount': element.amount,
            'recipeName': recipeName,
          }
        ]),
      });
    });
  }

  Future removeUserGroceryList(List<Ingredient> list, String recipeName) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    list.forEach((element) async {
      return await userCollection.document(user.uid).updateData({
        'groceryList': FieldValue.arrayRemove([
          {
            'name': element.name,
            'measurement': element.measurement,
            'amount': element.amount,
            'recipeName': recipeName,
          }
        ]),
      });
    });
  }

  /*
  List<String> getIngredientNames(List<Ingredient> ingredients) {
    List<String> ingredientNames = List<String>();
    ingredients.forEach((element) {
      ingredientNames.add(element.name);
    });
    return ingredientNames;
  }

  List<String> getIngredientMeasurements(List<Ingredient> ingredients) {
    List<String> ingredientMeasurements = List<String>();
    ingredients.forEach((element) {
      ingredientMeasurements.add(element.measurement);
    });
    return ingredientMeasurements;
  } */

  // My tears
  // UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    List<Ingredient> groceryList = List<Ingredient>();
    List<dynamic> list = snapshot.data['groceryList'];
    list.forEach((element) {
      groceryList.add(Ingredient(
          name: element['name'],
          measurement: element['measurement'],
          amount: element['amount'],
          recipeName: element['recipeName']));
    });
    return UserData(
      uid: uid,
      email: snapshot.data['email'],
      groceryList: groceryList,
    );
  }

  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future removeUserIngredient(Ingredient ingredient, String id) async {
    return await userCollection.document(id).updateData({
      'groceryList': FieldValue.arrayRemove([
        {
          'name': ingredient.name,
          'measurement': ingredient.measurement,
          'amount': ingredient.amount,
          'recipeName': ingredient.recipeName,
        }
      ]),
    });
  }

// RECIPES
  final CollectionReference recipeCollection =
      Firestore.instance.collection('recipes');

  Future addRecipe(String name, String description, String id) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;
    return await recipeCollection.document(id).setData({
      'name': name,
      'description': description,
      'owner': userid,
    });
  }

  Future addIngredientToRecipe(String id, Ingredient ingredient) async {
    return await recipeCollection.document(id).updateData({
      'ingredients': FieldValue.arrayUnion([
        {
          'nameIngredient': ingredient.name,
          'measurement': ingredient.measurement,
          'amount': ingredient.amount,
          'id': ingredient.id,
        }
      ]),
    });
  }

  Future removeIngredientFromRecipe(String id, Ingredient ingredient) async {
    return await recipeCollection.document(id).updateData({
      'ingredients': FieldValue.arrayRemove([
        {
          'nameIngredient': ingredient.name,
          'measurement': ingredient.measurement,
          'amount': ingredient.amount,
          'id': ingredient.id,
        }
      ]),
    });
  }

  List<Ingredient> _recipeIngredientsFromSnapshot(
      QuerySnapshot snapshot, String id) {
    List<Ingredient> ingredients = List<Ingredient>();
    try {
      snapshot.documents.forEach((doc) {
        if (doc.documentID.contains(id)) {
          List<dynamic> list = doc.data['ingredients'];
          List<Ingredient> newIngredients = List<Ingredient>();
          for (int i = 0; i < list.length; i++) {
            Ingredient ingredient = Ingredient(
              name: doc.data['ingredients'][i]['nameIngredient'] ?? '',
              measurement: doc.data['ingredients'][i]['measurement'] ?? '',
              amount: doc.data['ingredients'][i]['amount'] ?? 0,
              id: doc.data['ingredients'][i]['id'],
            );
            newIngredients.add(ingredient);
          }
          ingredients = newIngredients;
        }
      });
      return ingredients;
    } catch (e) {
      return ingredients;
    }
  }

  Stream<List<Ingredient>> getIngredientsFromRecipe(String id) {
    return recipeCollection
        .snapshots()
        .map((snapshot) => _recipeIngredientsFromSnapshot(snapshot, id));
  }

  // RECIPES
  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      List<Ingredient> ingredients =
          _recipeIngredientsFromSnapshot(snapshot, doc.documentID.toString());
      return Recipe(
          name: doc.data['name'] ?? '',
          description: doc.data['description'],
          ingredientList: ingredients,
          id: doc.documentID);
    }).toList();
  }

  Stream<List<Recipe>> get recipes {
    return recipeCollection.snapshots().map(_recipeListFromSnapshot);
  }

  // INGREDIENTS
  final CollectionReference ingredientCollection =
      Firestore.instance.collection('ingredients');

  Future addIngredient(Ingredient ingredient) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userid = user.uid;
    return await ingredientCollection.document(ingredient.id).setData({
      'nameIngredient': ingredient.name,
      'measurement': ingredient.measurement,
      'amount': ingredient.amount,
      'recipeID': ingredient.recipeID,
      'owner': userid,
    });
  }

  Future removeIngredient(String ingredientId) async {
    // Reference is nodig voor deletion!
    ingredientCollection.reference().document(ingredientId).delete();
  }

  List<Ingredient> _ingredientListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Ingredient(
          name: doc.data['nameIngredient'] ?? '',
          measurement: doc.data['measurement'] ?? '',
          amount: doc.data['amount'] ?? 0,
          recipeID: doc.data['recipeID'] ?? '');
    }).toList();
  }

  Stream<List<Ingredient>> get ingredients {
    return ingredientCollection.snapshots().map(_ingredientListFromSnapshot);
  }

  List<String> getTextListIngredients(List<Ingredient> ingredients) {
    List<String> list = List<String>();
    ingredients.forEach((element) {
      list.add(element.toString());
    });
    return list;
  }

  Container getFilteredRecipe(
      Recipe recipe, List<Ingredient> ingredients, Map<String, int> inputMap) {
    List<String> selectedIngredients = getTextListIngredients(ingredients);
    List<Ingredient> missingIngredients = List<Ingredient>();
    int total = recipe.ingredientList.length;
    double count = 0;
    recipe.ingredientList.forEach((ingredient) {
      if (inputMap[ingredient.getNameAndMeasurement()] != null) {
        if (inputMap[ingredient.getNameAndMeasurement()] < ingredient.amount) {
          int oldAmount = ingredient.amount;
          int newAmount =
              ingredient.amount - inputMap[ingredient.getNameAndMeasurement()];
          count += newAmount / oldAmount;
          ingredient.amount = newAmount;
        }
      } else {
        count++;
      }
      missingIngredients.add(ingredient);
    });
    double p = (1 - (count / total)) * 100;
    String percentage = (p).toStringAsPrecision(3) + "%";

    return Container(
        child: ResultCard(
            recipe, selectedIngredients, missingIngredients, percentage));
  }

  List<Recipe> getFilteredRecipes(List<Recipe> recipes,
      List<Ingredient> ingredients, Map<String, int> inputMap) {
    List<String> selectedIngredients = getTextListIngredients(ingredients);
    List<Recipe> filteredRecipes = recipes;

    filteredRecipes.forEach((recipe) {
      double count = 0;
      int total = recipe.ingredientList.length;
      recipe.ingredientList.forEach((ingredient) {
        if (selectedIngredients.contains(ingredient.toString())) {
          count++;
        }
        if (inputMap[ingredient.getNameAndMeasurement()] != null) {
          if (inputMap[ingredient.getNameAndMeasurement()] <
              ingredient.amount) {
            int oldAmount = ingredient.amount;
            int newAmount = ingredient.amount -
                inputMap[ingredient.getNameAndMeasurement()];
            count += newAmount / oldAmount;
          }
        }
      });
      double p = (1 - (count / total)) * 100;
      recipe.setPercentage(p);
      count = 0;
    });
    filteredRecipes
        .sort((a, b) => a.getPercentage().compareTo(b.getPercentage()));
    return filteredRecipes;
  }

  String getMissingIngredientsOutput(List<Ingredient> ingredients) {
    List<String> missingIngredients = getTextListIngredients(ingredients);
    String text = "";
    missingIngredients.forEach((ingredient) {
      text += ingredient + "\n";
    });
    return text;
  }

  Future removeRecipe(String recipeId) async {
    // Reference is nodig voor deletion!
    recipeCollection.reference().document(recipeId).delete();
    ingredientCollection
        .where('recipeID', isEqualTo: recipeId)
        .getDocuments()
        .then((snapshot) => snapshot.documents.forEach((element) {
              element.reference.delete();
            }));
  }

  bool checkIfNumeric(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }
    final number = num.tryParse(string);
    if (number == null) {
      return false;
    }
    return true;
  }
}
