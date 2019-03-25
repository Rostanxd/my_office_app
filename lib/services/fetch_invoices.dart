import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/invoice.dart';
import 'package:my_office_th_app/utils/connection.dart';

class InvoiceApi {
  final _httpClient = http.Client();

  Future<List<Invoice>> fetchInvoices(String localId, String sellerId,
      String initDate, String finalDate) async {
    List<Invoice> _invoiceList = List<Invoice>();

    print('fetchInvoices >> $localId $sellerId $initDate $finalDate');
    final response =
        await _httpClient.post(Connection.host + '/rest/WsInvoices',
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "localId": "$localId",
              "sellerId": "$sellerId",
              "initDate": "$initDate",
              "finalDate": "$finalDate"
            }));
    print('fetchInvoices << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtInvoice'] as List;

    /// Loading the list from the response
    _invoiceList = responseList.map((f) => Invoice.fromJson((f))).toList();

    return _invoiceList;
  }
}
