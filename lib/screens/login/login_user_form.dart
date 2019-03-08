import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/user.dart' as mu;
import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';
import 'package:my_office_th_app/services/fetch_users.dart' as su;

class LoginUserForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginUserFormState();
  }
}

class _LoginUserFormState extends State<LoginUserForm> {
  final _formKey = GlobalKey<FormState>();

  mu.User _myUser;
  String _user, _password;
  bool _login = false;

  void _checkLogin(BuildContext context) {

//    Getting data from the item sate container
    final container = LoginStateContainer.of(context);

//    Change the state to true to keep the circle loading
    setState(() {
      _login = true;
    });

    var _userLogged = su.fetchAnUser(http.Client(), _user, _password);

//    When I have a response from the future, take the result to evaluate.
    _userLogged.timeout(new Duration(seconds: 30)).then((result) {
      setState(() {
        this._login = false;
        if (result != null) {
          this._myUser = result;

          if (this._myUser.local.id.isEmpty) {
//            Update the user inherited
            container.updateUser(_myUser);
          } else {
//            Update the user and local inherited
            container.updateUser(_myUser);
            container.updateHolding(_myUser.holding);
            container.updateLogin(_myUser.local);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage()));
          }
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("User login failed!")));
        }
      });
    }, onError: (error) {
      setState(() => this._login = false);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Connection time-out!")));
    }).catchError((error) {
      print(error);

      setState(() => this._login = false);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Error connection!")));
    });
  }

  Column _buildingColumn(BuildContext context) {
    var formColumn = new Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new TextFormField(
          decoration: InputDecoration(
              labelText: 'USER',
              labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff011e41)))),
          validator: (val) => val.isEmpty ? 'User is empty' : null,
          onSaved: (val) => this._user = val,
        ),
        SizedBox(height: 20.0),
        new TextFormField(
          decoration: InputDecoration(
              labelText: 'PASSWORD',
              labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff011e41)))),
          validator: (val) => val.isEmpty
              ? 'Please insert your password to '
                  'continue...'
              : null,
          onSaved: (val) => _password = val,
          obscureText: true,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment(1.0, 0.0),
          padding: EdgeInsets.only(top: 15.0, left: 20.0),
          child: InkWell(
            child: Text(
              'Forgot Password',
              style: TextStyle(
                  color: Color(0xFFeb2227),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
        SizedBox(height: 40.0),
      ],
    );

    if (_login) {
      formColumn.children.add(new Container(
        height: 40.0,
        color: Colors.transparent,
        child: new CircularProgressIndicator(),
      ));
    } else {
      formColumn.children.add(
        new Container(
          height: 40.0,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Color(0xff212121),
            color: Color(0xff011e41),
            elevation: 7.0,
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _checkLogin(context);
                }
              },
              child: Center(
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ),
        ),
      );
    }

//    Adding the other buttons
    formColumn.children.add(new SizedBox(height: 20.0));

//    Facebook button
    /*
    formColumn.children.add(new Container(
      height: 40.0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 1.0),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ImageIcon(AssetImage('assets/img/facebook.png')),
            ),
            SizedBox(width: 10.0),
            Center(
              child: Text('Log in with facebook',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
            )
          ],
        ),
      ),
    ));
    */

    return formColumn;
  }

  @override
  Widget build(BuildContext context) {
    return (new Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: new Column(
        children: <Widget>[
          new Form(key: _formKey, child: _buildingColumn(context)),
        ],
      ),
    ));
  }
}
