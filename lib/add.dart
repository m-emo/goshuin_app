import 'package:goshuin_app/style.dart';
import 'jinjaList.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'db_goshuin_data.dart';
import 'package:provider/provider.dart';
import 'package:goshuin_app/db_shrine_data.dart';
import 'package:image_picker/image_picker.dart';

class AddContents extends StatelessWidget {
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
            '御朱印登録',
            style: appBarTextStyle,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFEAEAEA),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ImagePickerView(),
              PlaceArea(),
              NameArea(),
              SelectDateArea(),
              MemoArea(),
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
  String _id = ""; // ID
  String _jinjaId = ""; // 神社・寺院Id
  String _name = ""; // 御朱印名
  String _date = ""; // 日付
  String _memo = ""; // メモ

  void setId(String val) {
    _id = val;
    // increment()が呼ばれると、Listenerたちに変更を通知する
    notifyListeners();
  }

  void setJinjaId(String val) {
    _jinjaId = val;
    notifyListeners();
  }

  void setName(String val) {
    _name = val;
    notifyListeners();
  }

  void setDate(String val) {
    _date = val;
    notifyListeners();
  }

  void setMemo(String val) {
    _memo = val;
    notifyListeners();
  }
}



// 写真Widget -start-
class ImagePickerView extends StatefulWidget {
  @override
  State createState() {
    return ImagePickerViewState();
  }
}

class ImagePickerViewState extends State {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (imageFile == null)
              ? Icon(Icons.no_sim)
              : Image.file(
            imageFile,
            height: 100.0,
            width: 100.0,
          ),
          Container(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('カメラで撮影'),
                onPressed: () {
                  _getImageFromDevice(ImageSource.camera);
                },
              )),
          Container(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('ライブラリから選択'),
                onPressed: () {
                  _getImageFromDevice(ImageSource.gallery);
                },
              )),
        ],
      ),
    );
  }

// カメラまたはライブラリから画像を取得
  void _getImageFromDevice(ImageSource source) async {
    // 撮影/選択したFileが返ってくる
    var imageFile = await ImagePicker.pickImage(source: source);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return;
    }
    setState(() {
      this.imageFile = imageFile;
    });
  }
}
// 写真Widget -end-


//神社・寺院Widget -start-
class PlaceArea extends StatefulWidget {
  @override
  //_PlaceArea createState() => _PlaceArea();
  State<StatefulWidget> createState() {
    return _PlaceArea();
  }
}

class _PlaceArea extends State<PlaceArea> {
  var _place = '選択してください';
  var _prefectures = ''; // 都道府県名
//  var _jinjaId = ''; // 神社・寺院ID

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: AddTitle(title1: "神社・寺院"),
                          ),
                          Container(
                            child: Text(
                              "${_prefectures}", // 都道府県名
                              style: mainTextStyleSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "${_place}", // 神社・寺院名
                        style: mainTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }

  // 神社・寺院選択値受取
  void _navigateAndDisplaySelection(BuildContext context) async {
    var shrine = Shrine();
    shrine = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JinjaList(),
        ));
    var place = shrine.shrineName; // 神社・寺院
    var prefectures = "[ " + shrine.prefectures + " ]"; // 都道府県名
    var jinjaId = shrine.id; // 神社・寺院ID

    // データ登録用変数セット
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);
    valueChangeNotifier.setJinjaId(jinjaId);
    print("★add.dart 神社・寺院選択値受取 = " + valueChangeNotifier._jinjaId);

    setState(() {
      _place = place;
      _prefectures = prefectures;
//      _jinjaId = jinjaId;
    });
  }
}
//神社・寺院Widget -end-

//名前Widget
//Widget _nameArea() {
class NameArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: AddTitle(title1: "御朱印名"),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextField(
              style: mainTextStyle,
              decoration: new InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: '通常御朱印',
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

// 日付Widget
class SelectDateArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SelectDateArea> {
  var _labelText = '選択してください';
  DateTime _date = new DateTime.now();
  var formatter = new DateFormat('yyyy.MM.dd');

  Future<Null> _selectDate(BuildContext context) async {
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    var fmtDate = formatter.format(picked);

    // データ登録用変数セット
    valueChangeNotifier.setDate(fmtDate);

    if (picked != null) setState(() => _labelText = fmtDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
              top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: AddTitle(title1: "参拝日"),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${_labelText}",
                      style: mainTextStyle,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.date_range),
                    ),
//                  IconButton(
//                    icon: Icon(Icons.date_range),
//                    onPressed: () => _selectDate(context),
//                  )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// メモWidget
class MemoArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final valueChangeNotifier =
        Provider.of<_ValueChangeNotifier>(context, listen: false);

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: AddTitle(title1: "メモ"),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: mainTextStyle,
                decoration: new InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: '入力してください',
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
                ),
                onChanged: (String value) async {
                  valueChangeNotifier.setMemo(value);
                }),
          ),
        ],
      ),
    );
  }
}

//ボタン
class ButtonArea extends StatelessWidget {
  var goshuin = Goshuin();

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
            // 最大ID取得
            Goshuin max = await DbGoshuinData().getMaxIdGoshuin();
            var maxId = max.id;
            var id ="";
            if (maxId == null) {
              // 初回登録
              id = "GSI000001";
            } else {
              var prefix = maxId.substring(0, 3); // プレフィックス
              int num = int.parse(maxId.substring(3, 9)); // 連番
              num = num + 1;
              id = prefix + num.toString().padLeft(6, "0");
            }

            // 登録
            goshuin = Goshuin(
              id: id,
              shrineId: valueChangeNotifier._jinjaId,
              goshuinName: valueChangeNotifier._name,
              date: valueChangeNotifier._date,
              memo: valueChangeNotifier._memo,
            );
            DbGoshuinData().insertGoshuin(goshuin);
            print("add.dart ★登録する = ");
            print(goshuin);
          }

          main();

//          await Future<Goshuin> future = DbGoshuinData().getMaxIdGoshuin();
//          future.then((content) => max = content);
//          print(max);
//          print(max.id);

//          goshuin = Goshuin(
//            id: "GSI000002",
//            shisetsu: valueChangeNotifier._jinjaId,
//            name: valueChangeNotifier._name,
//            date: valueChangeNotifier._date,
//            memo: valueChangeNotifier._memo,
//          );
//          DbGoshuinData().insertGoshuin(goshuin);
//          print("★登録する = ");
//          print(goshuin);
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
