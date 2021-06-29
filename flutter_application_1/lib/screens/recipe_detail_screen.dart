import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/noti.dart';
import 'package:flutter_application_2/model/noti_db.dart';
import 'package:flutter_application_2/screens/myprofile_screen.dart';
import 'package:flutter_application_2/screens/profile.dart';
import 'package:googleapis/trafficdirector/v2.dart';
import 'package:html/parser.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:rating_bar/rating_bar.dart';
import '../apis.dart';

class RecipeDetail extends InheritedWidget {
  final double rating;
  RecipeDetail({Widget child, this.rating}) : super(child: child) {}

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static RecipeDetail of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RecipeDetail>();
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final ValueChanged<int> onBookmarkChanged;
  final Recipe recipe;
  RecipeDetailScreen({@required this.recipe, @required this.onBookmarkChanged});
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  String title;
  DateTime date;
  Recipe detail;
  double rating;
  bool isBookmark;
  int currentTab = 0;
  final pageController = PageController();
  final listWidget = <Widget>[];

  addNoti(NotiModel noti) {
    DatabaseProvider.db.addNewNote(noti);
    print("noti added successfully");
  }

  Future<void> initDetail() async {
    detail = await APIs.getRecipe(widget.recipe.id);
    rating = detail.avgRating;
    if (Session.isLogin)
      isBookmark = Session.profile.savedIDs.contains(detail.id);
    setState(() {
      listWidget.add(Introduction(
        detail: detail,
        onRatingChanged: (value) => setState(() => rating = value),
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
      print(detail.title);
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
              child: !Session.isLogin ||
                      detail.creator.username == Session.profile.username
                  ? null
                  : GestureDetector(
                      onTap: () async {
                        int response;
                        if (isBookmark) {
                          response = await APIs.unsaveRecipe(widget.recipe.id);
                          Session.profile.savedIDs.removeWhere(
                              (element) => element == widget.recipe.id);
                        } else {
                          response = await APIs.saveRecipe(widget.recipe.id);
                          Session.profile.savedIDs.add(widget.recipe.id);
                        }
                        print(response);
                        setState(() {
                          isBookmark = Session.profile.savedIDs
                              .contains(widget.recipe.id);
                          title =
                              "Lưu công thức ${widget.recipe.title} vào bộ sưu tập";
                          date = DateTime.now();
                        });
                        NotiModel noti = NotiModel(title: title, date: date);
                        addNoti(noti);
                      },
                      child: Icon(
                        isBookmark ? Icons.bookmark : Icons.bookmark_outline,
                        color: Colors.yellow.shade700,
                        size: 40,
                      ),
                    ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: RecipeDetail(
          rating: rating,
          child: Column(children: [
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.new_label), label: "Giới thiệu"),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_food_beverage), label: "Nguyên liệu"),
            BottomNavigationBarItem(
                icon: Icon(Icons.integration_instructions), label: "Hướng dẫn"),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTab,
          selectedItemColor: kSecondaryColor,
          onTap: (index) => setState(() {
            currentTab = index;
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Introduction extends StatefulWidget {
  final ValueChanged<double> onRatingChanged;
  final Recipe detail;
  Introduction({@required this.onRatingChanged, @required this.detail});

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  double rating;
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  void share(BuildContext context, Recipe recipe) {
    String title = "${recipe.title}\n";
    String description = "1. MÔ TẢ CHUNG:\n\n${recipe.description}\n";
    String ingre = "2. NGUYÊN LIỆU:\n\n";
    String step = "3. HƯỚNG DẪN THỰC HIỆN:\n\n";
    int idx = 0;
    recipe.ingredients.forEach((element) {
      idx += 1;
      ingre += idx.toString() +
          ". " +
          element.name +
          "     " +
          element.quantity +
          " " +
          element.unit +
          "\n";
    });
    idx = 0;
    recipe.steps.forEach((element) {
      idx += 1;
      step += idx.toString() + ". " + element.content + "\n\n";
      element.listImageUrl.forEach((elem) {
        step += elem + "\n";
      });
      step += "\n\n";
    });
    final String res = _parseHtmlString(
        title + "\n" + description + "\n" + ingre + "\n" + step);
    final RenderBox box = context.findRenderObject();
    Share.share(res,
        subject: recipe.title,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rating = RecipeDetail.of(context).rating;
    print(widget.detail.title);
    return Scaffold(
      floatingActionButton: Session.isLogin
          ? FloatingActionButton.extended(
              backgroundColor: kSecondaryColor,
              icon: Icon(Icons.reviews),
              label: Text("Rate"),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return SafeArea(
                        child: Container(
                          child: new Wrap(
                            children: <Widget>[
                              Center(
                                child: SmoothStarRating(
                                    allowHalfRating: true,
                                    onRated: (v) async {
                                      print("Asdfasfdasdfasdfasdfasdf  " +
                                          v.toString());
                                      rating = await APIs.rateRecipe(
                                          widget.detail.id, v * 2);

                                      widget.onRatingChanged(rating);
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    starCount: 5,
                                    size: 40.0,
                                    color: kSecondaryColor,
                                    borderColor: kSecondaryColor,
                                    spacing: 0.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            )
          : null,
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 175,
                        child: Text(widget.detail.title,
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
                  child: GestureDetector(
                    child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.detail.creator.avatarUrl)),
                    onTap: () async {
                      final profile =
                          await APIs.getProfile(widget.detail.creator.username);

                      if (profile == null)
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Lỗi"),
                                  content: Text("Không tìm thấy người dùng"),
                                ));
                      else
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Session.isLogin &&
                                        profile.username ==
                                            Session.profile.username
                                    ? MyProfileScreen()
                                    : ProfileScreen(
                                        profile: profile,
                                      )));
                    },
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      RatingBar.readOnly(
                        isHalfAllowed: true,
                        filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        halfFilledIcon: Icons.star_half,
                        initialRating: rating / 2,
                        size: 30,
                        emptyColor: kSecondaryColor,
                        filledColor: kSecondaryColor,
                        halfFilledColor: kSecondaryColor,
                      ),
                      Icon(Icons.visibility),
                      Text(widget.detail.totalView.toString()),
                    ],
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 80,
                  child: Text(
                    widget.detail.creator.displayName,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
            ],
          ),
          Session.isLogin
              ? MaterialButton(
                  color: kSecondaryColor,
                  onPressed: () {
                    return share(context, widget.detail);
                  },
                  child: SizedBox(
                    width: 70,
                    child: Row(
                      children: [
                        Text("Share", style: TextStyle(color: Colors.white)),
                        SizedBox(width: 5),
                        Icon(
                          Icons.share,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ))
              : SizedBox(width: 0),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(_parseHtmlString(widget.detail.description)),
          ),
        ]),
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
