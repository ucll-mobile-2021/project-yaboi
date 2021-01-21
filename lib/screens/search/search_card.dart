import 'package:cobok/services/database.dart';
import 'package:cobok/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cobok/models/ingredient.dart';

class SearchCard extends StatefulWidget {
  final Ingredient ingredient;
  final List<Ingredient> selectedIngredients;
  final List<Ingredient> ingredientList;
  final Map<String, int> inputMap;

  SearchCard(
      {this.ingredient,
      this.selectedIngredients,
      this.ingredientList,
      this.inputMap});

  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  DatabaseService databaseService = DatabaseService();
  int inputAmountIngredient = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          /*color: widget.selectedIngredients.contains(widget.ingredient)
              ? Colors.blue
              : Colors.white, */
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            title: Text(widget.ingredient.name +
                " (" +
                widget.ingredient.measurement +
                ")"),
            trailing: Container(
              width: 150.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: textInputDecoration.copyWith(hintText: '0'),
                      textAlign: TextAlign.end,
                      onChanged: (val) async {
                        setState(() {
                          inputAmountIngredient = int.tryParse(val);
                          widget.ingredientList.forEach((element) {
                            if (inputAmountIngredient != null &&
                                element.amount <= inputAmountIngredient &&
                                element.name == widget.ingredient.name &&
                                element.measurement ==
                                    widget.ingredient.measurement) {
                              if (!widget.selectedIngredients.contains(element))
                                widget.selectedIngredients.add(element);
                            } else {
                              if (inputAmountIngredient != null &&
                                  element.amount > inputAmountIngredient &&
                                  element.name == widget.ingredient.name &&
                                  element.measurement ==
                                      widget.ingredient.measurement) if (widget
                                  .selectedIngredients
                                  .contains(element))
                                widget.selectedIngredients.remove(element);
                            }
                          });
                          widget.inputMap[widget.ingredient.getNameAndMeasurement()] =
                              inputAmountIngredient;
                        });
                        // Le checkity check:
                        // print(widget.selectedIngredients);
                      },
                    ),
                  ),
                  /* Expanded(
                    child: IconButton(
                      icon: Icon(Icons.chevron_right),
                      color: Colors.black26,
                      onPressed: () {
                        /*
                        setState(() {
                          print(widget.ingredient.name);
                          /*if (widget.selectedIngredients
                              .contains(widget.ingredient))*/
                          if (widget.selectedIngredients
                              .contains(widget.ingredient)) {
                            //widget.selectedIngredients.remove(widget.ingredient);
                            widget.ingredientList.forEach((element) {
                              if (element.name == widget.ingredient.name &&
                                  element.measurement ==
                                      widget.ingredient.measurement) {
                                if (element.amount <= inputAmountIngredient) {
                                  widget.selectedIngredients.remove(element);
                                }
                              }
                            });
                          } else {
                            //widget.selectedIngredients.add(widget.ingredient);
                            widget.ingredientList.forEach((element) {
                              if (element.name == widget.ingredient.name &&
                                  element.measurement ==
                                      widget.ingredient.measurement) {
                                if (element.amount <= inputAmountIngredient) {
                                  widget.selectedIngredients.add(element);
                                }
                              }
                            });
                          }
                          print(
                              "list: " + widget.selectedIngredients.toString());
                        }); */
                      },
                    ),
                  ) */
                ],
              ),
            ),
          ),
        ));
  }
}
