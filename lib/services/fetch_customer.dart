import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/utils/connection.dart';

class CustomerApi {
  final _httpClient = http.Client();

  Future<List<Customer>> fetchCustomerList(
      String id, String lastName, String firstName) async {
    List<Customer> _customerList;

    print('fetchCustomer >> $id $lastName $firstName');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmClientes',
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {"id": "$id", "lastName": "$lastName", "firstName": "$firstName"}));

    print('fetchCustomer << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsClientes'] as List;

    /// Loading the list from the response
    _customerList = responseList.map((f) => Customer.fromJson((f))).toList();

    return _customerList;
  }
}
