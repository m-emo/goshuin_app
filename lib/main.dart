//import 'dart:html';

import 'footer.dart';
import 'add.dart';
import 'list.dart';
import 'photo.dart';
import 'addJinja.dart';
import 'prefecturesList.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
      // ルート名と表示するウィジェットのビルド関数を定義
      routes: <String, WidgetBuilder>{
        '/my-page-1': (BuildContext context) => new MyHomePage(),
        '/my-page-2': (BuildContext context) => new MyPage2(),
        '/addContents': (BuildContext context) => new AddContents(),
        '/my-page-4': (BuildContext context) => new PhotoContents(),
        '/addJinja': (BuildContext context) => new AddJinja(),
      },
    );
  }
}

class TabInfo {
  String label;
  Widget widget;

  TabInfo(this.label, this.widget);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  final List<TodoItem> _items = List();
  final List<TabInfo> _tabs = [
    TabInfo("一覧", ListContents()),
    TabInfo("てすと", AddJinja()),
    TabInfo("写真", PhotoContents()),
    TabInfo("てすと", Prefectures()),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Todo App',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.black54,
              unselectedLabelColor: Colors.black54.withOpacity(0.3),
              labelStyle: TextStyle(fontSize: 16.0),
              tabs: _tabs.map((TabInfo tab) {
                return Tab(text: tab.label);
              }).toList(),
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
        // フッター
        bottomNavigationBar: Footer(),
      ),
    );
  }

/*@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Todo App',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("追加"),
                    color: Colors.orange[600],
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        _items.add(TodoItem(
                          content: _controller.text,
                        ));
                        _controller.clear();
                      });
                    },
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                children: _items,
              ),
            ),
          ],
        ),
        // フッター
        bottomNavigationBar: Footer());
  }
  */
}

class TodoItem extends StatelessWidget {
  final String content;

  TodoItem({@required this.content});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 50.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.lightBlue[200]))),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Center(
                child: Text(content,
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
              ),
            ),
            Expanded(
              flex: 1,
              child: RaisedButton(
                child: Text("移動"),
                color: Colors.orange[600],
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/my-page-2');
                },
              ),
            ),
          ],
        ),

//        child: Center(
//          child: Text(
//              content,
//              style: TextStyle(
//                fontSize: 18.0,
//              )
//          ),
//        ),
      ),
    );
  }
}

// 遷移先のページ
class MyPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyPage 2')),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.lightBlue[200]))),
            height: 100.0,
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
                        child: Text('テストテスト',
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                      Container(
                        child: Text('テストテスト',
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ),
                      Container(
                        child: Text('[テストテスト]',
                            style:
                            TextStyle(fontSize: 12.0, color: Colors.grey)),
                      ),
                      Container(
                        child: Text('2020.10.10',
                            style:
                            TextStyle(fontSize: 12.0, color: Colors.grey)),
                      ),
                    ],
                  ),
                )
              ],
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
        itemCount: 10,
      ),
    );
  }
}


//class Page2 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        Container(
//          padding: EdgeInsets.all(10.0),
//          child: Text("2"),
//        )
//      ],
//    );
//  }
//}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text("3"),
        )
      ],
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text("4"),
        )
      ],
    );
  }
}
