import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/models/user.dart';

class LoginUserForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginUserFormState();
  }
}

class _LoginUserFormState extends State<LoginUserForm> {
  bool _login = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return (new Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: new Column(
        children: <Widget>[
          new Form(child: _buildingColumn(context)),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    bloc.dispose();
  }

//  void _checkLogin(BuildContext context) {
////    Getting data from the item sate container
//    final container = LoginStateContainer.of(context);
//
////    Change the state to true to keep the circle loading
//    setState(() {
//      _login = true;
//    });
//
//    var _userLogged = su.fetchUser(http.Client(), _user, _password);
//
////    When I have a response from the future, take the result to evaluate.
//    _userLogged.timeout(new Duration(seconds: Connection.timeOutSec)).then(
//        (result) {
//      setState(() {
//        this._login = false;
//        if (result != null) {
//          this._myUser = result;
//
//          if (this._myUser.local.id.isEmpty) {
////            Update the user inherited
//            container.updateUser(_myUser);
//          } else {
////            Update the user and local inherited
//            container.updateUser(_myUser);
//            container.updateHolding(_myUser.holding);
//            container.updateLogin(_myUser.local);
//
//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => HomePage()));
//          }
//        } else {
//          Scaffold.of(context)
//              .showSnackBar(SnackBar(content: Text("User login failed!")));
//        }
//      });
//    }, onError: (error) {
//      setState(() => this._login = false);
//      Scaffold.of(context)
//          .showSnackBar(SnackBar(content: Text("Connection time-out!")));
//    }).catchError((error) {
//      print(error);
//
//      setState(() => this._login = false);
//      Scaffold.of(context)
//          .showSnackBar(SnackBar(content: Text("Error connection!")));
//    });
//  }

  /// Field for the user's Id
  Widget _idField() {
    return StreamBuilder(
      stream: bloc.id,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeId,
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
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
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
    return Container(
      height: 40.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Color(0xff212121),
        color: Color(0xff011e41),
        elevation: 7.0,
        child: GestureDetector(
          onTap: () {
            bloc.submit();
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
  }

  /// Streamer
  Widget _streamer(BuildContext context) {
    return StreamBuilder(
        stream: bloc.obsUser,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

          /// If we have a error in the snapshot
          if (snapshot.hasError) {
            Scaffold.of(context)
                .showSnackBar(new SnackBar(content: Text(snapshot.error)));
          }

          /// Handle streaming states
          switch (snapshot.connectionState) {
            case ConnectionState.none:
//              print('Select lot');
              break;
            case ConnectionState.waiting:
//              print('Awaiting bids...');
              break;
            case ConnectionState.active:
              print(snapshot.data.user);
              break;
            case ConnectionState.done:
//              print('\$${snapshot.data} (closed)');
              break;
          }

          /// Returning submit button
          return _submitButton(context);
        });
  }

  /// Function to build te body of the form (column).
  Widget _buildingColumn(BuildContext context) {
    Column formColumn = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _idField(),
        SizedBox(height: 20.0),
        _passwordField(),
        SizedBox(height: 5.0),
        _forgotInkWell(),
        SizedBox(height: 40.0),
      ],
    );

    if (_login) {
      formColumn.children.add(Container(
        height: 40.0,
        color: Colors.transparent,
        child: CircularProgressIndicator(),
      ));
    } else {
      formColumn.children.add(_streamer(context));
    }

    return formColumn;
  }
}
