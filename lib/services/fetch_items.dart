import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:my_office_th_app/factories/item.dart' as fi;
import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/utils/connection.dart' as con;


Future<List<fi.Item>> fetchItems(
    http.Client client, String itemId) async {

  final response = await client.post(con.Connection.host + '/rest/WsItem',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"itemId": "$itemId",}));

  //  Code generated for object sdt from genexus.
  var mapSdt = <Map>[];

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtItems'].length; i++) {
    mapSdt.add(mapResponse['SdtItems'][i]);
  }

  var jsonSdt = json.encode(mapSdt);

  return compute(parseItems, jsonSdt);
}

Future<mi.Item> fetchAnItem(
    http.Client client, String itemId) async {
  mi.Item item;
  var response = await http.post(con.Connection.host + '/rest/WsItem',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"date": "$itemId"}));

  print(response.body);

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtItem'].length; i++) {
    item = mi.Item(
        mapResponse['SdtItem'][i]['style'],
        mapResponse['SdtItem'][i]['styleName'],
        mapResponse['SdtItem'][i]['lineName'],
        mapResponse['SdtItem'][i]['productName'],
        mapResponse['SdtItem'][i]['seasonName'],
        mapResponse['SdtItem'][i]['priceIva'],
        mapResponse['SdtItem'][i]['priceNoIva'],
        mapResponse['SdtItem'][i]['imagePath'],
        mapResponse['SdtItem'][i]['rank']);
  }

//  If we don't have data in this day.
  if (item == null) {
    item = mi.Item(
        'TH CORE FLAG',
        'TH CORE FLAG',
        'ACCESORIES MEN',
        'CAMISETAS',
        'SPRING 2017',
        44.80,
        40.00,
        "https://www.gamepals.co/1467-thickbox_default/camiseta-tommy-hilfiger-color-blanco.jpg",
        3.60);
  }

  return item;
}

List<fi.Item> parseItems(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<fi.Item>((json) => fi.Item.fromJson(json))
      .toList();
}
