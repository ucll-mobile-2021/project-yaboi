import 'package:cobok/models/ingredient.dart';
import 'package:cobok/pages/ingredient_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientList extends StatefulWidget {
  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  void getData() async {
    // Simulate network request for username
    await Future.delayed(Duration(seconds: 3), () {
      print('3 seconds passed sinds you went to your ingredients list');
    });

    String example = await Future.delayed(Duration(seconds: 2), () {
      return 'cool';
    });

    print(example);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<Ingredient> ingredients = [
    Ingredient(name: "cheese", measurement: "gram", amount: 50),
    Ingredient(name: "milk", measurement: "cl", amount: 75),
    Ingredient(name: "butter", measurement: "gram", amount: 100)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your ingredients'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: ingredients
                .map((ingredient) => IngredientCard(
                    ingredient: ingredient,
                    delete: () {
                      setState(() {
                        ingredients.remove(ingredient);
                      });
                    }))
                .toList(),
          ),
        ));
  }
}
