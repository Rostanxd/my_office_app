import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/crm_bloc.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/user.dart';

import 'package:my_office_th_app/blocs/inventory_bloc.dart';
import 'package:my_office_th_app/screens/crm/index.dart';
import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/inventory/index.dart';
import 'package:my_office_th_app/screens/login/index.dart';

// ignore: must_be_immutable
class UserDrawer extends StatelessWidget {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);

    /// Searching for the login bloc in the provider
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          _header(),
          ListTile(
              title: new Text("Inventario"),
              trailing: new Icon(Icons.apps),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              bloc: CrmBloc(),
                              child: CrmHome(),
                            )));
              }),
          Divider(),
          ListTile(
              title: new Text("Inicio"),
              trailing: new Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              bloc: HomeBloc(),
                              child: HomePage(),
                            )));
              }),
          _loginBloc.user.value.local.name.isNotEmpty &&
                      (_loginBloc.user.value.accessId == '08' &&
                          _loginBloc.user.value.level != '4') ||
                  _loginBloc.user.value.accessId == '05'
              ? Container(
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                  child: null,
                )
              : ListTile(
                  title: new Text("Cambiar Local"),
                  trailing: new Icon(Icons.location_on),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyLoginPage(_settingsBloc, _loginBloc)));
                  }),
          ListTile(
              title: new Text("Salir"),
              trailing: new Icon(Icons.exit_to_app),
              onTap: () {
                /// Function to set null user and local
                _loginBloc.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            MyLoginPage(_settingsBloc, _loginBloc)),
                    (Route<dynamic> route) => false);
              }),
          Divider(),
          ListTile(
              title: new Text("Dispositivo"),
              trailing: new Icon(Icons.info),
              onTap: () {
                Navigator.pushNamed(context, '/device_info');
              }),
          _loginBloc.user.value.accessId != '01'
              ? Container(
                  child: null,
                )
              : ListTile(
                  title: new Text("Configuración"),
                  trailing: new Icon(Icons.settings),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  }),
          ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("SSF - v0.0.3"),
                ],
              ),
              onTap: () {})
        ],
      ),
    );
  }

  Widget _header() {
    return DrawerHeader(
      child: Container(
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
                      image: AssetImage('assets/img/user.png'))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    left: 20.0,
                  ),
                  child: StreamBuilder(
                      stream: _loginBloc.user,
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
                    top: 5.0,
                    left: 20.0,
                  ),
                  child: Text(
                    _loginBloc.holding.value.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                    left: 20.0,
                  ),
                  child: Text(
                    _loginBloc.local.value.name,
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
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/img/drawer_image.jpg'))),
    );
  }
}
