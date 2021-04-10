// @dart=2.9

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'Authentication/login.dart';

void main() async {
  runApp(
      /* WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();*/
      MaterialApp(
          theme: ThemeData(primaryColor: HexColor('#232531')),
          debugShowCheckedModeBanner: false,
          home: Authentication()));
}
