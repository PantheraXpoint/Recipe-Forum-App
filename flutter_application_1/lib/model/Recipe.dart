import 'package:flutter/material.dart';

class Recipe {
  final int recipeId;
  final String title;
  final String imageUrl;
  final int totalPrepTime;
  final String difficulty;

  Recipe({
    @required this.recipeId,
    @required this.title,
    @required this.totalPrepTime,
    @required this.difficulty,
    @required this.imageUrl,
  });

  factory Recipe.fromJson(Map json) {
    return Recipe(
        recipeId: json['Id'],
        title: json['Name'],
        imageUrl: json['Img'],
        difficulty: json['Level'],
        totalPrepTime: json['TotalTime']);
  }
}
