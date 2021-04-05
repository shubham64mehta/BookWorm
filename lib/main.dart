// @dart=2.9

import 'package:flutter/material.dart';

import 'Authentication/login.dart';

void main() async {
  runApp(
      /* WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();*/
      MaterialApp(debugShowCheckedModeBanner: false, home: Authentication()));
}
