import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-slider.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Recipe> list = [];

  Future<List<Recipe>> listRecipes() async {
    final response = await http.get(Uri.http(BASE_URL, "/recipe"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    if (response.statusCode == 200) {
      Iterable i = json.decode(response.body);
      List<Recipe> list =
          List<Recipe>.from(i.map((e) => Recipe.fromJson(e)).toList());
      return list;
    }
    return null;
  }

  Future<void> initRecipeList() async {
    list = await listRecipes();
    setState(() {});
  }

  List<Recipe> recipeList = [];
  @override
  void initState() {
    super.initState();
    initRecipeList();
  }

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
              RecipeSlider(
                list: list,
              ),
              RecipeSlider(
                list: list,
                difficulty: "Dễ",
              ),
              RecipeSlider(
                list: list,
                difficulty: "Trung bình",
              ),
              RecipeSlider(
                list: list,
                difficulty: "Khó",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
