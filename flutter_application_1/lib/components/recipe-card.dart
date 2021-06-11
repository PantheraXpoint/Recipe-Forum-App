import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:flutter_application_2/screens/recipe_detail_screen.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final double scale;
  RecipeCard({@required this.recipe, this.scale});
  @override
  State<StatefulWidget> createState() => RecipeCardState();
}

class RecipeCardState extends State<RecipeCard> {
  bool isBookmark = false;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailScreen(recipe: widget.recipe)));
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
                    height: widget.recipe.title.length < 40 ? 90 : 110,
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
                            GestureDetector(
                              onTap: () => setState(() {
                                isBookmark = !isBookmark;
                              }),
                              child: Icon(
                                isBookmark
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: Colors.yellow,
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Text("{widget.recipe.totalPrepTime} phút | ",
                                    style: TextStyle(color: Color(0xFF7A7A7A))),
                                Text(
                                  "widget.recipe.difficulty",
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
      ),
    );
  }
}
