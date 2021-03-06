import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/dynamic_links_service/dynamic_link_service.dart';
import 'package:flutter_application_2/components/recipe-slider.dart';
import 'package:flutter_application_2/model/Profile.dart';

import 'package:flutter_application_2/model/Recipe.dart';
import 'package:flutter_application_2/screens/notification.dart';
import 'package:flutter_application_2/screens/search_screen.dart';

import '../apis.dart';
import 'note_taking.dart';
import 'myprofile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Recipe> listRecipe = [];
  final listWidget = <Widget>[];
  final pageController = PageController();
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  int currentTab = 0;

  Future handleStartUp() async {
    await _dynamicLinkService.handleDynamicLinks();
  }

  Future<void> initRecipeList() async {
    listRecipe = await APIs.getListRecipes();
    Session.profile = await APIs.getMyProfile();
    Session.isLogin = Session.profile != null;
    print(Session.isLogin);
    if (Session.isLogin) {
      Session.savedRecipes = Session.profile.savedIDs;
      Session.myRecipes = await APIs.getProfileRecipe(Session.profile.username);
    }

    setState(() {
      listWidget.add(Home(
        list: listRecipe,
        profile: Session.profile,
      ));
      if (Session.profile != null) {
        listWidget.add(MyProfileScreen());
      }
      listWidget.add(NoteScreen());
      print(listWidget.length);
    });
  }

  @override
  void initState() {
    super.initState();
    handleStartUp();
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
          bottomNavigationBar: !Session.isLogin
              ? null
              : BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.book), label: "Profile"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.note), label: "Note")
                  ],
                  type: BottomNavigationBarType.fixed,
                  currentIndex: currentTab,
                  selectedItemColor: kSecondaryColor,
                  onTap: (value) => setState(() {
                    currentTab = value;
                    pageController.animateToPage(value,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn);
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

class Home extends StatefulWidget {
  final List<Recipe> list;
  final Profile profile;
  Home({@required this.list, @required this.profile});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final sliders = List.generate(
      10,
      (index) => RecipeSlider(
        onBookmarkChanged: (value) {
          print("home");
          setState(() {});
        },
        list: widget.list,
        type: index,
      ),
    );

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
          SizedBox(
              child: IconButton(
            icon: Icon(
              Icons.notifications_active,
              color: kText,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
            },
          )),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Session.isLogin
                    ? "Hello ${widget.profile.displayName},"
                    : "Hello user",
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen())).then((value) {
                    print("home");
                    setState(() {});
                  });
                },
                child: TextFormField(
                  enabled: false,
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
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                child: widget.list == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Column(
                            children: [
                              RecipeSlider(
                                onBookmarkChanged: (value) {
                                  print("home");
                                  setState(() {});
                                },
                                list: widget.list,
                              ),
                              RecipeSlider(
                                onBookmarkChanged: (value) {
                                  print("home");
                                  setState(() {});
                                },
                                list: widget.list,
                                difficulty: "D???",
                              ),
                              RecipeSlider(
                                onBookmarkChanged: (value) {
                                  print("home");
                                  setState(() {});
                                },
                                list: widget.list,
                                difficulty: "Trung b??nh",
                              ),
                              RecipeSlider(
                                onBookmarkChanged: (value) {
                                  print("home");
                                  setState(() {});
                                },
                                list: widget.list,
                                difficulty: "Kh??",
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
      ),
    );
  }
}
