import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/screens/ingredients/ingredient_tile.dart';
import 'package:cobok/screens/recipes/recipe_tile.dart';
import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilteredRecipesList extends StatefulWidget {
  final List<String> selectedIngredients;

  FilteredRecipesList({this.selectedIngredients});

  @override
  _FilteredRecipesListState createState() => _FilteredRecipesListState();
}

class _FilteredRecipesListState extends State<FilteredRecipesList> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<List<Recipe>>(context) ?? [];
    List<Recipe> list =
        databaseService.getFilteredRecipes(recipes, widget.selectedIngredients);
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        /* return databaseService.getFilteredRecipe(
            recipes[index], widget.selectedIngredients); */
        return databaseService.getFilteredRecipe(
            list[index], widget.selectedIngredients);
      },
    );
  }
}
