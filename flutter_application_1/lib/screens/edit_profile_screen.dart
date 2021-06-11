import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/Profile.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../apis.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _image;
  Profile profile;
  Future<void> initProfile() async {
    profile = await APIs.getMyProfile();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  Future _imgFromCamera() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 50);
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = File(image.path);
    });
  }

  Future _imgFromGallery() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 50);
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = File(image.path);
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
    if (profile != null) {
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
            IconButton(
              icon: Icon(
                Icons.edit,
                color: kText,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500, color: kText),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color:
                                _image == null ? kPrimaryColor : Colors.white,
                            image: _image == null
                                ? null
                                : DecorationImage(image: FileImage(_image)),
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 5,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10),
                              ),
                            ],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                            child: Icon(Icons.camera, color: Colors.white),
                          )),
                      SizedBox(
                        height: 35,
                      )
                    ],
                  ),
                ),
                buildTextField("User Name", profile.username),
                buildTextField("Display Name", profile.displayName),
                buildTextField("Avatar Link", profile.avatarUrl),
                buildTextField("Total Recipe", profile.totalRecipe.toString()),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 50, right: 50),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(50, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kSecondaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: Text(
                        "Sign out",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "Delete your account",
                    style: TextStyle(color: kText, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }
}
