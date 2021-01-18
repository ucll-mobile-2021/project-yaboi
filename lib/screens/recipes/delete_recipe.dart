import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/screens/ingredients/ingredient_tile.dart';
import 'package:cobok/screens/recipes/recipe_tile.dart';
import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteRecipe extends StatefulWidget {
  @override
  _DeleteRecipeState createState() => _DeleteRecipeState();
}

class _DeleteRecipeState extends State<DeleteRecipe> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<List<Recipe>>(context) ?? [];

    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        String delName = recipes[index].name;
        return Card(
          child: ListTile(
            title:
                Text(recipes[index].name + "\n" + recipes[index].description),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("Delete '$delName'?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () {
                            setState(() {
                              databaseService.removeRecipe(recipes[index].id);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
