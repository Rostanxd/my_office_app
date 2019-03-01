import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/home/assistance_card.dart';
import 'package:my_office_th_app/screens/home/user_drawer.dart';

import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/models/local.dart';

class HomePage extends StatelessWidget {
  final User user;
  final Local local;

  HomePage(this.user, this.local);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color(0xff011e41),
        ),
        drawer: UserDrawer(this.user, this.local),
        body: Container(
          child: ListView(
            children: <Widget>[
              AssistanceCard(),
            ],
          ),
        ));
  }
}
