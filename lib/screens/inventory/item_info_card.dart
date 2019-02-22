import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item.dart' as mi;

class ItemInfoCard extends StatelessWidget {
  final mi.Item _item;

  ItemInfoCard(this._item);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 5.0,
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 5.0
                      ),
                      child: Text(
                        'Information',
                        style: TextStyle(fontSize: 18.0,
                            fontWeight: FontWeight.bold, color: Color(0xff011e41))
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Style Name: ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this._item.styleName,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Line: ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this._item.lineName,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Product: ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this._item.productName,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Season: ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this._item.seasonName,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Price No Iva: ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$ " + this._item.priceNoIva.toString(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Price No Iva: ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this._item.priceIva.toString(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  width: 100.0,
                  alignment: Alignment(0, 0),
                  child: Image(
                    image: NetworkImage(this._item.imagePath),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
