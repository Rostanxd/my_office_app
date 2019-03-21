import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/home/assistance_card.dart';
import 'package:my_office_th_app/components/user_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color(0xff011e41),
        ),
        drawer: UserDrawer(),
        body: Container(
          child: ListView(
            children: <Widget>[
              AssistanceCard(),
            ],
          ),
        ));
  }
}
