import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/resources/inventory_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class InventoryBloc extends Object implements BlocBase {
  final _searchedStyle = BehaviorSubject<String>();
  final _index = BehaviorSubject<int>();
  final _itemList = BehaviorSubject<List<Item>>();
  final InventoryRepository _itemRepository = InventoryRepository();

  /// Retrieve data from streams
  Observable<List<Item>> styleList;

  Observable<List<Item>> get itemList => _itemList.stream;

  ValueObservable<int> get index => _index.stream;

  /// Add data to streams
  Function(String) get changeSearchStyle => _searchedStyle.sink.add;

  Function(int) get changeIndex => _index.sink.add;

  /// Functions
  fetchStyles() {
    styleList = _searchedStyle
        .debounce(const Duration(milliseconds: 500))
        .switchMap((terms) async* {
      yield await _itemRepository.fetchStyles(terms);
    });
  }

  fetchItemsStyle(String itemId, String styleId) async {
    await _itemRepository
        .fetchItems(itemId, styleId)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _itemList.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      if (error.runtimeType == RangeError) {
        _itemList.sink.addError('No data!');
      } else {
        _itemList.sink.addError(error.toString());
      }
    }).catchError((error) {
      print(error.toString());
      _itemList.sink.addError(error.toString());
    });
  }

  @override
  void dispose() {
    _searchedStyle.close();
    _itemList.close();
    _index.close();
  }
}

final inventoryBloc = InventoryBloc();
