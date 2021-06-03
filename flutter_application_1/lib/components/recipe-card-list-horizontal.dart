import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeCardListHorizontal extends StatefulWidget {
  final List<Recipe> recipeList;
  RecipeCardListHorizontal({@required this.recipeList});
  @override
  State<StatefulWidget> createState() => RecipeCardListHorizontalState();
}

class RecipeCardListHorizontalState extends State<RecipeCardListHorizontal> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      // child: PageView.builder(
      //   itemCount: widget.recipeList.length,
      //   controller: PageController(viewportFraction: 0.7),
      //   onPageChanged: (int index) => setState(() => _index = index),
      //   itemBuilder: (_, i) {
      //     return Transform.scale(
      //       scale: i == _index ? 1 : 0.9,
      //       child: RecipeCard(
      //         recipe: widget.recipeList[i],
      //       ),
      //     );
      //   },
      // ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.recipeList.length,
        itemBuilder: (context, i) => RecipeCard(recipe: widget.recipeList[i]),
        separatorBuilder: (context, index) => SizedBox(
          width: 20,
        ),
      ),
    );
  }
}
