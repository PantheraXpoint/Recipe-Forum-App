import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/model/Ingredient.dart';
import 'package:flutter_application_2/model/Step.dart';
import 'package:flutter_application_2/model/Creator.dart';

class RecipeDetail {
  List<Ingredient> ingredients;
  List<Step> steps;
  Creator creator;
  double avgRating;
  int totalView;
  int likes;
  String description;

  RecipeDetail(
      {@required this.ingredients,
      @required this.steps,
      @required this.creator,
      @required this.avgRating,
      @required this.totalView,
      @required this.likes,
      @required this.description});

  factory RecipeDetail.fromJson(Map json) {
    print("RecipeDetail fromJson");
    Iterable ing = json['ingredients'];
    Iterable st = json['steps'];
    return RecipeDetail(
        ingredients: ing == null
            ? []
            : List<Ingredient>.from(ing.map((e) => Ingredient.fromJson(e))),
        steps:
            st == null ? [] : List<Step>.from(st.map((e) => Step.fromJson(e))),
        creator: Creator.fromJson(json['creator']),
        avgRating: double.parse(json['avgRating'].toString()),
        totalView: json['totalView'],
        likes: json['likes'],
        description: json['description']);
  }
}
