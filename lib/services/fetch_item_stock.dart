import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:my_office_th_app/factories/item_stock.dart' as fi;
import 'package:my_office_th_app/models/item_stock.dart' as mi;
import 'package:my_office_th_app/utils/connection.dart' as con;

Future<List<fi.ItemStock>> fetchItemStock(
    http.Client client, String itemId, String localId) async {

  final response = await client.post(con.Connection.host + '/rest/WsItemStock',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"itemId": "$itemId", "BodCodigo": "$localId"}));

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
    http.Client client, String itemId, String localId) async {

  List<mi.ItemStock> itemStockModel = new List<mi.ItemStock>();
  var response = await client.post(con.Connection.host + '/rest/WsItemStock',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"itemId": "$itemId", "BodCodigo": "$localId"}));

  print(response.body);

  //  Code generated for object sdt from genexus.
  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i=0; i < mapResponse['sdt_inv_estilos_app'].length; i++){
    itemStockModel.add(new mi.ItemStock(mapResponse['sdt_inv_estilos_app'][i]['Color'],
        mapResponse['sdt_inv_estilos_app'][i]['Talla'],
        int.parse(mapResponse['sdt_inv_estilos_app'][i]['StockLocal']),
        int.parse(mapResponse['sdt_inv_estilos_app'][i]['StockOtros'])));
  }

  return itemStockModel;
}

List<fi.ItemStock> parseItemStock(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<fi.ItemStock>((json) => fi.ItemStock.fromJson(json)).toList();
}