import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:flutter_application_2/model/RecipeDetail.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  RecipeDetailScreen({@required this.recipe});
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isBookmark = false;
  RecipeDetail detail;

  Future<RecipeDetail> getDetail() async {
    final response = await http
        .get(Uri.http(BASE_URL, "recipe-detail/${widget.recipe.recipeId}"));
    print("Done requesting");
    if (response.statusCode == 200) {
      print("Request successfully");
      return RecipeDetail.fromJson(json.decode(response.body)[0]);
    }

    return null;
  }

  Future<void> initDetail() async {
    detail = await getDetail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDetail();
  }

  @override
  Widget build(BuildContext context) {
    if (detail != null && detail.creator != null) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              color: kPrimaryColor,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.recipe.imageUrl))),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 250,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: Text(widget.recipe.title,
                                      style:
                                          TextStyle(color: Color(0xFF2C2E2D))),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(Icons.bookmark_outline,
                                    color: Colors.yellow),
                              ],
                            )),
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(detail.creator.avatarUrl),
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 250,
                            child: Row(
                              children: [
                                SmoothStarRating(
                                    allowHalfRating: true,
                                    onRated: (v) {},
                                    starCount: 5,
                                    rating: detail.avgRating / 2,
                                    size: 25.0,
                                    isReadOnly: true,
                                    color: Colors.yellow,
                                    borderColor: Colors.yellow,
                                    spacing: 0.0),
                                Icon(Icons.visibility),
                                Text("10"),
                              ],
                            )),
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 80,
                            child: Text(
                              detail.creator.name,
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 280,
                width: 370,
                child: ListView.separated(
                  itemCount: detail.ingredients.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => Row(
                    children: [
                      SizedBox(
                        width: 185,
                        child: Text(detail.ingredients[index].name),
                      ),
                      Expanded(
                        child: Text(
                          _parseHtmlString(detail.ingredients[index].quantity +
                              " " +
                              detail.ingredients[index].unit),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Hướng dẫn thực hiện",
                  textAlign: TextAlign.right,
                ),
                style: ElevatedButton.styleFrom(primary: kSecondaryColor))
          ]));
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
}
