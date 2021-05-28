import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_application_2/model/Recipe.dart';

class TitleContainer extends StatelessWidget {
  final Recipe recipe;
  TitleContainer({@required this.recipe});
  final double width = 170.0;
  final double height = 70.0;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.0,
                sigmaY: 1.0,
              ),
              child: Container(

                  // width: width,
                  // height: height,
                  ),
            ),
            Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade900.withOpacity(0.9),
                      Colors.grey.shade900.withOpacity(0.9),
                    ],
                    stops: [
                      0.0,
                      1.0
                    ]),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        recipe.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.bookmark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
