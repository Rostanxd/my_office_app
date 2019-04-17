import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/utils/connection.dart';

class TelemarketingApi {
  final _httpClient = http.Client();

  Future<List<Telemarketing>> fetchCustomerTelemarketing(
      String sellerId, String customerId) async {
    List<Telemarketing> _telemarketingList = List<Telemarketing>();

    print('fetchCustomerTelemarketing >> $sellerId $customerId');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmClienteTelemarketing',
        headers: {"Content-Type": "application/json"},
        body: json
            .encode({"sellerId": "$sellerId", "customerId": "$customerId"}));

    print('fetchCustomerTelemarketing << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsTelemarketing'] as List;

    /// Loading the list from the response
    _telemarketingList =
        responseList.map((f) => Telemarketing.fromJson((f))).toList();

    return _telemarketingList;
  }

  Future<String> postCustomerTelemarketing(Telemarketing _telemarketing) async {
    List<Telemarketing> _telemarketingList = List();
    _telemarketingList.add(_telemarketing);

    print('postCustomerTelemarketing >> ${json.encode({
      "SdtWsTelemarketing": _telemarketingList
    })}');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmTelemarketingPost',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"SdtWsTelemarketing": _telemarketingList}));

    print('postCustomerTelemarketing << ${response.body}');

    return response.body;
  }

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
    _customerAnniversaryList =
        responseList.map((f) => CustomerAnniversary.fromJson((f))).toList();

    return _customerAnniversaryList;
  }
}
