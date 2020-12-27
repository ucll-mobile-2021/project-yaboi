import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String name, int age) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'age': age,
    });
  }

  /*final CollectionReference ingredientCollection =
      Firestore.instance.collection('ingredients');

  Future addIngredient(String name) async {
    return await ingredientCollection.document(name).setData({
      'name': name,
    });
  }

  // List from snapshot
  List<Ingredient> _ingredientListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Ingredient(name: doc.data['name'] ?? '');
    }).toList();
  }

  Stream<List<Ingredient>> get ingredients {
    return ingredientCollection.snapshots().map(_ingredientListFromSnapshot);
  } */

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

  /*
  Stream<List<Ingredient>> get recipeIngredients {
    return recipeCollection.snapshots().map(_recipeIngredientsFromSnapshot);
  } */

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

  Card getFilteredRecipe(Recipe recipe, List<String> selectedIngredients) {
    List<String> missingIngredients = List<String>();
    int total = recipe.ingredientList.length;
    int count = 0;
    recipe.ingredientList.forEach((ingredient) {
      if (selectedIngredients.contains(ingredient.toString())) {
        count++;
      } else {
        missingIngredients.add(ingredient.toString());
      }
    });
    double p = (count / total);
    String percentage = (p * 100).toString() + "%";
    if (p > 0) {
      return Card(
        child: ListTile(
          title: Text(recipe.name +
              " -- " +
              percentage +
              "\n" +
              "missing ingredients: " +
              missingIngredients.toString()),
        ),
      );
    } else {
      return Card();
    }
  }

  List<Recipe> getFilteredRecipes(
      List<Recipe> recipes, List<String> selectedIngredients) {
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
}
