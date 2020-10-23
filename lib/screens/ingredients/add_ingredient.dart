import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/constants.dart';
import 'package:flutter/material.dart';

class AddIngredient extends StatefulWidget {
  final String recipeID;

  AddIngredient({this.recipeID});

  @override
  _AddIngredientState createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  String name = '';
  String measurement = '';
  int amount = 0;
  DatabaseService databaseService = DatabaseService();
  Ingredient ingredient = Ingredient();

  addIngredient() {
    Ingredient newIngredient =
        Ingredient(name: name, measurement: measurement, amount: amount);
    databaseService.addIngredientToRecipe(widget.recipeID, newIngredient);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'name'),
            validator: (val) => val.isEmpty ? 'Enter name' : null,
            onChanged: (val) {
              setState(() {
                //name = val;
                ingredient.name = val;
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
                  decoration: textInputDecoration.copyWith(hintText: 'amount'),
                  validator: (val) => val is int ? 'Enter amount' : 0,
                  onChanged: (val) {
                    setState(() {
                      //amount = int.parse(val);
                      ingredient.amount = int.parse(val);
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
                  decoration:
                      textInputDecoration.copyWith(hintText: 'measurement'),
                  validator: (val) => val.isEmpty ? 'Enter measurement' : null,
                  onChanged: (val) {
                    setState(() {
                      //measurement = val;
                      ingredient.measurement = measurement;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
