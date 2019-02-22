import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item.dart' as mi;

class PriceInkWell extends StatefulWidget {
  final mi.Item item;

  PriceInkWell(this.item);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PriceInkWellState();
  }
}

class _PriceInkWellState extends State<PriceInkWell> {
  bool pressed = false;

  void _changePrice() {
    setState(() {
      pressed = !this.pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: _changePrice,
        child: Container(
          height: 50.0,
          width: 125.0,
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
              this.pressed
                  ? 'c/IVA \$ ' + widget.item.priceIva.toString()
                  : 's/IVA \$ ' + widget.item.priceNoIva.toString(),
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ));
  }
}
