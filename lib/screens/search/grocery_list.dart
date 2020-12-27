import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobok/models/ingredient.dart';
import 'package:cobok/models/recipe.dart';
import 'package:cobok/screens/home/home.dart';
import 'package:cobok/screens/ingredients/ingredient_list.dart';
import 'package:cobok/screens/recipes/recipe_list.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroceryList extends StatefulWidget {
  final Function toggleView;

  GroceryList({this.toggleView});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  bool loading = false;
  final DatabaseService databaseService = DatabaseService();

  // text field state
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Your grocery list'),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()))),
            ),
            body: Container(),
          );
  }
}
