import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/screens/inventory/item_info_card.dart';
import 'package:my_office_th_app/screens/inventory/item_sales_stock_card.dart';
import 'package:my_office_th_app/screens/inventory/item_stock_card.dart';

class ItemDetails extends StatefulWidget {
  final String itemId;

  ItemDetails(this.itemId);

  @override
  State<StatefulWidget> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  LoginBloc _loginBloc;
  ItemDetailsBloc _itemDetailsBloc;
  GlobalKey<ScaffoldState> _scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    print('Item Details >> didChangeDependecies');

    /// Getting the bloc of the login
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print('Item Details >> initState');
    super.initState();
  }

  @override
  void dispose() {
    print('Item Details >> dispose');
    _itemDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Item Details >> build');

    /// Getting the bloc of the item details
    _itemDetailsBloc = BlocProvider.of<ItemDetailsBloc>(context);

    /// Adding the data to the stream
    _itemDetailsBloc.changeItemId(widget.itemId);

    /// Item's detail
    _itemDetailsBloc.fetchItem(widget.itemId, '');

    /// Item's stock
    _itemDetailsBloc.fetchItemStockLocal(
        _itemDetailsBloc.itemId.value, _loginBloc.local.value.id);

    /// To set what kind of stock report we want to see first.
    _itemDetailsBloc.changeTypeReport('L');

    /// Item's stock/sale
    _itemDetailsBloc.fetchItemStockSales(
        _itemDetailsBloc.itemId.value, _loginBloc.local.value.id, 'C');

    /// Default index for the bottom navigation bar.
    _itemDetailsBloc.changeIndex(0);

    /// Listen the stream image file, showing a dialog.
    /// Once we load a new image to the item
    /// We show a snack bar with a message and set null the stream.
    _itemDetailsBloc.loadingImage.listen((data) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StreamBuilder(
              stream: _itemDetailsBloc.loadingImage,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.hasData && snapshot.data
                    ? AlertDialog(
                        title: Text('Cargando foto del estilo'),
                        content: Container(
                            height: 40.0,
                            width: 40.0,
                            child: Center(child: CircularProgressIndicator())),
                      )
                    : StreamBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<File> snapshot) {
                          print(snapshot.data);
                          if (snapshot.hasError) {
                            return AlertDialog(
                              actions: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                              title: Text('Cargando foto del estilo'),
                              content: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  child: Center(child: Text(snapshot.error))),
                            );
                          }
                          return snapshot.hasData
                              ? AlertDialog(
                                  title: Text('Cargando foto del estilo'),
                                  content: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      child: Center(
                                          child: Text(
                                              'Imagen cargada correctamente.'))),
                                  actions: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cerrar'),
                                    ),
                                  ],
                                )
                              : AlertDialog(
                                  title: Text('Cargando foto del estilo'),
                                  content: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      child: Center(
                                          child: Text(
                                              'No ha seleccionado ninguna imagen...'))),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Cerrar'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                        },
                      );
              },
            );
          });
    });

    /// Adding the 2 first page for all user access
    var _widgetOptions = [
      ListView(
        children: <Widget>[ItemInfoCard()],
      ),
      ListView(
        children: <Widget>[ItemStockCard()],
      )
    ];

    var _buttonOptions = [
      BottomNavigationBarItem(icon: Icon(Icons.info), title: Text('Info')),
      BottomNavigationBarItem(
          icon: Icon(Icons.format_list_numbered), title: Text('Saldos')),
    ];

    /// Only if the user is not a access '05' (seller).
    if (_loginBloc.user.value.accessId != '05') {
      _widgetOptions.add(ListView(
        children: <Widget>[ItemSalesStockCard()],
      ));

      _buttonOptions.add(BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on), title: Text('Ventas')));
    }

    return Scaffold(
      appBar: new AppBar(
        title: new Text(_itemDetailsBloc.itemId.value),
        backgroundColor: Color(0xff011e41),
      ),
      key: _scaffoldGlobalKey,
      body: Center(
        child: StreamBuilder<Item>(
          stream: _itemDetailsBloc.item,
          builder: (BuildContext context, AsyncSnapshot<Item> itemSnapshot) {
            if (itemSnapshot.hasError) return Text(itemSnapshot.error);
            return itemSnapshot.hasData
                ? StreamBuilder<int>(
                    stream: _itemDetailsBloc.index,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? _widgetOptions
                              .elementAt(_itemDetailsBloc.index.value)
                          : CardDummyLoading();
                    })
                : CircularProgressIndicator();
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _itemDetailsBloc.index,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasError) print(snapshot.error.toString());
          return snapshot.hasData
              ? BottomNavigationBar(
                  items: _buttonOptions,
                  currentIndex: snapshot.data,
                  fixedColor: Colors.deepPurple,
                  onTap: (index) {
                    _itemDetailsBloc.changeIndex(index);
                  },
                )
              : CardDummyLoading();
        },
      ),
    );
  }
}
