import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  RecipeCard({@required this.recipe});
  @override
  State<StatefulWidget> createState() => RecipeCardState();
}

class RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 20),
              width: double.infinity,
              height: 100,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          widget.recipe.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.bookmark_outline,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.recipe.totalPrepTime.toString(),
                      ),
                      VerticalDivider(),
                      Text(recipeDiffiCultyMap(widget.recipe.difficulty)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
