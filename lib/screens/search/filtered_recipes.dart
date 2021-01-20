import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/screens/ingredients/ingredient_tile.dart';
import 'package:cobok/screens/recipes/recipe_list.dart';
import 'package:cobok/screens/recipes/recipe_tile.dart';
import 'package:cobok/screens/search/filtered_recipes_list.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilteredRecipes extends StatefulWidget {
  @override
  _FilteredRecipesState createState() => _FilteredRecipesState();
}

class _FilteredRecipesState extends State<FilteredRecipes> {
  DatabaseService databaseService = DatabaseService();

  Map selectedIngredientsMap = {};
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    selectedIngredientsMap = ModalRoute.of(context).settings.arguments;
    List<Ingredient> selectedIngredientsList =
        selectedIngredientsMap['selectedIngredients'];

    return loading
        ? Loading()
        : StreamProvider<List<Recipe>>.value(
            value: databaseService.recipes,
            child: Scaffold(
              backgroundColor: Colors.brown[100],
              appBar: AppBar(
                backgroundColor: Colors.red[300],
                elevation: 0.0,
                title: Text('Search results'),
              ),
              body: selectedIngredientsList.isNotEmpty
                  ? FilteredRecipesList(
                      selectedIngredients: selectedIngredientsList,
                    )
                  : Center(
                      child: Text(
                        'NO RESULTS FOUND',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
            ),
          );
  }
}
