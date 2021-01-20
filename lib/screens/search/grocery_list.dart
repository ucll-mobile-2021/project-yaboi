import 'package:cobok/services/database.dart';
import 'package:flutter/material.dart';

class GroceryList extends StatefulWidget {
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /*
        Expanded(
          child: ListView.builder(
              itemCount: xx.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text( xx[index].toString()),
                );
              }),
        ), */
      ],
    );
  }
}
