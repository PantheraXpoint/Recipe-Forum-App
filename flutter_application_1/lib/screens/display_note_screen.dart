import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/note_db.dart';
import 'package:flutter_application_2/model/notes.dart';

import 'home_screen.dart';

class ShowNoteScreen extends StatefulWidget {
  @override
  _ShowNoteScreenState createState() => _ShowNoteScreenState();
}

class _ShowNoteScreenState extends State<ShowNoteScreen> {
  @override
  Widget build(BuildContext context) {
    final NoteModel note =
        ModalRoute.of(context).settings.arguments as NoteModel;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Note",
            style: TextStyle(color: kSecondaryColor),
          ),
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                DatabaseProvider.db.deleteNote(note.id);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                note.title,
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(note.body, style: TextStyle(fontSize: 18.0))
            ],
          ),
        ));
  }
}
