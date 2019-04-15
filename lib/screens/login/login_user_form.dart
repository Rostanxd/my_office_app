import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/screens/home/index.dart';

class LoginUserForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginUserFormState();
  }
}

class _LoginUserFormState extends State<LoginUserForm> {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  MediaQueryData _queryData;
  double _queryMediaWidth;

  @override
  void initState() {
    print('LoginUserFormState >> initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('LoginUserFormState >> didChangeDependencies');
    _queryData = MediaQuery.of(context);
    _queryMediaWidth = _queryData.size.width;

    /// Getting the setting bloc
    _settingsBloc = BlocProvider.of(context);

    /// Searching for the login bloc in the provider
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    /// Listener to the observable to catch the response.
    _loginBloc.user.listen((User user) {
      if (user != null){
        _moveNextPage(user);
      }
    }, onError: (error) {
      if (context != null){
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
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('LoginUserFormState >> build');

    return (Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _idField(),
              SizedBox(height: 20.0),
              _passwordField(),
              SizedBox(height: 5.0),
              _forgotInkWell(),
              SizedBox(height: 40.0),
              _streamButtonSubmit(context)
            ],
          )),
        ],
      ),
    ));
  }

  /// Field for the user's Id
  Widget _idField() {
    return StreamBuilder(
      stream: _loginBloc.id,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _loginBloc.changeId,
          decoration: InputDecoration(
              labelText: 'USUARIO',
              labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff011e41))),
              errorText: snapshot.error),
        );
      },
    );
  }

  /// Field for the user's password
  Widget _passwordField() {
    return StreamBuilder(
      stream: _loginBloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _loginBloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'CLAVE',
              labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff011e41))),
              errorText: snapshot.error),
        );
      },
    );
  }

  /// Inkwell to call a interface for the user when he forgot his password.
  Widget _forgotInkWell() {
    return Container(
      alignment: Alignment(1.0, 0.0),
      padding: EdgeInsets.only(top: 15.0, left: 20.0),
      child: InkWell(
        child: Text(
          'Olvidé mi clave',
          style: TextStyle(
              color: Color(0xFFeb2227),
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              decoration: TextDecoration.underline),
        ),
        onTap: () {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('En desarrollo!')));
        },
      ),
    );
  }

  /// Submit button for the form
  Widget _submitButton(BuildContext context) {
    return StreamBuilder(
        stream: _loginBloc.submitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return InkWell(
            onTap: () {
              if (snapshot.data != null && snapshot.data) {
                _loginBloc.logIn(
                    _settingsBloc.device.value, _settingsBloc.myIp.value);
              }
            },
            child: Container(
              height: 40.0,
              width: _queryMediaWidth * 0.75,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Color(0xff212121),
                color: snapshot.data != null
                    ? snapshot.data ? Color(0xff011e41) : Colors.grey
                    : Colors.grey,
                elevation: 7.0,
                child: Center(
                    child: Text(
                      'CONFIRMAR',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
              ),
            ),
          );
        });
  }

  /// Streamer to build button login or circular progress indicator
  Widget _streamButtonSubmit(BuildContext context) {
    return StreamBuilder(
      stream: _loginBloc.logging,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return snapshot.hasData
            ? snapshot.data
                ? Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: CircularProgressIndicator(),
                  )
                : _submitButton(context)
            : _submitButton(context);
      },
    );
  }

  /// Function to call the next page
  void _moveNextPage(User user) {
    if (!(user.level == '3' || (user.accessId == '08' && user.level == '4'))) {
      print(user.holding.name);
      print(user.local.name);

      _loginBloc.changeCurrentHolding(user.holding);
      _loginBloc.changeCurrentLocal(user.local);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => BlocProvider<HomeBloc>(
                    bloc: HomeBloc(),
                    child: HomePage(),
                  )),
          (Route<dynamic> route) => false);
    }
  }
}
