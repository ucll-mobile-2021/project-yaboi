import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilteredRecipesList extends StatefulWidget {
  final List<Ingredient> selectedIngredients;
  final Map<String, int> inputMap;

  FilteredRecipesList({this.selectedIngredients, this.inputMap});

  @override
  _FilteredRecipesListState createState() => _FilteredRecipesListState();
}

class _FilteredRecipesListState extends State<FilteredRecipesList> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<List<Recipe>>(context) ?? [];
    List<Recipe> filteredRecipes =
        databaseService.getFilteredRecipes(recipes, widget.selectedIngredients);
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return databaseService.getFilteredRecipe(filteredRecipes[index],
            widget.selectedIngredients, widget.inputMap);
      },
    );
  }
}
