import 'package:cobok/models/user.dart';
import 'package:cobok/screens/home/home.dart';
import 'package:cobok/screens/ingredients/ingredients.dart';
import 'package:cobok/screens/recipes/add_ingredients_to_recipe.dart';
import 'package:cobok/screens/recipes/add_recipe.dart';
import 'package:cobok/screens/recipes/recipes.dart';
import 'package:cobok/screens/search/filtered_recipes.dart';
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
        routes: {
          '/ingredients': (context) => Ingredients(),
          '/addRecipe': (context) => AddRecipe(),
          '/addIngredientsToRecipe' : (context) => AddIngredientsToRecipe(),
          '/recipes' : (context) => Recipes(),
          '/home' : (context) => Home(),
          '/filteredRecipes' : (context) => FilteredRecipes(),
        },
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
