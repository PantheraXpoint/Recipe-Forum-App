import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/apis.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-card-list-horizontal.dart';
import 'package:flutter_application_2/model/Profile.dart';
import 'package:flutter_application_2/model/Recipe.dart';
import 'package:flutter_application_2/screens/post_recipe_screen.dart';

import 'drive_integration/ggDrive.dart';
import 'edit_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  // final Profile myprofile;
  final Profile myprofile;
  MyProfileScreen({@required this.myprofile});
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final drive = GoogleDrive();

  List<Recipe> list = [];

  Future<void> initMyProfileRecipeList() async {
    list = await APIs.getProfileRecipe(widget.myprofile.username);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initMyProfileRecipeList();
  }

  @override
  Widget build(BuildContext context) {
    print("-------------------------------------------------------");
    print(widget.myprofile.totalRecipe);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 20, bottom: 10),
              color: kPrimaryColor,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(widget.myprofile.username,
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 15.8,
                          fontWeight: FontWeight.bold))),
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
                            backgroundImage:
                                NetworkImage(widget.myprofile.avatarUrl),
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
                          child: Text(
                            widget.myprofile.displayName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
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
                                  widget.myprofile.totalRecipe.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 90,
                                child: Text(
                                  "Công thức cá nhân",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kText),
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
                                width: 90,
                                child: Text(
                                  widget.myprofile.totalRecipe.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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
                                  style: TextStyle(color: kText),
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
                          MaterialStateProperty.all<Color>(kPrimaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  child: Text(
                    "Chỉnh sửa trang cá nhân",
                    style: TextStyle(color: Colors.black),
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
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    child: Row(
                                      children: [
                                        Text("Công thức của bạn",
                                            style: TextStyle(
                                                color: kSecondaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        Expanded(
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    Recipe newRecipe =
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PostRecipeScreen()));

                                                    setState(() {
                                                      list.add(newRecipe);
                                                    });
                                                  },
                                                  splashColor: kPrimaryColor,
                                                  tooltip: "Thêm bài đăng",
                                                  icon:
                                                      Icon(Icons.add, size: 30),
                                                )))
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: list == null || list.length == 0
                                      ? CircularProgressIndicator()
                                      : RecipeCardListHorizontal(
                                          onRecipeDeleted: (value) => setState(
                                              () => list.removeWhere(
                                                  (element) =>
                                                      element.id == value)),
                                          canDelete: true,
                                          recipeList: list,
                                          scale: 0.9,
                                        ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Bộ sưu tập",
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    SizedBox(
                                      width: 240,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      splashColor: kPrimaryColor,
                                      tooltip: "Xóa bài đăng",
                                      icon: Icon(
                                        Icons.delete,
                                        size: 30,
                                      ),
                                    ),
                                  ],
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
