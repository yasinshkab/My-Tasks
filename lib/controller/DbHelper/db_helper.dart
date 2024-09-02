// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_control/model/task_model.dart';

class DbHelper {
  Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    String path = join(directory!.path, 'db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE Tasks(key TEXT PRIMARY KEY,title TEXT,category TEXT,description TEXT,image TEXT,date TEXT,time,periority TEXT,show TEXT,notification TEXT,status TEXT,email TEXT)");
        db.execute(
            "CREATE TABLE PendingUploads(key TEXT PRIMARY KEY,title TEXT,category TEXT,description TEXT,image TEXT,date TEXT,time,periority TEXT,show TEXT,notification TEXT,status TEXT,email TEXT)");
        db.execute(
            "CREATE TABLE PendingDeletes(key TEXT PRIMARY KEY,title TEXT,category TEXT,description TEXT,image TEXT,date TEXT,time,periority TEXT,show TEXT,notification TEXT,status TEXT,email TEXT)");
      },
    );
    return db;
  }

  Future<TaskModel> insert(TaskModel model) async {
    var dbClient = await db;
    final Connectivity connectivity = Connectivity();
    var connection = await connectivity.checkConnectivity();
    if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      dbClient!.insert('Tasks', model.toMap());

      return model;
    }
    dbClient!.insert('PendingUploads', model.toMap()).then((value) {});

    return model;
  }

  Future<void> printAllTasks() async {
    var dbClient = await db;
    List<Map<String, dynamic>> results = await dbClient!.query('Tasks');
    for (var result in results) {
      print(result);
    }
  }

  Future<void> removeFromList(TaskModel model) async {
    var dbClient = await db;
    final Connectivity connectivity = Connectivity();
    var connection = await connectivity.checkConnectivity();
    await dbClient!
        .update('Tasks', {'show': 'no'},
            where: 'key = ?', whereArgs: [model.key!])
        .then((value) {});
    if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      // FirebaseService.update(model.key!, 'show', 'no');
    } else {
      dbClient.insert('PendingDeletes', model.toMap());
    }
  }

  Future<void> update(TaskModel model) async {
    var dbClient = await db;
    print('Updating task with key: ${model.key}'); // Debugging line
    int count = await dbClient!.update('Tasks', model.toMap(),
        where: 'key = ?', whereArgs: [model.key!]);
    print('Number of rows updated: $count'); // Debugging line
  }

  Future<void> updateTaskStatus(String key, String status) async {
    var dbClient = await db;

    await dbClient!.update(
      'Tasks',
      {'status': status},
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  Future<void> updateTask(TaskModel model) async {
    var dbClient = await db;
    final Connectivity connectivity = Connectivity();
    var connection = await connectivity.checkConnectivity();
    int count = await dbClient!.update(
      'Tasks',
      model.toMap(),
      where: 'key = ?',
      whereArgs: [model.key],
    );
  }

  Future<int> delete(String id, String table) async {
    print(id);
    var dbClient = await db;
    return await dbClient!.delete(table, where: 'key = ?', whereArgs: [id]);
  }

  // Future<List<TaskModel>> getData() async {
  //   var dbClient = await db;
  //   final List<Map<String, Object?>> queryResult =
  //       await dbClient!.query('Tasks');
  //   return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  // }

  Future<List<TaskModel>> getPendingUploads() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('PendingUploads');
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<bool> isRowExists(String id, String table) async {
    var dbClient = await db;
    var count = await dbClient!.query(table, where: 'key = ?', whereArgs: [id]);

    return count.isNotEmpty;
  }

  Future<TaskModel?> getTaskByKey(String key) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query(
      'Tasks',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<TaskModel>> getDataByEmail(String email) async {
    var dbClient = await db;
    String today = DateFormat('dd MMM yyyy').format(DateTime.now());

    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      'Tasks',
      where: 'email = ? AND date >= ?',
      whereArgs: [email, today],
    );

    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }
}
