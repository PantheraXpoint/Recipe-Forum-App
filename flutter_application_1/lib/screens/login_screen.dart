import 'dart:convert';

import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/signup_screen.dart';

import '../components/constaints.dart';
import '../components/email_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  String message;
  @override
  void initState() {
    super.initState();
    email = "";
    password = "";
    message = "";
  }

  bool isValidInput() {
    // if (!EmailValidator.validate(email)) {
    //   message = "Invalid email!";
    //   return false;
    // }
    if (email.isEmpty || password.isEmpty) {
      message = "Email or password missing!";
      return false;
    }
    message = "";
    return true;
  }

  Future<bool> login() async {
    Map<String, String> body = {"UserName": email, "PassWord": password};
    final response = await http.post(Uri.http("127.0.0.1:4996", "/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode(body));
    print("Request successfully");
    print(response.statusCode);
    if (response.statusCode == 200) {
      message = "Login successfully";
      return true;
    } else {
      message = "Login failed";
      return false;
    }
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
                        email = value;
                      },
                      onPasswordChanged: (value) {
                        password = value;
                      },
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                      onPressed: () {
                        if (isValidInput())
                          login().then((value) {
                            setState(() {});
                            if (value)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                          });
                        setState(() {});
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
