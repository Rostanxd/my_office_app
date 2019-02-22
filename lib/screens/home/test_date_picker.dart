import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

const appName = 'DateTimePickerFormField Example';

class TestDatePicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestDatePickerState();
  }

}

class _TestDatePickerState extends State<TestDatePicker> {

  // Show some different formats.
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text(appName)),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Text('Format: "${formats[inputType].pattern}"'),

              //
              // The widget.
              //
              DateTimePickerFormField(
                inputType: inputType,
                format: formats[inputType],
                editable: editable,
                decoration: InputDecoration(
                    labelText: 'Date/Time', hasFloatingPlaceholder: false),
                onChanged: (dt) => setState(() => date = dt),
              ),

              Text('Date value: $date'),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Date picker'),
                value: inputType != InputType.time,
                onChanged: (value) => updateInputType(date: value),
              ),
              CheckboxListTile(
                title: Text('Time picker'),
                value: inputType != InputType.date,
                onChanged: (value) => updateInputType(time: value),
              ),
              CheckboxListTile(
                title: Text('Editable'),
                value: editable,
                onChanged: (value) => setState(() => editable = value),
              ),
            ],
          ),
        ));
  }

  void updateInputType({bool date, bool time}) {
    date = date ?? inputType != InputType.time;
    time = time ?? inputType != InputType.date;
    setState(() => inputType =
    date ? time ? InputType.both : InputType.date : InputType.time);
  }

}