import 'ingredient.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String email;
  final List<Ingredient> groceryList;

  UserData({this.uid, this.email, this.groceryList});
}
