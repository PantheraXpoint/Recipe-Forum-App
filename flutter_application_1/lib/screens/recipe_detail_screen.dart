import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  RecipeDetailScreen({@required this.recipe});
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isBookmark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
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
              padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF2C2E2D).withOpacity(0.9)),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          "https://image.cooky.vn/usr/g13/126457/avt/s/cooky-avatar-636658845110260221.jpg")),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Recipe by:",
                        style: TextStyle(color: Color(0xFF7A7A7A)),
                      ),
                      //SizedBox(height: 5),
                      Text(
                        "Vũ Đức Huy",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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
