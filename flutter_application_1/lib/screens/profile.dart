import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/apis.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/components/recipe-card-list-horizontal.dart';
import 'package:flutter_application_2/model/Profile.dart';
import 'package:flutter_application_2/model/Recipe.dart';

import 'drive_integration/ggDrive.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;
  ProfileScreen({@required this.profile});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final drive = GoogleDrive();
  List<Recipe> list = [];
  // Profile myprofile;
  // _MyProfileScreenState({@required this.myprofile});
  // int _index = 0;
  Future<void> initProfileRecipeList() async {
    list = await APIs.getProfileRecipe(widget.profile.username);
    setState(() {
      print(list.length);
    });
  }

  @override
  void initState() {
    super.initState();
    initProfileRecipeList();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text(widget.profile.username,
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
                                NetworkImage(widget.profile.avatarUrl),
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
                            widget.profile.displayName,
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
                                  widget.profile.totalRecipe.toString(),
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
                                  widget.profile.totalRecipe.toString(),
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
              height: 30,
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
                                    Text("Công thức sở hữu",
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    SizedBox(width: 60),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: list == null || list.length == 0
                                      ? CircularProgressIndicator()
                                      : RecipeCardListHorizontal(
                                        canEdit: false,
                                          canBookmark: false,
                                          onBookmarkChanged: (value) {},
                                          recipeList: list,
                                          scale: 0.9,
                                          canDelete: false,
                                        ),
                                )
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
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
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
