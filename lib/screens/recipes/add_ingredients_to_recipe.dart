import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/screens/ingredients/add_ingredient.dart';
import 'package:cobok/screens/ingredients/ingredient_list.dart';
import 'package:cobok/screens/ingredients/ingredient_tile.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/constants.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddIngredientsToRecipe extends StatefulWidget {
  // Maak het zo dat  je een recept toevoegt en verwezen wordt naar een aparte screen van je recept.
  // Daar kan je dan ingredienten toevoegen of verwijderen.

  // widget.objectNaam to access shit

  @override
  _AddIngredientsToRecipeState createState() => _AddIngredientsToRecipeState();
}

class _AddIngredientsToRecipeState extends State<AddIngredientsToRecipe> {
  String nameIngredient = '';
  String measurement = '';
  int amount = 0;

  //List<Ingredient> ingredients = List<Ingredient>();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final DatabaseService databaseService = DatabaseService();

  // text field state
  String error = '';

  //List<Widget> ingredientList = List<Widget>();

  Map recipeMap = {};

  @override
  Widget build(BuildContext context) {
    recipeMap = ModalRoute.of(context).settings.arguments;
    String id = recipeMap['id'];
    // String name = recipeMap['name'];
    //String description = recipeMap['description'];
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('add ingredients for $id'),
            ),
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    /*
                    RaisedButton(
                      child: Text('+'),
                      onPressed: () {
                        setState(() {
                          ingredientList.add(AddIngredient(
                            recipeID: id,
                          ));
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        children: List.generate(ingredientList.length, (index) {
                          return Row(
                            children: [
                              Expanded(
                                child: ingredientList[index],
                                flex: 9,
                              ),
                              Expanded(
                                child: Container(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        ingredientList
                                            .remove(ingredientList[index]);
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                    highlightColor: Colors.blue,
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          );
                        }),
                      ),
                    ), */
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'name'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter name' : null,
                            onChanged: (val) {
                              setState(() {
                                nameIngredient = val;
                              });
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(right: 2.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'amount'),
                                  validator: (val) =>
                                      val is int ? 'Enter amount' : 0,
                                  onChanged: (val) {
                                    setState(() {
                                      amount = int.parse(val);
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                width: 0.5,
                                padding: EdgeInsets.only(left: 2.0),
                                child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'measurement'),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter measurement' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      measurement = val;
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
                      color: Colors.pink[400],
                      child: Text(
                        'Add ingredient',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        Ingredient newIngredient = Ingredient(
                            name: nameIngredient,
                            measurement: measurement,
                            amount: amount);
                        databaseService.addIngredientToRecipe(
                            id, newIngredient);
                        print(databaseService.recipeIngredients);
                      },
                    ),
                      Expanded(
                        child: StreamProvider<List<Ingredient>>.value(
                          value: databaseService.recipeIngredients,
                          child: IngredientList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
