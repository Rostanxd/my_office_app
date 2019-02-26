import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item_stock.dart' as mi;

class ItemStockCard extends StatefulWidget {
  final List<mi.ItemStock> listItemStock;

  ItemStockCard(this.listItemStock);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemStockCardState();
  }
}

class _ItemStockCardState extends State<ItemStockCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var _tableStock = new Table(
      border: TableBorder.all(color: Colors.white),
      children: [],
    );

    var _titleRow = TableRow(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(2.0),
                  child: Text(
                    'Color',
                    style: TextStyle(
                        color: Color(0xff011e41), fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(2.0),
                  child: Text(
                    'Size',
                    style: TextStyle(
                        color: Color(0xff011e41), fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(2.0),
                  child: Text(
                    'Local',
                    style: TextStyle(
                        color: Color(0xff011e41), fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(2.0),
                  child: Text(
                    'Others',
                    style: TextStyle(
                        color: Color(0xff011e41), fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ]);

    _tableStock.children.add(_titleRow);

    _tableStock.children.addAll(widget.listItemStock
        .map((f) => TableRow(children: [
              TableCell(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 50.0,
                        margin: EdgeInsets.all(5.0),
                        child: Text(f.color, style: TextStyle(fontSize: 10.0)))
                  ],
                ),
              ),
              TableCell(
                child: Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          f.size,
                          style: f.size == 'Total'
                              ? TextStyle(
                                  fontSize: 10.0, fontWeight: FontWeight.bold)
                              : TextStyle(fontSize: 10.0),
                        ))
                  ],
                ),
              ),
              TableCell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(5.0),
                        child: InkWell(
                          child: Text(f.local == 0 ? '' : f.local.toString(),
                              style: f.size == 'Total'
                                  ? TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(fontSize: 10.0)),
                        ))
                  ],
                ),
              ),
              TableCell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(5.0),
                        child: InkWell(
                          child: Text(f.others == 0 ? '' : f.others.toString(),
                              style: f.size == 'Total'
                                  ? TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(fontSize: 10.0)),
                          onTap: () {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    f.others == 0 ? '' : f.others.toString())));
                          },
                        ))
                  ],
                ),
              ),
            ]))
        .toList());

    return Card(
        elevation: 5.0,
        child: Container(
            width: 300.0, margin: EdgeInsets.all(20.0), child: _tableStock));
  }
}
