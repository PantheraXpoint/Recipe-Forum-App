import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'home_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  RecipeDetailScreen({@required this.recipe});
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            color: kPrimaryColor,
            child: Row(children: [
              SizedBox(
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  )),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: Text("Ingredient", textAlign: TextAlign.center)),
                  SizedBox(
                    width: 50,
                  )
                ],
              ))
            ]),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.recipe.imageUrl))),
              padding: EdgeInsets.fromLTRB(40, 180, 40, 20),
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
}
