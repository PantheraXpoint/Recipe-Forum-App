import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Profile.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:flutter_application_2/screens/post_recipe_screen.dart';

import 'edit_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  // final Profile myprofile;
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // final Profile myprofile;
  // _MyProfileScreenState({@required this.myprofile});
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: 40, left: 20, bottom: 10),
            color: Colors.pink.shade200,
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text("Tau Nhat Quang",
                    style:
                        TextStyle(color: Color(0xFF2C2E2D), fontSize: 15.8))),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://media.cooky.vn/usr/g43/420151/avt/c60x60/cooky-avatar-637113450729148354.jpg"),
                          radius: 50,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Nhat Quang", textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                  child: Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 60,
                              child: Text(
                                "2",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 60,
                              child:
                                  Text("Bai viet", textAlign: TextAlign.center))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 60,
                              child: Text(
                                "89",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 60,
                              child: Text(
                                "Nguoi theo doi",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 60,
                              child: Text(
                                "177",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 60,
                              child: Text(
                                "Dang theo doi",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(400, 40)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kSecondaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                child: Text(
                  "Chinh sua trang ca nhan",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Text("Following", textAlign: TextAlign.left),
            ],
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://media.cooky.vn/usr/g43/420151/avt/c60x60/cooky-avatar-637113450729148354.jpg",
                          ),
                          radius: 25,
                        ),
                    separatorBuilder: (context, i) => SizedBox(
                          width: 20,
                        ),
                    itemCount: 10),
              )),
          Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      appBar: TabBar(
                        indicatorColor: kPrimaryColor,
                        tabs: [
                          Tab(
                              icon: Icon(
                            Icons.access_alarm_rounded,
                            color: kSecondaryColor,
                          )),
                          Tab(
                              icon: Icon(Icons.access_alarm_sharp,
                                  color: kSecondaryColor)),
                        ],
                      ),
                      body: TabBarView(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50, left: 10),
                                  ),
                                  Text("Your recipes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (context, i) => Image(
                                    height: 80,
                                    width: 80,
                                    image: NetworkImage(
                                        "https://media.cooky.vn/usr/g43/420151/avt/c60x60/cooky-avatar-637113450729148354.jpg"),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50, left: 10),
                                  ),
                                  Text("Your collection",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (context, i) => Image(
                                    height: 80,
                                    width: 80,
                                    image: NetworkImage(
                                        "https://media.cooky.vn/usr/g43/420151/avt/c60x60/cooky-avatar-637113450729148354.jpg"),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: kSecondaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PostRecipeScreen()));
        },
      ),
    );
  }
}
