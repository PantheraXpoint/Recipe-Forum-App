import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/signup_screen.dart';

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
  String username;
  String password;
  String message;
  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    message = "";
  }

  bool isValidInput() {
    // if (!EmailValidator.validate(email)) {
    //   message = "Invalid email!";
    //   return false;
    // }
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
                            "Cooky",
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
                        setState(() {
                          if (isValidInput())
                            APIs.login(username, password).then((value) {
                              if (value)
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
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
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: kText),
                  ),
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
