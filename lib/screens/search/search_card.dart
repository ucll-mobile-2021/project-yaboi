import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cobok/models/ingredient.dart';

class SearchCard extends StatefulWidget {
  final Ingredient ingredient;
  final List<String> selectedIngredients;
  final String nameIngredient;

  SearchCard({this.ingredient, this.nameIngredient, this.selectedIngredients});

  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          color: widget.selectedIngredients.contains(widget.ingredient.toString())
              ? Colors.blue
              : Colors.white,
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
              title: Text(widget.ingredient.toString()),
              onTap: () {
                setState(() {
                  print(widget.ingredient.name);
                  if (widget.selectedIngredients
                      .contains(widget.ingredient.toString())) {
                    widget.selectedIngredients
                        .remove(widget.ingredient.toString());
                  } else {
                    widget.selectedIngredients
                        .add(widget.ingredient.toString());
                  }
                  print("list: " + widget.selectedIngredients.toString());
                });
              }),
        ));
  }
}
