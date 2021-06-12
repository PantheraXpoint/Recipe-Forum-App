import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/apis.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:flutter_application_2/screens/recipe_detail_screen.dart';

class RecipeCard extends StatefulWidget {
  final ValueChanged<int> onRecipeDeleted;
  final ValueChanged<bool> onBookmarkChanged;
  final Recipe recipe;
  final double scale;
  final bool canDelete;
  final bool canBookmark;
  RecipeCard(
      {@required this.recipe,
      this.scale,
      @required this.canDelete,
      this.onRecipeDeleted,
      @required this.onBookmarkChanged,
      @required this.canBookmark});
  @override
  State<StatefulWidget> createState() => RecipeCardState();
}

class RecipeCardState extends State<RecipeCard> {
  bool isBookmark;
  @override
  void initState() {
    super.initState();
    isBookmark = Session.profile.savedIDs.contains(widget.recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(
                    onBookmarkChanged: (value) {
                      print("card");
                      widget.onBookmarkChanged(value);
                    },
                    recipe: widget.recipe))).then((value) {
          setState(() {
            isBookmark = Session.profile.savedIDs.contains(widget.recipe.id);
          });
        });
      },
      child: Container(
        width: 300,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.transparent, Colors.black],
          ),
          image: DecorationImage(
            image: NetworkImage(
              widget.recipe.imageUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.recipe.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                ),
              ),
            ),
            SizedBox(
                child: widget.canDelete
                    ? IconButton(
                        onPressed: () async {
                          int response =
                              await APIs.deleteRecipe(widget.recipe.id);
                          if (response == 200) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text("Xóa thành công"),
                                    ));
                            widget.onRecipeDeleted(widget.recipe.id);
                          } else
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text("Xóa thất bại"),
                                    ));
                        },
                        icon: Icon(Icons.delete))
                    : null),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF2C2E2D).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: widget.recipe.title.length < 40 ? 90 : 120,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(
                              widget.recipe.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: !widget.canBookmark
                                ? null
                                : GestureDetector(
                                    onTap: () async {
                                      int response;
                                      if (isBookmark) {
                                        response = await APIs.unsaveRecipe(
                                            widget.recipe.id);
                                        Session.profile.savedIDs.removeWhere(
                                            (element) =>
                                                element == widget.recipe.id);
                                      } else {
                                        response = await APIs.saveRecipe(
                                            widget.recipe.id);
                                        Session.profile.savedIDs
                                            .add(widget.recipe.id);
                                      }
                                      print(response);
                                      setState(() {
                                        isBookmark = Session.profile.savedIDs
                                            .contains(widget.recipe.id);
                                        widget.onBookmarkChanged(true);
                                      });
                                    },
                                    child: Icon(
                                      Session.profile.savedIDs
                                              .contains(widget.recipe.id)
                                          ? Icons.bookmark
                                          : Icons.bookmark_outline,
                                      color: Colors.yellow,
                                    ),
                                  ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text("${widget.recipe.totalPrepTime} phút | ",
                                  style: TextStyle(color: Color(0xFF7A7A7A))),
                              Text(
                                widget.recipe.difficulty,
                                style: TextStyle(color: Color(0xFF7A7A7A)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
