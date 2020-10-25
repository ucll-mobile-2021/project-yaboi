import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cobok/models/ingredient.dart';

class IngredientTile extends StatefulWidget {
  final Ingredient ingredient;
  final String id;

  IngredientTile({this.ingredient, this.id});

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
            });
          },
          onLongPress: (){
            databaseService.removeIngredientFromRecipe(widget.id, widget.ingredient);
          },
        ),
      ),
    );
  }
}