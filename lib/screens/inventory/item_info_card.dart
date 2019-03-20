import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';

import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/components/gradient_back.dart';
import 'package:my_office_th_app/models/item.dart';
import 'package:my_office_th_app/screens/inventory/item_price_inkwell.dart';
import 'package:my_office_th_app/screens/inventory/item_image_foot.dart';
import 'package:my_office_th_app/screens/inventory/item_page_photos.dart';

class ItemInfoCard extends StatefulWidget {
  final Item item;

  ItemInfoCard(this.item);

  @override
  State<StatefulWidget> createState() {
    return ItemInfoCardState();
  }
}

class ItemInfoCardState extends State<ItemInfoCard> {
  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    return Card(
      elevation: 5.0,
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 400.0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: GradientBack(
                        widget.item.styleName,
                        widget.item.lineName +
                            ' \/ ' +
                            widget.item.productName,
                        widget.item.seasonName),
                  ),
                ),
                _itemImageList(),
                Container(
                    margin: EdgeInsets.only(top: 350.0, left: 10.0),
                    child: ItemImageFoot(widget.item,
                        _loginBloc.local.value, _loginBloc.user.value)),
                Container(
                    margin: EdgeInsets.only(top: 325.0, left: 200.0),
                    child: ItemPriceInkwell(widget.item)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemImageList(){
    return Container(
      height: 350.0,
      child: ListView(
        padding: EdgeInsets.only(
            top: 10,
            left: 25.0,
            bottom: 40.0
        ),
        scrollDirection: Axis.horizontal,
        children: widget.item.listImagesPath.length != 0 ? widget.item.listImagesPath.map((i) =>
            _imageCard(i)).toList() : _imageCard(''),
      ),
    );
  }

  Widget _imageCard(String imageUrl){
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
                    ItemPagePhotos(widget.item.listImagesPath)));
      },
    );
  }

}
