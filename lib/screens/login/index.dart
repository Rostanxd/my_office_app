import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/user.dart' as mu;

import 'package:my_office_th_app/screens/login/login_user_form.dart';
import 'package:my_office_th_app/screens/login/login_local_form.dart';

class MyLoginPage extends StatefulWidget {
  final mu.User user;

  MyLoginPage(this.user);

  @override
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Smart Sales',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('Force',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold)),
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
            ),
            SizedBox(height: 15.0),
            widget.user == null
                ? Text('')
                : Center(
                    child: Container(
                    child: Text(widget.user.name),
                  )),
            widget.user == null ? LoginUserForm() : LoginLocalForm(widget.user),
            SizedBox(height: 15.0),
            widget.user == null ? Row(
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
            ) : Text('')
          ],
        ));
  }
}
