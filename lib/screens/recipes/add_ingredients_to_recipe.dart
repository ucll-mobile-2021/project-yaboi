import 'package:cobok/models/ingredient.dart';
import 'package:cobok/screens/ingredients/ingredient_list.dart';
import 'package:cobok/screens/recipes/recipes.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/constants.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddIngredientsToRecipe extends StatefulWidget {
  @override
  _AddIngredientsToRecipeState createState() => _AddIngredientsToRecipeState();
}

class _AddIngredientsToRecipeState extends State<AddIngredientsToRecipe> {
  String nameIngredient = '';
  String measurement = '';
  int amount = 0;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final DatabaseService databaseService = DatabaseService();
  Map recipeMap = {};

  @override
  Widget build(BuildContext context) {
    recipeMap = ModalRoute.of(context).settings.arguments;
    String id = recipeMap['id'];
    String ingredientId = randomAlphaNumeric(10);
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.red[300],
              elevation: 0.0,
              title: Text('add ingredients'),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Recipes()))),
            ),
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0, bottom: 4.0),
                          child: TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'name'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter name' : null,
                            onChanged: (val) {
                              setState(() {
                                nameIngredient = val.trim();
                              });
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(right: 2.0, left: 8.0, bottom: 10.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'amount'),
                                  validator: (val) =>
                                      databaseService.checkIfNumeric(val) == false ||
                                              int.tryParse(val) <= 0
                                          ? 'Enter amount'
                                          : null,
                                  onChanged: (val) {
                                    setState(() {
                                      amount = int.parse(val.trim());
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                width: 0.5,
                                padding: EdgeInsets.only(left: 2.0, right: 8.0, bottom: 10.0),
                                child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'measurement'),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter measurement' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      measurement = val.trim();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    RaisedButton(
                      color: Colors.red[400],
                      child: Text(
                        'Add ingredient',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (nameIngredient == null ||
                              nameIngredient.isEmpty ||
                              measurement == null ||
                              measurement.isEmpty ||
                              amount == 0 ||
                              amount == null) {
                          } else {
                            Ingredient newIngredient = Ingredient(
                                name: nameIngredient.toLowerCase(),
                                measurement: measurement.toLowerCase(),
                                amount: amount,
                                id: ingredientId,
                                recipeID: id);
                            databaseService.addIngredientToRecipe(
                                id, newIngredient);
                            databaseService.addIngredient(newIngredient);
                          }
                        }
                      },
                    ),
                    Expanded(
                      child: StreamProvider<List<Ingredient>>.value(
                        value: databaseService.getIngredientsFromRecipe(id),
                        child: IngredientList(
                          id: id,
                          ingredientId: ingredientId,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
