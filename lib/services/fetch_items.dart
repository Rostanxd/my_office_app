import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:my_office_th_app/factories/item.dart' as fi;
import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/utils/connection.dart' as con;

Future<List<fi.Item>> fetchItems(http.Client client, String itemId, String styleId) async {
  final response = await client.post(con.Connection.host + '/rest/WsItem',
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "itemId": "$itemId",
        "styleId": "$styleId"
      }));

  print(response.body);

  //  Code generated for object sdt from genexus.
  var mapSdt = <Map>[];

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtItems'].length; i++) {
    mapSdt.add(mapResponse['SdtItems'][i]);
  }

  var jsonSdt = json.encode(mapSdt);

  return compute(parseItems, jsonSdt);
}

Future<List<mi.Item>> fetchItemsModel (http.Client client, String itemId, String styleId) async {
  final response = await client.post(con.Connection.host + '/rest/WsItem',
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "itemId": "$itemId",
        "styleId": "$styleId"
      }));

  List<mi.Item> listItem = new List<mi.Item>();

  print('fetchItemsModel >> ' + response.body);

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtItems'].length; i++) {
    listItem.add(new mi.Item(
        mapResponse['SdtItems'][i]['itemId'],
        mapResponse['SdtItems'][i]['styleId'],
        mapResponse['SdtItems'][i]['styleName'],
        mapResponse['SdtItems'][i]['lineName'],
        mapResponse['SdtItems'][i]['productName'],
        mapResponse['SdtItems'][i]['seasonName'],
        mapResponse['SdtItems'][i]['priceIva'],
        mapResponse['SdtItems'][i]['priceNoIva'],
        mapResponse['SdtItems'][i]['imagePath'],
        mapResponse['SdtItems'][i]['listImagesPath'].cast<String>(),
        mapResponse['SdtItems'][i]['rank']));
  }

  return listItem;
}

Future<List<fi.Item>> fetchStyles(http.Client client, String styleId) async {
  final response = await client.post(con.Connection.host + '/rest/WsEstilo',
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "styleId": "$styleId",
      }));

  print(response.body);

  //  Code generated for object sdt from genexus.
  var mapSdt = <Map>[];

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtItems'].length; i++) {
    mapSdt.add(mapResponse['SdtItems'][i]);
  }

  var jsonSdt = json.encode(mapSdt);

  return compute(parseItems, jsonSdt);
}

Future<mi.Item> fetchAnItem(http.Client client, String itemId, String styleId) async {
  mi.Item item;
  var response = await http.post(con.Connection.host + '/rest/WsItem',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"itemId": "$itemId", "styleId": "$styleId"}));

  print(response.body);

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtItems'].length; i++) {
    item = mi.Item(
        mapResponse['SdtItems'][i]['itemId'],
        mapResponse['SdtItems'][i]['styleId'],
        mapResponse['SdtItems'][i]['styleName'],
        mapResponse['SdtItems'][i]['lineName'],
        mapResponse['SdtItems'][i]['productName'],
        mapResponse['SdtItems'][i]['seasonName'],
        mapResponse['SdtItems'][i]['priceIva'],
        mapResponse['SdtItems'][i]['priceNoIva'],
        mapResponse['SdtItems'][i]['imagePath'],
        mapResponse['SdtItems'][i]['listImagesPath'].cast<String>(),
        mapResponse['SdtItems'][i]['rank']);
  }

  return item;
}

List<fi.Item> parseItems(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<fi.Item>((json) => fi.Item.fromJson(json)).toList();
}