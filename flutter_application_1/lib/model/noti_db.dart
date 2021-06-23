import 'package:flutter_application_2/model/noti.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "noti_app.db"),
        onCreate: (db, version) async {
      await db.execute('''
CREATE TABLE noti (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  date DATE
)
''');
    }, version: 1);
  }

  addNewNote(NotiModel noti) async {
    final db = await database;
    db.insert("noti", noti.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getNoti() async {
    final db = await database;
    var res = await db.query("noti");
    if (res.length == 0) {
      return Null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }
}
