import 'dart:async';

import 'package:fend/classes/subjects.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SubjectDatabase {
  static final SubjectDatabase instance = SubjectDatabase._init();

  static Database _database;

  SubjectDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('subjects10.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSubjects
      (
        ${SubjectFields.id} INTEGER,
        ${SubjectFields.subject} TEXT
      )
      ''');
  }

  Future<Subject> addSubject(Subject subject) async {
    final db = await instance.database;
    final id = await db.insert(tableSubjects, subject.toJson());
    return subject.copy(id: id);
  }

  Future<Subject> getSubject(String subjectName) async {
    final db = await instance.database;
    final maps = await db.query(
      tableSubjects,
      columns: SubjectFields.values,
      where: '${SubjectFields.subject} = ?',
      whereArgs: [subjectName],
    );

    if (maps.isNotEmpty) {
      return Subject.fromJson(maps.first);
    } else {
      throw Exception('$subjectName not found');
    }
  }

  Future<List<Subject>> getAllSubjects() async {
    final db = await instance.database;

    final result = await db.query(tableSubjects);

    return result.map((json) => Subject.fromJson(json)).toList();
  }

  Future<int> updateSubject(Subject subject) async {
    final db = await instance.database;

    return db.update(tableSubjects, subject.toJson(),
        where: '${SubjectFields.subject} = ?', whereArgs: [subject.subject]);
  }

  Future<int> deleteSubject(String subjectName) async {
    final db = await instance.database;

    return await db.delete(tableSubjects,
        where: '${SubjectFields.subject} = ?', whereArgs: [subjectName]);
  }

  Future<void> deleteTable() async {
    final db = await instance.database;
    return await db.execute('DELETE FROM $tableSubjects');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
