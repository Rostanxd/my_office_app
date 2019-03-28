import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/inventory_bloc.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/screens/inventory/item_details.dart';

import 'package:webview_flutter/webview_flutter.dart';

class InventoryHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InventoryHomeState();
  }
}

class _InventoryHomeState extends State<InventoryHome> {
  LoginBloc _loginBloc;
  InventoryBloc _inventoryBloc;
  WebViewController _controller;

  Future _barcodeScanning() async {
    try {
      var _barcodeRead = await BarcodeScanner.scan();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    bloc: ItemDetailsBloc(),
                    child: ItemDetails(_barcodeRead),
                  )));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Error acceso a cámara denegado.')));
      }
    } on FormatException {} catch (e) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Error ${e.toString()}')));
    }
  }

  @override
  void initState() {
    print('Inventory Home >> initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('Inventory Home >> didChangeDependecies');
    _inventoryBloc = BlocProvider.of<InventoryBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('Inventory Home >> dispose');
    _inventoryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Inventory Home >> build');

    /// Getting login bloc from provider
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff011e41),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: DataSearch(_inventoryBloc));
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              _barcodeScanning();
            },
          )
        ],
      ),
      drawer: UserDrawer(),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'http://info.thgye.com.ec/InvLineasProveedor.html?hldCodigo='
            '${_loginBloc.holding.value.id}&bodCodigo='
            '${_loginBloc.local.value.id}',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            //  _controller.clearCache();
            _controller.reload();
          }),
    );
  }
}

///  Implementation of search bar.
class DataSearch extends SearchDelegate<String> {
  final InventoryBloc _inventoryBloc;

  DataSearch(this._inventoryBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    /// Icon to close the search bar
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
    /// Leading icon on the left of the app
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
    /// Show some result based on the selection, in this case the list of items
    /// of the style.
    return _itemsOfStyleList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /// Show when someone searches for something
    if (query.isEmpty) {
      return Container(
          margin: EdgeInsets.all(20.0),
          child: Text(
            'Ingrese un estilo.',
            style: TextStyle(fontSize: 16.0),
          ));
    } else {
      /// Update the stream
      _inventoryBloc.changeSearchStyle(query);

      /// Fetching styles by query (stream)
      _inventoryBloc.fetchStyles();

      /// Returning the stream builder
      return StreamBuilder(
          stream: _inventoryBloc.styleList,
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasError) {
              return Container(
                  margin: EdgeInsets.all(20.0),
                  child: Text(
                    'Se ha encontrado un Error. ' +
                        'Comunicar al Dpto. de Sistemas.\n\n'
                        'Tipo: ${snapshot.error.runtimeType}',
                    style: TextStyle(fontSize: 16.0),
                  ));
            }
            if (snapshot.hasData) {
              if (snapshot.data.length == 0)
                return Container(
                    margin: EdgeInsets.all(20.0),
                    child: Text(
                      'No se ha encontrado el estilo.',
                      style: TextStyle(fontSize: 16.0),
                    ));

              /// Passing the list of style from the stream to the function to
              /// build the list view
              return _buildSuggestionItems(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    }
  }

  /// List view with the styles.
  Widget _buildSuggestionItems(List<Item> items) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);

              /// Loading items if the style in the bloc
              _inventoryBloc.fetchItemsStyle('', items[index].styleId);
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
              '${items[index].styleName} / ${items[index].lineName} / ${items[index].productName}',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
      itemCount: items.length,
    );
  }

  /// List view with the style's items.
  Widget _itemsOfStyleList() {
    return StreamBuilder(
      stream: _inventoryBloc.itemList,
      builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        /// Navigation to the item's detail
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      bloc: ItemDetailsBloc(),
                                      child: ItemDetails(
                                          snapshot.data[index].itemId),
                                    )));
                      },
                      leading: Icon(Icons.open_in_new),
                      title: Text(snapshot.data[index].itemId),
                      subtitle: Text(
                        '${snapshot.data[index].styleName} / ${snapshot.data[index].lineName} / ${snapshot.data[index].productName}',
                        style: TextStyle(fontSize: 10.00),
                      ),
                    ),
                itemCount: snapshot.data.length,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
