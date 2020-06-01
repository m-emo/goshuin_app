import 'package:flutter/material.dart';
import 'style.dart';
import 'db_shrine_data.dart';
import 'prefecturesList.dart';
import 'package:provider/provider.dart';

class AddJinja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ValueChangeNotifier>(
      create: (context) => _ValueChangeNotifier(),
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.black54),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '神社・寺院を登録',
            style: appBarTextStyle,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
//        backgroundColor: Color(0xFFEAEAEA),
        backgroundColor: Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              NameArea(),
              PrefecturesArea(),
              ButtonArea(),
            ],
          ),
        ),
      ),
    );
  }
}

// 値受け渡し
class _ValueChangeNotifier extends ChangeNotifier {
  String _name = ""; // [神社・寺院名]
  String _prefectures = ""; // [都道府県]
  String _prefecturesNo = ""; // [都道府県No]

  void setName(String val) {
    _name = val;
    notifyListeners();
  }

  void setPrefectures(String val) {
    _prefectures = val;
    notifyListeners();
  }

  void setPrefecturesNo(String val) {
    _prefecturesNo = val;
    notifyListeners();
  }
}

//名前Widget
class NameArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);
    return Container(
       color: Colors.white,
      margin: const EdgeInsets.only(top: 30.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: AddTitle(title1: "神社・寺院名"),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextField(
              style: mainTextStyle,
              decoration: new InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: '○○神社',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
              ),
              onChanged: (changed) => valueChangeNotifier.setName(changed),
            ),
          ),
        ],
      ),
    );
  }
}

//都道府県Widget
class PrefecturesArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrefecturesArea();
  }
}

class _PrefecturesArea extends State<PrefecturesArea> {
  var _prefectures = '選択してください'; // 都道府県名

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: InkWell(
        onTap: () => _navigateAndDisplaySelection(context),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 11,
              child: Container(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: AddTitle(title1: "都道府県"),
                      ),
                      Container(
                        child: Text("${_prefectures}", style: mainTextStyle),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward_ios, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // 選択値受取
  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Prefectures(),
        ));
    var prefectures = result[1]; // 都道府県名
    var prefecturesNo = result[0]; // 都道府県No

//     データ登録用変数セット
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);
    valueChangeNotifier.setPrefecturesNo(prefecturesNo); // 都道府県No
    valueChangeNotifier.setPrefectures(prefectures); // 都道府県名

    setState(() {
      _prefectures = prefectures;
    });
  }
}

//ボタン
class ButtonArea extends StatelessWidget {
  var shrine = Shrine();

  @override
  Widget build(BuildContext context) {
    final valueChangeNotifier = Provider.of<_ValueChangeNotifier>(context);
    return Container(
      margin: const EdgeInsets.only(
          top: 20.0, right: 20.0, left: 20.0, bottom: 30.0),
      child: FlatButton(
        padding: EdgeInsets.all(15.0),
        child: Text(
          "登録する",
          style: mainButtonTextStyle,
        ),
        color: Color(0xFFFE3E4D),
        onPressed: () {
          void main() async {
            var id = "";
            // 最大ID取得 [都道府県番号-都道府県番号内の連番5桁（03-00001）]
            Shrine max = await DbShrineData().getMaxIdShrine(valueChangeNotifier._prefecturesNo);
            var maxId = max.id;


            if(maxId == null){
              // 都道府県ごとの初回登録
              id = valueChangeNotifier._prefecturesNo + "-00001";
            }else{
              var prefix = maxId.substring(0, 3);         // プレフィックス
              int num = int.parse(maxId.substring(3, 8)); // 連番
              num = num + 1;
              id = prefix + num.toString().padLeft(5, "0");
            }

            print("★登録する = "+id);
            // 登録
            shrine = Shrine(
              id: id,
              shrineName: valueChangeNotifier._name,
              prefectures: valueChangeNotifier._prefectures,
              prefecturesNo: valueChangeNotifier._prefecturesNo,
            );
            DbShrineData().insertShrine(shrine);
            print("★登録する = ");
            print(shrine);
          }
          main();
        },
      ),
    );
  }
}

// 見出し
class AddTitle extends StatelessWidget {
  final String title1; // 引数
  AddTitle({@required this.title1});

  @override
  Widget build(BuildContext context) {
    return Text(
      title1,
      style: mainTextStyleBold,
    );
  }
}
