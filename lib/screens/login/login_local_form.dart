import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/holding.dart' as mh;
import 'package:my_office_th_app/models/local.dart' as ml;
import 'package:my_office_th_app/screens/home/index.dart';

import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';
import 'package:my_office_th_app/services/fetch_holdings.dart' as sh;
import 'package:my_office_th_app/services/fetch_locals.dart' as sl;
import 'package:my_office_th_app/utils/connection.dart';

class LoginLocalForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginLocalFormState();
  }
}

class _LoginLocalFormState extends State<LoginLocalForm> {
  mh.Holding _currentHolding;
  ml.Local _currentLocal;
  List<mh.Holding> _listHoldings = new List<mh.Holding>();
  List<ml.Local> _listLocals = new List<ml.Local>();
  List<DropdownMenuItem<mh.Holding>> _listDropDownHoldings =
      new List<DropdownMenuItem<mh.Holding>>();
  List<DropdownMenuItem<ml.Local>> _listDropDownLocals =
      new List<DropdownMenuItem<ml.Local>>();

//  Variables to keep showing the circular progress.
  bool _boolHolding = false;
  bool _boolLocals = false;

  void _getHoldings() {
    setState(() {
      this._boolHolding = true;
    });

    sh
        .fetchHoldings(http.Client())
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((result) {
      setState(() {
        this._boolHolding = false;

        for (mh.Holding h in result) {
          this._listHoldings.add(h);
        }

        for (var _hld in _listHoldings) {
          this._listDropDownHoldings.add(
              new DropdownMenuItem(value: _hld, child: new Text(_hld.name)));
        }

        _currentHolding = _listDropDownHoldings[0].value;
      });
    }, onError: (error) {
      print(error);
    }).catchError((error) {
      print(error);
    });
  }

  void _changeDropDownItemHolding(mh.Holding _holdingSelected) {
    setState(() {
      _currentHolding = _holdingSelected;
      _getLocals(_currentHolding.id);
    });
  }

  void _getLocals(String holdingId) {
    setState(() {
      this._boolLocals = true;
    });

    sl
        .fetchLocals(http.Client(), holdingId)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((result) {
      setState(() {
        this._boolLocals = false;

//        Updating the list variable for the holdings, and the dropdown
        _listLocals.clear();
        for (ml.Local l in result) {
          _listLocals.add(l);
        }

        _listDropDownLocals.clear();
        for (var _loc in this._listLocals) {
          this._listDropDownLocals.add(
              new DropdownMenuItem(value: _loc, child: new Text(_loc.name)));
        }

        _currentLocal = _listDropDownLocals[0].value;
      });
    }, onError: (error) {
      print(error);
    }).catchError((error) {
      print(error);
    });
  }

  void _changeDropDownItemLocal(ml.Local _localSelected) {
    setState(() {
      this._currentLocal = _localSelected;
    });
  }

  @override
  void initState() {
//    Loading DropdownMenuItem for holdings
    this._getHoldings();

//    Loading DropdownMenuItem for locals
    this._getLocals('0');
  }

  @override
  Widget build(BuildContext context) {
//    Getting data from the item sate container
    final container = LoginStateContainer.of(context);

    var _circularProgress = CircularProgressIndicator();

    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 20.0,
              left: 20.0,
            ),
            child: Text('Holding',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff011e41))),
          ),
          SizedBox(height: 10.0),
          Container(
            child: Center(
              child: _boolHolding
                  ? _circularProgress
                  : DropdownButton<mh.Holding>(
                      value: _currentHolding,
                      items: _listDropDownHoldings,
                      onChanged: (mh.Holding h) {
                        this._changeDropDownItemHolding(h);
                      },
                    ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 20.0),
            child: Text('Local',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff011e41))),
          ),
          SizedBox(height: 10.0),
          Container(
            child: Center(
              child: _boolLocals
                  ? _circularProgress
                  : DropdownButton<ml.Local>(
                      value: _currentLocal,
                      items: _listDropDownLocals,
                      onChanged: (ml.Local l) {
                        this._changeDropDownItemLocal(l);
                      },
                    ),
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Color(0xff212121),
              color: Color(0xff011e41),
              elevation: 7.0,
              child: GestureDetector(
                onTap: () {
                  container.updateHolding(this._currentHolding);
                  container.updateLogin(this._currentLocal);

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
          ),
          SizedBox(height: 20.0),
          Container(
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Color(0xff212121),
              color: Color(0xFFeb2227),
              elevation: 7.0,
              child: GestureDetector(
                onTap: () {
                  container.logOut();

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
          ),
        ],
      ),
    );
  }
}
