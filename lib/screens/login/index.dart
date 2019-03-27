import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/models/user.dart';

import 'package:my_office_th_app/screens/login/login_user_form.dart';
import 'package:my_office_th_app/screens/login/login_local_form.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    /// Calling the setting bloc on the provider.
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);

    /// Calling the setting bloc on the provider.
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);

    /// Calling function to verify device
    Platform.isAndroid
        ? _settingsBloc.fetchAndroidInfo()
        : _settingsBloc.fetchIosInfo();

    /// Calling the login bloc on the provider
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Color(0xff011e41),
        ),
        drawer: _infoDrawer(context),
        body: Platform.isAndroid
            ? StreamBuilder(
                stream: _settingsBloc.androidDeviceInfo,
                builder: (BuildContext context,
                    AsyncSnapshot<AndroidDeviceInfo> snapshot) {
                  return snapshot.hasData
                      ? StreamBuilder(
                          stream: _settingsBloc.authorizedDevice,
                          builder: (BuildContext context,
                              AsyncSnapshot<Device> snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                              return _scaffoldError(snapshot.error.toString());
                            }
                            return Center(
                              child: snapshot.hasData
                                  ? _scaffoldBodyOk()
                                  : CircularProgressIndicator(),
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              )
            : StreamBuilder(
                stream: _settingsBloc.iosDeviceInfo,
                builder: (BuildContext context,
                    AsyncSnapshot<IosDeviceInfo> snapshot) {
                  return snapshot.hasData
                      ? StreamBuilder(
                          stream: _settingsBloc.authorizedDevice,
                          builder: (BuildContext context,
                              AsyncSnapshot<Device> snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                              return _scaffoldError(snapshot.error.toString());
                            }
                            return Center(
                              child: snapshot.hasData
                                  ? _scaffoldBodyOk()
                                  : CircularProgressIndicator(),
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ));
  }

  @override
  void dispose() {
    print('login dispose!');
    super.dispose();
  }

  Widget _scaffoldError(String error) {
    return ListView(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _header(),
            SizedBox(height: 15.0),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Text(
                  error,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _scaffoldBodyOk() {
    return ListView(
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
    );
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
      stream: _loginBloc.user,
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
      stream: _loginBloc.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot.hasData ? LoginLocalForm() : LoginUserForm();
      },
    );
  }

  Widget _footPage() {
    return StreamBuilder(
      stream: _loginBloc.user,
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
