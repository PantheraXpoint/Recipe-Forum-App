import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/drive_integration/demo_screen.dart';
import 'package:flutter_application_2/screens/edit_profile_screen.dart';
import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'package:flutter_application_2/screens/signup_screen.dart';

import 'screens/post_recipe_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: LoginScreen());
  }
}
