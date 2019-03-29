import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/blocs/invoice_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/models/user.dart';

import 'package:my_office_th_app/blocs/inventory_bloc.dart';
import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/inventory/index.dart';
import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/sales/invoice_home.dart';

// ignore: must_be_immutable
class UserDrawer extends StatelessWidget {
  LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    /// Searching for the login bloc in the provider
    bloc = BlocProvider.of<LoginBloc>(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          _header(),
          Divider(),
          ListTile(
              title: new Text("Inventario"),
              trailing: new Icon(Icons.apps),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BlocProvider(
                      bloc: InventoryBloc(),
                      child: InventoryHome(),
                    )));
              }),
//          ListTile(
//              title: new Text("Sales"),
//              trailing: new Icon(Icons.attach_money),
//              onTap: () {
//                Navigator.pop(context);
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => BlocProvider(
//                      bloc: InvoiceBloc(),
//                      child: InvoiceHome(),
//                    )));
//              }),
          ListTile(
              title: new Text("CRM"),
              trailing: new Icon(Icons.people),
              onTap: () {
                Navigator.pop(context);
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: Text('En desarrollo!')));
              }),
          Divider(),
          ListTile(
              title: new Text("Inicio"),
              trailing: new Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BlocProvider(
                      bloc: HomeBloc(),
                      child: HomePage(),
                    )));
              }),
          ListTile(
              title: new Text("Cambiar Local"),
              trailing: new Icon(Icons.location_on),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyLoginPage()));
              }),
          ListTile(
              title: new Text("Salir"),
              trailing: new Icon(Icons.exit_to_app),
              onTap: () {
                /// Function to set null user and local
                bloc.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyLoginPage()),
                        (Route<dynamic> route) => false);
              }),
          Divider(),
          ListTile(
              title: new Text("Dispositivo"),
              trailing: new Icon(Icons.info),
              onTap: () {
                Navigator.pushNamed(context, '/device_info');
              }),
        ],
      ),
    );
  }

  Widget _header() {
    return DrawerHeader(
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
                child: StreamBuilder(
                    stream: bloc.user,
                    builder:
                        (BuildContext context, AsyncSnapshot<User> snapshot) {
                      return snapshot.hasData
                          ? Text(
                        snapshot.data.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      )
                          : CircularProgressIndicator();
                    }),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                  left: 20.0,
                ),
                child: StreamBuilder(
                    stream: bloc.local,
                    builder:
                        (BuildContext context, AsyncSnapshot<Local> snapshot) {
                      return snapshot.hasData
                          ? Text(
                        snapshot.data.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      )
                          : CircularProgressIndicator();
                    }),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/img/drawer_image.jpg'))),
    );
  }
}
