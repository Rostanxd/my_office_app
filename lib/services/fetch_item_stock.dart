import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:my_office_th_app/factories/item_stock.dart' as fi;
import 'package:my_office_th_app/models/item_stock.dart' as mi;
import 'package:my_office_th_app/utils/connection.dart' as con;

Future<List<fi.ItemStock>> fetchItemStock(
    http.Client client, String itemId) async {

  final response = await client.post(con.Connection.host + '/rest/WsItemStock',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"date": "$itemId"}));

  //  Code generated for object sdt from genexus.
  var mapSdt = <Map>[];

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i = 0; i < mapResponse['SdtItemStock'].length; i++) {
    mapSdt.add(mapResponse['SdtItemStock'][i]);
  }

  var jsonSdt = json.encode(mapSdt);

  return compute(parseItemStock, jsonSdt);
}

Future<List<mi.ItemStock>> fetchModelItemStock(
    http.Client client, String itemId) async {

  List<mi.ItemStock> itemStockModel = new List<mi.ItemStock>();
  var response = await client.post(con.Connection.host + '/rest/WsItemStock',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"date": "$itemId"}));

  print(response.body);

  //  Code generated for object sdt from genexus.
  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i=0; i < mapResponse['SdtItemStock'].length; i++){
    itemStockModel.add(new mi.ItemStock(mapResponse['SdtItemStock'][i]['color'],
        mapResponse['SdtItemStock'][i]['size'],
        mapResponse['SdtItemStock'][i]['local'],
        mapResponse['SdtItemStock'][i]['others']));
  }

//  Dummy data
  if (itemStockModel == null) {
    itemStockModel.add(mi.ItemStock('Blue', '', '', ''));
    itemStockModel.add(mi.ItemStock('', 'Small', '8', '4'));
    itemStockModel.add(mi.ItemStock('', 'Medium', '2', '0'));
    itemStockModel.add(mi.ItemStock('', 'Large', '5', '3'));
    itemStockModel.add(mi.ItemStock('Total Blue', '', '15', '7'));
  }

  return itemStockModel;
}

List<fi.ItemStock> parseItemStock(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<fi.ItemStock>((json) => fi.ItemStock.fromJson(json)).toList();
}