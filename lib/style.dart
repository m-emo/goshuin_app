import 'package:flutter/material.dart';

// appBarのテキストスタイル
var appBarTextStyle = TextStyle(
  color: Color(0xFF707070),
  fontSize: 16.0,
);

//メインテキストスタイル
var mainTextStyle = TextStyle(
  color: Color(0xFF707070),
  letterSpacing: 0.5,
  fontSize: 14.0,
);

// メインテキストスタイルの太字
var mainTextStyleBold = TextStyle(
  color: Color(0xFF707070),
  letterSpacing: 0.5,
  fontSize: 14.0,
  fontWeight: FontWeight.w600,
);

//メインテキストスタイル(小さめ）
var mainTextStyleSmall = TextStyle(
  color: Color(0xFF707070),
  letterSpacing: 0.5,
  fontSize: 14.0,
);

//メインテキストスタイル(小さめ）
var mainTextStyleSmall2 = TextStyle(
  color: Color(0xFF707070),
  letterSpacing: 0.5,
  fontSize: 12.0,
);


//loadingテキストスタイル
var loadingTextStyle = TextStyle(
  color: Color(0xFFB5B5B5),
  letterSpacing: 0.5,
  fontSize: 16.0,
);

// ボタン
var mainButtonTextStyle = TextStyle(
  color: Color(0xFFFFFFFF),
  letterSpacing: 1.0,
  fontSize: 16.0,
);

// 戻る（＞）アイコン
var backIcon = new Icon(Icons.arrow_back_ios, color: Color(0xFFD13833));
// メニュ（縦3点）アイコン
var moreVertIcon = new Icon(Icons.more_vert, color: Color(0xFFD13833));

// 画像の背景色
var bgImgcolor = Color(0xFFFBFBFB);

// loading

var loading =Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    Image(// Imageウィジェット
        image: AssetImage('assets/img/loading.gif')// 表示したい画像
    ),
    Container(
      padding: const EdgeInsets.only(
          top: 10.0),
      child: Text("Loding...",style: loadingTextStyle,),
    ),
  ],
);