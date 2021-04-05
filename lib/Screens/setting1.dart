import 'package:bookworm/navigationbloc/navigationbloc.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Setting1 extends StatefulWidget with NavigationStates {
  final Function onMenuTap;

  const Setting1({Key key, this.onMenuTap}) : super(key: key);

  @override
  _UtilityBillsPageState createState() => _UtilityBillsPageState();
}

class _UtilityBillsPageState extends State<Setting1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#232531'),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: widget.onMenuTap),
      ),
    );
  }
}
