import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
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

  Future addUserGroceryList(String recipeName, List<String> list) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    list.forEach((element) async {
      return await userCollection.document(user.uid).updateData({
        'groceryList': FieldValue.arrayUnion([
          {
            recipeName: element,
          }
        ]),
      });
    });
  }

  Future removeUserGroceryList(String recipeName, List<String> list) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    list.forEach((element) async {
      return await userCollection.document(user.uid).updateData({
        'groceryList': FieldValue.arrayRemove([
          {
            recipeName: element,
          }
        ]),
      });
    });
  }

// RECIPES
  final CollectionReference recipeCollection =
      Firestore.instance.collection('recipes');

  Future addRecipe(String name, String description, String id) async {
    return await recipeCollection.document(id).setData({
      'name': name,
      'description': description,
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
    //return recipeCollection.snapshots().map(_recipeIngredientsFromSnapshot);
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
    return await ingredientCollection.document(ingredient.id).setData({
      'nameIngredient': ingredient.name,
      'measurement': ingredient.measurement,
      'amount': ingredient.amount,
      'recipeID': ingredient.recipeID,
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

  Container getFilteredRecipe(Recipe recipe, List<Ingredient> ingredients) {
    List<String> selectedIngredients = getTextListIngredients(ingredients);
    List<Ingredient> missingIngredients = List<Ingredient>();
    int total = recipe.ingredientList.length;
    int count = 0;
    recipe.ingredientList.forEach((ingredient) {
      if (selectedIngredients.contains(ingredient.toString())) {
        count++;
      } else {
        missingIngredients.add(ingredient);
      }
    });
    double p = (count / total) * 100;
    String percentage = (p).toStringAsFixed(0) + "%";
    if (p > 0) {
      return Container(
          child: ResultCard(
              recipe, selectedIngredients, missingIngredients, percentage));
    } else {
      return Container();
    }
  }

  List<Recipe> getFilteredRecipes(
      List<Recipe> recipes, List<Ingredient> ingredients) {
    List<String> selectedIngredients = getTextListIngredients(ingredients);
    List<Recipe> filteredRecipes = recipes;
    double count = 0;

    filteredRecipes.forEach((recipe) {
      recipe.ingredientList.forEach((ingredient) {
        if (selectedIngredients.contains(ingredient.toString())) {
          count++;
        }
      });
      count = (count / recipe.ingredientList.length) * 100;
      recipe.setPercentage(count);
      count = 0;
    });
    filteredRecipes
        .sort((a, b) => b.getPercentage().compareTo(a.getPercentage()));
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
}
