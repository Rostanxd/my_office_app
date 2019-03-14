import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/utils/connection.dart';

class LocalApi {
  final _httpClient = new http.Client();

  Future<List<Local>> fetchLocals(String holdingId) async {
    List<Local> localList = new List<Local>();
    var response = await _httpClient.post(
        Connection.host + '/rest/WsManBodegas',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"HldCodigo": "$holdingId"}));

    print('fetchLocals >> ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsManBodegas'] as List;

    /// Loading the list from the response
    localList = responseList.map((l) {
      new Local(l['BodCodigo'], l['BodNombre']);
    }).toList();

    return localList;
  }
}
