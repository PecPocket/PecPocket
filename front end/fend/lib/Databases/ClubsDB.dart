import 'dart:async';

import 'package:fend/classes/Clubs.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ClubDatabase {
  static final ClubDatabase instance = ClubDatabase._init();

  static Database _database;

  ClubDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('Clubs6.db');
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
      CREATE TABLE $tableClubs
      (
        ${ClubFields.id} INTEGER,
        ${ClubFields.club} TEXT,
        ${ClubFields.clubCode} TEXT
      )
      ''');
  }

  Future<Club> addClub(Club club) async {
    final db = await instance.database;
    final id = await db.insert(tableClubs, club.toJson());
    print('Added Club');
    return club.copy(id: id);
  }

  Future<Club> getClub(String clubName) async {
    final db = await instance.database;
    final maps = await db.query(
      tableClubs,
      columns: ClubFields.values,
      where: '${ClubFields.club} = ?',
      whereArgs: [clubName],
    );

    if (maps.isNotEmpty) {
      return Club.fromJson(maps.first);
    } else {
      throw Exception('$clubName not found');
    }
  }

  Future<List<Club>> getAllClubs() async {
    final db = await instance.database;

    final result = await db.query(tableClubs);

    return result.map((json) => Club.fromJson(json)).toList();
  }

  Future<int> updateClub(Club club) async {
    final db = await instance.database;
    print('updated');
    return db.update(tableClubs, club.toJson(),
        where: '${ClubFields.club} = ?', whereArgs: [club.club]);
  }

  Future<int> deleteClub(String clubName) async {
    final db = await instance.database;

    return await db.delete(tableClubs,
        where: '${ClubFields.club} = ?', whereArgs: [clubName]);
  }

  Future<void> deleteTable() async {
    final db = await instance.database;
    return await db.execute('DELETE FROM $tableClubs');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
