import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../apis.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  RecipeDetailScreen({@required this.recipe});
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe detail;
  bool isBookmark = false;
  int currentTab = 0;
  final pageController = PageController();
  final listWidget = <Widget>[];

  Future<void> initDetail() async {
    detail = await APIs.getRecipeDetail(widget.recipe);
    setState(() {
      listWidget.add(Introduction(
        detail: detail,
      ));
      listWidget.add(Ingredient(detail: detail));
      listWidget.add(Steps(
        detail: detail,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    initDetail();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (detail != null && detail.creator != null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: kText,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              GestureDetector(
                onTap: () => () {
                  isBookmark = !isBookmark;
                },
                child: Icon(
                    isBookmark ? Icons.bookmark : Icons.bookmark_outline,
                    color: Colors.yellow),
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.recipe.imageUrl))),
            ),
            Expanded(
                child: PageView(
              children: listWidget,
              controller: pageController,
              onPageChanged: (value) => setState(() => currentTab = value),
            ))
          ]),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.new_label), label: "Giới thiệu"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_food_beverage), label: "Nguyên liệu"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.integration_instructions),
                  label: "Hướng dẫn"),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab,
            selectedItemColor: kSecondaryColor,
            onTap: (index) => setState(() {
              currentTab = index;
              pageController.animateToPage(index,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            }),
          ));
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Introduction extends StatelessWidget {
  final Recipe detail;
  Introduction({@required this.detail});
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 20),
      child: Column(children: [
        Row(
          children: [
            SizedBox(
                width: 250,
                child: Row(
                  children: [
                    SizedBox(
                      width: 175,
                      child: Text(detail.title,
                          style: TextStyle(
                              color: Color(0xFF2C2E2D), fontSize: 15.8)),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                  ],
                )),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundImage: NetworkImage(detail.creator.avatarUrl),
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
                    Text(detail.totalView.toString()),
                  ],
                )),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 80,
                child: Text(
                  detail.creator.displayName,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text(_parseHtmlString(detail.description)),
        )
      ]),
    );
  }
}

class Ingredient extends StatelessWidget {
  final Recipe detail;
  Ingredient({@required this.detail});

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: detail.ingredients.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) => ListTile(
              title: Row(
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
            ));
  }
}

class Steps extends StatelessWidget {
  final Recipe detail;
  Steps({@required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: detail.steps.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) => ListTile(
          title: Column(
        children: [
          RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: [
                TextSpan(
                    text: "Bước ${index + 1}: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: detail.steps[index].content)
              ])),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            child: detail.steps[index].listImageUrl.length == 0
                ? null
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) => Image(
                            image: NetworkImage(
                                detail.steps[index].listImageUrl[i])),
                        separatorBuilder: (context, i) => SizedBox(
                              width: 10,
                            ),
                        itemCount: detail.steps[index].listImageUrl.length),
                  ),
          )
        ],
      )),
    );
  }
}
