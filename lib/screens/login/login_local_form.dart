import 'package:flutter/material.dart';

import 'package:my_office_th_app/blocs/login_local_bloc.dart';

import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/screens/home/index.dart';

import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';

class LoginLocalForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginLocalFormState();
  }
}

class _LoginLocalFormState extends State<LoginLocalForm> {
  Holding _currentHolding;
  Local _currentLocal;
  List<DropdownMenuItem<Holding>> _listDropDownHoldings =
      new List<DropdownMenuItem<Holding>>();
  List<DropdownMenuItem<Local>> _listDropDownLocals =
      new List<DropdownMenuItem<Local>>();

  /// Function to be called from the holding dropdown to change its current value
  void _changeDropDownItemHolding(Holding _holdingSelected) {
    setState(() {
      _currentHolding = _holdingSelected;
      loginLocalBloc.fetchLocal(_currentHolding.id);
    });
  }

  /// Function to be called from the local dropdown to change its current value
  void _changeDropDownItemLocal(Local _localSelected) {
    setState(() {
      this._currentLocal = _localSelected;
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    /// Loading DropdownMenuItem for holdings
    loginLocalBloc.fetchAllHolding();

    /// Loading DropdownMenuItem for locals
    loginLocalBloc.fetchLocal('0');
  }

  @override
  Widget build(BuildContext context) {
    /// Getting data from the login state container
    final container = LoginStateContainer.of(context);

    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _optionTitleText('Holding'),
          SizedBox(height: 10.0),
          _holdingDropDown(),
          _optionTitleText('Local'),
          SizedBox(height: 10.0),
          _localDropDown(),
          SizedBox(height: 40.0),
          _continueButton(),
          SizedBox(height: 20.0),
          _cancelButton(),
        ],
      ),
    );
  }

  @override
  // ignore: must_call_super
  void dispose() {
    loginLocalBloc.dispose();
  }

  Widget _optionTitleText(String title) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff011e41))),
    );
  }

  Widget _holdingDropDown() {
    return StreamBuilder(
        stream: loginLocalBloc.obsHoldingList,
        builder: (BuildContext context,
            AsyncSnapshot<List<Holding>> holdingSnapshot) {
          return Container(
            child: Center(
                child: holdingSnapshot.hasData
                    ? DropdownButton<Holding>(
                        value: _currentHolding,
                        items: _listDropDownHoldings,
                        onChanged: (Holding h) {
                          _changeDropDownItemHolding(h);
                        })
                    : CircularProgressIndicator()),
          );
        });
  }

  Widget _localDropDown() {
    return StreamBuilder(
        stream: loginLocalBloc.obsLocalList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Local>> localSnapshot) {
          return Container(
            child: Center(
              child: localSnapshot.hasData
                  ? DropdownButton<Local>(
                      value: _currentLocal,
                      items: _listDropDownLocals,
                      onChanged: (Local l) {
                        _changeDropDownItemLocal(l);
                      },
                    )
                  : CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _continueButton() {
    return Container(
      height: 40.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Color(0xff212121),
        color: Color(0xff011e41),
        elevation: 7.0,
        child: GestureDetector(
          onTap: () {
//            container.updateHolding(this._currentHolding);
//            container.updateLogin(this._currentLocal);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          },
          child: Center(
            child: Text(
              'CONTINUE',
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

  Widget _cancelButton() {
    return Container(
      height: 40.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Color(0xff212121),
        color: Color(0xFFeb2227),
        elevation: 7.0,
        child: GestureDetector(
          onTap: () {
//            container.logOut();

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyLoginPage()),
                (Route<dynamic> route) => false);
          },
          child: Center(
            child: Text(
              'CANCEL',
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
}
