import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/utils/connection.dart';

class TelemarketingApi {
  final _httpClient = http.Client();

  Future<TelemarketingEffectiveness> fetchTelemarketingEffectiveness(
      String localId, String sellerId) async {
    TelemarketingEffectiveness _telemarketingEffectiveness;

    print('fetchTelemarketingEffectiveness >> $localId $sellerId');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmEfectividadTelemarketing',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"localId": "$localId", "sellerId": "$sellerId"}));

    print('fetchTelemarketingEffectiveness << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsEfectividadTelemarketing'] as List;

    /// Loading the list from the response
    _telemarketingEffectiveness = responseList
        .map((f) => TelemarketingEffectiveness.fromJson((f)))
        .toList()[0];

    return _telemarketingEffectiveness;
  }

  Future<List<CustomerAnniversary>> fetchCustomerAnniversaries(
      String localId, String sellerId) async {
    List<CustomerAnniversary> _customerAnniversaryList;

    print('fetchCustomerAnniversaries >> $localId $sellerId');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmClientesAniversarios',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"localId": "$localId", "sellerId": "$sellerId"}));

    print('fetchCustomerAnniversaries << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsClientesAniversarios'] as List;

    /// Loading the list from the response
    _customerAnniversaryList = responseList
        .map((f) => CustomerAnniversary.fromJson((f)))
        .toList();

    return _customerAnniversaryList;
  }
}
