import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/apis.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String avatarUrl;

  const EditProfileScreen({@required this.avatarUrl});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _image;
  String url;
  String display;
  String newPwd;
  FocusNode focusDisplay = FocusNode();
  FocusNode focusNewPwd = FocusNode();
  FocusNode focusConfirm = FocusNode();
  @override
  void initState() {
    super.initState();
    url = display = newPwd = "";
  }

  @override
  void dispose() {
    super.dispose();
    focusDisplay.dispose();
    focusNewPwd.dispose();
    focusConfirm.dispose();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 25, right: 20),
          child: Column(
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
                          color: _image == null ? kPrimaryColor : Colors.white,
                          image: _image == null
                              ? null
                              : DecorationImage(image: FileImage(_image)),
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                          ),
                          child: Icon(Icons.camera, color: Colors.white),
                        )),
                    SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
              TextField(
                  onTap: () {
                    focusDisplay.requestFocus();
                  },
                  focusNode: focusDisplay,
                  onChanged: (value) => display = value,
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Tên hiển thị mới",
                  )),
              SizedBox(
                height: 15,
              ),
              TextField(
                  onTap: () {
                    focusNewPwd.requestFocus();
                  },
                  focusNode: focusNewPwd,
                  onChanged: (value) => newPwd = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Mật khẩu mới",
                  )),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  focusConfirm.requestFocus();
                  showDialog(
                      context: context,
                      builder: (context) {
                        String confirm;
                        return AlertDialog(
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                TextFormField(
                                  focusNode: focusConfirm,
                                  obscureText: true,
                                  onChanged: (value) => confirm = value,
                                  decoration: InputDecoration(
                                      hintText: "Xác nhận mật khẩu"),
                                ),
                                SizedBox(height: 15),
                                Expanded(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: kSecondaryColor),
                                  child: Text("Xác nhận"),
                                  onPressed: () async {
                                    if (_image != null)
                                      url = await APIs.getImageUrl(_image);

                                    int response = await APIs.editProfile(
                                        display, newPwd, url, confirm);

                                    if (response == 200)
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text("Sửa thành công"),
                                              )).then((value) {
                                        Navigator.pop(context);
                                        focusDisplay.unfocus();
                                        focusNewPwd.unfocus();
                                      });
                                    else
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text("Sửa thất bại"),
                                              )).then((value) {
                                        Navigator.pop(context);
                                        focusDisplay.unfocus();
                                        focusNewPwd.unfocus();
                                      });
                                  },
                                ))
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Text("Xác nhận sửa"),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 50)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kSecondaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      String confirm;
                                      return AlertDialog(
                                          content: SizedBox(
                                              height: 100,
                                              child: Column(children: [
                                                TextFormField(
                                                  focusNode: focusConfirm,
                                                  obscureText: true,
                                                  onChanged: (value) =>
                                                      confirm = value,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Xác nhận mật khẩu"),
                                                ),
                                                SizedBox(height: 15),
                                                Expanded(
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary:
                                                                    kSecondaryColor),
                                                        child: Text("Xác nhận"),
                                                        onPressed: () async {
                                                          int response =
                                                              await APIs
                                                                  .deleteAccount(
                                                                      confirm);
                                                          print(response);
                                                          if (response == 200)
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                          content:
                                                                              Text("Sửa thành công"),
                                                                        )).then(
                                                                (value) {
                                                              Navigator.popUntil(
                                                                  context,
                                                                  ModalRoute
                                                                      .withName(
                                                                          "/"));
                                                            });
                                                          else
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                          content:
                                                                              Text("Sửa thất bại"),
                                                                        )).then(
                                                                (value) {
                                                              Navigator.popUntil(
                                                                  context,
                                                                  ModalRoute
                                                                      .withName(
                                                                          "/"));
                                                            });
                                                        })),
                                              ])));
                                    });
                              },
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(300, 50)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          kPrimaryColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: Text(
                                "Xóa tài khoản",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )),
                          SizedBox(height: 15),
                          ElevatedButton(
                              onPressed: () async {
                                int response = await APIs.logout();

                                if (response == 200)
                                  Navigator.popUntil(
                                      context, ModalRoute.withName("/"));
                              },
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(300, 50)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          kPrimaryColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: Text(
                                "Đăng xuất",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )),
                        ],
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
