import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/dynamic_links_service/dynamic_link_service.dart';
import 'package:flutter_application_2/screens/display_note_screen.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'package:flutter_application_2/screens/note_taking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginScreen(),
      routes: {
        // "ShowNote": (context) => ShowNoteScreen(),
        "NoteScreen": (context) => NoteScreen()
      },
    );
  }
}
