import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/screens/home/assistance_card_hour.dart';

class AssistanceCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AssistanceCardState();
  }
}

class _AssistanceCardState extends State<AssistanceCard> {
  final _bloc = HomeBloc();
  DateTime _now = new DateTime.now();
  DateFormat formatter = new DateFormat('yyyy-MM-dd');

  ///  Future to show the date picker
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _now,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));

    if (picked != null) {
      _bloc.changeDateToFind(formatter.format(picked).toString());
      _bloc.fetchAssistance('0915157473');
    }
  }

  @override
  void initState() {
    _bloc.changeDateToFind(formatter.format(_now).toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Getting the assistance
    _bloc.fetchAssistance('0915157473');

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              _cardHeader(),
              Divider(),
              _cardBody(),
            ],
          )),
    );
  }

  Widget _cardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(top: 20.0, left: 20.0, bottom: 10.0, right: 20.0),
          child: Text('Asistencia',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff011e41))),
        ),
        StreamBuilder(
            stream: _bloc.dateToFind,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return snapshot.hasData
                  ? Container(
                      margin: EdgeInsets.only(
                          top: 20.0, left: 10.0, bottom: 10.0, right: 20.0),
                      child: Text(snapshot.data,
                          style: TextStyle(
                              fontSize: 18.0, color: Color(0xff011e41))),
                    )
                  : Text('No hay datos');
            }),
        Container(
          margin:
              EdgeInsets.only(top: 20.0, left: 20.0, bottom: 10.0, right: 20.0),
          child: InkWell(
            child: Icon(Icons.search),
            onTap: () {
              _selectDate();
            },
          ),
        )
      ],
    );
  }

  Widget _cardBody() {
    return StreamBuilder(
      stream: _bloc.allAssistance,
      builder: (BuildContext context, AsyncSnapshot<Assistance> snapshot) {
        if (snapshot.hasError) {
          return Container(
              margin: EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
              ),
              height: 40.0,
              child: Text(snapshot.error));
        }
        return snapshot.hasData
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      AssistanceCardHour('assets/img/entrance.jpg', 'Entrada',
                          snapshot.data.entryHour, snapshot.data.entryMsg),
                      AssistanceCardHour(
                          'assets/img/lunch_out.jpg',
                          'Lunch-Out',
                          snapshot.data.lunchOutHour,
                          snapshot.data.lunchOutMsg),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      AssistanceCardHour('assets/img/lunch_in.jpg', 'Lunch-In',
                          snapshot.data.lunchInHour, snapshot.data.lunchInMsg),
                      AssistanceCardHour('assets/img/exit.jpg', 'Salida',
                          snapshot.data.exitHour, snapshot.data.exitMsg),
                    ],
                  ),
                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text(
                            'JUSTIFICAR',
                            style: TextStyle(
                              color: Color(0xFFeb2227),
                            ),
                          ),
                          onPressed: () {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('En desarrollo!')));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                ),
                height: 40.0,
                child: CircularProgressIndicator());
      },
    );
  }
}
