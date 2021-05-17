import 'dart:async';
import '../classes/Reminder.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ReminderDatabase {
  static final ReminderDatabase instance = ReminderDatabase._init();

  static Database _database;

  ReminderDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _intiDB('reminders11.db');
    return _database;
  }

  Future<Database> _intiDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  FutureOr _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableReminders 
    (
      ${ReminderFields.id} INTEGER,
      ${ReminderFields.title} STRING,
      ${ReminderFields.description} INTEGER,
      ${ReminderFields.year} INTEGER,
      ${ReminderFields.month} INTEGER,
      ${ReminderFields.day} INTEGER,
      ${ReminderFields.hour} INTEGER,
      ${ReminderFields.minute} INTEGER,
      ${ReminderFields.getNotified} BOOLEAN NOT NULL
    )
    ''');
  }

  Future<Reminder> create(Reminder reminder) async {
    final db = await instance.database;

    final id = await db.insert(tableReminders, reminder.toJson());
    print('reminder ADDED');
    return reminder.copy(id: id);
  }

  Future<Reminder> getReminder(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableReminders,
      columns: ReminderFields.values,
      where: '${ReminderFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Reminder.fromJson(maps.first);
    } else {
      throw Exception('Couldnt find $id');
    }
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await instance.database;

    final result = await db.query(tableReminders);

    return result.map((json) => Reminder.fromJson(json)).toList();
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;

    return db.update(
      tableReminders,
      reminder.toJson(),
      where: '${ReminderFields.id} = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(String description) async {
    final db = await instance.database;
    return await db.delete(
      tableReminders,
      where: '${ReminderFields.description}= ?',
      whereArgs: [description],
    );
  }

  Future<void> deleteTable() async {
    final db = await instance.database;
    return await db.execute('DELETE FROM $tableReminders');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
