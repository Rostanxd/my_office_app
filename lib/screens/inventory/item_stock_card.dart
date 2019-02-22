import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item.dart' as mi;

class ItemStockCard extends StatefulWidget {
  final mi.Item _item;

  ItemStockCard(this._item);

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
    return Card(
        elevation: 5.0,
        child: Container(
            width: 300.0,
            margin: EdgeInsets.all(20.0),
            child: Table(
                border: TableBorder.all(width: 1.0, color: Colors.black),
                children: stocks
                    .map((s) => TableRow(children: [
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(s.color),
                                Text(s.size),
                                Text(s.local),
                                Text(s.others),
                              ],
                            ),
                          )
                        ]))
                    .toList())));
  }
}

class tableStock {
  String color;
  String size;
  String local;
  String others;

  tableStock(this.color, this.size, this.local, this.others);
}

var stocks = [
  tableStock('Color', 'Talla', 'Local', 'Others'),
  tableStock('Blue', '', '', ''),
  tableStock('', 'Medium', '', ''),
  tableStock('', '', '8', '4'),
];
