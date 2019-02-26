import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/holding.dart' as mh;
import 'package:my_office_th_app/utils/connection.dart' as con;

//TODO: Return a future list of holdings
Future<List<mh.Holding>> fetchHoldings(http.Client client) async {
  List<mh.Holding> listHoldings = new List<mh.Holding>();
  var response = await http.post(con.Connection.host + '/rest/WsManHoldings',
      headers: {"Content-Type": "application/json"});

  print(response.body);

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtWsManHoldings'].length; i++) {
    listHoldings.add(new mh.Holding(
        mapResponse['SdtWsManHoldings'][i]['HldCodigo'],
        mapResponse['SdtWsManHoldings'][i]['HldNombre']));
  }

  return listHoldings;
}
