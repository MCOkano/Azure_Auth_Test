import 'dart:async';
// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
// import 'dart:convert' as convert;
// import 'package:http/http.dart' as http;

import 'NextPage.dart';

// [Themelist] インスタンスにおける処理。
class Home extends StatefulWidget {

  final String user_token;
  Home({Key key, this.user_token}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
//  _HomeState createState() => new _HomeState(user_id:user_id);
}

class _HomeState extends State<Home> {

//  final String userid;
//  _HomeState({Key key, this.userid}) : super(key: key);

  String barcode = "";
  String rcvres = '';

  String _defaultValue = '入庫';
  List<String> _list = <String>['入庫', '出庫'];
  String _inputdata = '';


  void _handleChange(String newValue) {
    setState(() {
      _defaultValue = newValue;
    });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('入出庫登録'),
          centerTitle: true,
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new MaterialButton(
                  onPressed: scan,
                  child: new Text("QRコードスキャン"),
                  color: Colors.blue,

                ),
                padding: const EdgeInsets.all(8.0),
              ),
              new Row(children: <Widget>[
                new Text("　スキャンコード： "),
                new Text(barcode),
              ]),
              new Container(
                child: new MaterialButton(
                  onPressed: send,
                  child: new Text("登録"),
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(8.0),
              ),
              DropdownButton<String>(
                value: _defaultValue,
                onChanged: _handleChange,
                items: _list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              new TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "内容データ入力",
                ),
                onChanged: (text) {
                  if (text.length > 0) {
                    setState(() {
                      _inputdata = text;
                    });
                  }
                  else {
                    _inputdata = "";
                  }
                },
              )
            ],
          ),
        ));
  }

  Future scan() async {
    try {
      rcvres = '';
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future<void> send() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NextPage(barcode: barcode, sendKind: _defaultValue, inputdata:_inputdata);
        },
      ),
    ).then((value) {
      setState(() {
        barcode = "";
        _inputdata = '';
      });
    });
  }
}
