import 'dart:io';
import 'package:flutter_demo1/model/entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_demo1/utility/extension.dart';

class DatabaseHelper {
  static DatabaseHelper _instance;
  DatabaseHelper._internal();
  static _getInstance() {
    if (_instance == null) {
      _instance = DatabaseHelper._internal();
    }
    return _instance;
  }
  factory DatabaseHelper.getInstance() => _getInstance();

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
    if (repository == null || repository.owner == null) return;
    log("add ${repository.name}");
    final db = await this.database;
    db.execute("REPLACE INTO repository(id, own_id, name, full_name, html_url, description, comment)VALUES(?,?,?,?,?,?,?)",
      [repository.id, repository.owner.id, repository.name, repository.fullName, repository.htmlUrl, repository.desp, repository.comment]);
    db.execute("REPLACE INTO repository_owner(id, login, url, avatar_url)VALUES(?,?,?,?)",
      [repository.owner.id, repository.owner.login, repository.owner.url, repository.owner.avatarUrl]);
  }

  Future<void> delete(Repository repository) async {
    if (repository == null) return;
    log("delete ${repository.name}");
    final db = await this.database;
    db.execute("DELETE FROM repository WHERE id = ?", [repository.id]);
  }

  Future<void> update(Repository repository) async {
    if (repository == null) return;
    log("update ${repository.name}");
    final db = await this.database;
    db.execute("UPDATE 'repository' SET name = ?  WHERE id = ? ", [repository.name, repository.id]);
    db.execute("UPDATE 'repository' SET full_name = ?  WHERE id = ? ", [repository.fullName, repository.id]);
    db.execute("UPDATE 'repository' SET html_url = ?  WHERE id = ? ", [repository.htmlUrl, repository.id]);
    db.execute("UPDATE 'repository' SET description = ?  WHERE id = ? ", [repository.desp,   repository.id]);
    db.execute("UPDATE 'repository' SET comment = ?  WHERE id = ? ", [repository.comment, repository.id]);
  }

  Future<List<Repository>> getAllRepository() async {
    final db = await this.database;
    List<Repository> list = [];
    List<Map<String, dynamic>> res = await db.rawQuery("SELECT * FROM repository ");
    for (final map in res) {
      final repository = Repository();
      repository.id = map["id"];
      repository.name = map["name"];
      repository.fullName = map["full_name"];
      repository.htmlUrl = map["html_url"];
      repository.desp = map["description"];
      repository.comment = map["comment"];
      repository.owner = await getRepositoryOwner(map["own_id"]);
      list.add(repository);
    }
    log("getAllRepository: ${list.map((it) => it.name)}");
    return list;
  }

  Future<Repository> getRepository(int id) async {
    log("getRepository $id");
    final db = await this.database;
    final repository = Repository();
    final List<Map<String, dynamic>> res = await db.rawQuery("SELECT * FROM repository where id = ? ", [id]);
    for (final map in res) {
      repository.id = map["id"];
      repository.owner.id = map["own_id"];
      repository.name = map["name"];
      repository.fullName = map["full_name"];
      repository.htmlUrl = map["html_url"];
      repository.desp = map["description"];
      repository.comment = map["comment"];
      repository.owner = await getRepositoryOwner(repository.owner.id);
    }
    return repository;
  }

  Future<RepositoryOwner> getRepositoryOwner(int id) async {
    log("getRepositoryOwner $id");
    final db = await this.database;
    final owner = RepositoryOwner();
    final List<Map<String, dynamic>> res = await db.rawQuery("SELECT * FROM repository_owner where id = ? ", [id]);
    for (final map in res) {
      owner.id = map["id"];
      owner.login = map["login"];
      owner.url = map["url"];
      owner.avatarUrl = map["avatar_url"];
    }
    return owner;
  }
}