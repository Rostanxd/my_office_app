import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_office_th_app/components/card_dummy_loading.dart';

import 'package:my_office_th_app/models/item_stock.dart' as ms;
import 'package:my_office_th_app/screens/inventory/item_state_container.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';
import 'package:my_office_th_app/services/fetch_item_stock.dart' as si;

class ItemStockCard extends StatefulWidget {
  final List<ms.ItemStock> listItemStock;

  ItemStockCard(this.listItemStock);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemStockCardState();
  }
}

class _ItemStockCardState extends State<ItemStockCard> {
  bool _boolLocal = false;
  String _tableType = 'L';
  String _itemSelected;
  List<ms.ItemStock> _listItemStock = new List<ms.ItemStock>();

  void _getStockOtherLocal(
      LoginStateContainerState containerLogin, String itemId) {
    setState(() {
      _boolLocal = true;
      _tableType = 'A';
      _itemSelected = itemId;
    });

    si
        .fetchModelItemStock(
            http.Client(), itemId, containerLogin.local.id, _tableType)
        .timeout(Duration(seconds: 30))
        .then((result) {
      setState(() {
        _boolLocal = false;
        this._listItemStock.clear();
        for (ms.ItemStock i in result) {
          this._listItemStock.add(i);
        }
      });
    }, onError: (error) {
      print('fetchModelItemStock onError: $error');
    }).catchError((error) {
      print('fetchModelItemStock catchError: $error');
    });
  }

  TextStyle _textStyleStock(
      ItemStateContainerState containerItem, ms.ItemStock _itemStock) {
    if (_itemStock.color == 'Total General') {
      return TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11.0);
    }

    if (_itemStock.size == 'Total') {
      return TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11.0);
    }

    if (_itemStock.itemId == containerItem.item.itemId) {
      return TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.0);
    }

    return TextStyle(color: Colors.black, fontSize: 10.0);
  }

  @override
  Widget build(BuildContext context) {
//    Getting data from the item sate container
    final containerItem = ItemStateContainer.of(context);
//    Getting data from the login sate container
    final containerLogin = LoginStateContainer.of(context);

//    Generating the table based on the _tableType variable, "L" for the local, and 'A' for the others.
    var _tableStock = new Table(
      border: TableBorder.all(color: Colors.grey, width: 1.0),
      children: [],
    );

    var _titleRow = _tableType == 'A'
        ? TableRow(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            children: [
                Container(
                  color: Color(0xff011e41),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Local',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff011e41),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Stock',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ])
        : TableRow(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            children: [
                Container(
                  color: Color(0xff011e41),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Color',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff011e41),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Size',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff011e41),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Local',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff011e41),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Others',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ]);

    _tableStock.children.add(_titleRow);

    _tableStock.children.addAll(_tableType == 'A'
        ? _listItemStock.map((f) => TableRow(children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(f.color,
                      style: TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    f.local.toString(),
                    style: f.color == 'Total General'
                        ? TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)
                        : TextStyle(fontSize: 10.0),
                  ),
                ),
              ))
            ]))
        : widget.listItemStock
            .map((f) => TableRow(children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(f.color,
                          style: TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      f.size,
                      style: f.size == 'Total'
                          ? TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.bold)
                          : TextStyle(fontSize: 10.0),
                    ),
                  )),
                  Container(
                      color: f.itemId == containerItem.item.itemId
                          ? Colors.red
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Center(
                            child: Text(f.local == 0 ? '' : f.local.toString(),
                                style: _textStyleStock(containerItem, f)),
                          ),
                          onTap: () {},
                        ),
                      )),
                  Container(
                      color: f.itemId == containerItem.item.itemId
                          ? Colors.red
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Center(
                              child: Text(
                            f.others == 0 ? '' : f.others.toString(),
                            style: _textStyleStock(containerItem, f),
                          )),
                          onTap: () {
                            if (f.itemId.isNotEmpty) {
                              _getStockOtherLocal(containerLogin, f.itemId);
                            }
                          },
                        ),
                      )),
                ]))
            .toList());

    return _boolLocal
        ? CardDummyLoading()
        : Container(
            child: Card(
                elevation: 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        this._tableType == 'A'
                            ? Container(
                                margin: EdgeInsets.only(
                                  top: 20.0,
                                  left: 20.0,
                                  bottom: 5.0,
                                ),
                                child: InkWell(
                                  child: Icon(Icons.arrow_back),
                                  onTap: () {
                                    setState(() => _tableType = 'L');
                                  },
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(
                              top: 20.0, left: 20.0, bottom: 5.0),
                          child: Text(
                            this._tableType == 'L'
                                ? 'Stock in local'
                                    ''
                                : 'Stock of ' + this._itemSelected,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Container(
                        width: 300.0,
                        margin: EdgeInsets.only(
                            top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: _tableStock),
                  ],
                )));
  }
}
