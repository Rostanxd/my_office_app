import 'package:flutter/material.dart';

import 'package:my_office_th_app/factories/assistance.dart';
import 'package:my_office_th_app/screens/home/assistance_card_hour.dart';

class ListAssistanceCard extends StatelessWidget {

  final List<Assistance> assistance;

  const ListAssistanceCard({Key key, this.assistance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemCount: assistance.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 20.0,
                    bottom: 10.0,
                  ),
                  child: Text('Assistance',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff011e41))),
                ),
                Row(
                  children: <Widget>[
                    AssistanceCardHour(
                        'assets/img/beach.jpeg',
                        'Entrance',
                        assistance[index].entryHour,
                        assistance[index].entryMsg),
                    AssistanceCardHour(
                        'assets/img/girl.jpg',
                        'Lunch-Out',
                        assistance[index].lunchOutHour,
                        assistance[index].lunchOutMsg),
                  ],
                ),
                Row(
                  children: <Widget>[
                    AssistanceCardHour(
                        'assets/img/mountain.jpeg',
                        'Lunch-In',
                        assistance[index].lunchInHour,
                        assistance[index].lunchInMsg),
                    AssistanceCardHour(
                        'assets/img/people.jpg',
                        'Exit',
                        assistance[index].exitHour,
                        assistance[index].exitMsg),
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
                          /*Navigator.pushNamed(context, '/signup');*/
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
