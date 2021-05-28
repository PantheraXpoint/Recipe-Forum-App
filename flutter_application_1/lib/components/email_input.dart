import 'dart:convert';
import 'dart:io';

import '../components/constaints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EmailInput extends StatefulWidget {
  //final String type;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  EmailInput({@required this.onEmailChanged, @required this.onPasswordChanged});

  @override
  State<StatefulWidget> createState() => EmailInputState();
}

class EmailInputState extends State<EmailInput> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: height / 15,
            decoration: BoxDecoration(
                color: kPrimaryColor, borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              controller: emailController,
              onChanged: (value) {
                widget.onEmailChanged(value);
                setState(() {});
              },
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Email"),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: height / 15,
            decoration: BoxDecoration(
                color: kPrimaryColor, borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              controller: passwordController,
              onChanged: (value) {
                widget.onPasswordChanged(value);
                setState(() {});
              },
              obscureText: true,
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Password"),
            ),
          ),
        ],
      ),
    );
  }
}
