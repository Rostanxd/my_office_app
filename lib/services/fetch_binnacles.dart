import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/binnacle.dart';
import 'package:my_office_th_app/utils/connection.dart';

class BinnacleApi {
  final _httpClient = http.Client();

  Future<String> postBinnacle(Binnacle _binnacle) async {
    List _binnacleList = new List();
    _binnacleList.add(_binnacle);

    /// Printing the json data
    print("postBinnacle >> ${json.encode({"SdtWsBitacora": _binnacleList})}");

    final response = await _httpClient.post(
        Connection.host + '/rest/WsManBitacoraPost',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"SdtWsBitacora": _binnacleList}));

    /// Printing response from the post
    print("postBinnacle << ${response.body}");

    return response.body;
  }
}
