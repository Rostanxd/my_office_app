import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/inventory/index.dart';
import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Getting data from the item sate container
    final container = LoginStateContainer.of(context);

    return Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: Row(
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 60.0,
                  margin: EdgeInsets.only(left: 0.0),
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
                        container.user != null ? container.user.name : '',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                        left: 20.0,
                      ),
                      child: Text(
                        container.local != null ? container.local.name : '',
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
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InventoryHome()));
              }),
          new ListTile(
              title: new Text("CRM"),
              trailing: new Icon(Icons.people),
              onTap: () {
                Navigator.pop(context);
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: Text('In developing, hold on!')));
              }),
          new Divider(),
          new ListTile(
              title: new Text("Inicio"),
              trailing: new Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }),
          new ListTile(
              title: new Text("Salir"),
              trailing: new Icon(Icons.exit_to_app),
              onTap: () {
//                Function to set null user and local
                container.logOut();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyLoginPage()),
                    (Route<dynamic> route) => false);
              }),
        ],
      ),
    );
  }
}
