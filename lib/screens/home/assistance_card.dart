import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:intl/intl.dart';

import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/assistance.dart' as ma;
import 'package:my_office_th_app/services/fetch_assistances.dart';
import 'package:my_office_th_app/screens/home/assistance_card_hour.dart';

class AssistanceCard extends StatelessWidget {
  ma.Assistance assistance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final formats = {
      InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
      InputType.date: DateFormat('yyyy-MM-dd'),
      InputType.time: DateFormat("HH:mm"),
    };

    // Changeable in demo
    InputType inputType = InputType.both;

    return FutureBuilder(
      future: fetchAnAssistance(http.Client(), '2019-02-12', '0915157473'),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.data == null) {
          return CardDummyLoading();
        } else {
          if (snapshot.hasData) {
//            Update the Assistance in my class.
            this.assistance = snapshot.data;

//            Returning the card.
            return Card(
              elevation: 5.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: 20.0,
                          left: 20.0,
                          bottom: 10.0,
                        ),
                        child: Text('Assistance',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff011e41))),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      AssistanceCardHour('assets/img/beach.jpeg', 'Entrance',
                          assistance.entryHour, assistance.entryMsg),
                      AssistanceCardHour('assets/img/girl.jpg', 'Lunch-Out',
                          assistance.lunchOutHour, assistance.lunchOutMsg),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      AssistanceCardHour('assets/img/mountain.jpeg', 'Lunch-In',
                          assistance.lunchInHour, assistance.lunchInMsg),
                      AssistanceCardHour('assets/img/people.jpg', 'Exit',
                          assistance.exitHour, assistance.exitMsg),
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
                            Navigator.pushNamed(context, '/picker');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CardDummyLoading();
          }
        }
      },
    );
  }
}
