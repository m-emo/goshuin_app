//import 'style.dart';
//import 'jinjaList.dart';
//import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:intl/intl.dart';
//import 'db_goshuin_data.dart';
//
//import 'package:provider/provider.dart';
//
//class AddContents extends StatelessWidget {
//
//  var goshuin = Goshuin();
//  var name = "";
//  var memo = "";
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        leading: new IconButton(
//          icon: new Icon(Icons.arrow_back_ios, color: Colors.black54),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        title: Text(
//          '登録する',
//          style: appBarTextStyle,
//        ),
//        backgroundColor: Colors.white,
//        centerTitle: true,
//      ),
//      backgroundColor: Color(0xFFEAEAEA),
//      body: SingleChildScrollView(
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            PlaceArea(),
//            _nameArea(),
//            SelectDateArea(),
//            _memoArea(),
//            _buttonArea(),
//          ],
//        ),
//      ),
//    );
//  }
//
////名前Widget
//  Widget _nameArea() {
//    return Container(
//      color: Colors.white,
//      margin: const EdgeInsets.only(top: 4.0),
//      padding:
//      const EdgeInsets.only(top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        children: <Widget>[
//          Container(
//            child: AddTitle(title1: "名前"),
//          ),
//          Container(
//            padding: const EdgeInsets.only(top: 5.0),
//            child: TextField(
//              style: mainTextStyle,
//              decoration: new InputDecoration.collapsed(
//                border: InputBorder.none,
//                hintText: '入力してください',
//                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
//              ),
//              onChanged: _setName,
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  void _setName(String value) {
//    name = value;
//    print(name);
//    print(memo);
//  }
//
//  // メモWidget
//  Widget _memoArea() {
//    return Container(
//      color: Colors.white,
//      margin: const EdgeInsets.only(top: 4.0),
//      padding:
//      const EdgeInsets.only(top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        children: <Widget>[
//          Container(
//            child: AddTitle(title1: "メモ"),
//          ),
//          Container(
//            padding: const EdgeInsets.only(top: 10.0),
//            child: TextField(
//              keyboardType: TextInputType.multiline,
//              maxLines: null,
//              style: mainTextStyle,
//              decoration: new InputDecoration.collapsed(
//                border: InputBorder.none,
//                hintText: '入力してください',
//                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
//              ),
//              onChanged: _setMemo,
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  void _setMemo(String value) {
//    memo = value;
//    print(name);
//    print(memo);
//  }
//
//  // ボタン
//  Widget _buttonArea() {
//    return Container(
//      margin:
//      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0, bottom: 30.0),
//      child: FlatButton(
//        padding: EdgeInsets.all(15.0),
//        child: Text(
//          "登録する",
//          style: mainButtonTextStyle,
//        ),
//        color: Color(0xFFFE3E4D),
//        onPressed: () {
//          goshuin = Goshuin(
//            id: 0,
//            shisetsu: 0,
//            name: name,
//            date: 'テスト',
//            memo: memo,
//          );
//          DbGoshuinData().insertGoshuin(goshuin);
//          print(goshuin);
//        },
//      ),
//    );
//  }
//}
//
////施設Widget
//class PlaceArea extends StatefulWidget {
//  @override
//  //_PlaceArea createState() => _PlaceArea();
//  State<StatefulWidget> createState() {
//    return _PlaceArea();
//  }
//}
//
//class _PlaceArea extends State<PlaceArea> {
//  var _place = '選択してください';
//  var _prefectures = '';
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: Colors.white,
//      margin: const EdgeInsets.only(top: 4.0),
//      padding: const EdgeInsets.only(
//          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
//      child: InkWell(
//        onTap: () => _navigateAndDisplaySelection(context),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//              flex: 11,
//              child: Container(
//                padding: const EdgeInsets.only(right: 20.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    Container(
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Container(
//                            child: AddTitle(title1: "施設"),
//                          ),
//                          Container(
//                            child: Text("${_prefectures}"),
//                          ),
//                        ],
//                      ),
//                    ),
//                    Container(
//                      padding: const EdgeInsets.only(top: 15.0),
//                      child: Text("${_place}"),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//            Expanded(
//              flex: 1,
//              child: Icon(Icons.arrow_forward_ios),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  // 選択値受取
//  void _navigateAndDisplaySelection(BuildContext context) async {
//    final result = await Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => JinjaList(),
//        ));
//    var place = result[0]; // 場所
//    var prefectures = "[ " + result[1] + " ]"; // 都道府県
//
//    setState(() {
//      _place = place;
//      _prefectures = prefectures;
//    });
//  }
//}
//
////名前Widget
///*
//Widget _nameArea() {
//  return Container(
//    color: Colors.white,
//    margin: const EdgeInsets.only(top: 4.0),
//    padding:
//        const EdgeInsets.only(top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
//    child: Column(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children: <Widget>[
//        Container(
//          child: AddTitle(title1: "名前"),
//        ),
//        Container(
//          padding: const EdgeInsets.only(top: 5.0),
//          child: TextField(
//            style: mainTextStyle,
//            decoration: new InputDecoration.collapsed(
//              border: InputBorder.none,
//              hintText: '入力してください',
//              hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
//            ),
//          ),
//        ),
//      ],
//    ),
//  );
//}
//*/
//
//// 日付Widget
//class SelectDateArea extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _State();
//  }
//}
//
//class _State extends State<SelectDateArea> {
//  var _labelText = '選択してください';
//  DateTime _date = new DateTime.now();
//  var formatter = new DateFormat('yyyy/MM/dd');
//
//  Future<Null> _selectDate(BuildContext context) async {
//    final DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: DateTime.now(),
//        firstDate: new DateTime(1950),
//        lastDate: new DateTime.now().add(new Duration(days: 360)));
//    if (picked != null) setState(() => _labelText = formatter.format(picked));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return InkWell(
//      onTap: () => _selectDate(context),
//      child: Container(
//        color: Colors.white,
//        margin: const EdgeInsets.only(top: 20.0),
//        padding: const EdgeInsets.only(
//            top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//              flex: 1,
//              child: AddTitle(title1: "日付"),
//            ),
//            Expanded(
//              flex: 3,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  Text(
//                    "${_labelText}",
//                    style: mainTextStyle,
//                  ),
//                  Container(
//                    padding: const EdgeInsets.only(left: 20.0),
//                    child: Icon(Icons.date_range),
//                  ),
////                  IconButton(
////                    icon: Icon(Icons.date_range),
////                    onPressed: () => _selectDate(context),
////                  )
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//// メモWidget
///*
//Widget _memoArea() {
//  return Container(
//    color: Colors.white,
//    margin: const EdgeInsets.only(top: 4.0),
//    padding:
//    const EdgeInsets.only(top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
//    child: Column(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children: <Widget>[
//        Container(
//          child: AddTitle(title1: "メモ"),
//        ),
//        Container(
//          padding: const EdgeInsets.only(top: 10.0),
//          child: TextField(
//            keyboardType: TextInputType.multiline,
//            maxLines: null,
//            style: mainTextStyle,
//            decoration: new InputDecoration.collapsed(
//              border: InputBorder.none,
//              hintText: '入力してください',
//              hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
//            ),
//          ),
//        ),
//      ],
//    ),
//  );
//}
// */
//
//// ボタン
///*
//Widget _buttonArea() {
//  return Container(
//    margin:
//    const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0, bottom: 30.0),
//    child: FlatButton(
//      padding: EdgeInsets.all(15.0),
//      child: Text(
//        "登録する",
//        style: mainButtonTextStyle,
//      ),
//      color: Color(0xFFFE3E4D),
//      onPressed: () {
//        DbGoshuinData().insertGoshuin(DbGoshuinData().goshuin);
//      },
//    ),
//  );
//}
// */
//
//// 見出し
//class AddTitle extends StatelessWidget {
//  final String title1; // 引数
//  AddTitle({@required this.title1});
//
//  @override
//  Widget build(BuildContext context) {
//    return Text(
//      title1,
//      style: mainTextStyleBold,
//    );
//  }
//}
