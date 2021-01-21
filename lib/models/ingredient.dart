class Ingredient {
  String name, measurement, id, recipeID, recipeName;
  int amount;
  String owner;

  Ingredient(
      {this.name,
      this.measurement,
      this.amount,
      this.id,
      this.recipeID,
      this.recipeName});

  @override
  String toString() {
    String text = '';
    text += name + ': ' + '$amount' + ' ' + measurement;
    if (recipeName != null) {
      text += "      (" + recipeName + ")";
    }
    return text;
  }

  String getNameAndMeasurement() {
    String text = name + " " + measurement;
    return text;
  }
}
