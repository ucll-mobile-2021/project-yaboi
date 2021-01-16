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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: FlatButton.icon(
                    padding: EdgeInsets.all(35.0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/ingredients');
                    },
                    icon: Icon(Icons.list),
                    label: Text('View ingredients')),
              ),
              Container(
                child: FlatButton.icon(
                    padding: EdgeInsets.all(35.0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/addRecipe');
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add a recipe')),
              ),
              Container(
                child: FlatButton.icon(
                    padding: EdgeInsets.all(35.0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/recipes');
                    },
                    icon: Icon(Icons.import_contacts),
                    label: Text('Show recipes')),
              ),
              Container(
                child: FlatButton.icon(
                    padding: EdgeInsets.all(35.0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/deleteRecipes');
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete recipes')),
              ),
              Container(
                child: FlatButton.icon(
                    padding: EdgeInsets.all(35.0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/groceryList');
                    },
                    icon: Icon(Icons.shopping_basket),
                    label: Text('Show your grocery list')),
              ),
            ],
          ),
        ));
  }
}