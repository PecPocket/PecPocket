import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../models/student_model.dart';

class StudentDbProvider {
  Database db;

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "StudentsData.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
        CREATE TABLE StudentsData
        (
          SID INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT
        )
        """);
      },
    );
  }

  Future<StudentModel> fetchDataFromDataBase(int sid) async {
    final maps = await db.query(
      "StudentsData",
      columns: null,
      where: "SID = ?",
      whereArgs: [sid],
    );

    if (maps.length > 0) {}

    return null;
  }

  // ignore: non_constant_identifier_names
  Future<int> addItemToDataBase(StudentModel Student) {
    return db.insert(
      "StudentsData",
      Student.toMap(),
    );
  }
}
