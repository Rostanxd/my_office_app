import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/user.dart';

import 'package:my_office_th_app/screens/inventory/item_home.dart';

class UserDrawer extends StatelessWidget {

  final User _user;

  UserDrawer(this._user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: Row(
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 60.0,
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/img/people.jpg'))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 40.0,
                        left: 20.0,
                      ),
                      child: Text(
                        this._user.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Text(
                        'Sistemas',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Text(
                        'rsoriano@nexcol.com.ec',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
//                    color: Color(0xff011e41),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/img/drawer_image.jpg'))),
          ),
          new Divider(),
          new ListTile(
              title: new Text("Inventario"),
              trailing: new Icon(Icons.apps),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ItemHome(this._user)));
              }),
          new ListTile(
              title: new Text("CRM"),
              trailing: new Icon(Icons.people),
              onTap: () {}),
          new Divider(),
          new ListTile(
              title: new Text("Inicio"),
              trailing: new Icon(Icons.home),
              onTap: () {}),
          new ListTile(
              title: new Text("Salir"),
              trailing: new Icon(Icons.exit_to_app),
              onTap: () {}),
        ],
      ),
    );
  }

}