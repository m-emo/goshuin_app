import 'package:flutter/material.dart';
import 'package:goshuin_app/db_goshuin_data.dart';
import 'db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbShrineData extends DbGoshuinData {
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
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM ' + tableName2 + ' ORDER BY shrineId ASC');
    var list = new List<Shrine>();
    var i = 0;
    for (Map map in maps) {
      list.add(Shrine(
        shrineId: maps[i]['shrineId'],
        shrineName: maps[i]['shrineName'],
        prefectures: maps[i]['prefectures'],
        prefecturesNo: maps[i]['prefecturesNo'],
      ));
      i++;
    }
    return list;
  }

  /* 更新 */
  Future<void> updateShrine(Shrine shrine) async {
    print("★更新処理");
    print(shrine.shrineId);
    print(shrine.prefectures);
    // Get a reference to the database.
    final db = await database;
    await db.update(
      tableName2,
      shrine.toMap(),
      where: "shrineId = ?",
      whereArgs: [shrine.shrineId],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /* 削除 */
  Future<void> deleteShrine(String id) async {
    final db = await database;
    await db.delete(
      tableName2,
      where: "shrineId = ?",
      whereArgs: [id],
    );
    print("db_shrine_data.dart★削除した");
  }

  /* 都道府県Noごとの最大IDレコード取得 */
  Future<Shrine> getMaxIdShrine(String prefecturesNo) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM ' +
        tableName2 +
        ' WHERE prefecturesNo = "' +
        prefecturesNo +
        '" ORDER BY shrineId DESC LIMIT 1');
    var shrine = new Shrine();
    var i = 0;
    if (maps.length != 0) {
      shrine = Shrine(
        shrineId: maps[i]['shrineId'],
        shrineName: maps[i]['shrineName'],
        prefectures: maps[i]['prefectures'],
        prefecturesNo: maps[i]['prefecturesNo'],
      );
    }
    print("db_shrine_data.dart ★最大値取得");
    print(shrine);
    return shrine;
  }

  /*
  * IDで1件取得
  *
  * prm:ID
  * return：Shrine
  * */
  Future<Shrine> getShrineId(String prmId) async {
    print("db_shrine_data.dart★ShrineIDで1件取得 start");
    var shrine = new Shrine();
    print("prmId");
    print(prmId);

    if (prmId != null) {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'SELECT * FROM $tableName2 where shrineId = "' + prmId + '"');

      var i = 0;
      if (maps.length != 0) {
        shrine = Shrine(
          shrineId: maps[i]['shrineId'],
          shrineName: maps[i]['shrineName'],
          prefectures: maps[i]['prefectures'],
          prefecturesNo: maps[i]['prefecturesNo'],
        );
      }
    }
    print("db_shrine_data.dart★ShrineIDで1件取得 end");
    return shrine;
  }
}

class Shrine {
  final String shrineId; // [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String shrineName; // [神社・寺院名]
  final String prefectures; // [都道府県]
  final String prefecturesNo; // [都道府県No]

  Shrine(
      {this.shrineId, this.shrineName, this.prefectures, this.prefecturesNo});

  Map<String, dynamic> toMap() {
    return {
      'shrineId': shrineId,
      'shrineName': shrineName,
      'prefectures': prefectures,
      'prefecturesNo': prefecturesNo,
    };
  }

  @override
  String toString() {
    return 'Shrine{shrineId: $shrineId, shrineName: $shrineName, prefectures: $prefectures, prefecturesNo: $prefecturesNo}';
  }
}
