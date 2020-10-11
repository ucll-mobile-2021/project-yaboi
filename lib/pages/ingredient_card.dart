import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientCard extends StatelessWidget {

  final Ingredient ingredient;
  final Function delete;
  IngredientCard({this.ingredient, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 6.0),
            Text(
              ingredient.toString(),
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            FlatButton.icon(onPressed: delete, icon: Icon(Icons.delete), label: Text('delete ingredient')),
          ],
        ),
      ),
    );
  }
}