import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/screens/inventory/item_info_card.dart';
import 'package:my_office_th_app/screens/inventory/item_sales_stock_card.dart';
import 'package:my_office_th_app/screens/inventory/item_stock_card.dart';

class ItemDetails extends StatefulWidget {
  final LoginBloc _loginBloc;
  final ItemDetailsBloc _itemDetailsBloc;
  final String itemId;

  ItemDetails(this._loginBloc, this._itemDetailsBloc, this.itemId);

  @override
  State<StatefulWidget> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  GlobalKey<ScaffoldState> _scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    print('Item Details >> didChangeDependecies');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print('Item Details >> initState');

    /// Adding the data to the stream
    widget._itemDetailsBloc.changeItemId(widget.itemId);

    /// Item's detail
    widget._itemDetailsBloc.fetchItem(widget.itemId, '');

    /// Item's stock
    widget._itemDetailsBloc.fetchItemStockLocal(
        widget._itemDetailsBloc.itemId.value, widget._loginBloc.local.value.id);

    /// To set what kind of stock report we want to see first.
    widget._itemDetailsBloc.changeTypeReport('L');

    /// Item's stock/sale
    widget._itemDetailsBloc.fetchItemStockSales(
        widget._itemDetailsBloc.itemId.value,
        widget._loginBloc.local.value.id,
        'C');

    /// Default index for the bottom navigation bar.
    widget._itemDetailsBloc.changeIndex(0);

    /// Listening to the bool loading variable
    widget._itemDetailsBloc.loadingImage.listen((data) {
      print(data);
      if (data)
        _scaffoldGlobalKey.currentState.showSnackBar(SnackBar(
          content: Text('Cargando imágen...'),
          duration: Duration(seconds: 3),
        ));
    });

    /// Listen the stream image file, showing a dialog.
    /// Once we load a new image to the item we show a dialog.
    widget._itemDetailsBloc.imageFile.listen((data) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cargando foto del estilo'),
              content: Container(
                  height: 40.0,
                  width: 40.0,
                  child: Center(child: Text('Imagen cargada correctamente.'))),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Container(
                  height: 40.0, width: 40.0, child: Center(child: Text(error))),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    });

    super.initState();
  }

  @override
  void dispose() {
    print('Item Details >> dispose');
    widget._itemDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Item Details >> build');

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
    if (widget._loginBloc.user.value.accessId != '05') {
      _widgetOptions.add(ListView(
        children: <Widget>[ItemSalesStockCard()],
      ));

      _buttonOptions.add(BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on), title: Text('Ventas')));
    }

    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget._itemDetailsBloc.itemId.value),
        backgroundColor: Color(0xff011e41),
      ),
      key: _scaffoldGlobalKey,
      body: Center(
        child: StreamBuilder<Item>(
          stream: widget._itemDetailsBloc.item,
          builder: (BuildContext context, AsyncSnapshot<Item> itemSnapshot) {
            if (itemSnapshot.hasError) return Text(itemSnapshot.error);
            return itemSnapshot.hasData
                ? StreamBuilder<int>(
                    stream: widget._itemDetailsBloc.index,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? _widgetOptions
                              .elementAt(widget._itemDetailsBloc.index.value)
                          : CardDummyLoading();
                    })
                : CircularProgressIndicator();
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: widget._itemDetailsBloc.index,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasError) print(snapshot.error.toString());
          return snapshot.hasData
              ? BottomNavigationBar(
                  items: _buttonOptions,
                  currentIndex: snapshot.data,
                  fixedColor: Colors.deepPurple,
                  onTap: (index) {
                    widget._itemDetailsBloc.changeIndex(index);
                  },
                )
              : CardDummyLoading();
        },
      ),
    );
  }
}
