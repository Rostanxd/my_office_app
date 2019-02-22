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

    var _tableStock = new Table(
      border: TableBorder.all(color: Colors.white),
      children: [],
    );

    var _titleRow = TableRow(
      decoration: BoxDecoration(color: Colors.black),
        children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2.0),
              child: Text(
                'Color',
                style:
                    TextStyle(color: Color(0xff011e41), fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Color(0xff011e41), fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Color(0xff011e41), fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Color(0xff011e41), fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    ]);

    _tableStock.children.add(_titleRow);

    _tableStock.children.addAll(_dummyStock
        .map((f) => TableRow(children: [
              TableCell(
                child: Row(
                  children: <Widget>[
                    Container(margin: EdgeInsets.all(5.0), child: Text(f.color))
                  ],
                ),
              ),
              TableCell(
                child: Row(
                  children: <Widget>[
                    Container(margin: EdgeInsets.all(5.0), child: Text(f.size))
                  ],
                ),
              ),
              TableCell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(margin: EdgeInsets.all(5.0), child: InkWell(child: Text(f.local),
                    onTap: (){
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(f.local)));
                    },))
                  ],
                ),
              ),
              TableCell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(5.0), child: InkWell(child: Text(f.others),
                    onTap: (){
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(f.others)));
                    },))
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

class itemStock {
  String color;
  String size;
  String local;
  String others;

  itemStock(this.color, this.size, this.local, this.others);
}

var _dummyStock = [
  itemStock('Blue', '', '', ''),
  itemStock('', 'Small', '8', '4'),
  itemStock('', 'Medium', '2', '0'),
  itemStock('', 'Large', '5', '3'),
  itemStock('Total Blue', '', '15', '7'),
];
