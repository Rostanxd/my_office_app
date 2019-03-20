import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/resources/inventory_repository.dart';
import 'package:rxdart/rxdart.dart';

class ItemBloc {
  final _itemFetcher = PublishSubject<List<Item>>();
  final InventoryRepository _repository = InventoryRepository();

  /// To observe the stream
  Observable<List<Item>> get itemsFiltered => _itemFetcher.stream;

  /// To call de api
  fetchItemsFiltered(String itemId, String styleId) async {
    List<Item> itemList = await _repository.fetchItems(itemId, styleId);
    _itemFetcher.sink.add(itemList);
  }

  /// To close the stream
  dispose() {
    _itemFetcher.close();
  }
}