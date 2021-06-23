class NotiModel {
  int id;
  String title;
  DateTime date;

  NotiModel({this.id, this.title, this.date});
  Map<String, dynamic> toMap() {
    return ({"id": id, "title": title, "date": date.toString()});
  }
}
