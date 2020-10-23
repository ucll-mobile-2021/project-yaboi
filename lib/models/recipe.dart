import 'package:cobok/models/ingredient.dart';

class Recipe {
  final String name, description, id;
  List<Ingredient> ingredientList = List<Ingredient>();

  Recipe({this.name, this.description, this.id});

  void addIngredientToRecipe(Ingredient ingredient) {
    this.ingredientList.add(ingredient);
  }
}
