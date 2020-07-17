import 'contents.dart';
import 'package:flutter/material.dart';
import 'db_goshuin_data.dart';
import 'package:goshuin_app/style.dart';
import 'dart:convert';
import 'dart:typed_data';

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
        if (getList.hasData) {
          return Scaffold(
            body: ListView.builder(
              itemCount: listGoshuin.length,
              itemBuilder: (BuildContext context, int index) {
                // 画像取得
                String base64Image = listGoshuin[index].img; // 画像(base64)
                // 画像に戻す
                Uint8List bytesImage = Base64Decoder().convert(base64Image);

                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color(0xFFF5F5F5),
                    width: 1,
                  ))),
                  height: 100.0,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Contents(id: listGoshuin[index].id),
                        )),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          top: 0.0, right: 10.0, bottom: 0.0, left: 2.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              height: 100.0,
                              width: 100.0,
                              color: bgImgcolor,
                              child: bytesImage == null
                                  ? new Text('No image value.')
                                  : Image.memory(
                                      bytesImage,
                                      fit: BoxFit.cover,
                                    )),
                          Container(
                            padding: const EdgeInsets.only(right: 10.0),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // 左寄せ
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // 均等配置
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    listGoshuin[index].shrineName, // 神社・寺院名
                                    style: mainTextStyleBold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    listGoshuin[index].goshuinName, // 御朱印名
                                    style: mainTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                      "[ " +
                                          listGoshuin[index].prefectures +
                                          " ]  " +
                                          listGoshuin[index].date,
                                      // 都道府県 日付
                                      style: mainTextStyleSmall2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: loading,
            ),
          );
        }
      },
    );
  }
}
