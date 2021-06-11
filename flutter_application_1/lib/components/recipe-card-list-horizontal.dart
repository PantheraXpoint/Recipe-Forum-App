import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeCardListHorizontal extends StatefulWidget {
  final List<Recipe> recipeList;
  final double scale;
  RecipeCardListHorizontal({@required this.recipeList, this.scale});
  @override
  State<StatefulWidget> createState() => RecipeCardListHorizontalState();
}

class RecipeCardListHorizontalState extends State<RecipeCardListHorizontal> {
  @override
  Widget build(BuildContext context) {
    double scale = widget.scale == null ? 1 : widget.scale;
    print("OKAY TILL HERE");
    return SizedBox(
      height: 400 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.recipeList.length,
        itemBuilder: (context, i) =>
            RecipeCard(recipe: widget.recipeList[i], scale: scale),
        separatorBuilder: (context, index) => SizedBox(
          width: 20,
        ),
      ),
    );
  }
}
