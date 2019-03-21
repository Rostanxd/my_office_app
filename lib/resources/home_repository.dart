import 'dart:async';

import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/services/fetch_assistances.dart';

class HomeRepository {
  final AssistanceApi assistanceApi = AssistanceApi();

  Future<Assistance> fetchDateAssistance(String date, String employeeId) =>
      assistanceApi.fetchDateAssistance(date, employeeId);
}
