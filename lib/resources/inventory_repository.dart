import 'dart:async';

import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/models/item_stock.dart';
import 'package:my_office_th_app/services/fetch_items.dart';

class InventoryRepository {
  final itemApi = ItemApi();

  Future<List<Item>> fetchItems(String itemId, String styleId) =>
      itemApi.fetchItems(itemId, styleId);

  Future<List<Item>> fetchStyles(String styleId) =>
      itemApi.fetchStyles(styleId);

  Future<Item> fetchItem(String itemId, String styleId) =>
      itemApi.fetchItem(itemId, styleId);

  Future<List<ItemStock>> fetchItemStock(
          String itemId, String localId, String type) =>
      itemApi.fetchItemStock(itemId, localId, type);

  Future postImageStyle(styleId, imageName, extension, user, imageBase64) =>
      itemApi.postImageStyle(styleId, imageName, extension, user, imageBase64);
}
