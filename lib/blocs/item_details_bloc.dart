import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as im;
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
  final _photoFromCamera = BehaviorSubject<bool>();
  final _imageFile = BehaviorSubject<File>();
  final _loadingImage = BehaviorSubject<bool>();
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
      _itemStockSaleList.stream;

  ValueObservable<bool> get loadingData => _loadingData.stream;

  ValueObservable<bool> get photoFromCamera => _photoFromCamera.stream;

  ValueObservable<File> get imageFile => _imageFile.stream;

  ValueObservable<bool> get loadingImage => _loadingImage.stream;

  /// Add data to the streams.
  Function(Item) get changeItem => _item.sink.add;

  Function(String) get changeItemId => _itemId.sink.add;

  Function(int) get changeIndex => _index.sink.add;

  Function(String) get changeTypeReport => _typeReport.sink.add;

  Function(bool) get changeLoadingData => _loadingData.sink.add;

  Function(bool) get changeOriginPhoto => _photoFromCamera.sink.add;

  Function(File) get updateImageFile => _imageFile.sink.add;

  Function(bool) get changeLoadingImage => _loadingImage.sink.add;

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

  uploadStyleImage(String user) async {
    File _photoThumb;
    if (_imageFile.value == null) {
      _loadingImage.sink.add(false);
      return;
    }

    print(_imageFile.value.existsSync());

    im.Image _image = im.decodeImage(_imageFile.value.readAsBytesSync());
    im.Image _thumbnail = im.copyResize(_image, 500);

    _photoThumb = _imageFile.value
      ..writeAsBytesSync(im.encodeJpg(_thumbnail, quality: 50));

    await _inventoryRepository.postImageStyle(
        _item.value.styleId,
        _photoThumb.path.split("/").last,
        '.jpg',
        user, base64Encode(_photoThumb.readAsBytesSync())).then((data){
          _loadingImage.sink.add(false);
    }, onError: (error){
      _loadingImage.sink.add(false);
    }).catchError((error){
      _loadingImage.sink.add(false);
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
    _photoFromCamera.close();
    _imageFile.close();
    _loadingImage.close();
  }
}
