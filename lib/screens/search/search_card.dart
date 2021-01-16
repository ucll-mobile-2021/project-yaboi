import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cobok/models/ingredient.dart';

class SearchCard extends StatefulWidget {
  final Ingredient ingredient;
  final List<Ingredient> selectedIngredients;
  final List<Ingredient> ingredientList;

  SearchCard({this.ingredient, this.selectedIngredients, this.ingredientList});

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
          color: widget.selectedIngredients.contains(widget.ingredient)
              ? Colors.blue
              : Colors.white,
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
              title: Text(widget.ingredient.toString()),
              onTap: () {
                setState(() {
                  print(widget.ingredient.name);
                  if (widget.selectedIngredients.contains(widget.ingredient)) {
                    //widget.selectedIngredients.remove(widget.ingredient);
                    widget.ingredientList.forEach((element) {
                      if (element.name == widget.ingredient.name &&
                          element.measurement ==
                              widget.ingredient.measurement) {
                        if (element.amount <= widget.ingredient.amount) {
                          widget.selectedIngredients.remove(element);
                        }
                      }
                    });
                  } else {
                    //widget.selectedIngredients.add(widget.ingredient);
                    widget.ingredientList.forEach((element) {
                      if (element.name == widget.ingredient.name &&
                          element.measurement ==
                              widget.ingredient.measurement) {
                        if (element.amount <= widget.ingredient.amount) {
                          widget.selectedIngredients.add(element);
                        }
                      }
                    });
                  }
                  print("list: " + widget.selectedIngredients.toString());
                });
              }),
        ));
  }
}
