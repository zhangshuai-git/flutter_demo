import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static DatabaseService _instance;
  DatabaseService._internal();
  static _getInstance() {
    if (_instance == null) {
      _instance = DatabaseService._internal();
    }
    return _instance;
  }
  factory DatabaseService.getInstance() => _getInstance();

  Database _database;
  Future<Database> get database async {
    if (_database == null) {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'repositories.sqlite';
      _database = await openDatabase(path, version: 1, onCreate: _creatTable);
    }
    return _database;
  }

  void _creatTable(Database db, int newVersion) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS 'repository' (\
      'id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,\
      'own_id' INT,\
      'name' VARCHAR(255),\
      'full_name' VARCHAR(255),\
      'html_url' VARCHAR(255),\
      'description' VARCHAR(255),\
      'comment' VARCHAR(255)\
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS 'repository_owner' (\
      'id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,\
      'login' VARCHAR(255),\
      'url' VARCHAR(255),\
      'avatar_url' VARCHAR(255)\
      )
    """);
  }

}