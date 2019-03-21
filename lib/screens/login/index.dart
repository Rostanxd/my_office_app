import 'package:flutter/material.dart';

import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/models/user.dart';

import 'package:my_office_th_app/screens/login/login_user_form.dart';
import 'package:my_office_th_app/screens/login/login_local_form.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  LoginBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    /// Searching for the login bloc in the provider
    bloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Color(0xff011e41),
        ),
        drawer: _infoDrawer(context),
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _header(),
                SizedBox(height: 15.0),
                _userLogged(),
                _form(),
                SizedBox(height: 15.0),
                _footPage()
              ],
            ),
          ],
        ));
  }

  Widget _header() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
            child: Text('Smart Sales',
                style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 100.0, 0.0, 0.0),
            child: Text('Force',
                style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(175.0, 100.0, 0.0, 0.0),
            child: Text('.',
                style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff011e41))),
          )
        ],
      ),
    );
  }

  Widget _userLogged() {
    return StreamBuilder(
      stream: bloc.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot.hasData
            ? Center(
                child: Container(
                child: Text(
                  snapshot.data.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ))
            : Text('');
      },
    );
  }

  Widget _form() {
    return StreamBuilder(
      stream: bloc.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot.hasData ? LoginLocalForm() : LoginUserForm();
      },
    );
  }

  Widget _footPage() {
    return StreamBuilder(
      stream: bloc.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot.hasData
            ? Text('')
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Nuevo en la app ?',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('En desarrollo!')));
                    },
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                          color: Color(0xFFeb2227),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              );
      },
    );
  }

  Widget _infoDrawer(BuildContext context) {
    return Drawer(
        child: new ListView(children: <Widget>[
      DrawerHeader(
          child: Text(
            'Configuración',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/img/drawer_image.jpg')))),
      Divider(),
      ListTile(
          title: new Text("Sobre el dispositivo"),
          trailing: new Icon(Icons.info),
          onTap: () {
            Navigator.pushNamed(context, '/device_info');
          }),
    ]));
  }
}
