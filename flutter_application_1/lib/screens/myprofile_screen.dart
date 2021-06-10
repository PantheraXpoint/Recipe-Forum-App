import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-card.dart';
import 'package:flutter_application_2/model/Profile.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:flutter_application_2/screens/post_recipe_screen.dart';

import 'drive_integration/ggDrive.dart';
import 'edit_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  // final Profile myprofile;
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // final Profile myprofile;
  // _MyProfileScreenState({@required this.myprofile});
  final drive = GoogleDrive();
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
                          child:
                              Text("Nhat Quang", textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                    child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 90,
                                child: Text(
                                  "2",
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 90,
                                child: Text("Công thức cá nhân",
                                    textAlign: TextAlign.center))
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
                                width: 90,
                                child: Text(
                                  "89",
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 90,
                                child: Text(
                                  "Công thức sưu tầm",
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
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
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(400, 40)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kSecondaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  child: Text(
                    "Chỉnh sửa trang cá nhân",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
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
                                      padding:
                                          EdgeInsets.only(top: 50, left: 10),
                                    ),
                                    Text("Công thức của bạn",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    SizedBox(width: 60),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostRecipeScreen()));
                                      },
                                      splashColor: kPrimaryColor,
                                      tooltip: "Thêm bài đăng",
                                      icon: Icon(Icons.add, size: 30),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      splashColor: kPrimaryColor,
                                      tooltip: "Xóa bài đăng",
                                      icon: Icon(
                                        Icons.remove,
                                        size: 30,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      splashColor: kPrimaryColor,
                                      tooltip: "Chỉnh sửa bài đăng",
                                      icon: Icon(Icons.edit, size: 30),
                                    )
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
                                      padding:
                                          EdgeInsets.only(top: 50, left: 10),
                                    ),
                                    Text("Bộ sưu tập",
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
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera),
          label: Text("Upload Drive"),
          onPressed: () async {
            FilePickerResult result = await FilePicker.platform.pickFiles();
            var file = File(result.files.single.path);
            drive.upload(file);
          },
        ));
  }
}
