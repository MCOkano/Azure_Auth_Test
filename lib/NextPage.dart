import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NextPage extends StatefulWidget {
  NextPage({Key key, this.barcode, this.sendKind,this.inputdata}) : super(key: key);
  final String barcode;
  final String sendKind;
  final String inputdata;

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String _result = "";

  @override
  initState() {
    super.initState();
    send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登録結果'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(child: Text('ステータス：${_result}')),
              RaisedButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: Text('スキャンページに戻る'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future send() async {
//    final Uri addr = 'http://localhost:7071/api/mctest00/' ;
    var url = Uri.parse(
        'https://dmre-demo-httptrigger-app.azurewebsites.net/api/DMREHttpTriggerTEST?apid=scn&id=${widget.barcode}&kind=${widget.sendKind}&data=${widget.inputdata}');
//      'https://testdemo00.azurewebsites.net/api/DMREHttpTriggerTEST?apid=scn&id=${widget.barcode}&kind=${widget.sendKind}&data=${widget.inputdata}');
//    var url = Uri.parse(
//        'https://dmredemoapp.azurewebsites.net/api/HttpTriggerDMRE_Demo?apid=scn&id=${widget.barcode}&kind=${widget.sendKind}');
    print('id: ${widget.barcode}');
    print('kind: ${widget.sendKind}');
    print('inputdata: ${widget.inputdata}');
    var response = await http.get(url);
    String result = "登録に失敗しました";
    if (response.statusCode == 200) {
//      var jsonResponse = convert.jsonDecode(response.body);
//      rcv_kind = jsonResponse['kind'];
      print('rcv kind about http: ${response.body}');
      result = response.body.toString();
    } else {
      result = "正常に通信できませんでした";
      print('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      _result = result;
    });
  }
}
