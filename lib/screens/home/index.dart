import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/home/assistance_card_tres.dart';
import 'package:my_office_th_app/screens/home/user_drawer.dart';

import 'package:my_office_th_app/models/user.dart';

class HomePage extends StatelessWidget {
  final User _user;

  HomePage(this._user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color(0xff011e41),
        ),
        drawer: UserDrawer(_user),
        body: Container(
          child: ListView(
            children: <Widget>[
              AssistanceCard(),
//              CardDummyLoading(),
//              CardDummyLoading(),
            ],
          ),
        ));
  }
}
