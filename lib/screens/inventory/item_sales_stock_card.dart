import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/inventory_bloc.dart';
import 'package:my_office_th_app/models/item_stock.dart';

class ItemSalesStockCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemSalesStockCardState();
}

class _ItemSalesStockCardState extends State<ItemSalesStockCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Card(
          elevation: 2.5,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                      EdgeInsets.only(top: 20.0, left: 20.0, bottom: 5.0),
                      child: Text(
                        'Stock and Sales',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Container(
                    width: 300.0,
                    margin: EdgeInsets.only(
                        top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
                    child: StreamBuilder<List<ItemStock>>(
                      stream: inventoryBloc.itemStockSaleList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ItemStock>> snapshot) {
                        if (snapshot.hasError) print(snapshot.error.toString());
                        return snapshot.hasData ?
                        _tableStockSales(snapshot.data) : _myCircularProgress();
                      },
                    )),
              ])),
    );
  }

  Widget _tableStockSales(List<ItemStock> _itemStockSaleList) {
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
                  'Ing',
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
                  'Vta',
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
                  'Sld',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]);

    _tableStock.children.add(_titleRow);

    _tableStock.children.addAll(_itemStockSaleList
        .map((f) =>
        TableRow(children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(f.color,
                  style: TextStyle(
                      fontSize: 10.0, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: f.local == 0
                    ? Text('')
                    : Text(
                  f.local.toString(),
                  style: f.size == 'Total' || f.color == 'Total'
                      ? TextStyle(
                      fontSize: 10.0, fontWeight: FontWeight.bold)
                      : TextStyle(fontSize: 10.0),
                ),
              )),
          Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: f.others == 0
                    ? Text('')
                    : Text(
                  f.others.toString(),
                  style: f.size == 'Total' || f.color == 'Total'
                      ? TextStyle(
                      fontSize: 10.0, fontWeight: FontWeight.bold)
                      : TextStyle(fontSize: 10.0),
                ),
              )),
          Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Center(
                      child: f.local == 0 && f.others == 0
                          ? Text('')
                          : Text(
                        (f.local - f.others).toString(),
                        style: f.size == 'Total' || f.color == 'Total'
                            ? TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold)
                            : TextStyle(fontSize: 10.0),
                      )),
                  onTap: () {},
                ),
              )),
        ]))
        .toList());

    return _tableStock;
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
