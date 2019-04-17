import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';

import 'package:my_office_th_app/models/item.dart';

class ItemPriceInkwell extends StatefulWidget {
  final Item item;

  ItemPriceInkwell(this.item);

  @override
  State<StatefulWidget> createState() => _ItemPriceInkwellState();
}

class _ItemPriceInkwellState extends State<ItemPriceInkwell> {
  SettingsBloc _settingsBloc;
  ItemDetailsBloc _itemDetailsBloc;
  bool _pressed = false;
  MediaQueryData _queryData;
  double _queryMediaWidth;

  @override
  void didChangeDependencies() {
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _itemDetailsBloc = BlocProvider.of<ItemDetailsBloc>(context);
    _queryData = _settingsBloc.queryData.value;
    _queryMediaWidth = _queryData.size.width;
    _itemDetailsBloc.changePriceBool(_pressed);
    super.didChangeDependencies();
  }

  void _changePrice() {
    _pressed = !_pressed;
    _itemDetailsBloc.changePriceBool(_pressed);
  }

  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder(
                  stream: _itemDetailsBloc.priceBool,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return snapshot.hasData && snapshot.data
                        ? Text(
                            'c/IVA \$ ${widget.item.priceIva.toString()}',
                            style: TextStyle(
                                fontSize: _queryMediaWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : Text(
                            's/IVA \$ ${widget.item.priceNoIva.toString()}',
                            style: TextStyle(
                                fontSize: _queryMediaWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                  })),
        ));
  }
}
