class Ingredient {
  String name, measurement;
  int amount;

  Ingredient({this.name, this.measurement, this.amount});

  @override
  String toString() {
    String text = '';
    text += name + ': ' + '$amount' + ' ' + measurement;
    return text;
  }
}
