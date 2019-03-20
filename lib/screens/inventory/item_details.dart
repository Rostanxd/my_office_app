import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';

import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/inventory_bloc.dart';
import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/screens/inventory/item_info_card.dart';
import 'package:my_office_th_app/screens/inventory/item_sales_stock_card.dart';
import 'package:my_office_th_app/screens/inventory/item_stock_card.dart';

class ItemDetails extends StatefulWidget {
  final String itemStr;

  ItemDetails(this.itemStr);

  @override
  State<StatefulWidget> createState() {
    return _ItemDetailsState();
  }
}

class _ItemDetailsState extends State<ItemDetails> {
  LoginBloc _loginBloc;

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    inventoryBloc.cleanDataItem();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    /// Item's detail
    inventoryBloc.fetchItem(widget.itemStr, '');

    /// Item's stock
    inventoryBloc.fetchItemStockLocal(
        widget.itemStr, _loginBloc.local.value.id);
    inventoryBloc.changeTypeReport('L');

    /// Item's stock/sale
    inventoryBloc.fetchItemStockSales(
        widget.itemStr, _loginBloc.local.value.id, 'C');

    /// Default index
    inventoryBloc.changeIndex(0);

    var _widgetOptions = [
      ListView(
        children: <Widget>[_itemInformation()],
      ),
      ListView(
        children: <Widget>[_itemStock()],
      ),
      ListView(
        children: <Widget>[_itemStockSales()],
      ),
    ];

    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.itemStr),
        backgroundColor: Color(0xff011e41),
      ),
      body: Center(
        child: StreamBuilder<int>(
            stream: inventoryBloc.index,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? _widgetOptions.elementAt(inventoryBloc.index.value)
                  : CardDummyLoading();
            }),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: inventoryBloc.index,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasError) print(snapshot.error.toString());
          return snapshot.hasData
              ? BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.info), title: Text('Info')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.format_list_numbered),
                        title: Text('Stock')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.monetization_on),
                        title: Text('Sales')),
                  ],
                  currentIndex: snapshot.data,
                  fixedColor: Colors.deepPurple,
                  onTap: (index) {
                    print(index.toString());
                    inventoryBloc.changeIndex(index);
                  },
                )
              : CardDummyLoading();
        },
      ),
    );
  }

  Widget _itemInformation() {
    return StreamBuilder(
        stream: inventoryBloc.item,
        builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
          return Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: snapshot.hasData
                  ? ItemInfoCard(snapshot.data)
                  : CardDummyLoading());
        });
  }

  Widget _itemStock() {
    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: ItemStockCard());
  }

  Widget _itemStockSales() {
    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: ItemSalesStockCard());
  }
}
