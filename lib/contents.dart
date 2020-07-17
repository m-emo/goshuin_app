import 'package:flutter/cupertino.dart';

import 'add.dart';
import 'main.dart';
import 'style.dart';
import 'package:flutter/material.dart';
import 'db_goshuin_data.dart';
import 'dart:convert';
import 'dart:typed_data';

enum Menu { goshuin_update, goshuin_delete }

class Contents extends StatelessWidget {
  // 引数取得
  final String id;

  Contents({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // ページ遷移
    void _pushPage(BuildContext context, Widget page) {
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
    }

    // キャンセル確認ダイアログ
    void _pushDialog(BuildContext context) {
      showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('削除する'),
            content: Text('本当に削除してもよろしいですか'),
            actions: <Widget>[
              FlatButton(
                child: Text('キャンセル'),
                onPressed: () => Navigator.of(context).pop(0),
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () async{
                  // 削除する
                  await DbGoshuinData().deleteGoshuin(id);
                  // 一覧にもどる
                  _pushPage(context, MyApp());
                },
              ),
            ],
          );
        },
      );
    }

    // 右上メニュー遷移
    void popupMenuSelected(Menu selectedMenu) {
      switch (selectedMenu) {
        case Menu.goshuin_update:
          _pushPage(context, AddContents(id: id, kbn: "1"));
          break;
        case Menu.goshuin_delete:
          _pushDialog(context);
          break;
        default:
          break;
      }
    }

    return FutureBuilder(
      future: DbGoshuinData().getGoshuinId(id),
      builder: (BuildContext context, AsyncSnapshot<GoshuinList> getGoshuin) {
        var goshuin = getGoshuin.data;
        print("★contents.dart 詳細表示");




        if (getGoshuin.hasData) {
          // 画像取得
          String base64Image = goshuin.img; // 画像(base64)
          // 画像に戻す
          Uint8List bytesImage = Base64Decoder().convert(base64Image);

          return Scaffold(
            appBar: AppBar(
              leading: new IconButton(
                icon: backIcon,
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                goshuin.shrineName,
                style: appBarTextStyle,
              ),
              actions: <Widget>[
                PopupMenuButton(
                  icon: moreVertIcon,
                  onSelected: popupMenuSelected,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    const PopupMenuItem(
                        child: const ListTile(
                            leading: Icon(Icons.brush),
                            title: Text(
                              "編集する",
                              style: TextStyle(
                                color: Color(0xFF707070),
                                letterSpacing: 0.5,
                                fontSize: 16.0,
                              ),
                            )),
                        value: Menu.goshuin_update),
                    const PopupMenuItem(
                      child: const ListTile(
                          leading: Icon(Icons.delete),
                          title: Text(
                            "削除",
                            style:  TextStyle(
                              color: Color(0xFF707070),
                              letterSpacing: 0.5,
                              fontSize: 16.0,
                            ),
                          )),
                      value: Menu.goshuin_delete,
                    ),
                  ],
                ),
              ],
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _imagePickerView(size, bytesImage),
                  _placeArea(goshuin.shrineName, goshuin.date,
                      goshuin.prefectures, goshuin.goshuinName),
                  _memoArea(goshuin.memo),
                ],
              ),
            ),
          );
        } else {
          return Text("データが存在しません");
        }
      },
    );
  }
}

/*
prm: Size size (画面サイズ)
     Uint8List bytesImage (画像)
 */
Widget _imagePickerView(Size size, Uint8List bytesImage) {
  return Container(
      height: size.width,
      width: size.width,
      color: bgImgcolor,
      child: bytesImage == null
          ? new Text('No image value.')
          : Image.memory(
              bytesImage,
            ));
}

/*
prm: String jinjaName (神社・寺院名)
     String data (参拝日)
     String prefectures (都道府県)
     String goshuinName (御朱印名)
 */
Widget _placeArea(
    String jinjaName, String date, String prefectures, String goshuinName) {
  return Container(
    color: Colors.white,
    padding:
        const EdgeInsets.only(top: 30.0, right: 20.0, bottom: 30.0, left: 20.0),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 11,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Text(
                    date, // 参拝日
                    style: mainTextStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Text(
                            jinjaName,
                            // 神社・寺院名
                            style: mainTextStyleBold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "[ " + prefectures + " ]", // 都道府県名
                            style: mainTextStyleSmall,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    goshuinName,
                    // 御朱印名
                    style: mainTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/*
prm: String memo (メモ)
 */
Widget _memoArea(String memo) {
  if (memo != null && memo != "") {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(right: 20.0, bottom: 30.0, left: 20.0),
      child: Container(
        padding: const EdgeInsets.only(top: 30.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFF5F5F5),
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          memo,
          style: mainTextStyle,
        ),
      ),
    );
  } else {
    return Container();
  }
}
