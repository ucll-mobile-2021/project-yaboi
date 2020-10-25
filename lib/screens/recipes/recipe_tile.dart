import 'package:cobok/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:cobok/models/ingredient.dart';

class RecipeTile extends StatefulWidget {
  final Recipe recipe;

  RecipeTile({this.recipe});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: selected ? Colors.blue : Colors.white,
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(widget.recipe.toString()),
          onTap: () {
            setState(() {
              selected = !selected;
            });
          },
        ),
      ),
    );
  }
}
