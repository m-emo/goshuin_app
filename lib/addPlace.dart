//import 'style.dart';
//import 'package:flutter/material.dart';
//
//class AddPlace extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    const data = [
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["ああああああああああああああああああああああああああ", "神奈川県"],
//      ["場所２", "東京都"]
//    ];
//    return Scaffold(
//      appBar: AppBar(
//        leading: new IconButton(
//          icon: new Icon(Icons.arrow_back_ios, color: Colors.black54),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        title: Text(
//          '神社・寺院',
//          style: appBarTextStyle,
//        ),
//        backgroundColor: Colors.white,
//        centerTitle: true,
//
//      ),
//      persistentFooterButtons:<Widget>[
//        FlatButton(
//          child: Text(
//            '＋ 神社・寺院を追加',
//          ),
//                  ),
//      ],
//      body: ListView.builder(
//        itemCount: data.length,
//        itemBuilder: (context, int index) {
//          return Container(
//            decoration: BoxDecoration(
//                border: Border(
//                    bottom: BorderSide(
//                      color: Color(0xFFEAEAEA),
//                      width: 6.0,
//                    ))),
//            child: InkWell(
//              onTap: () {
//                Navigator.pop(context, data[index]); //前の画面に戻る（変更なし）
//              },
//              child: Container(
//                padding: EdgeInsets.only(
//                    top: 20.0, right: 20.0, bottom: 20.0, left: 20.0),
//                child: Container(
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Expanded(
//                        flex: 6,
//                        child: Container(
//                          child: Text(data[index][0], style: mainTextStyle),
//                        ),
//                      ),
//                      Expanded(
//                        flex: 2,
//                        child: Container(
//                            padding: EdgeInsets.only(left: 10.0),
//                            child: Align(
//                              alignment: Alignment.centerRight,
//                              child: Text('[ ' + data[index][1] + ' ]',
//                                  style: mainTextStyleSmall),
//                            )),
//                      ),
//                    ],
//                  ),
//                ),
////                child: Text(data[index][0], style: mainTextStyle),
//              ),
//            ),
//          );
//        },
//      ),
//    );
//  }
//}
