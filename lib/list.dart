import 'contents.dart';
import 'package:flutter/material.dart';
import 'db_goshuin_data.dart';
import 'package:goshuin_app/style.dart';

class ListContents extends StatefulWidget {
  const ListContents();

  @override
  _ListContents createState() => _ListContents();
}

class _ListContents extends State<ListContents> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DbGoshuinData().getGoshuinList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<GoshuinList>> getList) {
        var listGoshuin = getList.data;
        print("★list.dart 一覧表示");
        if (getList.hasData) {
          return Scaffold(
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFEAEAEA)))),
                  height: 100.0,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Contents(),
                        )),

                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text('$index',
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                    listGoshuin[index].shrineName, // 神社・寺院名
                                    style: mainTextStyle),
                              ),
                              Container(
                                child:
                                    Text(listGoshuin[index].goshuinName, // 御朱印名
                                        style: mainTextStyle),
                              ),
                              Container(
                                child: Text(
                                    "[ " +
                                        listGoshuin[index].prefectures +
                                        " ]", // 都道府県
                                    style: mainTextStyleSmall2),
                              ),
                              Container(
                                child: Text(listGoshuin[index].date, // 日付
                                    style: mainTextStyleSmall2),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                ),
                  ),
                );
//          return Card(
//            child: Padding(
//              child: Text(
//                '$index',
//                style: TextStyle(fontSize: 22.0),
//              ),
//              padding: EdgeInsets.all(20.0),
//            ),
//          );
              },
              itemCount: listGoshuin.length,
            ),
          );
        } else {
          return Text("データが存在しません");
        }
        ;
      },
    );
  }
}
