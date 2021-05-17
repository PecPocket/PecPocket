import 'dart:async';
import 'package:fend/classes/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();

  static Database _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('User19.db');
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
      CREATE TABLE $tableUser
      (
        ${UserFields.id} INTEGER,
        ${UserFields.sid} INTEGER,
        ${UserFields.password} TEXT,
        ${UserFields.auth} INTEGER,
        ${UserFields.login} INTEGER
      )
      ''');
  }

  Future<User> addUser(User user) async {
    final db = await instance.database;
    final id = await db.insert(tableUser, user.toJson());
    print('Added User');
    return user.copy(id: id);
  }

  Future<User> getUser(int sid) async {
    final db = await instance.database;
    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
      where: '${UserFields.sid} = ?',
      whereArgs: [sid],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('$sid not found');
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await instance.database;

    final result = await db.query(tableUser);

    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    print('updated');
    return db.update(tableUser, user.toJson(),
        where: '${UserFields.sid} = ?', whereArgs: [user.sid]);
  }

  Future<int> deleteUser(int sid) async {
    final db = await instance.database;

    return await db
        .delete(tableUser, where: '${UserFields.sid} = ?', whereArgs: [sid]);
  }

  Future<int> isEmpty() async {
    final db = await instance.database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableUser'));
    return count;
  }

  Future<void> deleteTable() async {
    final db = await instance.database;
    return await db.execute('DELETE FROM $tableUser');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
