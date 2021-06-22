import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        backgroundColor: kSecondaryColor,
      ),
    );
  }
}
