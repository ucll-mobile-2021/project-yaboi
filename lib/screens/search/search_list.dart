import 'package:cobok/models/ingredient.dart';
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
  List<Ingredient> selectedIngredients = List<Ingredient>();
  String nameIngredient = '';
  List<String> ingredientNameList;
  Map<String, int> inputMap = Map<String, int>();

  @override
  Widget build(BuildContext context) {
    final ingredients = Provider.of<List<Ingredient>>(context) ?? [];
    List<Ingredient> ingredientList = ingredients.toList();
    ingredientNameList = List<String>();
    return Column(
      children: <Widget>[
        Row(
          children: [
            SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'enter ingredient name'),
                  onChanged: (val) {
                    setState(() {
                      nameIngredient = val;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
          ],
        ),

        // Expanded is goeie shit, column werkt nu. Vraag me niet waarom, ik ben verlegen
        Expanded(
          child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                // SetState rebuilds widget, so in order to empty out the ingredientNameList when it rebuilds, we initialize it inside the widget build
                if (!ingredientNameList.contains(ingredients[index].name)) {
                  ingredientNameList.add(ingredients[index].name);
                  if (nameIngredient == '') {
                    return SearchCard(
                      ingredient: ingredients[index],
                      selectedIngredients: selectedIngredients,
                      ingredientList: ingredientList,
                      inputMap: inputMap,
                    );
                  } else {
                    return ingredients[index].name.contains(nameIngredient)
                        ? SearchCard(
                            ingredient: ingredients[index],
                            selectedIngredients: selectedIngredients,
                            ingredientList: ingredientList,
                            inputMap: inputMap,
                          )
                        : Container();
                  }
                } else {
                  return Container();
                }
              }),
        ),
        FlatButton(
          child: Text("Search"),
          onPressed: () {
            Navigator.pushNamed(context, '/filteredRecipes', arguments: {
              'selectedIngredients': selectedIngredients,
              'inputMap': inputMap,
            });
          },
        ),
      ],
    );
  }
}
