import 'dart:async';

import 'package:intl/intl.dart';

class HomeValidator {
  static DateTime _now = new DateTime.now();
  static DateFormat formatter = new DateFormat('yyyy-MM-dd');

  final validateDate = StreamTransformer<String, String>.fromHandlers(
      handleData: (date, sink) {
    if (date != null) {
      sink.add(date);
    } else {
      sink.add(_now.toString());
    }
  });
}
