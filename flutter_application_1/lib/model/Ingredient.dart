import 'package:flutter/material.dart';

class Ingredient {
  String unit;
  String name;
  String quantity;

  Ingredient(
      {@required this.unit, @required this.name, @required this.quantity});

  factory Ingredient.fromJson(Map json) {
    print("Ingredient fromJson");
    print(json['quantity']);
    return Ingredient(
        unit: json['unit'] == null ? ' ' : json['unit']['unit'],
        name: json['name'] == null ? ' ' : json['name'],
        quantity: json['quantity'] == null ? ' ' : json['quantity']);
  }
}
