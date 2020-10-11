import 'package:cobok/models/user.dart';
import 'package:cobok/screens/wrapper.dart';
import 'package:cobok/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

/*child: MaterialApp(
initialRoute: '/home',
routes: {
'/': (context) => Loading(),
'/home': (context) => Wrapper(),
'/ingredientList': (context) => IngredientList(),
},
),*/
