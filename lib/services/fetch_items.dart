import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/utils/connection.dart';

class ItemApi {
  final _httpClient = http.Client();

  Future<List<Item>> fetchItems(String itemId, String styleId) async {
    List<Item> itemList = new List<Item>();
    final response = await _httpClient.post(Connection.host + '/rest/WsItem',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"itemId": "$itemId", "styleId": "$styleId"}));

    print('fetchItems >> ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsManBodegas'] as List;

    /// Loading the list from the response
    itemList = responseList.map((l) => Item.fromJson(l)).toList();

    return itemList;
  }

  Future<List<Item>> fetchStyles(String styleId) async {
    List<Item> itemList = new List<Item>();
    final response = await _httpClient.post(Connection.host + '/rest/WsEstilo',
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "styleId": "$styleId",
        }));

    print('fetchStyles >> ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsManBodegas'] as List;

    /// Loading the list from the response
    itemList = responseList.map((l) => Item.fromJson(l)).toList();

    return itemList;
  }

  Future<Item> fetchItem(String itemId, String styleId) async {
    Item item;
    final response = await _httpClient.post(Connection.host + '/rest/WsItem',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"itemId": "$itemId", "styleId": "$styleId"}));

    print('fetchItem >> ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    item = Item(
        gxResponse['SdtItems'][0]['itemId'],
        gxResponse['SdtItems'][0]['styleId'],
        gxResponse['SdtItems'][0]['styleName'],
        gxResponse['SdtItems'][0]['lineName'],
        gxResponse['SdtItems'][0]['productName'],
        gxResponse['SdtItems'][0]['seasonName'],
        gxResponse['SdtItems'][0]['priceIva'],
        gxResponse['SdtItems'][0]['priceNoIva'],
        gxResponse['SdtItems'][0]['imagePath'],
        gxResponse['SdtItems'][0]['listImagesPath'].cast<String>(),
        gxResponse['SdtItems'][0]['rank']);

    return item;
  }
}
