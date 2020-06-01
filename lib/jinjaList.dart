import 'package:goshuin_app/db_shrine_data.dart';
import 'package:goshuin_app/style.dart';
import 'package:flutter/material.dart';

class JinjaList extends StatefulWidget {
  const JinjaList();

  @override
  _JinjaList createState() => _JinjaList();
}

class _JinjaList extends State<JinjaList> {
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, listShrine[index]); //前の画面に戻る（変更なし）
                      },
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            top: 20.0, right: 20.0, bottom: 20.0, left: 20.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Container(
                                  child: Text(listShrine[index].shrineName, // 神社・寺院名
                                      style: mainTextStyle),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('[ ' + listShrine[index].prefectures + ' ]', // 都道府県名
                                          style: mainTextStyleSmall),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
          ;
        });
  }
}
