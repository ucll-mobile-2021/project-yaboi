import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cobok/models/ingredient.dart';

class IngredientTile extends StatefulWidget {
  final Ingredient ingredient;
  final String id, ingredientId;

  IngredientTile({this.ingredient, this.id, this.ingredientId});

  @override
  _IngredientTileState createState() => _IngredientTileState();
}

class _IngredientTileState extends State<IngredientTile> {
  bool selected = false;

  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: selected ? Colors.blue : Colors.white,
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(widget.ingredient.toString()),
          onTap: () {
            setState(() {
              selected = !selected;
              print(widget.ingredient.id);
            });
          },
          //TODO: can't delete ingredient from ingredientCollection because I don't have the ingredientId when returning to
          // add_ingredients_to_recipe.dart (i.g. when I go a page backwards and return, the ingredientId disappears.
          onLongPress: () {
            databaseService.removeIngredientFromRecipe(
                widget.id, widget.ingredient);
            databaseService.removeIngredient(widget.ingredientId);
          },
        ),
      ),
    );
  }
}
