import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeCardListHorizontal extends StatefulWidget {
  final List<Recipe> recipeList = [
    Recipe(
        recipeId: 1,
        title: "Bún đậu mắm tôm",
        totalPrepTime: 30.0,
        difficulty: "BEGINNER",
        imageUrl:
            "https://media.istockphoto.com/photos/vietnamese-traditional-plate-pork-vermicelli-tofu-the-popular-lunch-picture-id1220057044?s=612x612"),
    Recipe(
        recipeId: 2,
        title: "Bún bò giò heo",
        totalPrepTime: 60.0,
        difficulty: "INTERMEDIATE",
        imageUrl:
            "https://cdn.pixabay.com/photo/2016/05/09/10/26/rice-1381146__340.jpg"),
    Recipe(
        recipeId: 3,
        title: "Phở gà",
        difficulty: "ADVANCE",
        totalPrepTime: 180.0,
        imageUrl:
            "https://cdn.pixabay.com/photo/2016/03/09/15/22/food-1246621__340.jpg"),
  ];
  @override
  State<StatefulWidget> createState() => RecipeCardListHorizontalState();
}

class RecipeCardListHorizontalState extends State<RecipeCardListHorizontal> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: PageView.builder(
        itemCount: widget.recipeList.length,
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            child: RecipeCard(
              recipe: widget.recipeList[i],
            ),
          );
        },
      ),
    );
  }
}
