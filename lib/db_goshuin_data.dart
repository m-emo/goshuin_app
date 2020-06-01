import 'package:flutter/material.dart';
import 'package:goshuin_app/db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbGoshuinData extends DBProvider {
  @override
  String get databaseName => "goshuin.db";

  @override
  String get tableName => "goshuin";

  String get tableName2 => "shrine";

  @override
  createDatabase(Database db, int version) async {
          db.execute(
            "CREATE TABLE $tableName(id TEXT PRIMARY KEY, shrineId TEXT, goshuinName TEXT, date TEXT, memo TEXT)",
          );
          db.execute(
            "CREATE TABLE $tableName2(id TEXT PRIMARY KEY, shrineName TEXT,  prefectures TEXT,  prefecturesNo TEXT)",
          );

  }
//  createDatabase(Database db, int version) =>
//      db.execute(
//        "CREATE TABLE $tableName(id TEXT PRIMARY KEY, shisetsu TEXT, name TEXT, date TEXT, memo TEXT)",
//      );



  /* データ登録 */
  Future<void> insertGoshuin(Goshuin goshuin) async {
    final Database db = await database;
    await db.insert(
      tableName,
      goshuin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /* 全件取得 */
  Future<List<Goshuin>> getGoshuins() async {
    final Database db = await database;
//    final List<Map<String, dynamic>> maps = await db.query(tableName);
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id DESC');
    var list = new List<Goshuin>();
    var i = 0;
    for (Map map in maps) {
      list.add(
          Goshuin(
            id: maps[i]['id'],
            shrineId: maps[i]['shrineId'],
            goshuinName: maps[i]['goshuinName'],
            date: maps[i]['date'],
            memo: maps[i]['memo'],
          )
      );
      i++;
    }
    return list;
//    return List.generate(maps.length, (i) {
//      return Goshuin(
//        id: maps[i]['id'],
//        shisetsu: maps[i]['shisetsu'],
//        name: maps[i]['name'],
//        date: maps[i]['date'],
//        memo: maps[i]['memo'],
//      );
//    });
  }

  /* 更新 */
  Future<void> updateGoshuin(Goshuin goshuin) async {
    // Get a reference to the database.
    final db = await database;
    await db.update(
      tableName,
      goshuin.toMap(),
      where: "id = ?",
      whereArgs: [goshuin.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /* 削除 */
  Future<void> deleteGoshuin(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /* 最大IDレコード取得 */
  Future<Goshuin> getMaxIdGoshuin() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id DESC LIMIT 1');
    var goshuin = new Goshuin();
    var i = 0;
    if(maps.length != 0) {
      goshuin =
          Goshuin(
            id: maps[i]['id'],
            shrineId: maps[i]['shrineId'],
            goshuinName: maps[i]['goshuinName'],
            date: maps[i]['date'],
            memo: maps[i]['memo'],
          );
    }
    print("db_goshuin_data.dart★最大値取得");
    print(goshuin);
    return goshuin;
  }

  /* レコード取得 */
  Future<List<GoshuinList>> getGoshuinList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $tableName inner join $tableName2 on shrineId = $tableName2.id ORDER BY $tableName.id DESC ');
    var list = new List<GoshuinList>();
    var i = 0;
    for (Map map in maps) {
      list.add(
          GoshuinList(
            id: maps[i]['id'],
            shrineName: maps[i]['shrineName'],
            goshuinName: maps[i]['goshuinName'],
            date: maps[i]['date'],
            prefectures: maps[i]['prefectures'],
          )
      );
      i++;
    }
    print("db_goshuin_data.dart★結合一覧");
    print(list);
    return list;
  }
  /* 最大IDレコード取得 */
//  Future<Goshuin> getMaxIdGoshuin() async {
//    final Database db = await database;
//    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id DESC LIMIT 1');
//    var goshuin = new Goshuin();
//    var i = 0;
//    goshuin =
//        Goshuin(
//          id: maps[i]['id'],
//          shisetsu: maps[i]['shisetsu'],
//          name: maps[i]['name'],
//          date: maps[i]['date'],
//          memo: maps[i]['memo'],
//        );
//    print("★最大値取得");
//    print(goshuin);
//    return goshuin;
//  }
}

class Goshuin {
  final String id;       // [GSI+連番6桁（GSI000001）]
  final String shrineId; // 神社・寺院ID
  final String goshuinName;     // 御朱印名
  final String date;     // 参拝日
  final String memo;     // メモ

  Goshuin({this.id, this.shrineId, this.goshuinName, this.date, this.memo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shrineId': shrineId,
      'goshuinName': goshuinName,
      'date': date,
      'memo': memo,
    };
  }

  @override
  String toString() {
    return 'Goshuin{id: $id, shrineId: $shrineId, goshuinName: $goshuinName, date: $date, memo: $memo}';
  }
}

class GoshuinList {
  final String id;              // [GSI+連番6桁（GSI000001）]
  final String shrineName;        // 神社・寺院ID
  final String goshuinName;     // 御朱印名
  final String date;            // 参拝日
  final String prefectures;     // 都道府県

  GoshuinList({this.id, this.shrineName, this.goshuinName, this.date, this.prefectures});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shrineName': shrineName,
      'goshuinName': goshuinName,
      'date': date,
      'prefectures': prefectures,
    };
  }

  @override
  String toString() {
    return 'Goshuin{id: $id, shrineName: $shrineName, goshuinName: $goshuinName, date: $date, prefectures: $prefectures}';
  }
}
