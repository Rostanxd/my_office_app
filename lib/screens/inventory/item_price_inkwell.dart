import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item.dart' as mi;

class ItemPriceInkwell extends StatefulWidget {
  final mi.Item item;

  ItemPriceInkwell(this.item);

  @override
  State<StatefulWidget> createState() => _ItemPriceInkwellState();
}

class _ItemPriceInkwellState extends State<ItemPriceInkwell> {
  bool _pressed = false;
  MediaQueryData _queryData;
  double _queryMediaWidth;

  void _changePrice() {
    setState(() {
      _pressed = !this._pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);
    _queryMediaWidth = _queryData.size.width;

    return InkWell(
        onTap: _changePrice,
        child: Container(
          height: 50.0,
          width: _queryMediaWidth * 0.35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                  colors: [Color(0xFF4268D3), Color(0xFF584cd1)],
                  begin: FractionalOffset(0.2, 0.0),
                  end: FractionalOffset(1.0, 0.6),
                  stops: [0.0, 0.6],
                  tileMode: TileMode.clamp)),
          child: Center(
            child: Text(
              this._pressed
                  ? 's/IVA \$ ' + widget.item.priceNoIva.toString()
                  : 'c/IVA \$ ' + widget.item.priceIva.toString(),
              style: TextStyle(
                  fontSize: _queryMediaWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ));
  }
}
