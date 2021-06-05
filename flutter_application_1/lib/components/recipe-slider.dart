import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/recipe-card-list-horizontal.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeSlider extends StatelessWidget {
  final List<Recipe> list;
  final String difficulty;
  RecipeSlider({@required this.list, this.difficulty});

  @override
  Widget build(BuildContext context) {
    print(list.length);
    List<Recipe> finalList = [];
    if (difficulty == null)
      finalList = list;
    else
      for (Recipe recipe in list) {
        if (recipe.difficulty == difficulty) finalList.add(recipe);
      }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(difficulty == null ? "Trending recipe" : "Mức độ " + difficulty,
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
