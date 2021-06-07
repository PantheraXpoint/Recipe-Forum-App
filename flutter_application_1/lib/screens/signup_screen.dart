import '../apis.dart';
import '../components/constaints.dart';
import '../components/email_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  String username;
  String password;
  String display;
  String message;

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    message = "";
  }

  bool isValidInput() {
    if (username.isEmpty || password.isEmpty || display.isEmpty) {
      message = "Please enter full information!";
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
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 60, bottom: 15, left: 20),
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: kText, fontSize: 30),
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
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: UsernameInput(onEmailChanged: (value) {
                    username = value;
                  }, onPasswordChanged: (value) {
                    password = value;
                  }, onDisplayChanged: (value) {
                    display = value;
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isValidInput())
                            APIs.signup(username, password, display)
                                .then((value) {
                              if (value) Navigator.pop(context);
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
                        "Sign up",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign In",
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
