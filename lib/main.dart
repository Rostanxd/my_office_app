import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/inventory/item_home.dart';
import 'package:my_office_th_app/screens/signup/signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new MyLoginPage(null),
        '/signup': (BuildContext context) => new SignupPage(),
        '/home': (BuildContext context) => new HomePage(null, null),
        '/item_home': (BuildContext context) => new ItemHome(null, null),
      },
      home: new MyLoginPage(null),
    );
  }
}