import 'dart:convert';

import 'package:flutter/material.dart';
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
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back)),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Ingredients",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: 300,
                padding: EdgeInsets.fromLTRB(40, 200, 40, 10),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.recipe.imageUrl))),
                child: Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF2C2E2D).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://image.cooky.vn/usr/g13/126457/avt/s140/cooky-avatar-636658845110260221.jpg"),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Recipe by:",
                                style: TextStyle(color: Color(0xFF7A7A7A))),
                            Text("Tau Nhat Quang",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ))),
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text("Bánh Crepe Kem Sầu Riêng",
                        style: TextStyle(color: Color(0xFF2C2E2D))),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.bookmark_outline, color: Colors.green),
                  ],
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    SmoothStarRating(
                        allowHalfRating: true,
                        onRated: (v) {},
                        starCount: 5,
                        rating: 3.5,
                        size: 25.0,
                        isReadOnly: true,
                        color: Colors.green,
                        borderColor: Colors.green,
                        spacing: 0.0),
                    SizedBox(width: 40, child: Text("3.5")),
                    Icon(Icons.visibility),
                    Text("10"),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              (MediaQuery.of(context).size.width - 4) / 3, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<
                                  ContinuousRectangleBorder>(
                              ContinuousRectangleBorder()),
                        ),
                        child: Text(
                          "Ingredients",
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(
                      width: 2,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              (MediaQuery.of(context).size.width - 4) / 3, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<
                                  ContinuousRectangleBorder>(
                              ContinuousRectangleBorder()),
                        ),
                        child: Text(
                          "Instructions",
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(
                      width: 2,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              (MediaQuery.of(context).size.width - 4) / 3, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<
                                  ContinuousRectangleBorder>(
                              ContinuousRectangleBorder()),
                        ),
                        child: Text(
                          "Reviews",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            )
          ]));
    }
    return Scaffold(
      body: CircularProgressIndicator(),
    );
  }
}
