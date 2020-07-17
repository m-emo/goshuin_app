import 'package:flutter/material.dart';
import 'style.dart';
import 'db_shrine_data.dart';
import 'prefecturesList.dart';
import 'package:provider/provider.dart';

class AddJinja extends StatelessWidget {
  // 引数取得
  final String kbn; // 新規登録＝０、更新＝１
  final String id; // 御朱印ID
  AddJinja({Key key, this.kbn, this.id}) : super(key: key);

  var flg = false; // 更新用の値を画面に設定フラグ

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ValueChangeNotifier>(
      create: (context) => _ValueChangeNotifier(),
      child: kbn == "0"
          ? Area(
              kbn: kbn,
            )
          : FutureBuilder(
              future: DbShrineData().getShrineId(id), // 更新データ取得
              builder: (BuildContext context, AsyncSnapshot<Shrine> getshrine) {
                var shrine = getshrine.data;

                final valueChangeNotifier =
                    Provider.of<_ValueChangeNotifier>(context, listen: false);
                if (getshrine.hasData) {
                  if (!flg) {
                    // 画面遷移時のみ更新用の値を画面に設定
                    getdata(shrine, context);
                    flg = true;
                  }
                  return Area(
                    kbn: kbn,
                    shrine: shrine,
                  );
                } else {
                  return Text("データが存在しません");
                }
              },
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

/*
* 更新データを変数登録
* prm : shrine 取得した神社・寺院データ
*       context
* return : なし
 */
void getdata(Shrine shrine, BuildContext context) {
  if (shrine != null) {
    // データ登録用変数セット
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);
    var name = shrine.shrineName; // [神社・寺院名]
    var prefectures = shrine.prefectures; // [都道府県]
    var prefecturesNo = shrine.prefecturesNo; // [都道府県No]

    // 値セット
    if (name != null && name != "") {
      valueChangeNotifier._name = name; // [神社・寺院名]
    }
    if (prefectures != null && prefectures != "") {
      valueChangeNotifier._prefectures = prefectures; // [都道府県]
    }
    if (prefecturesNo != null && prefecturesNo != "") {
      valueChangeNotifier._prefecturesNo = prefecturesNo; // [都道府県No]
    }
  }
}

class Area extends StatelessWidget {
  // 引数
  final String kbn;
  final Shrine shrine;

  Area({this.kbn, this.shrine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: backIcon,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: kbn == "1" // 更新
            ? new Text(
                "編集中",
                style: appBarTextStyle,
              )
            : Text(
                // 登録
                '神社・寺院を登録',
                style: appBarTextStyle,
              ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              NameArea(),
              PrefecturesArea(kbn: kbn, shrine: shrine),
              ButtonArea(kbn: kbn, updateShrine: shrine),
            ],
          ),
        ),
      ),
    );
  }
}

//名前Widget
class NameArea extends StatefulWidget {
  @override
  _NameAreaState createState() => _NameAreaState();
}

class _NameAreaState extends State<NameArea> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);
    _textEditingController =
        new TextEditingController(text: valueChangeNotifier._name); // 更新時初期値設定
  }

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
              controller: _textEditingController,
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
  // 引数
  final String kbn;
  final Shrine shrine;

  PrefecturesArea({this.kbn, this.shrine});

  @override
  State<StatefulWidget> createState() {
    return _PrefecturesArea(kbn: kbn, shrine: shrine);
  }
}

class _PrefecturesArea extends State<PrefecturesArea> {
  // 引数
  final String kbn;
  final Shrine shrine;

  _PrefecturesArea({this.kbn, this.shrine});

  var _prefectures = ''; // 都道府県名

  @override
  void initState() {
    super.initState();
    // 更新時初期値設定
    setState(() {
      if (kbn == "1") {
        // 更新
        _prefectures = shrine.prefectures;
      } else {
        // 登録
        _prefectures = '選択してください（必須）';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          _navigateAndDisplaySelection(context);
        },
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

  // 引数
  final String kbn;
  final Shrine updateShrine;

  ButtonArea({this.kbn, this.updateShrine});

  // エラーチェックダイアログ
  void _pushDialog(BuildContext context, String msg) {
    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(0),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final valueChangeNotifier = Provider.of<_ValueChangeNotifier>(context);
    return Container(
      margin: const EdgeInsets.only(
          top: 20.0, right: 20.0, left: 20.0, bottom: 30.0),
      child: FlatButton(
        padding: EdgeInsets.all(15.0),
        child: kbn == "1" // 更新
            ? new Text(
                "更新する",
                style: mainButtonTextStyle,
              )
            : Text(
                // 登録
                "登録する",
                style: mainButtonTextStyle,
              ),
        color: Color(0xFFE75331),
        onPressed: () {
          /*登録*/
          void insert() async {
            var id = "";
            // 最大ID取得 [都道府県番号-都道府県番号内の連番5桁（03-00001）]
            Shrine max = await DbShrineData()
                .getMaxIdShrine(valueChangeNotifier._prefecturesNo);
            var maxId = max.shrineId;

            if (maxId == null) {
              // 都道府県ごとの初回登録
              id = valueChangeNotifier._prefecturesNo + "-00001";
            } else {
              var prefix = maxId.substring(0, 3); // プレフィックス
              int num = int.parse(maxId.substring(3, 8)); // 連番
              num = num + 1;
              id = prefix + num.toString().padLeft(5, "0");
            }

            shrine = Shrine(
              shrineId: id,
              shrineName: valueChangeNotifier._name,
              prefectures: valueChangeNotifier._prefectures,
              prefecturesNo: valueChangeNotifier._prefecturesNo,
            );
            await DbShrineData().insertShrine(shrine);
          }

          void update() async {
            // 更新
            shrine = Shrine(
              shrineId: updateShrine.shrineId,
              shrineName: valueChangeNotifier._name,
              prefectures: valueChangeNotifier._prefectures,
              prefecturesNo: valueChangeNotifier._prefecturesNo,
            );
            await DbShrineData().updateShrine(shrine);
          }

          /*入力チェック*/
          String checkInsert() {
            var text = "";
            var check = true;
            if (valueChangeNotifier._name == "") {
              text = "神社・寺院を入力してください";
              return text;
            }
            if (valueChangeNotifier._prefecturesNo == "") {
              text = "都道府県を選択してください";
              check = false;
            }
            return text;
          }

          // 登録・更新処理
          var msg = "";
          msg = checkInsert();
          if (msg != "") {
            _pushDialog(context, msg);
          } else {
            if (kbn == "1") {
              // 更新
              update();
            } else {
              // 登録
              insert();
            }
            // 戻る
            Navigator.of(context).pop();
          }
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
