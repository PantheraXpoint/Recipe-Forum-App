import 'package:flutter/material.dart';

class Ingredient {
  String unit;
  String name;
  String quantity;

  Ingredient(
      {@required this.unit, @required this.name, @required this.quantity});

  factory Ingredient.fromJson(Map json) {
    print("Ingredient fromJson");
    return Ingredient(
        unit: json['unit']['unit'],
        name: json['name'],
        quantity: json['quantity']);
  }
}
