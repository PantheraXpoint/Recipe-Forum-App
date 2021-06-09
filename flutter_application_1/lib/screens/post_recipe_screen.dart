import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:image_picker/image_picker.dart';

class PostRecipeScreen extends StatefulWidget {
  @override
  _PostRecipeScreenState createState() => _PostRecipeScreenState();
}

class _PostRecipeScreenState extends State<PostRecipeScreen> {
  bool isBookmark = false;

  int currentTab = 0;
  final pageController = PageController();
  final listWidget = <Widget>[];

  Future<void> initDetail() async {
    setState(() {
      listWidget.add(Introduction());
      listWidget.add(Ingredient());
      listWidget.add(Steps());
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
        ),
        resizeToAvoidBottomInset: false,
        body: PageView(
          children: listWidget,
          controller: pageController,
          onPageChanged: (value) => setState(() => currentTab = value),
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
        ));
  }
}

class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  File _image;
  String level = "";
  String defaultFT = "Khai vị";
  List<String> foodtype = [
    "Khai vị",
    "Tráng miệng",
    "Món Chay",
    "Món chính",
    "Ăn sáng",
    "Nhanh và dễ",
    "Thức uống",
    "Bánh",
    "Món ăn cho trẻ",
    "Món nhậu"
  ];
  void lv(String value) {
    setState(() {
      level = value;
    });
  }

  void getFoodType(String value) {
    setState(() {
      defaultFT = value;
    });
  }

  Future _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 280,
            child: GestureDetector(
              onTap: () => _showPicker(context),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: _image == null ? Colors.grey : Colors.white,
                      image: _image == null
                          ? null
                          : DecorationImage(image: FileImage(_image))),
                  child: _image == null
                      ? Center(
                          child: Text(
                            "Nhấn để thêm hình nền",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : null),
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Thịt bò xào",
                        labelText: "Tên nguyên liệu",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Mức độ:")),
                      SizedBox(
                        width: 70,
                        child: Row(
                          children: [
                            Radio(
                                value: "Dễ",
                                groupValue: level,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  lv(value);
                                }),
                            Text("Dễ")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Row(
                          children: [
                            Radio(
                                value: "Trung bình",
                                groupValue: level,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  lv(value);
                                }),
                            Text("Trung bình")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            Radio(
                                value: "Khó",
                                groupValue: level,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  lv(value);
                                }),
                            Text("Khó")
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Loại món ăn:")),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        child: DropdownButton(
                            onChanged: (value) {
                              getFoodType(value);
                            },
                            iconDisabledColor: Colors.pink,
                            value: defaultFT,
                            items: foodtype.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        focusColor: Colors.red,
                        hintText: "Món ăn đậm chất truyền thống,.....",
                        labelText: "Mô tả",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class Ingredient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('b'),
    );
  }
}

class Steps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('c'),
    );
  }
}
