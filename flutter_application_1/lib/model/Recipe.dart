import 'package:flutter/widgets.dart';

import 'Profile.dart';
import 'Ingredient.dart';
import 'Step.dart';

class Recipe {
  final int recipeId;
  final String title;
  final String imageUrl;
  final int totalPrepTime;
  final String difficulty;

  List<Ingredient> ingredients;
  List<Step> steps;
  Profile creator;
  double avgRating;
  int totalView;
  int likes;
  String description;

  Recipe(
      {this.recipeId,
      @required this.title,
      @required this.totalPrepTime,
      @required this.difficulty,
      @required this.imageUrl,
      this.ingredients,
      this.steps,
      this.creator,
      this.avgRating,
      this.totalView,
      this.likes,
      this.description});

  factory Recipe.fromJsonPreview(Map json) {
    return Recipe(
        recipeId: json['Id'],
        title: json['Name'],
        imageUrl: json['Img'],
        difficulty: json['Level'],
        totalPrepTime: json['TotalTime']);
  }

  factory Recipe.fromJsonDetail(Map json, Recipe recipe) {
    print("RecipeDetail fromJson");
    Iterable ing = json['ingredients'];
    Iterable st = json['steps'];
    return Recipe(
        recipeId: recipe.recipeId,
        title: recipe.title,
        imageUrl: recipe.imageUrl,
        difficulty: recipe.difficulty,
        totalPrepTime: recipe.totalPrepTime,
        ingredients: ing == null
            ? []
            : List<Ingredient>.from(ing.map((e) => Ingredient.fromJson(e))),
        steps:
            st == null ? [] : List<Step>.from(st.map((e) => Step.fromJson(e))),
        creator: Profile.fromJsonCreator(json['creator']),
        avgRating: double.parse(json['avgRating'].toString()),
        totalView: json['totalView'],
        likes: json['likes'],
        description: json['description']);
  }

  Map toJson() {
    List<Map> listIngredientToMap = [];
    List<Map> listStepsToMap = [];
    ingredients.forEach((element) => listIngredientToMap.add(element.toJson()));
    steps
        .forEach((element) async => listStepsToMap.add(await element.toJson()));

    return {
      'name': title,
      'photos': [
        [
          {'url': imageUrl, 'height': '0', 'width': '0'}
        ]
      ],
      'description': description,
      'avgRating': '0',
      'ingredients': listIngredientToMap,
      'steps': listStepsToMap
    };
  }
}
