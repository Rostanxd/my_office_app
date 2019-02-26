import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/local.dart' as ml;
import 'package:my_office_th_app/utils/connection.dart' as con;

Future<List<ml.Local>> fetchLocals(http.Client client,
    String holdingId) async {
  List<ml.Local> listLocals = new List<ml.Local>();
  var response = await http.post(con.Connection.host + '/rest/WsManBodegas',
      headers: {"Content-Type": "application/json"},
      body: {"HldCodigo": holdingId});

  print(response.body);

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtWsManBodegas'].length; i++) {
    listLocals.add(new ml.Local(
        mapResponse['SdtWsManBodegas'][i]['BodCodigo'],
        mapResponse['SdtWsManBodegas'][i]['BodNombre']));
  }

  return listLocals;
}