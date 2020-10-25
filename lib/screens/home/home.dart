import 'package:cobok/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addIngredient');
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add an ingredient')),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/ingredients');
                  },
                  icon: Icon(Icons.arrow_right),
                  label: Text('View ingredients')),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addRecipe');
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add a recipe')),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recipes');
                  },
                  icon: Icon(Icons.arrow_right),
                  label: Text('Show recipes')),
            ],
          ),
        ));
  }
}

/*     return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/ingredientList');
              },
              icon: Icon(Icons.arrow_forward),
              label: Text('Go to ingredients'))
        ],
      ),
    )); */
