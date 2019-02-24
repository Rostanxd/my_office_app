import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item.dart' as mi;

class ItemImageFoot extends StatefulWidget {

  final mi.Item item;

  ItemImageFoot(this.item);

  @override
  State<StatefulWidget> createState() {

    // TODO: implement createState
    return _ItemImageFootState();
  }
}

class _ItemImageFootState extends State<ItemImageFoot> {

  var _container = new Container();
  var _row = new Row();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _row = Row(
      children: <Widget>[
        InkWell(
          onTap: (){
            Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Calling camera!')));
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Icon(
                Icons.camera_enhance
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text('|'),
        )
      ],
    );

//    Loading stars
    var i = 1;
    for (i = 1; i <= widget.item.rank; i++) {

      this._row.children.add(Icon(
        Icons.star,
        color: Color(0xFFf2C611),
      ));

      if ( i + 1 > widget.item.rank && i != widget.item.rank) {
        this._row.children.add(Icon(
          Icons.star_half,
          color: Color(0xFFf2C611),
        ));
      }
    }

    for (var j = this._row.children.length; j <= 6; j++){
      this._row.children.add(Icon(
        Icons.star_border,
        color: Color(0xFFf2C611),
      ));
    }


    this._container = Container(
      margin: EdgeInsets.all(5.0),
      child: this._row,
    );

    return this._container;
  }

  @override
  void initState() {

  }
}
