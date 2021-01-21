import 'package:cobok/models/user.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.red[300],
              elevation: 0.0,
              title: Text('Your grocery list'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, '/')),
            ),
            body: StreamBuilder<UserData>(
                stream: DatabaseService(uid: user.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data;
                    if (userData.groceryList.isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: userData.groceryList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                child: ListTile(
                                  trailing: IconButton(
                                      icon: Icon(Icons.close),
                                      color: Colors.black,
                                      onPressed: () {
                                        databaseService.removeUserIngredient(
                                            userData.groceryList[index],
                                            userData.uid);
                                      }),
                                  title: Text(
                                      userData.groceryList[index].toString()),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Card();
                  } else {
                    return Center(
                      child: Text(
                        'EMPTY',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }
                }),
          );
  }
}
