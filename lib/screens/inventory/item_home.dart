import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/factories/item.dart' as fi;
import 'package:my_office_th_app/models/local.dart' as ml;
import 'package:my_office_th_app/models/user.dart' as mu;
import 'package:my_office_th_app/screens/home/user_drawer.dart';
import 'package:my_office_th_app/screens/inventory/item_details.dart';
import 'package:my_office_th_app/screens/inventory/items_style_list_view.dart';
import 'package:my_office_th_app/services/fetch_items.dart' as si;

class ItemHome extends StatefulWidget {
  final mu.User user;
  final ml.Local local;

  ItemHome(this.user, this.local);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemHomeState();
  }
}

class _ItemHomeState extends State<ItemHome> {
  String _barcode = '';

  Future barcodeScanning() async {
    try {
      var _barcodeRead = await BarcodeScanner.scan();
      setState(() => this._barcode = _barcodeRead);
      MaterialPageRoute(
          builder: (context) => ItemDetails(this._barcode, widget.local));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() => this._barcode = '');
      } else {
        setState(() => this._barcode = '');
      }
    } on FormatException {
      setState(() => this._barcode = '');
    } catch (e) {
      setState(() => this._barcode = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget cardEmpty = Align(
        alignment: Alignment.center,
        child: Container(
            height: 100.0,
            width: 200.0,
            child: Center(
                child: Text(
              'Search the item!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ))));

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Color(0xff011e41),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: DataSearch(widget.local));
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () {
                barcodeScanning();
              },
            )
          ],
        ),
        drawer: UserDrawer(widget.user, widget.local),
        body: cardEmpty,
      ),
    );
  }
}

//  TODO: Implementation of search bar.
class DataSearch extends SearchDelegate<String> {
  final ml.Local local;

  DataSearch(this.local);

  String styleId;

  @override
  List<Widget> buildActions(BuildContext context) {
//    TODO: Icon to close the search bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
//    TODO: Leading icon on the left of the app
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //    TODO: Show some result based on the selection, in this case the list of items
    return ItemsStyleListView(this.styleId, this.local);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
//    TODO: Show when someone searches for something
    return query.isEmpty
        ? Container(
            margin: EdgeInsets.all(20.0),
            child: Text(
              'Insert a Style...',
              style: TextStyle(fontSize: 16.0),
            ))
        : FutureBuilder<List<fi.Item>>(
            future: si.fetchStyles(http.Client(), query),
            builder:
                (BuildContext context, AsyncSnapshot<List<fi.Item>> items) {
              if (!items.hasData) {
                return Container(
                    margin: EdgeInsets.all(20.0),
                    child: Text(
                      'No result',
                      style: TextStyle(fontSize: 16.0),
                    ));
              }

              return buildSuggestionItems(items.data);
            },
          );
  }

  Widget buildSuggestionItems(List<fi.Item> items) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);
              this.styleId = items[index].styleId;
            },
            leading: Icon(Icons.style),
            title: RichText(
                text: TextSpan(
                    text: items[index].styleId.substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                      text: items[index].styleId.substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ])),
            subtitle:
                Text(items[index].styleName + ' / ' + items[index].lineName),
          ),
      itemCount: items.length,
    );
  }
}