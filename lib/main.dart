import 'package:cobok/pages/ingredient_list.dart';
import 'package:cobok/pages/loading.dart';
import 'package:cobok/screens/home/home.dart';
import 'package:cobok/screens/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() =>
    runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Wrapper(),
        '/ingredientList': (context) => IngredientList(),
      },
    ));
