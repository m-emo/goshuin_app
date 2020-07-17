import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:goshuin_app/style.dart';
import 'contents.dart';
import 'db_goshuin_data.dart';

class PhotoContents extends StatefulWidget {
  const PhotoContents();

  @override
  _PhotoContents createState() => _PhotoContents();
}

class _PhotoContents extends State<PhotoContents> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DbGoshuinData().getGoshuinList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<GoshuinList>> getList) {
        var listGoshuin = getList.data;
        print("★Photo.dart 一覧表示");
        if (getList.hasData) {
          return Container(
            padding: EdgeInsets.only(right: 2.0, left: 2.0),
            color: Color(0xFFFFFFFF),
            child: Scaffold(
              backgroundColor: bgImgcolor,
              body: GridView.count(
                crossAxisCount: 3,
                // 1行に表示する数

                crossAxisSpacing: 2.0,
                // 縦スペース

                mainAxisSpacing: 2.0,
                // 横スペース

                shrinkWrap: true,
                children: List.generate(listGoshuin.length, (index) {
                  // 画像取得
                  String base64Image = listGoshuin[index].img; // 画像(base64)
                  // 画像に戻す
                  Uint8List bytesImage = Base64Decoder().convert(base64Image);

                  return Card(
                    margin: EdgeInsets.all(0.0),
                    child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Contents(id: listGoshuin[index].id),
                            )),
                        child: bytesImage == null
                            ? new Text('No image value.')
                            : Image.memory(
                                bytesImage,
                                fit: BoxFit.cover,
                              )),
                  );
                }),
              ),
            ),
          );
        } else {
          return Scaffold(
            body:Center(
              child: loading,
            ),
          );
        }
      },
    );
  }
}
