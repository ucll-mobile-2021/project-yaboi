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
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(widget.ingredient.toString()),
          onTap: () {
            if (widget.ingredient.id != null) {
              setState(() {
                print(widget.ingredient.id);
              });
            } else {
              print("No ingredient id passed");
              print(widget.ingredient.name);
            }
          },
          onLongPress: () {
            databaseService.removeIngredientFromRecipe(
                widget.id, widget.ingredient);
            databaseService.removeIngredient(widget.ingredient.id);
          },
        ),
      ),
    );
  }
}
