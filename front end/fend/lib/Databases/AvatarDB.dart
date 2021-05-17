import 'dart:async';
import '../classes/Avatar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AvatarDatabase {
  static final AvatarDatabase instance = AvatarDatabase._init();

  static Database _database;

  AvatarDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('Avatar5.db');
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
      CREATE TABLE $tableAvatars
      (
        ${AvatarFields.id} INTEGER ,
        ${AvatarFields.avatar} TEXT
      )
      ''');
  }

  Future<Avatar> addAvatar(Avatar avatar) async {
    final db = await instance.database;
    final id = await db.insert(tableAvatars, avatar.toJson());
    print('Added avatar');
    return avatar.copy(id: id);
  }

  Future<Avatar> getAvatar(String avatarName) async {
    final db = await instance.database;
    final maps = await db.query(
      tableAvatars,
      columns: AvatarFields.values,
      where: '${AvatarFields.avatar} = ?',
      whereArgs: [avatarName],
    );

    if (maps.isNotEmpty) {
      return Avatar.fromJson(maps.first);
    } else {
      throw Exception('$avatarName not found');
    }
  }

  Future<List<Avatar>> getAllavatar() async {
    final db = await instance.database;

    final result = await db.query(tableAvatars);

    return result.map((json) => Avatar.fromJson(json)).toList();
  }

  Future<int> deleteavatar(String avatarName) async {
    final db = await instance.database;

    return await db.delete(tableAvatars,
        where: '${AvatarFields.avatar} = ?', whereArgs: [avatarName]);
  }

  Future<void> deleteTable() async {
    final db = await instance.database;
    return await db.execute('DELETE FROM $tableAvatars');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
