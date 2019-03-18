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
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _header(),
            SizedBox(height: 15.0),
            _userLogged(),
            _form(),
            SizedBox(height: 15.0),
            _footPage()
          ],
        ));
  }

  Widget _header() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
            child: Text('Smart Sales',
                style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
            child: Text('Force',
                style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(175.0, 175.0, 0.0, 0.0),
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
      stream: bloc.obsUser,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot != null
            ? snapshot.hasData
                ? Center(
                    child: Container(
                    child: Text(snapshot.data.name),
                  ))
                : Text('')
            : Text('');
      },
    );
  }

  Widget _form() {
    return StreamBuilder(
      stream: bloc.obsUser,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot.hasData ? LoginLocalForm() : LoginUserForm();
      },
    );
  }

  Widget _footPage() {
    return StreamBuilder(
      stream: bloc.obsUser,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return snapshot.hasData
            ? Text('')
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New to app ?',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: Text(
                      'Register',
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
}
