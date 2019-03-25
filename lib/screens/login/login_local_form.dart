import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';

import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/screens/home/index.dart';

import 'package:my_office_th_app/screens/login/index.dart';

class LoginLocalForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginLocalFormState();
  }
}

class _LoginLocalFormState extends State<LoginLocalForm> {
  LoginBloc bloc;
  List<DropdownMenuItem<Holding>> _listDropDownHoldings =
      new List<DropdownMenuItem<Holding>>();
  List<DropdownMenuItem<Local>> _listDropDownLocals =
      new List<DropdownMenuItem<Local>>();

  void _updateDropdownListHolding(List<Holding> _holdingList) {
    _listDropDownHoldings.clear();
    _listDropDownHoldings = _holdingList
        .map((h) => DropdownMenuItem(value: h, child: Text(h.name)))
        .toList();
  }

  void _updateDropdownListLocal(List<Local> _localList) {
    _listDropDownLocals.clear();
    _listDropDownLocals = _localList
        .map((l) => DropdownMenuItem(value: l, child: Text(l.name)))
        .toList();
  }

  /// Function to be called from the holding dropdown to change its current value
  void _changeDropDownItemHolding(Holding _holdingSelected) {
    bloc.fetchLocal(_holdingSelected.id);
    bloc.changeCurrentHolding(_holdingSelected);
  }

  /// Function to be called from the local dropdown to change its current value
  void _changeDropDownItemLocal(Local _localSelected) {
    bloc.changeCurrentLocal(_localSelected);
  }

  @override
  // ignore: must_call_super
  void initState() {}

  @override
  Widget build(BuildContext context) {
    /// Getting data from the login state container
    bloc = BlocProvider.of<LoginBloc>(context);

    /// Loading DropdownMenuItem for holdings
    bloc.fetchAllHolding();

    /// Loading DropdownMenuItem for locals
    bloc.fetchLocal('0');

    /// Listener to update the holding dropdown
    bloc.holdingList.listen((data) {
      _updateDropdownListHolding(data);
    });

    /// Listener to update the local dropdown
    bloc.localList.listen((data) {
      _updateDropdownListLocal(data);
    });

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
        stream: bloc.holding,
        builder: (BuildContext context, AsyncSnapshot<Holding> snapshot) {
          return Container(
            child: Center(
                child: snapshot.hasData
                    ? StreamBuilder(
                        stream: bloc.holdingList,
                        initialData: bloc.holdingList.value,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Holding>> holdingListSnapshot) {
                          return holdingListSnapshot.hasData
                              ? DropdownButton<Holding>(
                                  value: snapshot.data,
                                  items: _listDropDownHoldings,
                                  onChanged: (Holding h) {
                                    _changeDropDownItemHolding(h);
                                  },
                                )
                              : CircularProgressIndicator();
                        },
                      )
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      )),
          );
        });
  }

  Widget _localDropDown() {
    return StreamBuilder(
        stream: bloc.local,
        builder: (BuildContext context, AsyncSnapshot<Local> snapshot) {
          return Container(
            child: Center(
              child: snapshot.hasData
                  ? StreamBuilder(
                      stream: bloc.localList,
                      initialData: bloc.localList.value,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Local>> localListSnapshot) {
                        return localListSnapshot.hasData
                            ? DropdownButton<Local>(
                                value: snapshot.data,
                                items: _listDropDownLocals,
                                onChanged: (Local l) {
                                  _changeDropDownItemLocal(l);
                                },
                              )
                            : CircularProgressIndicator();
                      },
                    )
                  : CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
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
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => BlocProvider<HomeBloc>(
                  bloc: HomeBloc(),
                  child: HomePage(),
                )),
                (Route<dynamic> route) => false);
          },
          child: Center(
            child: Text(
              'CONTINUAR',
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
            bloc.logOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyLoginPage()),
                (Route<dynamic> route) => false);
          },
          child: Center(
            child: Text(
              'CANCELAR',
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
