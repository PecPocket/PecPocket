import 'dart:async';
import '../classes/Timetable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TimetableDatabase {
  static final TimetableDatabase instance = TimetableDatabase._init();

  static Database _database;

  TimetableDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('Timetable11.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTimetable
      (
        ${TimetableFields.id} INTEGER,
        ${TimetableFields.title} TEXT,
        ${TimetableFields.startYear} INTEGER,
        ${TimetableFields.startMonth} INTEGER,
        ${TimetableFields.startDay} INTEGER,
        ${TimetableFields.startHour} INTEGER,
        ${TimetableFields.startMinute} INTEGER,
        ${TimetableFields.endYear} INTEGER,
        ${TimetableFields.endMonth} INTEGER,
        ${TimetableFields.endDay} INTEGER,
        ${TimetableFields.endHour} INTEGER,
        ${TimetableFields.endMinute} INTEGER,
        ${TimetableFields.interval} INTEGER
      )
      ''');
  }

  Future<Timetable> addTimetable(Timetable timetable) async {
    final db = await instance.database;
    final id = await db.insert(tableTimetable, timetable.toJson());
    print('Timetable Added');
    return timetable.copy(id: id);
  }

  /*Future<Timetable> getTimetable(String timetableName) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTimetables,
      columns: TimetableFields.values,
      where: '${TimetableFields.Timetable} = ?',
      whereArgs: [TimetableName],
    );
    if (maps.isNotEmpty) {
      return Timetable.fromJson(maps.first);
    } else {
      throw Exception('$TimetableName not found');
    }
  }*/

  Future<List<Timetable>> getAllTimetables() async {
    final db = await instance.database;

    final result = await db.query(tableTimetable);

    return result.map((json) => Timetable.fromJson(json)).toList();
  }

  /*Future<int> updateTimetable(Timetable Timetable) async {
    final db = await instance.database;
    return db.update(tableTimetable, Timetable.toJson(),
        where: '${TimetableFields.Timetable} = ?',
        whereArgs: [Timetable.Timetable]);
  }*/

  Future<int> deleteTimetable(String title) async {
    final db = await instance.database;

    return await db.delete(tableTimetable,
        where: '${TimetableFields.title} = ?', whereArgs: [title]);
  }

  Future<int> deleteTimetables() async {
    final db = await instance.database;
    return await db.delete(tableTimetable);
  }

  Future<void> deleteTable() async {
    final db = await instance.database;
    return await db.execute('DELETE FROM $tableTimetable');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
