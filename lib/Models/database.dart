import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:radio_app/Models/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MessageDatabaseProvider {
  MessageDatabaseProvider._();
  static final MessageDatabaseProvider db = MessageDatabaseProvider._();
  // Database instance from SQFLITE package
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    // Get Path to store database file in
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'message.db');
    // SQL to create Message Table in DB
    String sql = "CREATE TABLE Message("
        "id integer primary key,"
        "title TEXT,"
        "description TEXT,"
        "author TEXT,"
        "message TEXT,"
        "date TEXT,"
        "picture TEXT"
        ")";
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(sql);
    });
  }

  // Method to add message to DB
  addMessagetoDB(Data message) async {
    final db = await database;
    int res = await db.insert('Message', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Data>> getAllMessages() async {
    final db = await database;
    var res = await db.query('Message');
    List<Data> messages = res.map((f) => Data.fromDB(f)).toList();
    return messages;
  }

  Future<Data> getMessage(int id) async {
    final db = await database;
    var res = await db.query('Message', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Data.fromJson(res.first) : null;
  }
}
