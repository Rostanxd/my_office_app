import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/models/item_stock.dart';
import 'package:my_office_th_app/resources/inventory_repository.dart';
import 'package:rxdart/rxdart.dart';

class ItemDetailsBloc extends Object implements BlocBase {
  final _item = BehaviorSubject<Item>();
  final _itemId = BehaviorSubject<String>();
  final _searchedStyle = BehaviorSubject<String>();
  final _typeReport = BehaviorSubject<String>();
  final _index = BehaviorSubject<int>();
  final _itemList = BehaviorSubject<List<Item>>();
  final _itemStockLocalList = BehaviorSubject<List<ItemStock>>();
  final _itemStockAllList = BehaviorSubject<List<ItemStock>>();
  final _itemStockSaleList = BehaviorSubject<List<ItemStock>>();
  final _loadingData = BehaviorSubject<bool>();
  final InventoryRepository _inventoryRepository = InventoryRepository();

  /// Retrieve data from the stream.
  ValueObservable<String> get itemId => _itemId.stream;

  ValueObservable<Item> get item => _item.stream;

  ValueObservable<int> get index => _index.stream;

  ValueObservable<String> get typeReport => _typeReport.stream;

  ValueObservable<List<ItemStock>> get itemStockLocalList =>
      _itemStockLocalList.stream;

  ValueObservable<List<ItemStock>> get itemStockAllList =>
      _itemStockAllList.stream;

  ValueObservable<List<ItemStock>> get itemStockSaleList =>
      _itemStockLocalList.stream;

  ValueObservable<bool> get loadingData => _loadingData.stream;

  /// Add data to the streams.
  Function(Item) get changeItem => _item.sink.add;

  Function(String) get changeItemId => _itemId.sink.add;

  Function(int) get changeIndex => _index.sink.add;

  Function(String) get changeTypeReport => _typeReport.sink.add;

  Function(bool) get changeLoadingData => _loadingData.sink.add;

  /// Functions to call APIs.
  fetchItem(String itemId, String styleId) async {
    await _inventoryRepository
        .fetchItem(itemId, styleId)
        .timeout(Duration(seconds: 30))
        .then((response) {
      _item.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      if (error.runtimeType == RangeError) {
        _item.sink.addError('Item no existe!');
      } else {
        _item.sink.addError(error.runtimeType.toString());
      }
    }).catchError((error) {
      print(error.toString());
      _item.sink.addError(error.toString());
    });
  }

  fetchItemStockLocal(String itemId, String localId) async {
    await _inventoryRepository
        .fetchItemStock(itemId, localId, 'L')
        .timeout(Duration(seconds: 30))
        .then((response) {
      _itemStockLocalList.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      if (error.runtimeType == RangeError) {
        _itemStockLocalList.sink.addError('No data');
      } else {
        _itemStockLocalList.sink.addError(error.toString());
      }
    }).catchError((error) {
      print(error.toString());
      _itemStockLocalList.addError(error.toString());
    });
  }

  fetchItemStockAll(String itemId, String localId) async {
    _loadingData.sink.add(true);
    await _inventoryRepository
        .fetchItemStock(itemId, localId, 'A')
        .timeout(Duration(seconds: 30))
        .then((response) {
      _itemStockAllList.sink.add(response);
      _loadingData.sink.add(false);
    }, onError: (error) {
      print(error.toString());
      _itemStockAllList.sink.addError('No data');
      _loadingData.sink.add(false);
    }).catchError((error) {
      print(error.toString());
      _itemStockAllList.addError(error.toString());
      _loadingData.sink.add(false);
    });
  }

  fetchItemStockSales(String itemId, String localId, String type) async {
    await _inventoryRepository
        .fetchItemStock(itemId, localId, type)
        .timeout(Duration(seconds: 30))
        .then((response) {
      _itemStockSaleList.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      if (error.runtimeType == RangeError) {
        _itemStockSaleList.sink.addError('No data');
      } else {
        _itemStockSaleList.sink.addError(error.toString());
      }
    }).catchError((error) {
      print(error.toString());
      _itemStockSaleList.addError(error.toString());
    });
  }

  @override
  void dispose() {
    _item.close();
    _itemId.close();
    _searchedStyle.close();
    _typeReport.close();
    _index.close();
    _itemList.close();
    _itemStockLocalList.close();
    _itemStockAllList.close();
    _itemStockSaleList.close();
    _loadingData.close();
  }
}
