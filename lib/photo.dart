import 'package:flutter/material.dart';

class PhotoContents extends StatefulWidget {
  const PhotoContents();

  @override
  _PhotoContents createState() => _PhotoContents();
}

class _PhotoContents extends State<PhotoContents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        // 1行に表示する数
        crossAxisSpacing: 4.0,
        // 縦スペース
        mainAxisSpacing: 4.0,
        // 横スペース
        shrinkWrap: true,
        children: List.generate(100, (index) {
          return Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: GridTile(
                  child: Icon(Icons.map),
                  footer: Center(
                    child: Text(
                      'Meeage $index',
                    ),
                  )));
        }),
      ),
    );
  }
}
