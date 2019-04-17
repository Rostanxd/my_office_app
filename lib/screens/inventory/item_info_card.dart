import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';

import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/components/gradient_back.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/screens/inventory/item_price_inkwell.dart';
import 'package:my_office_th_app/screens/inventory/item_image_foot.dart';
import 'package:my_office_th_app/screens/inventory/item_page_photos.dart';

class ItemInfoCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ItemInfoCardState();
  }
}

class ItemInfoCardState extends State<ItemInfoCard> {
  SettingsBloc _settingsBloc;
  ItemDetailsBloc _itemDetailsBloc;
  MediaQueryData _queryData;
  double _queryMediaWidth, _queryMediaHeight;

  @override
  void didChangeDependencies() {
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _itemDetailsBloc = BlocProvider.of<ItemDetailsBloc>(context);
    _queryData = _settingsBloc.queryData.value;
    _queryMediaWidth = _queryData.size.width;
    _queryMediaHeight = _queryData.size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: StreamBuilder(
            stream: _itemDetailsBloc.item,
            builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text(snapshot.error),
                );
              return snapshot.hasData ? _cardInfo() : CardDummyLoading();
            }));
  }

  Widget _itemImageList() {
    return Container(
      height: _queryMediaHeight * 0.65,
      child: ListView(
        padding: EdgeInsets.only(top: 20, left: 25.0, bottom: 40.0),
        scrollDirection: Axis.horizontal,
        children: _itemDetailsBloc.item.value.listImagesPath.length != 0
            ? _itemDetailsBloc.item.value.listImagesPath
                .map((i) => _imageCard(i))
                .toList()
            : _imageCard(''),
      ),
    );
  }

  Widget _cardInfo() {
    return Card(
      elevation: 5.0,
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: _queryMediaHeight * 0.66,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: GradientBack(
                        _itemDetailsBloc.item.value.styleName,
                        _itemDetailsBloc.item.value.lineName +
                            ' \/ ' +
                            _itemDetailsBloc.item.value.productName,
                        _itemDetailsBloc.item.value.seasonName),
                  ),
                ),
                _itemImageList(),
                Container(
                    margin: EdgeInsets.only(
                        top: _queryMediaHeight * 0.655, left: 10.0),
                    child: ItemImageFoot()),
                Container(
                    margin: EdgeInsets.only(
                        top: _queryMediaHeight * 0.625,
                        left: _queryMediaWidth * 0.55),
                    child: ItemPriceInkwell(_itemDetailsBloc.item.value)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageCard(String imageUrl) {
    return InkWell(
      child: Container(
        height: _queryMediaHeight * 0.60,
        width: 250.0,
        margin: EdgeInsets.only(top: 80, left: 20.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.scaleDown,
                image: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/img/noImageAvailable.jpg')),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 7.0))
            ]),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemPagePhotos(
                    _itemDetailsBloc.item.value.listImagesPath)));
      },
    );
  }
}
