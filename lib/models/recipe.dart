import 'package:cobok/models/ingredient.dart';

class Recipe {
  final String name, description, id;
  final List<Ingredient> ingredientList;

  Recipe({this.name, this.description, this.id, this.ingredientList});

  void addIngredientToRecipe(Ingredient ingredient) {
    this.ingredientList.add(ingredient);
  }

  @override
  String toString() {
    String text = '';
    text += name + '\n' + description + '\n';
    ingredientList.forEach((ingredient) {
      text += ingredient.toString() + '\n';
    });
    return text;
  }
}
