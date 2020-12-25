import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobok/models/ingredient.dart';
import 'package:cobok/screens/ingredients/ingredient_list.dart';
import 'package:cobok/screens/search/search_list.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Ingredients extends StatefulWidget {
  final Function toggleView;

  Ingredients({this.toggleView});

  @override
  _IngredientsState createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  bool loading = false;
  final DatabaseService databaseService = DatabaseService();

  // text field state
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : StreamProvider<List<Ingredient>>.value(
            value: DatabaseService().ingredients,
            child: Scaffold(
              backgroundColor: Colors.brown[100],
              appBar: AppBar(
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                title: Text('Ingredients'),
              ),
              body: SearchList(),
            ),
          );
  }
}
