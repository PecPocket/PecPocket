import 'dart:async';
import 'package:fend/classes/Attendances.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AttendanceDatabase {
  static final AttendanceDatabase instance = AttendanceDatabase._init();

  static Database _database;

  AttendanceDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('Attendance6.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAttendance
      (
        ${AttendancesFields.id} INTEGER ,
        ${AttendancesFields.subject} TEXT,
        ${AttendancesFields.subtitle} TEXT,
        ${AttendancesFields.classesAttended} INTEGER,
        ${AttendancesFields.totalClasses} INTEGER
      )
      ''');
  }

  Future<Attendances> addAttendance(Attendances attendance) async {
    final db = await instance.database;
    final id = await db.insert(tableAttendance, attendance.toJson());
    print('Added attendance');
    return attendance.copy(id: id);
  }

  Future<Attendances> getAttendance(String subjectName) async {
    final db = await instance.database;
    final maps = await db.query(
      tableAttendance,
      columns: AttendancesFields.values,
      where: '${AttendancesFields.subject} = ?',
      whereArgs: [subjectName],
    );

    if (maps.isNotEmpty) {
      return Attendances.fromJson(maps.first);
    } else {
      throw Exception('$subjectName not found');
    }
  }

  Future<List<Attendances>> getAllAttendance() async {
    final db = await instance.database;

    final result = await db.query(tableAttendance);

    return result.map((json) => Attendances.fromJson(json)).toList();
  }

  Future<int> updateAttendance(Attendances attendance) async {
    final db = await instance.database;
    print('updated');
    return db.update(tableAttendance, attendance.toJson(),
        where: '${AttendancesFields.subject} = ?',
        whereArgs: [attendance.subject]);
  }

  Future<int> deleteAttendance(String subjectName, String subtitle) async {
    final db = await instance.database;

    return await db.delete(tableAttendance,
        where:
            '${AttendancesFields.subject} = ? and ${AttendancesFields.subtitle} = ?',
        whereArgs: [subjectName, subtitle]);
  }

  Future<void> deleteTable() async {
    final db = await instance.database;
    return await db.execute('DELETE FROM $tableAttendance');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
