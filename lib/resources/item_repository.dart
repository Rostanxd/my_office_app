import 'dart:async';

import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/services/fetch_items.dart';

class ItemRepository {
  final itemApi = ItemApi();

  Future<List<Item>> fetchItems(String itemId, String styleId) =>
      itemApi.fetchItems(itemId, styleId);

  Future<List<Item>> fetchStyles(String styleId) =>
      itemApi.fetchStyles(styleId);

  Future<Item> fetchItem(String itemId, String styleId) =>
      fetchItem(itemId, styleId);
}
