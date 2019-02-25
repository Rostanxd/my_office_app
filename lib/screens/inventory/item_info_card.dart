import 'package:flutter/material.dart';

import 'package:my_office_th_app/components/gradient_back.dart';
import 'package:my_office_th_app/components/image_list.dart';
import 'package:my_office_th_app/screens/inventory/item_price_inkwell.dart';
import 'package:my_office_th_app/screens/inventory/item_image_foot.dart';

import 'package:my_office_th_app/models/item.dart' as mi;

class ItemInfoCard extends StatefulWidget {
  final mi.Item item;

  ItemInfoCard(this.item);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return itemInfoCardDosState();
  }
}

class itemInfoCardDosState extends State<ItemInfoCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                        widget.item.lineName + ' \/ ' + widget.item.productName,
                        widget.item.seasonName),
                  ),
                ),
                ImageList(widget.item.listImagesPath),
                Container(
                    margin: EdgeInsets.only(top: 350.0, left: 10.0),
                    child: ItemImageFoot(widget.item)),
                Container(
                    margin: EdgeInsets.only(top: 325.0, left: 250.0),
                    child: ItemPriceInkwell(widget.item)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
