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
    return Column(
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
        )
      ],
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
