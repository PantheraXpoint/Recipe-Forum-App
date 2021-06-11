import 'package:flutter/material.dart';
import 'package:flutter_application_2/apis.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Recipe.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> list = [];
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
        ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    print(value);
                    query = value;
                  },
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        list = await APIs.searchRecipe(query);
                        setState(() {});
                      },
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
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (context, i) => SizedBox(
                      height: 400,
                      child: RecipeCard(
                          recipe: list[i],
                          canDelete: false,
                          initialBookmark: false),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
