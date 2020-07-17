//import 'dart:html';

import 'footer.dart';
import 'add.dart';
import 'jinjaList.dart';
import 'list.dart';
import 'photo.dart';
import 'addJinja.dart';
import 'listJinjabetsu.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
      // ルート名と表示するウィジェットのビルド関数を定義
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(),
        '/addContents': (BuildContext context) => new AddContents(id: "", kbn: "0"),
//        '/my-page-4': (BuildContext context) => new PhotoContents(),
        '/addJinja': (BuildContext context) => new AddJinja(kbn : "1", id: ""),
        '/listJinjabetsu': (BuildContext context) => new ListJinjabetsu(),
        '/JinjaList': (BuildContext context) => new JinjaList(kbn : "1"), // 神社・寺社一覧
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<TabInfo> _tabs = [
    TabInfo("一覧", ListContents()),
    TabInfo("神社・寺院", ListJinjabetsu()),
    TabInfo("写真", PhotoContents()),
  ];

  var _city = '';

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
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            title: Image(// Imageウィジェット
                image: AssetImage('assets/img/logo.png',),
              height: 18,
            ),
            leading: IconButton(
              icon: Icon(Icons.dehaze),
              color: Color(0xFF707070),
              padding: new EdgeInsets.all(15.0),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            bottom: TabBar(
//              isScrollable: true,
                indicatorColor: Color(0xFFE75331),
                labelColor: Color(0xFF707070),
                unselectedLabelColor: Color(0xFF707070).withOpacity(0.3),
                labelStyle: TextStyle(fontSize: 14.0),
                tabs: _tabs.map((TabInfo tab) {
                  return Container(height: 30.0,child:Tab(text: tab.label),);
                }).toList(),
              ),
//            bottom: PreferredSize(
//              child: TabBar(
////              isScrollable: true,
//                indicatorColor: Color(0xFFE75331),
//                labelColor: Color(0xFF707070),
//                unselectedLabelColor: Color(0xFF707070).withOpacity(0.3),
//                labelStyle: TextStyle(fontSize: 14.0),
//                tabs: _tabs.map((TabInfo tab) {
//                  return Container(height: 20.0,child:Tab(text: tab.label),);
//                }).toList(),
//              ),
//              preferredSize: Size.fromHeight(10.0),
//            ),
          ),
        ),

        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'My App',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('神社・寺院'),
                onTap: () {
                  setState(() => _city = 'Los Angeles, CA');
                  Navigator.pushNamed(context, '/JinjaList');
                },
              ),
              ListTile(
                title: Text('このアプリについて'),
                onTap: () {
                  setState(() => _city = 'Honolulu, HI');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
        // フッター
        bottomNavigationBar: Footer(),
      ),
    );
  }
}
