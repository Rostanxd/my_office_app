import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/screens/home/index.dart';

class LoginUserForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginUserFormState();
  }
}

class _LoginUserFormState extends State<LoginUserForm> {
  LoginBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    /// Searching for the login bloc in the provider
    bloc = BlocProvider.of<LoginBloc>(context);

    /// Listener to the observable to catch the response.
    bloc.user.listen((User user) {
      if (user != null) {
        _moveNextPage(user);
      }
    }, onError: (error) {
      _showSnackBarMsg(error, context);
    });

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
      stream: bloc.id,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeId,
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
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
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
        stream: bloc.submitValid,
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
                    bloc.logIn();
                  }
                },
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
      stream: bloc.logging,
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

  /// Function to call the next page, if user have a local
  /// he will be sent to the home page and updating holding and local streams,
  /// if he doesn't, sent to the login page with conditional interface (form).
  void _moveNextPage(User user) {
    if (user.local.name.isNotEmpty) {
      bloc.changeCurrentHolding(user.holding);
      bloc.changeCurrentLocal(user.local);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BlocProvider<HomeBloc>(
            bloc: HomeBloc(),
            child: HomePage(),
          )),
          (Route<dynamic> route) => false);
    }
  }

  /// Show a snack bar with a message
  void _showSnackBarMsg(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
