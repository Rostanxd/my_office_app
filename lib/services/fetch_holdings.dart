import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/utils/connection.dart';

class HoldingApi {
  final _httpClient = http.Client();

  Future<List<Holding>> fetchAllHoldings() async {
    List<Holding> holdingList = new List<Holding>();
    var response = await _httpClient.post(Connection.host + '/rest/WsManHoldings',
        headers: {"Content-Type": "application/json"});

    print('fetchAllHoldings >> ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsManHoldings'] as List;

    /// Loading the list from the response
    responseList.map((l) {
      holdingList.add(Holding(l['HldCodigo'], l['HldNombre']));
    }).toList();

    return holdingList;
  }
}