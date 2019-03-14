import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_office_th_app/models/assistance.dart' as ma;
import 'package:my_office_th_app/models/assistance_type.dart' as mt;
import 'package:my_office_th_app/services/fetch_assistances.dart';
import 'package:my_office_th_app/screens/home/assistance_card_hour.dart';

class AssistanceCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AssistanceCardState();
  }
}

class _AssistanceCardState extends State<AssistanceCard> {
  final _formKey = GlobalKey<FormState>();

  //  Variables
  DateTime _now = new DateTime.now();
  DateFormat formatter = new DateFormat('yyyy-MM-dd');
  ma.Assistance _assistance;
  mt.AssistanceType _currentAssistanceType;
  String _dateToFind, _futureDate, _assistanceReclaim;
  TextEditingController _reclaimController = new TextEditingController();
  List<DropdownMenuItem<mt.AssistanceType>> _listDropDownMenuItems =
      new List<DropdownMenuItem<mt.AssistanceType>>();
  List<mt.AssistanceType> _listAssistanceTypes = new List<mt.AssistanceType>();

//  Loading data into the dropdown menu item.
  void _changeDropDownItems(mt.AssistanceType _assistanceTypeSelected) {
    setState(() {
      _currentAssistanceType = _assistanceTypeSelected;
      print('_changeDropDownItems: ' + _currentAssistanceType.name);
    });
  }

//  Posting reclaim to the server.
  void _putReclaim() {
    setState(() {
      _assistanceReclaim = _reclaimController.text;

//      After posting the request
      _currentAssistanceType = _listAssistanceTypes[0];
      _assistanceReclaim = "";
      _reclaimController.value = TextEditingValue(text: '');
    });
  }

//  Future to show the date picker
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _now,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));

    if (picked != null) {
      setState(() {
        _futureDate = formatter.format(picked);
      });
    }
  }

//  Future to call dialog assistance
  Future _reclaimAssistanceHour() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Reclaiming"),
            contentPadding: EdgeInsets.all(25.0),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Container(
                  height: 280.0,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Assistance:',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.0),
                            child: Center(
                              child: DropdownButton<mt.AssistanceType>(
                                value: _currentAssistanceType,
                                items: _listDropDownMenuItems,
                                onChanged: (mt.AssistanceType a) {
                                  _changeDropDownItems(a);
                                  Navigator.pop(context);
                                  _reclaimAssistanceHour();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            labelText: 'Explain please...',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff011e41)))),
                        validator: (val) => val.isEmpty
                            ? "You can't send a reclaim with out a detail."
                            : null,
                        controller: _reclaimController,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate() && _currentAssistanceType.value != '0') {
                              Navigator.pop(context);
                              _putReclaim();
                            }
                          },
                          child: Text('Accept'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _listAssistanceTypes.add(new mt.AssistanceType('0', 'Select...'));
    _listAssistanceTypes.add(new mt.AssistanceType('1', 'Entrance'));
    _listAssistanceTypes.add(new mt.AssistanceType('2', 'Lunch-Out'));
    _listAssistanceTypes.add(new mt.AssistanceType('3', 'Lunch-In'));
    _listAssistanceTypes.add(new mt.AssistanceType('4', 'Exit'));

    for (var _ast in _listAssistanceTypes) {
      _listDropDownMenuItems.add(new DropdownMenuItem(
        value: _ast,
        child: new Text(_ast.name),
      ));
    }

    _currentAssistanceType = _listDropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    if (_futureDate != null) {
      _dateToFind = _futureDate;
    } else {
      _dateToFind = formatter.format(_now);
    }

    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Form(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(top: 20.0, left: 20.0, bottom: 10.0),
                      child: Text('Assistance',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff011e41))),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0),
                      child: Text(_dateToFind,
                          style: TextStyle(
                              fontSize: 18.0, color: Color(0xff011e41))),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0),
                      child: RaisedButton(
                        onPressed: _selectDate,
                        child: Text('Search'),
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder(
//                future: fetchDateAssistance(
//                    http.Client(), this._dateToFind, '0915157473'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.data == null) {
                    return Container(
                        margin: EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                        ),
                        height: 40.0,
                        child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasData) {
//                    Update the assitance
                      this._assistance = snapshot.data;

//                    Returning de column
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 15.0),
                          Row(
                            children: <Widget>[
                              AssistanceCardHour(
                                  'assets/img/beach.jpeg',
                                  'Entrance',
                                  _assistance.entryHour,
                                  _assistance.entryMsg),
                              AssistanceCardHour(
                                  'assets/img/girl.jpg',
                                  'Lunch-Out',
                                  _assistance.lunchOutHour,
                                  _assistance.lunchOutMsg),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              AssistanceCardHour(
                                  'assets/img/mountain.jpeg',
                                  'Lunch-In',
                                  _assistance.lunchInHour,
                                  _assistance.lunchInMsg),
                              AssistanceCardHour('assets/img/people.jpg', 'Exit',
                                  _assistance.exitHour, _assistance.exitMsg),
                            ],
                          ),
                          ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text(
                                    'RECLAIM',
                                    style: TextStyle(
                                      color: Color(0xFFeb2227),
                                    ),
                                  ),
                                  onPressed: () {
                                    _reclaimAssistanceHour();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          )),
    );
  }
}
