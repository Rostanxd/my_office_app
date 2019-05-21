import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/item_stock.dart';

class ItemStockCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemStockCardState();
}

class _ItemStockCardState extends State<ItemStockCard> {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  ItemDetailsBloc _itemDetailsBloc;


  @override
  void didChangeDependencies() {
    /// Getting the bloc of the item details
    _itemDetailsBloc = BlocProvider.of<ItemDetailsBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Getting blocs
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _itemDetailsBloc.changeLoadingData(false);

    return StreamBuilder<String>(
        stream: _itemDetailsBloc.typeReport,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) print(snapshot.error.toString());
          return snapshot.hasData
              ? _cardStock(snapshot.data)
              : _myCircularProgress();
        });
  }

  Widget _cardStock(String _tableType) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Card(
          elevation: 5.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: _settingsBloc.queryData.value.size.width * 0.5,
                    margin: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 5.0),
                    child: Text(
                      _tableType == 'L'
                          ? 'Saldos en el local ${_loginBloc.local.value.name}'
                              ''
                          : 'Saldos de ' + _itemDetailsBloc.itemId.value,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _tableType == 'A'
                      ? Container(
                    margin: EdgeInsets.only(
                      top: 20.0,
                      right: 20.0,
                      left: 20.0,
                      bottom: 5.0,
                    ),
                    child: InkWell(
                      child: Icon(Icons.arrow_back, color: Colors.blueAccent,),
                      onTap: () {
                        _itemDetailsBloc.changeTypeReport('L');
                      },
                    ),
                  )
                      : Container(),
                ],
              ),
              Divider(),
              Container(
                  width: 300.0,
                  margin: EdgeInsets.only(
                      top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
                  child: _tableType == 'L'
                      ? StreamBuilder<List<ItemStock>>(
                          stream: _itemDetailsBloc.itemStockLocalList,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ItemStock>> snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                              return Center(child: Text(snapshot.error));
                            }
                            return snapshot.hasData
                                ? _tableStockLocal()
                                : _myCircularProgress();
                          },
                        )
                      : StreamBuilder<bool>(
                          stream: _itemDetailsBloc.loadingData,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasError)
                              print(snapshot.error.toString());
                            return snapshot.hasData && !snapshot.data
                                ? StreamBuilder<List<ItemStock>>(
                                    stream: _itemDetailsBloc.itemStockAllList,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<ItemStock>>
                                            snapshot) {
                                      if (snapshot.hasError) {
                                        print(snapshot.error.toString());
                                        return Center(
                                            child: Text(snapshot.error));
                                      }
                                      return snapshot.hasData
                                          ? _tableStockAll(snapshot.data)
                                          : _myCircularProgress();
                                    },
                                  )
                                : _myCircularProgress();
                          },
                        )),
            ],
          )),
    );
  }

  /// Table for local stock
  Widget _tableStockLocal() {
    var _tableStock = new Table(
      border: TableBorder.all(color: Colors.grey, width: 1.0),
      children: [],
    );

    var _titleRow = TableRow(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        children: [
          Container(
            color: Color(0xff011e41),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Color',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xff011e41),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Talla',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xff011e41),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Local',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xff011e41),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Otros',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]);

    _tableStock.children.add(_titleRow);

    _tableStock.children.addAll(_itemDetailsBloc.itemStockLocalList.value
        .map((f) => TableRow(children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(f.color,
                      style: TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  f.size,
                  style: f.size == 'Total'
                      ? TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)
                      : TextStyle(fontSize: 10.0),
                ),
              )),
              Container(
                  color: f.itemId == _itemDetailsBloc.item.value.itemId
                      ? Colors.red
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Center(
                        child: Text(f.local == 0 ? '' : f.local.toString(),
                            style: _textStyleStock(f, 'L')),
                      ),
                      onTap: () {},
                    ),
                  )),
              InkWell(
                onTap: (){
                  if (f.itemId.isNotEmpty) {
                    _itemDetailsBloc.changeItemId(f.itemId);
                    _itemDetailsBloc.changeTypeReport('A');
                    _itemDetailsBloc.fetchItemStockAll(
                        f.itemId, _loginBloc.local.value.id);
                  }
                },
                child: Container(
                    color: f.itemId == _itemDetailsBloc.item.value.itemId
                        ? Colors.red
                        : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        f.others == 0 ? '' : f.others.toString(),
                        style: _textStyleStock(f, 'O'),
                      )),
                    )),
              ),
            ]))
        .toList());

    return _tableStock;
  }

  /// Table for all local stock
  Widget _tableStockAll(List<ItemStock> _listItemStock) {
    var _tableStock = new Table(
      border: TableBorder.all(color: Colors.grey, width: 1.0),
      children: [],
    );

    var _titleRow = TableRow(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        children: [
          Container(
            color: Color(0xff011e41),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Local',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xff011e41),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Stock',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]);

    _tableStock.children.add(_titleRow);

    _tableStock.children.addAll(_listItemStock
        .map((f) => TableRow(children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(f.color,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    f.local.toString(),
                    style: f.color == 'Total General'
                        ? TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
                        : TextStyle(fontSize: 12.0),
                  ),
                ),
              ))
            ]))
        .toList());

    return _tableStock;
  }

  /// Function to return a parameterized text style.
  TextStyle _textStyleStock(ItemStock _itemStock, String _column) {
    if (_itemStock.color == 'Total General')
      return TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.0);

    if (_itemStock.size == 'Total')
      return TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.0);

    if (_itemStock.itemId == _itemDetailsBloc.item.value.itemId)
      return TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0);

    if (_itemStock.color != 'Total' && _column == 'O')
      return TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
          fontSize: 12.0);

    return TextStyle(color: Colors.black, fontSize: 12.0);
  }

  Widget _myCircularProgress() {
    return Container(
        height: 80.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                ),
                child: new CircularProgressIndicator()),
          ],
        ));
  }
}
