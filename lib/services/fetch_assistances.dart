import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:my_office_th_app/factories/assistance.dart' as fa;
import 'package:my_office_th_app/models/assistance.dart' as ma;
import 'package:my_office_th_app/utils/connection.dart' as con;

Future<List<fa.Assistance>> fetchAssistances(
    http.Client client, String date, String employeeId) async {

  final response = await client.post(con.Connection.host + '/rest/WsAssistance',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"date": "$date", "employeeId": "$employeeId"}));

  //  Code generated for object sdt from genexus.
  var mapSdt = <Map>[];

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtAssistances'].length; i++) {
    mapSdt.add(mapResponse['SdtAssistances'][i]);
  }

  var jsonSdt = json.encode(mapSdt);

  return compute(parseAssistances, jsonSdt);
}

Future<ma.Assistance> fetchAnAssistance(
    http.Client client, String date, String employeeId) async {
  var assistance;
  var response = await http.post(con.Connection.host + '/rest/WsAssistance',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"date": "$date", "employeeId": "$employeeId"}));

  print(response.body);

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtAssistances'].length; i++) {
    assistance = ma.Assistance(
        mapResponse['SdtAssistances'][i]['day'],
        mapResponse['SdtAssistances'][i]['employeeId'],
        mapResponse['SdtAssistances'][i]['entryHour'],
        mapResponse['SdtAssistances'][i]['lunchOutHour'],
        mapResponse['SdtAssistances'][i]['lunchInHour'],
        mapResponse['SdtAssistances'][i]['exitHour'],
        mapResponse['SdtAssistances'][i]['entryMsg'],
        mapResponse['SdtAssistances'][i]['lunchOutMsg'],
        mapResponse['SdtAssistances'][i]['lunchInMsg'],
        mapResponse['SdtAssistances'][i]['exitMsg']);
  }

//  If we dont have data in this day.
  if (assistance == null) {
    assistance = ma.Assistance(
      date, employeeId, '00:00', '00:00', '00:00', '00:00',
      'No record.', 'No record.', 'No record.', 'No record.'
    );
  }

  return assistance;
}

List<fa.Assistance> parseAssistances(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<fa.Assistance>((json) => fa.Assistance.fromJson(json))
      .toList();
}
