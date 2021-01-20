import 'package:cobok/models/user.dart';
import 'package:cobok/screens/home/home.dart';
import 'package:cobok/services/auth.dart';
import 'package:cobok/services/database.dart';
import 'package:cobok/shared/loading.dart';
import 'package:flutter/cupertino.dart';
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
  final AuthService _auth = AuthService();

  // text field state
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Your grocery list'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()))),
            ),
            body: StreamBuilder<UserData>(
                stream: DatabaseService(uid: user.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data;
                    if (userData.groceryList.isNotEmpty) {
                      return ListView.builder(
                        itemCount: userData.groceryList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                      userData.groceryList[index].toString()),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.chevron_right),
                                  color: Colors.black26,
                                  onPressed: () {
                                    databaseService.removeUserIngredient(
                                        userData.groceryList[index],
                                        userData.uid);
                                  }),
                            ],
                          );
                        },
                      );
                    }
                    return Card();
                  } else {
                    return Container(
                      child: Text('NO DATA'),
                    );
                  }
                }),
          );
  }
}
