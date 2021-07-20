import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MaterialApp(
      home: TestApplication(),
    ));

var lfsr = 0xACE1;

List getRgbColorsList() {
  var lst = [];
  for (int i = 0; i < 3; i++) {
    do {
      var bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
      lfsr = (lfsr >> 1) | (bit << 15);
    } while (lfsr ~/ 100 > 255);
    lst.add(lfsr ~/ 100);
  }
  return lst;
}

Color getColor(List lst) => Color.fromRGBO(lst[0], lst[1], lst[2], 1.0);

class TestApplication extends StatefulWidget {
  @override
  _TestApplicationState createState() => _TestApplicationState();
}

class _TestApplicationState extends State<TestApplication> {
  String _titleProgram = "Test Application";
  String _heyThere = "Hey there";
  List _rgbList = [];
  Color _randomColor = const Color(0xFF000000);

  @protected
  @mustCallSuper
  void initState() {
    _rgbList = getRgbColorsList();
    _randomColor = getColor(_rgbList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_titleProgram),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SafeArea(
          child: Material(
            color: _randomColor,
            child: InkWell(
              onTap: () {
                setState(() {
                  _rgbList = getRgbColorsList();
                  _randomColor = getColor(_rgbList);
                });
              },
              onLongPress: () {
                Clipboard.setData(
                    ClipboardData(text: "RGB: ${_rgbList.join(', ')}"));
                Fluttertoast.showToast(
                    msg: "Copy to clipboard",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: Center(
                  child: Text(
                _heyThere,
                style: TextStyle(fontSize: 40),
              )),
            ),
          ),
        ));
  }
}
