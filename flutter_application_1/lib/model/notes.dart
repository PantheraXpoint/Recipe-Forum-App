class NoteModel {
  int id;
  String title;
  String body;
  DateTime creation_date;

  NoteModel({this.id, this.title, this.body, this.creation_date});
  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "title": title,
      "body": body,
      "creation_date": creation_date.toString()
    });
  }
}
