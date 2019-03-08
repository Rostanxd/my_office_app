import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/inventory/index.dart';
import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';
import 'package:my_office_th_app/screens/signup/signup.dart';

void main() => runApp(LoginStateContainer(child: new MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

//    To set-up vertical orientation (portrait).
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new MyLoginPage(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/home': (BuildContext context) => new HomePage(),
        '/item_home': (BuildContext context) => new InventoryHome(),
      },
      home: new MyLoginPage(),
    );
  }
}