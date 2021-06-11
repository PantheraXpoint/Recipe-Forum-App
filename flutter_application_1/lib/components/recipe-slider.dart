import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/recipe-card-list-horizontal.dart';
import 'package:flutter_application_2/model/Recipe.dart';

import 'constaints.dart';

class RecipeSlider extends StatelessWidget {
  final List<Recipe> list;
  final String difficulty;
  final int type;
  RecipeSlider({@required this.list, this.difficulty, this.type});

  @override
  Widget build(BuildContext context) {
    String title = "Trending recipe";
    List<Recipe> finalList = [];
    if (type != null) {
      title = types[type];
      for (Recipe recipe in list) {
        if (recipe.typeID == type) finalList.add(recipe);
      }
    } else if (difficulty != null) {
      title = "Mức độ " + difficulty;
      for (Recipe recipe in list) {
        if (recipe.difficulty == difficulty) finalList.add(recipe);
      }
    } else
      finalList = list;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(
          height: 20,
        ),
        RecipeCardListHorizontal(recipeList: finalList),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
