import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/holding.dart' as mh;
import 'package:my_office_th_app/models/local.dart' as ml;

import 'package:my_office_th_app/services/fetch_holdings.dart' as sh;
import 'package:my_office_th_app/services/fetch_locals.dart' as sl;

class LoginLocalForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginLocalFormState();
  }
}

class _LoginLocalFormState extends State<LoginLocalForm> {
  final _formKey = GlobalKey<FormState>();

  mh.Holding _currentHolding;
  ml.Local _currentLocal;
  List<mh.Holding> listHoldings = new List<mh.Holding>();
  List<ml.Local> listLocals = new List<ml.Local>();
  List<DropdownMenuItem<mh.Holding>> _listDropDownHoldings =
      new List<DropdownMenuItem<mh.Holding>>();
  List<DropdownMenuItem<ml.Local>> _listDropDownLocals =
      new List<DropdownMenuItem<ml.Local>>();

  void _getHoldings() {
    sh.fetchHoldings(http.Client()).timeout(Duration(seconds: 15)).then(
        (result) {
      print('_getHodlings >> ' + result.toString());
      setState(() {
        for (mh.Holding h in result) {
          this.listHoldings.add(h);
        }
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
    });
  }

  void _getLocals(String holdingId) {
    sl
        .fetchLocals(http.Client(), holdingId)
        .timeout(Duration(seconds: 15))
        .then((result) {
      setState(() {
//        TODO: updating the list variable for the holdings, and the dropdown
        for (ml.Local l in result) {
          listLocals.add(l);
        }
      });
    }, onError: (error) {
      print(error);
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    this._getHoldings();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButton<mh.Holding>(
      value: _currentHolding,
      items: _listDropDownHoldings,
      onChanged: (mh.Holding h) {
        _changeDropDownItemHolding(h);
      },
    );
  }
}
