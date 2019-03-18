import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/login_user_bloc.dart';
import 'package:my_office_th_app/screens/home/index.dart';

class LoginUserForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginUserFormState();
  }
}

class _LoginUserFormState extends State<LoginUserForm> {
  @override
  // ignore: must_call_super
  void initState() {
    loginUserBloc.obsUser.listen((data) {
      _moveNextPage();
    }, onError: (error) {
      _showSnackBarMsg(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return (new Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: new Column(
        children: <Widget>[
          new Form(
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

  @override
  // ignore: must_call_super
  void dispose() {
    loginUserBloc.dispose();
    super.dispose();
  }

  /// Field for the user's Id
  Widget _idField() {
    return StreamBuilder(
      stream: loginUserBloc.id,
      builder: (context, snapshot) {
        return TextField(
          onChanged: loginUserBloc.changeId,
          decoration: InputDecoration(
              labelText: 'USER',
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
      stream: loginUserBloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: loginUserBloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
              labelText: 'PASSWORD',
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
          'Forgot Password',
          style: TextStyle(
              color: Color(0xFFeb2227),
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  /// Submit button for the form
  Widget _submitButton(BuildContext context) {
    return StreamBuilder(
        stream: loginUserBloc.submitValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Container(
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Color(0xff212121),
              color: snapshot.data != null
                  ? snapshot.data ? Color(0xff011e41) : Colors.grey
                  : Colors.grey,
              elevation: 7.0,
              child: GestureDetector(
                onTap: () {
                  if (snapshot.data != null && snapshot.data) {
                    loginUserBloc.submit();
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
          );
        });
  }

  /// Streamer to build button login or circular progress indicator
  Widget _streamButtonSubmit(BuildContext context) {
    return StreamBuilder(
      stream: loginUserBloc.logging,
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
  void _moveNextPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  /// Show a snack bar with a message
  void _showSnackBarMsg(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
