import 'package:flutter/material.dart';

class Ingredient {
  String unit;
  String name;
  String quanity;

  Ingredient(
      {@required this.unit, @required this.name, @required this.quanity});

  factory Ingredient.fromJson(Map json) {
    print("Ingredient fromJson");
    return Ingredient(
        unit: json['unit']['unit'],
        name: json['name'],
        quanity: json['quanity']);
  }
}
