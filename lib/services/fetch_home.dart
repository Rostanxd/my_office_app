import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/card_info.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:my_office_th_app/models/personCounter.dart';

class HomeApi {
  final _httpClient = http.Client();

  Future<CardInfo> fetchCardInfo(
      String localId, String sellerId, String type) async {
    CardInfo _cardInfo;

    print('fetchCardInfo >> $localId $sellerId $type');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsPvtCartaInformacion',
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {"localId": "$localId", "sellerId": "$sellerId", "type": "$type"}));

    print('fetchCardInfo << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtCardInfo'] as List;

    /// Loading the list from the response
    _cardInfo = responseList.map((f) => CardInfo.fromJson((f))).toList()[0];

    return _cardInfo;
  }

  Future<PersonCounter> postCustomerCounter(String userId, String deviceId,
      String localId, String sellerId) async {

    final response = await _httpClient.post(
        Connection.host + '/rest/WsPvtClienteAtendidoPost',
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": "$userId",
          "deviceId": "$deviceId",
          "localId": "$localId",
          "sellerId": "$sellerId",
        }));

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    return PersonCounter.fromJson(gxResponse);
  }
}
