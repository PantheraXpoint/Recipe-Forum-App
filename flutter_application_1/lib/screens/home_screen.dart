import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-card-list-horizontal.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //int _index = 0;

  List<Recipe> recipeList = [
    Recipe(
        recipeId: 1,
        title: "Bún đậu mắm tôm",
        totalPrepTime: 30.0,
        difficulty: "BEGINNER",
        imageUrl:
            "https://media.istockphoto.com/photos/vietnamese-traditional-plate-pork-vermicelli-tofu-the-popular-lunch-picture-id1220057044?s=612x612"),
    Recipe(
        recipeId: 2,
        title: "Bún bò giò heo",
        totalPrepTime: 60.0,
        difficulty: "INTERMEDIATE",
        imageUrl:
            "https://cdn.pixabay.com/photo/2016/05/09/10/26/rice-1381146__340.jpg"),
    Recipe(
        recipeId: 3,
        title: "Phở gà",
        difficulty: "ADVANCE",
        totalPrepTime: 180.0,
        imageUrl:
            "https://cdn.pixabay.com/photo/2016/03/09/15/22/food-1246621__340.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 100, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello user,",
                style: TextStyle(
                  color: kText,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Looking for some fresh recipe?",
                style: TextStyle(
                  color: kSecondaryText,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: kSecondaryText,
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[60],
                  hintText: "Find your favorite recipe here",
                  hintStyle: TextStyle(
                    color: kUnhighlightedColor,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text("Trending recipes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              RecipeCardListHorizontal(
                recipeList: recipeList,
              ),
              SizedBox(
                height: 20,
              ),
              Text("Món nhậu",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              RecipeCardListHorizontal(
                recipeList: recipeList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
