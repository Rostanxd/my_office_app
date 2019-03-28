import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';

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
  ItemDetailsBloc _itemDetailsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    /// Getting the bloc of the item details
    _itemDetailsBloc = BlocProvider.of<ItemDetailsBloc>(context);

    /// Listen the stream image file. Once we load a new image to the item
    /// We show a snack bar with a message and set null the stream
    _itemDetailsBloc.imageFile.listen((data) {
      if (data != null){
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Imagen cargada correctamente!')));
        _itemDetailsBloc.updateImageFile(null);
      }
    }).onError((error){
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(error)));
    });

    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: StreamBuilder(
            stream: _itemDetailsBloc.item,
            builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
              if (snapshot.hasError) return Center(child: Text(snapshot.error),);
              return snapshot.hasData ? _cardInfo() : CardDummyLoading();
            }));
  }

  Widget _itemImageList() {
    return Container(
      height: 450.0,
      child: ListView(
        padding: EdgeInsets.only(top: 10, left: 25.0, bottom: 40.0),
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
                  height: 450.0,
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
                    margin: EdgeInsets.only(top: 450.0, left: 10.0),
                    child: ItemImageFoot()),
                Container(
                    margin: EdgeInsets.only(top: 425.0, left: 200.0),
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
        height: 350.0,
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
                builder: (context) =>
                    ItemPagePhotos(_itemDetailsBloc.item.value.listImagesPath)));
      },
    );
  }
}
