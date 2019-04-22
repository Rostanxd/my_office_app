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

    print('fetchCustomerList >> $id $lastName $firstName');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmClientes',
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {"id": "$id", "lastName": "$lastName", "firstName": "$firstName"}));

    print('fetchCustomerList << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsClientes'] as List;

    /// Loading the list from the response
    _customerList = responseList.map((f) => Customer.fromJson((f))).toList();

    return _customerList;
  }

  Future<Customer> fetchCustomer(String id) async {
    print('fetchCustomer >> $id');
    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmClientes',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"id": "$id", "lastName": "", "firstName": ""}));

    print('fetchCustomer << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsClientes'] as List;

    /// Loading the list from the response
    return responseList.map((f) => Customer.fromJson((f))).toList()[0];
  }

  Future<String> updateCustomers(Customer _customer, String userId) async {
    List _customerList = new List();

    _customerList.add(_customer);

    /// Printing the json data
    print("updateCustomers >> ${json.encode({
      "SdtWsClientes": _customerList,
      "userId": "$userId"
    })}");

    final response = await _httpClient.post(
        Connection.host + '/rest/WsCrmClientePost',
        headers: {"Content-Type": "application/json"},
        body:
            json.encode({"SdtWsClientes": _customerList, "userId": "$userId"}));

    /// Printing response from the rest
    print("updateCustomers << ${response.body}");

    return response.body;
  }

  Future<CustomerLastSummary> fetchCustomerLastSummary(
      String holdingId, String customerId) async {
    print('fetchCustomerLastSummary >> ${json.encode({
      "holdingId": "$holdingId",
      "customerId": "$customerId"
    })}');

    final response = await _httpClient.post(
        Connection.host + '/rest/WsPvtClienteResumenUltCompra',
        headers: {"Content-Type": "application/json"},
        body: json
            .encode({"holdingId": "$holdingId", "customerId": "$customerId"}));

    print('fetchCustomerLastSummary << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsClienteUltCompra'] as List;

    /// Loading the list from the response
    return responseList
        .map((f) => CustomerLastSummary.fromJson((f)))
        .toList()[0];
  }
}
