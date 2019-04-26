import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';

import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/screens/home/index.dart';

import 'package:my_office_th_app/screens/login/login_user_form.dart';
import 'package:my_office_th_app/screens/login/login_local_form.dart';
import 'package:my_office_th_app/utils/info.dart';

class MyLoginPage extends StatefulWidget {
  final SettingsBloc _settingsBloc;
  final LoginBloc _loginBloc;

  MyLoginPage(this._settingsBloc, this._loginBloc);

  @override
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  MediaQueryData _queryData;
  double _queryMediaWidth, _queryMediaHeight;

  /// Function to call the next page
  void _moveNextPage(User user) {
    if (!(user.level == '3' || (user.accessId == '08' && user.level == '4'))) {
      widget._loginBloc.changeCurrentHolding(user.holding);
      widget._loginBloc.changeCurrentLocal(user.local);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => BlocProvider<HomeBloc>(
                    bloc: HomeBloc(),
                    child: HomePage(),
                  )),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    print('MyLoginPageState >> initState');

    /// Calling function to verify device
    Platform.isAndroid
        ? widget._settingsBloc.fetchAndroidInfo()
        : widget._settingsBloc.fetchIosInfo();

    /// Add data to stream to control circular progress bar.
    widget._settingsBloc.changeLoadingData(false);

    /// To get ip
    widget._settingsBloc.fetchIp();

    /// Listener to the observable to catch the response.
    widget._loginBloc.user.listen((User user) {
      if (user != null) {
        _moveNextPage(user);
      }
    }, onError: (error, stacktrace) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Smart Sales Force'),
              content: Text(error),
              actions: <Widget>[
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('MyLoginPageState >> didChangeDependencies');
    _queryData = MediaQuery.of(context);
    _queryMediaWidth = _queryData.size.width;
    _queryMediaHeight = _queryData.size.height;

    /// Setting Media Query Data
    widget._settingsBloc.setQueryData(_queryData);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('MyLoginPageState >> build');
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Color(0xff011e41),
        ),
        drawer: _infoDrawer(context),
        body: Platform.isAndroid
            ? StreamBuilder(
                stream: widget._settingsBloc.androidDeviceInfo,
                builder: (BuildContext context,
                    AsyncSnapshot<AndroidDeviceInfo> snapshot) {
                  return snapshot.hasData
                      ? StreamBuilder(
                          stream: widget._settingsBloc.device,
                          builder: (BuildContext context,
                              AsyncSnapshot<Device> snapshot) {
                            if (snapshot.hasError) {
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
                stream: widget._settingsBloc.iosDeviceInfo,
                builder: (BuildContext context,
                    AsyncSnapshot<IosDeviceInfo> snapshot) {
                  return snapshot.hasData
                      ? StreamBuilder(
                          stream: widget._settingsBloc.device,
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
    print('MyLoginPageState >> dispose');
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
            StreamBuilder<bool>(
              stream: widget._settingsBloc.loadingData,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.hasData && snapshot.data
                    ? Column(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(top: _queryMediaHeight * 0.20),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: _queryMediaHeight * 0.10),
                              child: Text(
                                error,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            width: _queryMediaWidth * 0.75,
                            margin:
                                EdgeInsets.only(top: _queryMediaHeight * 0.10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Color(0xff212121),
                              color: Color(0xFFeb2227),
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {
                                  if (Platform.isAndroid)
                                    widget._settingsBloc.fetchInfoDevice();
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              },
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
    var _textTitleSize = _queryMediaWidth * 0.14;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
            child: Text('Smart Sales',
                style: TextStyle(
                    fontSize: _textTitleSize, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 100.0, 0.0, 0.0),
            child: Text('Force',
                style: TextStyle(
                    fontSize: _textTitleSize, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                _queryData.size.width * 0.4, 100.0, 0.0, 0.0),
            child: Text('.',
                style: TextStyle(
                    fontSize: _textTitleSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff011e41))),
          )
        ],
      ),
    );
  }

  Widget _userLogged() {
    return StreamBuilder(
      stream: widget._loginBloc.user,
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
      stream: widget._loginBloc.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          if (!(snapshot.data.level == '3' ||
              (snapshot.data.accessId == '08' && snapshot.data.level == '4'))) {
            return Container(
              child: null,
            );
          } else {
            return LoginLocalForm();
          }
        } else {
          return LoginUserForm();
        }
      },
    );
  }

  Widget _footPage() {
    return StreamBuilder(
      stream: widget._loginBloc.user,
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
            'Bienvenido',
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
      ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("SSF - ${Info.version}"),
            ],
          ),
          onTap: () {})
    ]));
  }
}
