import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/utils/connection.dart';

class AssistanceApi {
  final _httpClient = http.Client();

  Future<Assistance> fetchDateAssistance(String date, String employeeId) async {
    Assistance assistance;
    var response = await _httpClient.post(
        Connection.host + '/rest/WsAssistance',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"date": "$date", "employeeId": "$employeeId"}));

    print('fetchDateAssistance >> ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Loading assistance from the response
    assistance = Assistance(
        gxResponse['SdtAssistances'][0]['day'],
        gxResponse['SdtAssistances'][0]['employeeId'],
        gxResponse['SdtAssistances'][0]['entryHour'],
        gxResponse['SdtAssistances'][0]['lunchOutHour'],
        gxResponse['SdtAssistances'][0]['lunchInHour'],
        gxResponse['SdtAssistances'][0]['exitHour'],
        gxResponse['SdtAssistances'][0]['entryMsg'],
        gxResponse['SdtAssistances'][0]['lunchOutMsg'],
        gxResponse['SdtAssistances'][0]['lunchInMsg'],
        gxResponse['SdtAssistances'][0]['exitMsg']);

    return assistance;
  }
}
