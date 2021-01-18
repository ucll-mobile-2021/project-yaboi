class Ingredient {
  String name, measurement, id, recipeID;
  int amount;
  String owner;

  Ingredient(
      {this.name, this.measurement, this.amount, this.id, this.recipeID});

  @override
  String toString() {
    String text = '';
    text += name + ': ' + '$amount' + ' ' + measurement;
    return text;
  }
}
