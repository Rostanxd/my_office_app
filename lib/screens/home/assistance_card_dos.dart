import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_office_th_app/models/assistance.dart' as ma;
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

  //  Variables
  ma.Assistance _assistance;
  String _dateToFind;
  TextEditingController _dateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    if (_dateController.text != '') {
      _dateToFind = _dateController.text.toString();
    } else {
      _dateToFind = '2019-02-15';
    }

    // TODO: implement build
    return Card(
        elevation: 5.0,
        child: Column(
          children: <Widget>[
            Form(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 30.0,
                      left: 20.0,
                      bottom: 10.0,
                    ),
                    child: Text('Assistance',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff011e41))),
                  ),
                  Container(
                    width: 150.0,
                    margin: EdgeInsets.only(
                      top: 10.0,
                      left: 50.0,
                      bottom: 10.0,
                    ),
                    child: DateTimePickerFormField(
                      inputType: InputType.date,
                      format: DateFormat('yyyy-MM-dd'),
                      editable: false,
                      decoration: InputDecoration(
                          labelText: 'Date/Time', hasFloatingPlaceholder: false),
                      onChanged: (dt) =>
                          setState(() => this._dateToFind = dt.toString()),
                      controller: _dateController,
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: fetchAnAssistance(
                  http.Client(), this._dateToFind, '0915157473'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.data == null) {
                  return Container(
                      height: 40.0, child: CircularProgressIndicator());
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
                                  /*Navigator.pushNamed(context, '/picker');*/
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
        ));
  }
}
