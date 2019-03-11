import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/models/item_stock.dart' as mis;
import 'package:my_office_th_app/screens/inventory/item_info_card.dart';
import 'package:my_office_th_app/screens/inventory/item_sales_stock_card.dart';
import 'package:my_office_th_app/screens/inventory/item_state_container.dart';
import 'package:my_office_th_app/screens/inventory/item_stock_card.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';
import 'package:my_office_th_app/services/fetch_items.dart' as si;
import 'package:my_office_th_app/services/fetch_item_stock.dart' as si;
import 'package:my_office_th_app/utils/connection.dart';

class ItemDetails extends StatefulWidget {
  final String itemStr;

  ItemDetails(this.itemStr);

  @override
  State<StatefulWidget> createState() {
    return _ItemDetailsState();
  }
}

class _ItemDetailsState extends State<ItemDetails> {
  mi.Item _item;
  List<mis.ItemStock> _listItemStock = new List<mis.ItemStock>();
  List<mis.ItemStock> _listItemSalesStock = new List<mis.ItemStock>();
  bool _boolInfo = false;
  bool _boolStock = false;
  bool _boolStockSales = false;

//    Calling the fetch method to get the item's details, first card.
  void _getItemInfo(BuildContext context) {
    setState(() {
      this._boolInfo = true;
    });

    si
        .fetchAnItem(http.Client(), widget.itemStr, '')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((result) {
      setState(() {
        _item = result;
        this._boolInfo = false;
      });
    }, onError: (error) {
      print('fetchAnItem onError: $error');
      setState(() {
        this._boolInfo = false;
      });
    }).catchError((error) {
      print('fetchAnItem catchError: $error');
      setState(() {
        this._boolInfo = false;
      });
    });
  }

//  Calling the fetch method to get the item's stock, second card.
  void _getItemStock(BuildContext context) {
//    Getting data from the item sate container
    final container = LoginStateContainer.of(context);

    setState(() => this._boolStock = true);

    si
        .fetchModelItemStock(
            http.Client(), widget.itemStr, container.local.id, 'L')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((result) {
      setState(() {
        this._boolStock = false;

        this._listItemStock.clear();
        for (mis.ItemStock i in result) {
          this._listItemStock.add(i);
        }
      });
    }, onError: (error) {
      print('fetchModelItemStock onError: $error');
      setState(() => this._boolStock = false);
    }).catchError((error) {
      print('fetchModelItemStock catchError: $error');
      setState(() => this._boolStock = false);
    });
  }

  void _getItemStockSales(BuildContext context) {
//    Getting data from the item sate container
    final container = LoginStateContainer.of(context);

    setState(() => this._boolStockSales = true);

    si
        .fetchModelItemStock(
            http.Client(), widget.itemStr, container.local.id, 'C')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((result) {
      setState(() {
        this._boolStockSales = false;

        this._listItemSalesStock.clear();
        for (mis.ItemStock i in result) {
          this._listItemSalesStock.add(i);
        }
      });
    }, onError: (error) {
      print('fetchModelItemStock onError: $error');
      setState(() => this._boolStockSales = false);
    }).catchError((error) {
      print('fetchModelItemStock catchError: $error');
      setState(() => this._boolStockSales = false);
    });
  }

  Container _getCardDummyReload(BuildContext context, String cardType) {
    return Container(
      height: 150.0,
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                  margin: EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(20.0),
                          child: Text('No data. Please reload.')),
                      InkWell(
                          onTap: () {
                            cardType == 'S'
                                ? this._getItemStock(context)
                                : this._getItemStockSales(context);
                          },
                          child: Icon(
                            Icons.refresh,
                            size: 30.0,
                            color: Color(0xff011e41),
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    this._getItemInfo(context);
    this._getItemStock(context);
    this._getItemStockSales(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.itemStr),
          backgroundColor: Color(0xff011e41),
        ),
        body: _boolInfo
            ? ListView(
                children: <Widget>[
                  CardDummyLoading(),
                  CardDummyLoading(),
                  CardDummyLoading(),
                ],
              )
            : _item != null
                ? ItemStateContainer(
                    item: _item,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: ItemInfoCard()),
                        Container(
                            margin: EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: _boolStock
                                ? CardDummyLoading()
                                : _listItemStock.length > 0
                                    ? ItemStockCard(_listItemStock)
                                    : _getCardDummyReload(context, 'S')),
                        Container(
                            margin: EdgeInsets.only(
                                top: 10.0,
                                left: 10.0,
                                right: 10.0,
                                bottom: 10.0),
                            child: _boolStockSales
                                ? CardDummyLoading()
                                : _listItemSalesStock.length > 0
                                    ? ItemSalesStockCard(_listItemSalesStock)
                                    : _getCardDummyReload(context, 'V')),
                      ],
                    ))
                : Container(
                    child: Center(
                      child: Text('Item not found or connection problems.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          )),
                    ),
                  ));
  }
}
