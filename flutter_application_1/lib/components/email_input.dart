import '../components/constaints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsernameInput extends StatefulWidget {
  //final String type;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onDisplayChanged;
  UsernameInput(
      {@required this.onEmailChanged,
      @required this.onPasswordChanged,
      this.onDisplayChanged});

  @override
  State<StatefulWidget> createState() => UsernameInputState();
}

class UsernameInputState extends State<UsernameInput> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
  }

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
              controller: usernameController,
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
                  hintText: "Username"),
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
          SizedBox(
            height: widget.onDisplayChanged == null ? 0 : 15,
          ),
          SizedBox(
            child: widget.onDisplayChanged == null
                ? null
                : Container(
                    padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                    height: height / 15,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      controller: displayNameController,
                      onChanged: (value) {
                        widget.onDisplayChanged(value);
                        setState(() {});
                      },
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Display name"),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
