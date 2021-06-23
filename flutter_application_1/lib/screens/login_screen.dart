import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/signup_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../apis.dart';
import '../components/constaints.dart';
import '../components/email_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // FlutterLocalNotificationsPlugin localNotification;
  String username;
  String password;
  String message;
  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    message = "";
    // var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    // var initializationSettings =
    //     new InitializationSettings(android: androidInitialize);
    // localNotification = new FlutterLocalNotificationsPlugin();
    // localNotification.initialize(initializationSettings);
  }

  // Future _showNotification() async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       "channelId", "Local Notification", "channelDescription",
  //       importance: Importance.max);
  //   var generalNotificationDetails =
  //       new NotificationDetails(android: androidDetails);
  //   await localNotification.show(0, "s", "S", generalNotificationDetails);
  // }

  bool isValidInput() {
    if (username.isEmpty || password.isEmpty) {
      message = "Email or password missing!";
      return false;
    }
    message = "";
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: Column(
              children: [
                Container(
                  child: MediaQuery.of(context).viewInsets.bottom != 0
                      ? null
                      : Container(
                          padding: EdgeInsets.only(top: 60, bottom: 45),
                          child: Text(
                            "eRecipe",
                            style: TextStyle(color: kText, fontSize: 50),
                          ),
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: UsernameInput(
                      onEmailChanged: (value) {
                        username = value;
                      },
                      onPasswordChanged: (value) {
                        password = value;
                      },
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                      onPressed: () {
                        // _showNotification();
                        setState(() {
                          if (isValidInput())
                            APIs.login(username, password).then((value) {
                              if (value) {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()))
                                    .then((value) => APIs.logout());
                              } else
                                setState(() {
                                  message = "Wrong username or password";
                                });
                            });
                        });
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(200, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kSecondaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: Text(
                        "Log in",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()))
                        .then((value) => APIs.logout());
                  },
                  child: Text(
                    "Login as guest",
                    style: TextStyle(color: kText),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                Container(
                  child: MediaQuery.of(context).viewInsets.bottom != 0
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(color: kText, fontSize: 13),
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          ),
        ));
  }
}
