import 'package:flutter/cupertino.dart';

class Recipe {
  final int recipeId;
  final String title;
  final String imageUrl;
  final String description;
  final double totalPrepTime;
  final String difficulty;

  Recipe({
    @required this.recipeId,
    @required this.title,
    @required this.totalPrepTime,
    this.difficulty,
    this.imageUrl,
    this.description,
  });

  factory Recipe.fromJson(Map json) {
    return Recipe(
        recipeId: json['_id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        description: json['description'],
        difficulty: json['difficulty'],
        totalPrepTime: json['totalPrepTime']);
  }
}
