import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/models/local.dart' as ml;
import 'package:my_office_th_app/services/fetch_items.dart' as si;

import 'package:my_office_th_app/screens/inventory/item_details.dart';

class ItemsStyleListView extends StatefulWidget {
  final String styleId;
  final ml.Local local;

  ItemsStyleListView(this.styleId, this.local);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemsStyleListViewState();
  }
}

class _ItemsStyleListViewState extends State<ItemsStyleListView> {
  List<mi.Item> _listItem = new List<mi.Item>();
  bool _boolStyle = false;

  void _getItemsStyle() {
    setState(() {
      this._boolStyle = true;
    });

    si
        .fetchItemsModel(http.Client(), '', widget.styleId)
        .timeout(Duration(seconds: 15))
        .then((result) {
      setState(() {
        this._boolStyle = false;
      });

      for (mi.Item _itm in result) {
        this._listItem.add(_itm);
      }
    }, onError: (error) {
      print(error);
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    this._getItemsStyle();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _boolStyle
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemDetails(
                                this._listItem[index].itemId, widget.local)));
                  },
                  leading: Icon(Icons.open_in_new),
                  title: Text(this._listItem[index].itemId),
                  subtitle: Text(this._listItem[index].styleName +
                      ' / ' +
                      this._listItem[index].lineName),
                ),
            itemCount: this._listItem.length,
          );
  }
}
