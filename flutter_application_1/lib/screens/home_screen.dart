import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-slider.dart';
import 'package:flutter_application_2/model/Profile.dart';

import 'package:flutter_application_2/model/Recipe.dart';

import '../apis.dart';
import 'myprofile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Recipe> listRecipe = [];
  Profile profile;

  final listWidget = <Widget>[];
  final pageController = PageController();
  int currentTab = 0;

  Future<void> initRecipeList() async {
    listRecipe = await APIs.getListRecipes();
    profile = await APIs.getMyProfile();
    setState(() {
      listWidget.add(Home(
        list: listRecipe,
        profile: profile,
      ));

      listWidget.add(MyProfileScreen(myprofile: profile));
      print(listWidget.length);
    });
  }

  @override
  void initState() {
    super.initState();
    initRecipeList();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listRecipe.length != 0)
      return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: "Profile")
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab,
            selectedItemColor: kSecondaryColor,
            onTap: (value) => setState(() {
              currentTab = value;
              pageController.animateToPage(value,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            }),
          ),
          resizeToAvoidBottomInset: false,
          body: PageView(
            controller: pageController,
            children: listWidget,
            onPageChanged: (value) => setState(() => currentTab = value),
          ));
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class Home extends StatelessWidget {
  final List<Recipe> list;
  final Profile profile;
  Home({@required this.list, @required this.profile});

  @override
  Widget build(BuildContext context) {
    final sliders = List.generate(
      10,
      (index) => RecipeSlider(
        list: list,
        type: index,
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 100, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello ${profile.displayName},",
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
              enabled: false,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Scaffold())),
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
            SizedBox(
              child: list == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Column(
                          children: [
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
                        Column(children: sliders),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
