import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Summary1 extends StatefulWidget {
  final String summary;

  const Summary1({Key key, this.summary}) : super(key: key);
  @override
  _Summary1State createState() => _Summary1State();
}

class _Summary1State extends State<Summary1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#232531'),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: CupertinoColors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.summary,
                style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18)),
          ),
        ));
  }
}
