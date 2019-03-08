import 'package:flutter/material.dart';

import 'package:my_office_th_app/screens/login/login_user_form.dart';
import 'package:my_office_th_app/screens/login/login_local_form.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {

//    Getting data from the item sate container
    final container = LoginStateContainer.of(context);

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
            container.user == null
                ? Text('')
                : Center(
                    child: Container(
                    child: Text(container.user.name),
                  )),
            container.user == null ? LoginUserForm() : LoginLocalForm(),
            SizedBox(height: 15.0),
            container.user == null ? Row(
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
