import 'package:cobok/models/ingredient.dart';
import 'package:cobok/screens/ingredients/ingredient_tile.dart';
import 'package:cobok/screens/search/filtered_recipes.dart';
import 'package:cobok/screens/search/search_card.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  DatabaseService databaseService = DatabaseService();
  List<String> selectedIngredients = List<String>();
  String nameIngredient = '';

  @override
  Widget build(BuildContext context) {
    final ingredients = Provider.of<List<Ingredient>>(context) ?? [];
    return Column(
      children: <Widget>[
        Form(
          child: TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'name'),
            onChanged: (val) {
              setState(() {
                nameIngredient = val;
              });
            },
          ),
        ),
        // Expanded is goeie shit, column werkt nu. Vraag me niet waarom, ik ben verlegen
        Expanded(
          child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                if (nameIngredient == '') {
                  return SearchCard(
                    ingredient: ingredients[index],
                    nameIngredient: nameIngredient,
                    selectedIngredients: selectedIngredients,
                  );
                } else {
                  return ingredients[index].name == nameIngredient
                      ? SearchCard(
                          ingredient: ingredients[index],
                          nameIngredient: nameIngredient,
                          selectedIngredients: selectedIngredients,
                        )
                      : Container();
                }
              }),
        ),
        FlatButton(
          child: Text("Search"),
          onPressed: () {
            Navigator.pushNamed(context, '/filteredRecipes', arguments: {
              'selectedIngredients': selectedIngredients,
            });
          },
        ),
      ],
    );
  }
}
