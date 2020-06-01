import 'package:flutter/material.dart';
import 'package:goshuin_app/db_goshuin_data.dart';
import 'db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbShrineData extends DbGoshuinData {
//  @override
//  String get databaseName => "goshuin.db";
//
//  @override
//  String get tableName => "shrine";
//
//  @override
//  createDatabase(Database db, int version) =>
//      db.execute(
//        "CREATE TABLE $tableName(id TEXT PRIMARY KEY, name TEXT,  prefectures TEXT,  prefecturesNo TEXT)",
//      );

  /* データ登録 */
  Future<void> insertShrine(Shrine shrine) async {
    final Database db = await database;
    await db.insert(
      tableName2,
      shrine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /* 全件取得 */
  Future<List<Shrine>> getShrines() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ' + tableName2 + ' ORDER BY id ASC');
    var list = new List<Shrine>();
    var i = 0;
    for (Map map in maps) {
      list.add(
          Shrine(
            id: maps[i]['id'],
            shrineName: maps[i]['shrineName'],
            prefectures: maps[i]['prefectures'],
            prefecturesNo: maps[i]['prefecturesNo'],
          )
      );
      i++;
    }
    return list;
  }

  Future<void> updateShrine(Shrine shrine) async {
    // Get a reference to the database.
    final db = await database;
    await db.update(
      tableName2,
      shrine.toMap(),
      where: "id = ?",
      whereArgs: [shrine.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> deleteShrine(int id) async {
    final db = await database;
    await db.delete(
      tableName2,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /* 都道府県Noごとの最大IDレコード取得 */
  Future<Shrine> getMaxIdShrine(String prefecturesNo) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ' + tableName2 + ' WHERE prefecturesNo = ' + prefecturesNo +' ORDER BY id DESC LIMIT 1');
    var shrine = new Shrine();
    var i = 0;
    if(maps.length != 0){
      shrine =
          Shrine(
            id: maps[i]['id'],
            shrineName: maps[i]['shrineName'],
            prefectures: maps[i]['prefectures'],
            prefecturesNo: maps[i]['prefecturesNo'],
          );
    };
    print("db_shrine_data.dart ★最大値取得");
    print(shrine);
    return shrine;
  }

  var shrine = Shrine(
    id: '26-00001',
    shrineName: '八坂神社',
    prefectures: '京都府',
    prefecturesNo: '26',
  );
}

class Shrine {
  final String id;             // [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String shrineName;           // [神社・寺院名]
  final String prefectures;    // [都道府県]
  final String prefecturesNo;  // [都道府県No]

  Shrine({this.id, this.shrineName, this.prefectures, this.prefecturesNo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shrineName': shrineName,
      'prefectures': prefectures,
      'prefecturesNo': prefecturesNo,
    };
  }

  @override
  String toString() {
    return 'Shrine{id: $id, shrineName: $shrineName, prefectures: $prefectures, prefecturesNo: $prefecturesNo}';
  }
}
