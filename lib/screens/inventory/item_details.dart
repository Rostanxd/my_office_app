import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/models/item_stock.dart' as mis;
import 'package:my_office_th_app/models/local.dart' as ml;
import 'package:my_office_th_app/models/user.dart' as mu;
import 'package:my_office_th_app/screens/inventory/item_info_card.dart';
import 'package:my_office_th_app/screens/inventory/item_stock_card.dart';
import 'package:my_office_th_app/screens/inventory/item_sales_stock_card.dart';
import 'package:my_office_th_app/services/fetch_items.dart' as si;
import 'package:my_office_th_app/services/fetch_item_stock.dart' as si;

class ItemDetails extends StatefulWidget {
  final String itemStr;
  final ml.Local local;
  final mu.User user;

  ItemDetails(this.itemStr, this.local, this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemDetailsState();
  }
}

class _ItemDetailsState extends State<ItemDetails> {
  mi.Item _item;
  List<mis.ItemStock> _listItemStock = new List<mis.ItemStock>();
  List<mis.ItemStock> _listItemSalesStock = new List<mis.ItemStock>();
  bool _boolItem = false;

  @override
  void initState() {
//    TODO: calling the fetch method to get the item's details

    setState(() {
      this._boolItem = true;
    });

    si
        .fetchAnItem(http.Client(), widget.itemStr, '')
        .timeout(Duration(seconds: 30))
        .then((result) {
      setState(() {
        _item = result;
        this._boolItem = false;
      });
    }, onError: (error) {
      print('fetchAnItem onError: $error');
      setState(() {
        this._boolItem = false;
      });
    }).catchError((error) {
      print('fetchAnItem catchError: $error');
      setState(() {
        this._boolItem = false;
      });
    });

//    TODO: calling the fetch method to get the item's stock
    si
        .fetchModelItemStock(
            http.Client(), widget.itemStr, widget.local.id, 'L')
        .timeout(Duration(seconds: 30))
        .then((result) {
      setState(() {
        for (mis.ItemStock i in result) {
          this._listItemStock.add(i);
        }
      });
    }, onError: (error) {
      print('fetchModelItemStock onError: $error');
    }).catchError((error) {
      print('fetchModelItemStock catchError: $error');
    });

    si
        .fetchModelItemStock(
            http.Client(), widget.itemStr, widget.local.id, 'C')
        .timeout(Duration(seconds: 30))
        .then((result) {
      setState(() {
        for (mis.ItemStock i in result) {
          this._listItemSalesStock.add(i);
        }
      });
    }, onError: (error) {
      print('fetchModelItemStock onError: $error');
    }).catchError((error) {
      print('fetchModelItemStock catchError: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.itemStr),
          backgroundColor: Color(0xff011e41),
        ),
        body: _boolItem
            ? ListView(
                children: <Widget>[
                  CardDummyLoading(),
                  CardDummyLoading(),
                  CardDummyLoading(),
                ],
              )
            : _item != null
                ? ListView(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child:
                              ItemInfoCard(_item, widget.local, widget.user)),
                      Container(
                        margin:
                            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                        child: _listItemStock.length > 0
                            ? ItemStockCard(_item, _listItemStock, widget.local)
                            : CardDummyLoading(),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                        child: _listItemSalesStock.length > 0
                            ? ItemSalesStockCard(_listItemSalesStock)
                            : CardDummyLoading(),
                      ),
                    ],
                  )
                : Container(
                    child: Center(
                      child: Text('Item not found!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          )),
                    ),
                  ));
  }
}
