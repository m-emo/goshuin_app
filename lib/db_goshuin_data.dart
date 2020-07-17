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
      "CREATE TABLE $tableName(id TEXT PRIMARY KEY, img TEXT, shrineId TEXT, goshuinName TEXT, date TEXT, memo TEXT)",
    );
    db.execute(
      "CREATE TABLE $tableName2(shrineId TEXT PRIMARY KEY, shrineName TEXT,  prefectures TEXT,  prefecturesNo TEXT)",
    );
  }

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
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id DESC');
    var list = new List<Goshuin>();
    var i = 0;
    for (Map map in maps) {
      list.add(Goshuin(
        id: maps[i]['id'],
        img: maps[i]['img'],
        shrineId: maps[i]['shrineId'],
        goshuinName: maps[i]['goshuinName'],
        date: maps[i]['date'],
        memo: maps[i]['memo'],
      ));
      i++;
    }
    return list;
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
  Future<void> deleteGoshuin(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    print("db_goshuin_data.dart★削除した");
  }

  /*
  * 御朱印IDで1件取得
  *
  * prm:ID
  * return：Goshuin
  * */
  Future<GoshuinList> getGoshuinId(String prmId) async {
    print("db_goshuin_data.dart★御朱印IDで1件取得 start");
    var goshuin = new GoshuinList();
    print("prmId");
    print(prmId);

    if (prmId != null) {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'SELECT * FROM $tableName inner join $tableName2 on $tableName.shrineId = $tableName2.shrineId WHERE id = "' +
              prmId +
              '"');

      var i = 0;
      if (maps.length != 0) {
        goshuin = GoshuinList(
          id: maps[i]['id'],
          img: maps[i]['img'],
          shrineId: maps[i]['shrineId'],
          shrineName: maps[i]['shrineName'],
          goshuinName: maps[i]['goshuinName'],
          date: maps[i]['date'],
          prefectures: maps[i]['prefectures'],
          memo: maps[i]['memo'],
        );
      }
    }
    print("db_goshuin_data.dart★御朱印IDで1件取得 end");
    return goshuin;
  }

  /*
  * 神社・寺院IDで取得
  *
  * prm:ID
  * return：Goshuin
  * */
  Future<List<GoshuinList>> getGoshuinShrineId(String prmId) async {
    print("db_goshuin_data.dart★神社・寺院IDで取得 start");
    var list = new List<GoshuinList>();
    if (prmId != null) {
      final Database db = await database;
      final List<Map<String, dynamic>> maps =
          await db.rawQuery('SELECT * FROM $tableName WHERE shrineId = "' + prmId + '"');

      var i = 0;
      for (Map map in maps) {
        list.add(GoshuinList(
          id: maps[i]['id'],
          img: maps[i]['img'],
          shrineId: maps[i]['shrineId'],
          shrineName: maps[i]['shrineName'],
          goshuinName: maps[i]['goshuinName'],
          date: maps[i]['date'],
          prefectures: maps[i]['prefectures'],
          memo: maps[i]['memo'],
        ));
        i++;
      }
    }

    print("db_goshuin_data.dart★神社・寺院IDで取得 end");
    return list;
  }

  /* 最大IDレコード取得 */
  Future<GoshuinList> getMaxIdGoshuin() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id DESC LIMIT 1');
    var goshuin = new GoshuinList();
    var i = 0;
    if (maps.length != 0) {
      goshuin = GoshuinList(
        id: maps[i]['id'],
        img: maps[i]['img'],
        shrineId: maps[i]['shrineId'],
        shrineName: maps[i]['shrineName'],
        goshuinName: maps[i]['goshuinName'],
        date: maps[i]['date'],
        prefectures: maps[i]['prefectures'],
        memo: maps[i]['memo'],
      );
    }
    print("db_goshuin_data.dart★最大値取得");
    return goshuin;
  }

  /* レコード取得
  *　ID降順
  * */
  Future<List<GoshuinList>> getGoshuinList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $tableName inner join $tableName2 on $tableName.shrineId = $tableName2.shrineId ORDER BY $tableName.id DESC ');
    var list = new List<GoshuinList>();
    var i = 0;
    for (Map map in maps) {
      list.add(GoshuinList(
        id: maps[i]['id'],
        img: maps[i]['img'],
        shrineId: maps[i]['shrineId'],
        shrineName: maps[i]['shrineName'],
        goshuinName: maps[i]['goshuinName'],
        date: maps[i]['date'],
        prefectures: maps[i]['prefectures'],
        memo: maps[i]['memo'],
      ));
      i++;
    }
    print("db_goshuin_data.dart★結合一覧　ID昇順");
    return list;
  }

  /* レコード取得
  *　神社ID昇順
  * */
  Future<List<GoshuinList>> getAscshrineIdGoshuinList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM ' + tableName + ' ORDER BY shrineId ASC');
    var list = new List<GoshuinList>();
    var i = 0;
    for (Map map in maps) {
      list.add(GoshuinList(
        id: maps[i]['id'],
        img: maps[i]['img'],
        shrineId: maps[i]['shrineId'],
        shrineName: maps[i]['shrineName'],
        goshuinName: maps[i]['goshuinName'],
        date: maps[i]['date'],
        prefectures: maps[i]['prefectures'],
        memo: maps[i]['memo'],
      ));
      i++;
    }
    print("db_goshuin_data.dart★結合一覧　神社ID昇順");
    return list;
  }
}

class Goshuin {
  final String id; // [GSI+連番6桁（GSI000001）]
  final String img; // 画像(base64)
  final String shrineId; // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String goshuinName; // 御朱印名
  final String date; // 参拝日
  final String memo; // メモ

  Goshuin(
      {this.id,
      this.img,
      this.shrineId,
      this.goshuinName,
      this.date,
      this.memo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'shrineId': shrineId,
      'goshuinName': goshuinName,
      'date': date,
      'memo': memo,
    };
  }

  @override
  String toString() {
    return 'Goshuin{id: $id, img: $img, shrineId: $shrineId, goshuinName: $goshuinName, date: $date, memo: $memo}';
  }
}

class GoshuinList {
  final String id; // [GSI+連番6桁（GSI000001）]
  final String img; // 画像(base64)
  final String shrineId; // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String shrineName; // 神社・寺院名
  final String goshuinName; // 御朱印名
  final String date; // 参拝日
  final String prefectures; // 都道府県
  final String memo; // メモ

  GoshuinList(
      {this.id,
      this.img,
      this.shrineId,
      this.shrineName,
      this.goshuinName,
      this.date,
      this.prefectures,
      this.memo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'img': shrineId,
      'shrineName': shrineName,
      'goshuinName': goshuinName,
      'date': date,
      'prefectures': prefectures,
      'memo': memo,
    };
  }

  @override
  String toString() {
    return 'Goshuin{id: $id, img: $img, shrineId: $shrineId, shrineName: $shrineName, goshuinName: $goshuinName, date: $date, prefectures: $prefectures, memo: $memo}';
  }
}
