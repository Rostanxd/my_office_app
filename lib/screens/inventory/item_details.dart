import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';

import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/inventory_bloc.dart';
import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/screens/inventory/item_info_card.dart';
import 'package:my_office_th_app/screens/inventory/item_sales_stock_card.dart';
import 'package:my_office_th_app/screens/inventory/item_stock_card.dart';

class ItemDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemDetailsState();
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
    inventoryBloc.fetchItem(inventoryBloc.itemId.value, '');

    /// Item's stock
    inventoryBloc.fetchItemStockLocal(
        inventoryBloc.itemId.value, _loginBloc.local.value.id);
    inventoryBloc.changeTypeReport('L');

    /// Item's stock/sale
    inventoryBloc.fetchItemStockSales(
        inventoryBloc.itemId.value, _loginBloc.local.value.id, 'C');

    /// Default index
    inventoryBloc.changeIndex(0);

    var _widgetOptions = [
      ListView(
        children: <Widget>[ItemInfoCard()],
      ),
      ListView(
        children: <Widget>[ItemStockCard()],
      ),
      ListView(
        children: <Widget>[ItemSalesStockCard()],
      ),
    ];

    return Scaffold(
      appBar: new AppBar(
        title: new Text(inventoryBloc.itemId.value),
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
                    inventoryBloc.changeIndex(index);
                  },
                )
              : CardDummyLoading();
        },
      ),
    );
  }
}
