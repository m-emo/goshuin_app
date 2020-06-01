import 'db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';



class DbTestData extends DBProvider {
  @override
  String get databaseName => "search_history_database.db";

  @override
  String get tableName => "histories";

  @override
  createDatabase(Database db, int version) =>
      db.execute(
        "CREATE TABLE $tableName(id TEXT PRIMARY KEY, name TEXT,  prefecturesNo TEXT)",
      );

  Future<void> insertMemo(Memo memo) async {
    final Database db = await database;
    await db.insert(
      'memo',
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memo>> getMemos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memo');
    return List.generate(maps.length, (i) {
      return Memo(
        id: maps[i]['id'],
        text: maps[i]['text'],
        priority: maps[i]['priority'],
      );
    });
  }

  Future<void> updateMemo(Memo memo) async {
    // Get a reference to the database.
    final db = await database;
    await db.update(
      'memo',
      memo.toMap(),
      where: "id = ?",
      whereArgs: [memo.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> deleteMemo(int id) async {
    final db = await database;
    await db.delete(
      'memo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  var memo = Memo(
    id: 0,
    text: 'Flutterで遊ぶ',
    priority: 1,
  );
}

class Memo {
  final int id;
  final String text;
  final int priority;

  Memo({this.id, this.text, this.priority});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'priority': priority,
    };
  }
  @override
  String toString() {
    return 'Memo{id: $id, tet: $text, priority: $priority}';
  }
}