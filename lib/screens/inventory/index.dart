import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/screens/home/user_drawer.dart';
import 'package:my_office_th_app/screens/inventory/item_details.dart';
import 'package:my_office_th_app/screens/inventory/items_style_list_view.dart';
import 'package:my_office_th_app/screens/login/login_state_container.dart';
import 'package:my_office_th_app/services/fetch_items.dart';

import 'package:webview_flutter/webview_flutter.dart';

class InventoryHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InventoryHomeState();
  }
}

class _InventoryHomeState extends State<InventoryHome> {
  String _barcode = '';

  Future _barcodeScanning(LoginStateContainerState container) async {
    try {
      var _barcodeRead = await BarcodeScanner.scan();
      setState(() => this._barcode = _barcodeRead);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ItemDetails(this._barcode)));
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
//    Getting data from the item sate container
    final container = LoginStateContainer.of(context);

    String holdingId = container.holding.id;
    String localId = container.local.id;

    WebViewController _contoller;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff011e41),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              _barcodeScanning(container);
            },
          )
        ],
      ),
      drawer: UserDrawer(),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'http://info.thgye.com.ec/InvLineasProveedor.html?hldCodigo=$holdingId&bodCodigo=$localId',
        onWebViewCreated: (WebViewController webViewController) {
          _contoller = webViewController;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            _contoller.clearCache();
            _contoller.reload();
          }),
    );
  }
}

//  Implementation of search bar.
class DataSearch extends SearchDelegate<String> {
  String styleId;

  @override
  List<Widget> buildActions(BuildContext context) {
//    Icon to close the search bar
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
//    Leading icon on the left of the app
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
    //    Show some result based on the selection, in this case the list of items
    return ItemsStyleListView(this.styleId);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
//    Show when someone searches for something
    return query.isEmpty
        ? Container(
            margin: EdgeInsets.all(20.0),
            child: Text(
              'Insert a Style...',
              style: TextStyle(fontSize: 16.0),
            ))
        : FutureBuilder<List<Item>>(
//            future: fetchStyles(http.Client(), query),
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> items) {
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

  Widget buildSuggestionItems(List<Item> items) {
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
            subtitle: Text(
              items[index].styleName + ' / ' + items[index].lineName,
              style: TextStyle(fontSize: 10.0),
            ),
          ),
      itemCount: items.length,
    );
  }
}
