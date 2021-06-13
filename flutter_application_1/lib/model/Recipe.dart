import 'package:flutter/widgets.dart';

import 'Profile.dart';
import 'Ingredient.dart';
import 'Step.dart';

class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  final int totalPrepTime;
  final String difficulty;
  final int typeID;
  final List<Ingredient> ingredients;
  final List<Step> steps;
  final Profile creator;
  final double avgRating;
  final int totalView;
  final int likes;
  final String description;

  Recipe(
      {this.id,
      @required this.title,
      @required this.totalPrepTime,
      @required this.difficulty,
      @required this.typeID,
      @required this.imageUrl,
      @required this.ingredients,
      @required this.steps,
      this.creator,
      this.avgRating,
      this.totalView,
      this.likes,
      @required this.description});

  factory Recipe.fromJson(Map json) {
    Iterable ing = json['ingredients'];
    Iterable st = json['steps'];
    return Recipe(
        id: json['id'],
        title: json['name'],
        imageUrl: json['photos'][0][0]['url'],
        difficulty: json['level'],
        typeID: json['TypeID'] - 1,
        totalPrepTime: json['totalTime'],
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

  Future<Map> toJson() async {
    List<Map> listIngredientToMap = [];
    List<Map> listStepsToMap = [];
    ingredients.forEach((element) => listIngredientToMap.add(element.toJson()));

    for (Step step in steps) {
      Map json = await step.toJson();
      listStepsToMap.add(json);
    }
    print("TYPE IDDDDDDDDDDDDDDD: " + typeID.toString());
    return {
      'name': title,
      'photos': [
        [
          {'url': imageUrl, 'height': '0', 'width': '0'}
        ]
      ],
      'level': difficulty,
      'totalTime': totalPrepTime,
      'description': description,
      'avgRating': '0',
      'ingredients': listIngredientToMap,
      'steps': listStepsToMap,
      'TypeID': typeID + 1
    };
  }
}
