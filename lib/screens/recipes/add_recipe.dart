import 'package:cobok/models/recipe.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/constants.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class AddRecipe extends StatefulWidget {
  final Function toggleView;

  AddRecipe({this.toggleView});

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final DatabaseService databaseService = DatabaseService();

  // text field state
  String recipe = '';
  String description = '';
  String error = '';

  List<Widget> ingredientList = List<Widget>();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.red[300],
              elevation: 0.0,
              title: Text('Add a recipe'),
            ),
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 4.0),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'name recipe'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter name of recipe' : null,
                        onChanged: (val) {
                          setState(() {
                            recipe = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                      child: TextFormField(
                        maxLines: 4,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'description'),
                        /*validator: (val) =>
                            val.isEmpty ? 'Enter description' : null, */
                        onChanged: (val) {
                          setState(() {
                            description = val;
                          });
                        },
                      ),
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    RaisedButton(
                      color: Colors.red[400],
                      child: Text(
                        'Add recipe',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (recipe.isNotEmpty) {
                            String id = randomAlphaNumeric(10);
                            Recipe newRecipe = Recipe(
                                name: recipe, description: description, id: id);
                            databaseService.recipeCollection
                                .document(id)
                                .get()
                                .then((value) => {
                                      if (value.exists)
                                        {print('bestaat')}
                                      else
                                        {
                                          databaseService.addRecipe(
                                              newRecipe.name,
                                              newRecipe.description,
                                              newRecipe.id)
                                        }
                                    });
                            Navigator.pushNamed(
                                context, '/addIngredientsToRecipe',
                                arguments: {
                                  'id': id,
                                });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
