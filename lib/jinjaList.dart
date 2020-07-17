import 'package:goshuin_app/db_shrine_data.dart';
import 'package:goshuin_app/style.dart';
import 'package:flutter/material.dart';
import 'addJinja.dart';
import 'contents.dart';

class JinjaList extends StatefulWidget {

  // 引数取得
  final String kbn; // 登録画面から遷移＝０、メニューから遷移＝１
  JinjaList({Key key, this.kbn}) : super(key: key);

  @override
  _JinjaList createState() => _JinjaList(kbn: kbn);
}

class _JinjaList extends State<JinjaList> {
  // 引数取得
  final String kbn; // 登録画面から遷移＝０、メニューから遷移＝１
  _JinjaList({this.kbn});

  bool _flg = true;
  String _text = "削除・編集する";

  // 右上メニュー遷移
  void popupMenuSelected(Menu selectedMenu) {
    switch (selectedMenu) {
      case Menu.goshuin_update:
//        _pushPage(context, AddContents(id: id, kbn: "1"));
        setState(() {
          _flg = !_flg;
          if (_flg) {
            _text = "削除・編集する";
          } else {
            _text = "削除・編集を終了する";
          }
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbShrineData().getShrines(),
        builder: (BuildContext context, AsyncSnapshot<List<Shrine>> getList) {
          var listShrine = getList.data;
          print("★JinjaList.dart　りすと呼び出し");
          if (getList.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: new IconButton(
                  icon: backIcon,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  '神社・寺院',
                  style: appBarTextStyle,
                ),
                actions: <Widget>[
                  PopupMenuButton(
                    icon: moreVertIcon,
                    onSelected: popupMenuSelected,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Menu>>[
                      const PopupMenuItem(
                          child: const ListTile(
                              leading: Icon(Icons.brush),
                              title: Text(
                                "削除・編集する",
                                style: TextStyle(
                                  color: Color(0xFF707070),
                                  letterSpacing: 0.5,
                                  fontSize: 16.0,
                                ),
                              )),
                          value: Menu.goshuin_update),
                    ],
                  ),
                ],
                backgroundColor: Colors.white,
                centerTitle: true,
              ),
              persistentFooterButtons: <Widget>[
                FlatButton(
                  color: Colors.white,
                  child: Text(
                    '＋ 神社・寺院を追加',
                    style: mainTextStyle,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/addJinja'),
                ),
              ],
              body: ListView.builder(
                itemCount: listShrine.length,
                itemBuilder: (context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Color(0xFFEAEAEA),
                      width: 2.0,
                    ))),
//                    child: InkWell(
//                      onTap: () {
//                        Navigator.pop(
//                            context, listShrine[index]); //前の画面に戻る（変更なし）
//                      },
                    child: _flg
                        ? _contents(listShrine[index], context, kbn)
                        : _contents2(listShrine[index], context, kbn),
//                      child: Container(
//                        color: Colors.white,
//                        padding: EdgeInsets.only(
//                            top: 20.0, right: 20.0, bottom: 20.0, left: 20.0),
//                        child: Container(
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Expanded(
//                                flex: 6,
//                                child: Container(
//                                  child: Text(listShrine[index].shrineName, // 神社・寺院名
//                                      style: mainTextStyle),
//                                ),
//                              ),
//                              Expanded(
//                                flex: 2,
//                                child: Container(
//                                    padding: EdgeInsets.only(left: 10.0),
//                                    child: Align(
//                                      alignment: Alignment.centerRight,
//                                      child: Text('[ ' + listShrine[index].prefectures + ' ]', // 都道府県名
//                                          style: mainTextStyleSmall),
//                                    )),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
                  );
                },
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Colors.black54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  '神社・寺院',
                  style: appBarTextStyle,
                ),
                backgroundColor: Colors.white,
                centerTitle: true,
              ),
              persistentFooterButtons: <Widget>[
                FlatButton(
                  color: Colors.white,
                  child: Text(
                    '＋ 神社・寺院を追加',
                    style: mainTextStyle,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/addJinja'),
                ),
              ],
              body: Text("データが存在しません"),
            );
          }
        });
  }
}

/*
編集モードではない一覧
prm: Shrine
     BuildContext context
     kbn : 登録画面から遷移＝０、メニューから遷移＝１
 */
Widget _contents(Shrine shrine, BuildContext context, String kbn) {
  return kbn == "0"
      ? InkWell(
          onTap: () {
            Navigator.pop(context, shrine); //前の画面に戻る（変更なし）
          },
          child: _contentsList(shrine),
        )
      : _contentsList(shrine); //  return InkWell(
}

/*
編集モードではない一覧
prm: Shrine
 */
Widget _contentsList(Shrine shrine) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.only(top: 20.0, right: 20.0, bottom: 20.0, left: 20.0),
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              child: Text(shrine.shrineName, // 神社・寺院名
                  style: mainTextStyle),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('[ ' + shrine.prefectures + ' ]', // 都道府県名
                      style: mainTextStyleSmall),
                )),
          ),
        ],
      ),
    ),
  );
}

/*
編集モード一覧
prm: BuildContext context
     Shrine Shrine
     kbn : 登録画面から遷移＝０、メニューから遷移＝１
 */
Widget _contents2(Shrine shrine, BuildContext context, String kbn) {
  return kbn == "0"
      ? InkWell(
          onTap: () {
            Navigator.pop(context, shrine); //前の画面に戻る（変更なし）
          },
          child: _contents2List(context, shrine),
        )
      : _contents2List(context, shrine);
}

/*
編集モード一覧
prm: BuildContext context
     Shrine
 */
Widget _contents2List(BuildContext context, Shrine shrine) {
  // 削除エラーダイアログ
  void _errerDialog(BuildContext context) {
    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(
              'こちらの神社・寺院は御朱印が登録されているため削除できません。\n\n御朱印の神社・寺院を変更後に削除してください。'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(0),
            ),
          ],
        );
      },
    );
  }

  // キャンセル確認ダイアログ
  void _pushDialog(BuildContext context, String shrineId) {
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
              onPressed: () async {
                // 削除対象の神社・寺院IDが御朱印に登録されていないかチェック
                List getList =
                    await DbShrineData().getGoshuinShrineId(shrineId);
                print(getList);
                if (getList != null && getList.length != 0) {
                  Navigator.of(context).pop(0);
                  _errerDialog(context);
                } else {
                  // 削除する
                  await DbShrineData().deleteShrine(shrineId);
                  // もどる
                  Navigator.of(context).pop(0);
                }
              },
            ),
          ],
        );
      },
    );
  }

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
            child: Text(shrine.shrineName, // 神社・寺院名
                style: mainTextStyle),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('[ ' + shrine.prefectures + ' ]', // 都道府県名
                    style: mainTextStyleSmall),
              )),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddJinja(kbn: "1", id: shrine.shrineId),
                )),
            child: Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              color: Color(0xFFE75331),
              child: Icon(Icons.brush),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              _pushDialog(context, shrine.shrineId);
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              color: Color(0xFF707070),
              child: Icon(Icons.delete),
            ),
          ),
        ),
      ],
    ),
  );
}
