import 'dart:io';

import '../models/task.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {
  late Database database;
  static DBhelper dbHelper = DBhelper();
  final String tableName = 'tasks';
  final String idColumn = 'id';
  final String nameColumn = 'name';
  final String dateColumn = 'date';
  final String locationColumn = 'location';
  final String descriptionColumn = 'description';
  final String isCompletedColumn = 'isCompleted';
  final String priorityColumn = 'priority';

  Future<Database> connectToDatabase() async {
    debugPrint("DB connectToDatabase");
    Directory directory = await getApplicationDocumentsDirectory();

    String path = '$directory/taskit.db';

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version){
        db.execute(
            ''' CREATE TABLE $tableName(
              $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
              $nameColumn TEXT,
              $dateColumn TEXT,
              $locationColumn TEXT,
              $descriptionColumn TEXT,
              $isCompletedColumn INTEGER,
              $priorityColumn TEXT)'''
        );
      },
      onUpgrade: (db, oldVersion, newVersion){
        db.execute(
            ''' CREATE TABLE $tableName(
              $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
              $nameColumn TEXT,
              $dateColumn TEXT,
              $locationColumn TEXT,
              $descriptionColumn TEXT,
              $isCompletedColumn INTEGER,
              $priorityColumn TEXT)'''
        );
      },
      onDowngrade: (db, oldVersion, newVersion){
        db.delete(tableName);
      },
    );
  }

  initDatabase() async {
    debugPrint("DB initDatabase");
    database = await connectToDatabase();
  }

  Future <List<Task>> getAllTasks() async {
    debugPrint("DB get");
    List<Map<String, dynamic>> tasks = await database.query(tableName);
    //debugPrint('nr taskss: ' + tasks.length.toString());
    //debugPrint("1 : " + tasks.map((e) => Task.fromMap(e)).toList().toString());
    return tasks.map((e) => Task.fromMap(e)).toList();
  }

  insert(Task task) async {
    debugPrint("DB add");
    //debugPrint("2: " + task.toMap().toString());
    return await database.insert(tableName, task.toMap());
  }

  update(Task task) async {
    debugPrint("DB update");
    await database.update(
        tableName,
        task.toMap(),
        where: '$idColumn = ?',
        whereArgs: [task.id]);
  }

  delete(int taskId) async {
    debugPrint("DB delete");
    await database.delete(tableName, where: '$idColumn = ?', whereArgs: [taskId]);
  }

  updateFlag(int taskId, bool isCompleted) async {
    debugPrint("DB updateFlag");
    //debugPrint("taskID: " + taskId.toString());
    if (isCompleted) {
      await database.update(
        tableName,
        {isCompletedColumn: 0},
        where: '$idColumn = ?',
        whereArgs: [taskId],
      );
    }
    else {
      await database.update(
        tableName,
        {isCompletedColumn: 1},
        where: '$idColumn = ?',
        whereArgs: [taskId],
      );
    }

  }


  deleteTaskIt() async {
    await database.delete(tableName);
  }


}
