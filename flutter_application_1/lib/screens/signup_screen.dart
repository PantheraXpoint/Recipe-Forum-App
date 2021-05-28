import 'package:flutter_application_2/screens/login_screen.dart';

import '../components/constaints.dart';
import '../components/email_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
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
    if (!EmailValidator.validate(email)) {
      message = "Invalid email!";
      return false;
    }
    if (email.isEmpty || password.isEmpty) {
      message = "Email or password missing!";
      return false;
    }
    message = "";
    return true;
  }

  Future<bool> signup() async {
    Map<String, String> body = {"email": email, "password": password};
    final response =
        await http.post(Uri.http("127.0.0.1:4996", "/register"), body: body);
    print("Request successfully");
    print(response.statusCode);
    if (response.statusCode == 200) {
      message = "Sign up successfully";
      return true;
    } else if (response.statusCode == 400) {
      message = "Email already taken";
      return false;
    } else {
      message = "Sign up failed";
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
                    child: EmailInput(
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
                          signup().then((value) {
                            if (value) Navigator.pop(context);
                            setState(() {});
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
