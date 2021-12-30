import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_manager/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static initDB() async {
    if (_db != null) {
      return _db!;
    }
    try {
      String _path = join(await getDatabasesPath(), 'tasks.db');
      _db = await openDatabase(_path, version: _version,
          onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title STRING,
            note TEXT,
            date STRING,
            startTime STRING,
            endTime STRING,
            remind INTEGER,
            repeat STRING,
            color INTEGER,
            isCompleted INTEGER)
          
          ''');
      });
      debugPrint('creating a new database');
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    debugPrint('insert function called');
    return await _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task task) async {
    debugPrint('delete function called');
    return await _db!.delete(_tableName, where: 'id= ?', whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint('query function called');

    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    debugPrint('update function called');
    return await _db!.rawUpdate('''
    
    UPDATE tasks
    SET isCompleted= ?
    WHERE id=?
    
    ''', [1, id]);
  }
}
