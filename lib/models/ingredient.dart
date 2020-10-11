class Ingredient {
  String name, measurement;
  int amount;

  // Curly brackets = gebruik maken van name parameters in constructor
  Ingredient({this.name, this.measurement, this.amount});

  @override
  String toString() {
    return this.amount.toString() + ' ' + this.measurement + ' ' + this.name;
  }
}

// Je moet name dus meegeven bij parameters
// Ingredient ingredient = Ingredient(name: "cheese", measurement: "gram", amount: 50);
