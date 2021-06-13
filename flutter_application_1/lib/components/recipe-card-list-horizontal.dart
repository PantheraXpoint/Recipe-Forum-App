import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeCardListHorizontal extends StatefulWidget {
  final bool canBookmark;
  final ValueChanged<int> onRecipeDeleted;
  final ValueChanged<bool> onBookmarkChanged;
  final bool canDelete;
  final bool canEdit;
  final List<Recipe> recipeList;
  final double scale;
  RecipeCardListHorizontal(
      {@required this.recipeList,
      this.scale,
      @required this.canDelete,
      this.canEdit,
      this.onRecipeDeleted,
      @required this.onBookmarkChanged,
      @required this.canBookmark});
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
          canBookmark: widget.canBookmark,
          onBookmarkChanged: (value) {
            print("horizontal");
            widget.onBookmarkChanged(value);
          },
          onRecipeDeleted: (value) => widget.onRecipeDeleted(value),
          recipe: widget.recipeList[i],
          canDelete: widget.canDelete,
          // canEdit: widget.canEdit,
        ),
        separatorBuilder: (context, index) => SizedBox(
          width: 20,
        ),
      ),
    );
  }
}
