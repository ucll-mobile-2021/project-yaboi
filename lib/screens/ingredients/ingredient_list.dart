import 'package:cobok/models/ingredient.dart';
import 'package:cobok/screens/ingredients/ingredient_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientList extends StatefulWidget {

  final String id, ingredientId;
  IngredientList({this.id, this.ingredientId});

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {

  @override
  Widget build(BuildContext context) {
    final ingredients = Provider.of<List<Ingredient>>(context) ?? [];

    return ListView.builder(
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return IngredientTile(ingredient: ingredients[index], id: widget.id, ingredientId: widget.ingredientId,);
      },
    );
  }
}
