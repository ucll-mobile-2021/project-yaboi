import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';

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

  final CollectionReference ingredientCollection =
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
          'amount': ingredient.amount
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
          'amount': ingredient.amount
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
}
