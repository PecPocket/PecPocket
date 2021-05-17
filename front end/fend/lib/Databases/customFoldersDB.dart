import 'dart:async';
import 'package:fend/classes/CustomFolder.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CustomRemindersDatabase {
  static final CustomRemindersDatabase instance =
      CustomRemindersDatabase._init();

  static Database _database;

  CustomRemindersDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('customReminders3.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCustomFolders
      (
        ${CustomFolderFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${CustomFolderFields.filePath} TEXT
      )
      ''');
  }

  Future<CustomFolder> addSubject(CustomFolder customFolder) async {
    final db = await instance.database;
    final id = await db.insert(tableCustomFolders, customFolder.toJson());
    return customFolder.copy(id: id);
  }

  Future<CustomFolder> getSubject(String filename) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCustomFolders,
      columns: CustomFolderFields.values,
      where: '${CustomFolderFields.filePath} = ?',
      whereArgs: [filename],
    );

    if (maps.isNotEmpty) {
      return CustomFolder.fromJson(maps.first);
    } else {
      throw Exception('$filename not found');
    }
  }

  Future<List<CustomFolder>> getAllFiles() async {
    final db = await instance.database;

    final result = await db.query(tableCustomFolders);

    return result.map((json) => CustomFolder.fromJson(json)).toList();
  }

  Future<int> deleteFile(String fileName) async {
    final db = await instance.database;

    return await db.delete(tableCustomFolders,
        where: '${CustomFolderFields.filePath} = ?', whereArgs: [fileName]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
