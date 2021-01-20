import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/screens/home/home.dart';
import 'package:cobok/screens/ingredients/ingredient_list.dart';
import 'package:cobok/screens/recipes/recipe_list.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'delete_recipe.dart';

class DeleteRecipes extends StatefulWidget {
  final Function toggleView;

  DeleteRecipes({this.toggleView});

  @override
  _DeleteRecipesState createState() => _DeleteRecipesState();
}

class _DeleteRecipesState extends State<DeleteRecipes> {
  bool loading = false;
  final DatabaseService databaseService = DatabaseService();

  // text field state
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : StreamProvider<List<Recipe>>.value(
            value: databaseService.recipes,
            child: Scaffold(
              backgroundColor: Colors.brown[100],
              appBar: AppBar(
                backgroundColor: Colors.red[300],
                elevation: 0.0,
                title: Text('Delete Recipes'),
                leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context, '/')),
              ),
              body: DeleteRecipe(),
            ),
          );
  }
}
