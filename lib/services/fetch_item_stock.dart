import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/item_stock.dart';
import 'package:my_office_th_app/utils/connection.dart';

class ItemStockApi {
  final _httpClient = http.Client();

  Future<List<ItemStock>> fetchItemStock(
      String itemId, String localId, String type) async {
    List<ItemStock> itemStockList = new List<ItemStock>();
    var response = await _httpClient.post(Connection.host + '/rest/WsItemStock',
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {"itemId": "$itemId", "BodCodigo": "$localId", "type": "$type"}));

    print('fetchItems >> ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsManBodegas'] as List;

    /// Loading the list from the response
    itemStockList = responseList.map((l) {
      new ItemStock(l['color'], l['Talla'], l['StockLocal'], l['StockOtros'],
          l['ItmCodigo']);
    }).toList();

    return itemStockList;
  }
}
