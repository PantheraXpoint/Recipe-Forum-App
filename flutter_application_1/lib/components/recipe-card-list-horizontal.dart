import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeCardListHorizontal extends StatefulWidget {
  final ValueChanged<int> onRecipeDeleted;
  final bool canDelete;
  final List<Recipe> recipeList;
  final List<bool> isSaveds;
  final double scale;
  RecipeCardListHorizontal(
      {@required this.recipeList,
      this.scale,
      @required this.canDelete,
      this.onRecipeDeleted,
      @required this.isSaveds});
  @override
  State<StatefulWidget> createState() => RecipeCardListHorizontalState();
}

class RecipeCardListHorizontalState extends State<RecipeCardListHorizontal> {
  @override
  Widget build(BuildContext context) {
    double scale = widget.scale == null ? 1 : widget.scale;
    return SizedBox(
      height: 400 * (scale),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.recipeList.length,
        itemBuilder: (context, i) => RecipeCard(
            initialBookmark: widget.isSaveds[i],
            onRecipeDeleted: (value) => widget.onRecipeDeleted(value),
            recipe: widget.recipeList[i],
            canDelete: widget.canDelete),
        separatorBuilder: (context, index) => SizedBox(
          width: 20,
        ),
      ),
    );
  }
}
