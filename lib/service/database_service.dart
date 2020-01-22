import 'dart:io';
import 'package:flutter_demo1/model/entity.dart';
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
      _database = await openDatabase(path, version: 1, onCreate: _createTable);
    }
    return _database;
  }

  void _createTable(Database db, int newVersion) async {
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

  Future<void> add(Repository repository) async {
    print("add ${repository.name}");
    final db = await this.database;
    db.execute("INSERT INTO repository(id, own_id, name, full_name, html_url, description, comment)VALUES(?,?,?,?,?,?,?)",
      [repository.id, repository.owner.id, repository.name, repository.fullName, repository.htmlUrl, repository.desp, repository.comment]);
    db.execute("INSERT INTO repository_owner(id, login, url, avatar_url)VALUES(?,?,?,?)",
      [repository.owner.id, repository.owner.login, repository.owner.url, repository.owner.avatarUrl]);
  }

  Future<void> delete(Repository repository) async {
    print("delete ${repository.name}");
    final db = await this.database;
    db.execute("DELETE FROM repository WHERE id = ?", [repository.id]);
  }

  Future<void> update(Repository repository) async {
    print("update ${repository.name}");
    final db = await this.database;
    db.execute("UPDATE 'repository' SET name = ?  WHERE id = ? ", [repository.name, repository.id]);
    db.execute("UPDATE 'repository' SET full_name = ?  WHERE id = ? ", [repository.fullName, repository.id]);
    db.execute("UPDATE 'repository' SET html_url = ?  WHERE id = ? ", [repository.htmlUrl, repository.id]);
    db.execute("UPDATE 'repository' SET description = ?  WHERE id = ? ", [repository.desp,   repository.id]);
    db.execute("UPDATE 'repository' SET comment = ?  WHERE id = ? ", [repository.comment, repository.id]);
  }

  Future<List<Repository>> getAllRepository() async {
    print("getAllRepository");
    final db = await this.database;
    final res = db.rawQuery("SELECT * FROM repository ").then((it) => it.map((it) => Repository.fromJson(it)));
    return res;
  }

  Future<Repository> getRepository(int id) async {
    print("getRepository $id");
    final db = await this.database;
    final res = db.rawQuery("SELECT * FROM repository where id = ? ", [id]).then((it) => Repository.fromJson(it.last));
    return res;
  }

  Future<RepositoryOwner> getRepositoryOwner(int id) async {
    print("getRepositoryOwner $id");
    final db = await this.database;
    final res = db.rawQuery("SELECT * FROM repository_owner where id = ? ", [id]).then((it) => RepositoryOwner.fromJson(it.last));
    return res;
  }
}