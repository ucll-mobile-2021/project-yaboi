import 'package:cobok/models/recipe.dart';
import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cobok/models/ingredient.dart';

class ResultCard extends StatefulWidget {
  final Recipe recipe;
  final List<String> selectedIngredients;
  final List<Ingredient> missingIngredients;
  final String percentage;

  ResultCard(this.recipe, this.selectedIngredients, this.missingIngredients,
      this.percentage);

  @override
  _ResultCardState createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  DatabaseService databaseService = DatabaseService();
  bool pressed = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          trailing: pressed && widget.missingIngredients.isNotEmpty
              ? FlatButton.icon(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    databaseService.addUserGroceryList(
                        widget.missingIngredients, widget.recipe.name);
                    setState(() {
                      pressed = false;
                    });
                  },
                  label: Text("add"),
                )
              : FlatButton.icon(
                  icon: widget.missingIngredients.isNotEmpty
                      ? Icon(Icons.remove)
                      : Icon(Icons.check),
                  onPressed: () {
                    databaseService.removeUserGroceryList(
                        widget.missingIngredients, widget.recipe.name);
                    setState(() {
                      pressed = true;
                    });
                  },
                  label: widget.missingIngredients.isNotEmpty
                      ? Text("remove")
                      : Text(''),
                ),
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: widget.recipe.name + "\n",
                  style: TextStyle(color: Colors.black.withOpacity(1.0)),
                ),
                TextSpan(
                  text: "ingredients available: " + widget.percentage + "\n\n",
                  style: TextStyle(color: Colors.black.withOpacity(1.0)),
                ),
                widget.missingIngredients.isNotEmpty
                    ? TextSpan(
                        text: "MISSING INGREDIENTS: " + "\n",
                        style: TextStyle(
                            color: Colors.black.withOpacity(1.0),
                            fontWeight: FontWeight.bold),
                      )
                    : TextSpan(
                        text: "READY TO COOK",
                        style: TextStyle(
                            color: Colors.green.withOpacity(1.0),
                            fontWeight: FontWeight.bold)),
                TextSpan(
                  text: databaseService.getMissingIngredientsOutput(
                          widget.missingIngredients) +
                      "\n",
                  style: TextStyle(color: Colors.red.withOpacity(1.0)),
                ),
              ],
            ),
          )),
    );
  }
}
