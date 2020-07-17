import 'contents.dart';
import 'package:flutter/material.dart';
import 'db_goshuin_data.dart';
import 'package:goshuin_app/style.dart';
import 'dart:convert';
import 'dart:typed_data';

class ListJinjabetsu extends StatefulWidget {
  const ListJinjabetsu();

  @override
  _ListJinjabetsu createState() => _ListJinjabetsu();
}

class _ListJinjabetsu extends State<ListJinjabetsu> {
  List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbGoshuinData().getAscshrineIdGoshuinList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<GoshuinList>> getList) {
          var listGoshuin = getList.data;
          print("★listJinjabetsu.dart 一覧表示");
          List<PlaceItem> _item = jinjaItems(listGoshuin);

          if (getList.hasData) {
            return SingleChildScrollView(
              child: Container(
                child: _buildPanel(_item),
              ),
            );
          } else {
            return Center(
              child: loading,
            );
          }
        });
  }

  Widget _buildPanel(List<PlaceItem> item) {
    //★★★ここからやる
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: item.map<ExpansionPanel>((_createPanel) {
        var i = 0;
        var list = new List<itemData>();
        list = item[i].itemData;
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
//              title: Text(item.headerValue),
              title: Text(list[0].id),
            );
          },
          body: ListTile(
//              title: Text(item.expandedValue),
              title: Text("てすと２"),
              subtitle: Text('To delete this panel, tap the trash can icon'),
              trailing: Icon(Icons.delete),
              onTap: () {
//                setState(() {
//                  _data.removeWhere((currentItem) => item == currentItem);
//                });
              }),
          isExpanded: item[i].isExpanded,
        );
        i++;
      }).toList(),
    );

    ExpansionPanel _createPanel(List<itemData> list) {
      for (int i = 0; i < list.length; i++) {
        return ExpansionPanel(
//        for(int j = 0; j < list[i].length; j++){
//
//        }

          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
//              title: Text(item.headerValue),
                );
          },
        );
      }
    }

//    return ExpansionPanelList(
//      expansionCallback: (int index, bool isExpanded) {
//        setState(() {
//          _data[index].isExpanded = !isExpanded;
//        });
//      },
//      children: _data.map<ExpansionPanel>((Item item) {
//        return ExpansionPanel(
//          headerBuilder: (BuildContext context, bool isExpanded) {
//            return ListTile(
//              title: Text(item.headerValue),
//            );
//          },
//          body: ListTile(
//              title: Text(item.expandedValue),
//              subtitle: Text('To delete this panel, tap the trash can icon'),
//              trailing: Icon(Icons.delete),
//              onTap: () {
//                setState(() {
//                  _data.removeWhere((currentItem) => item == currentItem);
//                });
//              }),
//          isExpanded: item.isExpanded,
//        );
//      }).toList(),
//    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

/*
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbGoshuinData().getAscshrineIdGoshuinList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<GoshuinList>> getList) {
          var listGoshuin = getList.data;
          print("★listJinjabetsu.dart 一覧表示");
          List<List<itemData>> _item = jinjaItems(listGoshuin);

          if (getList.hasData) {
            return SingleChildScrollView(
              child: Container(
                child: _buildPanel(),
              ),
            );
          } else {
            return Text("データが存在しません");
          }
        });
  }

//  Widget _buildPanel() {
//    return ExpansionPanelList(
//      expansionCallback: (int index, bool isExpanded) {
//        setState(() {
//          _data[index].isExpanded = !isExpanded;
//        });
//      },
//      children: _data.map<ExpansionPanel>((Item item) {
//        return ExpansionPanel(
//          headerBuilder: (BuildContext context, bool isExpanded) {
//            return ListTile(
//              title: Text(item.headerValue),
//            );
//          },
//          body: ListTile(
//              title: Text(item.expandedValue),
//              subtitle: Text('To delete this panel, tap the trash can icon'),
//              trailing: Icon(Icons.delete),
//              onTap: () {
//                setState(() {
//                  _data.removeWhere((currentItem) => item == currentItem);
//                });
//              }),
//          isExpanded: item.isExpanded,
//        );
//      }).toList(),
//    );
//  }
}
*/

/*
* 表示値をリストに入れる
* prm：List<GoshuinList>
* return：List<List<itemData>>
*/
List<PlaceItem> jinjaItems(List<GoshuinList> listGoshuin) {
  var jinjabetsuList = new List<PlaceItem>();
  String oldId = "";
  var list = new List<itemData>();

  if (listGoshuin != null) {
    for (int i = 0; i < listGoshuin.length; i++) {
      // 神社・寺院ID取得
      var newId = listGoshuin[i].shrineId;
      //神社・寺院IDが違う場合、リストを追加し新しいリストを作成
      if (i != 0 && oldId != newId) {
// PlaceItem に設定
        var _item2 = new PlaceItem(false, list);

        // 作成したリストを返却用のリストへいれる
        jinjabetsuList.add(_item2);
        // 神社別の御朱印リスト生成
        list = new List<itemData>();
      }
      list.add(itemData(
        id: listGoshuin[i].id, // 御朱印ID
//        img: listGoshuin[i].img, // 画像
        img: "gazou",
        shrineId: listGoshuin[i].shrineId, // 神社・寺院ID
        shrineName: listGoshuin[i].shrineName, // 神社・寺院名
      ));
      oldId = listGoshuin[i].shrineId;
    }
  }

  return jinjabetsuList;
}
class PlaceItem {
  final bool isExpanded;
  final List itemData;

  PlaceItem(this.isExpanded, this.itemData,);
}

class itemData {
  final String id; // [GSI+連番6桁（GSI000001）]
  final String img; // 画像(base64)
  final String shrineId; // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String shrineName; // 神社・寺院名

  itemData({
    this.id,
    this.img,
    this.shrineId,
    this.shrineName,
  });
}


