import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/note_db.dart';
import 'package:flutter_application_2/model/notes.dart';

import 'add_note_screen.dart';
import 'display_note_screen.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Notes",
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: FutureBuilder(
          future: getNotes(),
          builder: (context, noteData) {
            switch (noteData.connectionState) {
              case ConnectionState.waiting:
                {
                  return Center(child: CircularProgressIndicator());
                }
              case ConnectionState.done:
                {
                  if (noteData.data == Null) {
                    return Center(
                      child: Text("You don't have any notes yet, create one"),
                    );
                  } else {
                    return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: noteData.data.length,
                          itemBuilder: (context, index) {
                            String title = noteData.data[index]['title'];
                            String body = noteData.data[index]['body'];
                            String creation_date =
                                noteData.data[index]['creation_date'];
                            int id = noteData.data[index]['id'];
                            return Card(
                                child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, "ShowNote",
                                    arguments: NoteModel(
                                        title: title,
                                        body: body,
                                        creation_date:
                                            DateTime.parse(creation_date),
                                        id: id));
                              },
                              title: Text(title),
                              subtitle: Text(body),
                            ));
                          },
                        ));
                  }
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()));
        },
        child: Icon(Icons.note_add),
      ),
    );
  }
}
