import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/model/Ingredient.dart';
import 'package:flutter_application_2/model/Step.dart';

class RecipeDetail {
  List<Ingredient> ingredients;
  List<Step> steps;
  double avgRating;
  int totalRating;
  int likes;
  String description;

  RecipeDetail(
      {@required this.ingredients,
      @required this.steps,
      @required this.avgRating,
      this.totalRating,
      @required this.likes,
      @required this.description});

  factory RecipeDetail.fromJson(Map json) {
    print("RecipeDetail fromJson");
    Iterable ing = json['ingredients'];
    Iterable st = json['steps'];
    return RecipeDetail(
        ingredients:
            List<Ingredient>.from(ing.map((e) => Ingredient.fromJson(e))),
        steps: List<Step>.from(st.map((e) => Step.fromJson(e))),
        avgRating: json['avgRating'],
        likes: json['likes'],
        description: json['description']);
  }
}
