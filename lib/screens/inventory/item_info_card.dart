import 'package:flutter/material.dart';

import 'package:my_office_th_app/components/gradient_back.dart';
import 'package:my_office_th_app/components/image_list.dart';
import 'package:my_office_th_app/screens/inventory/price_inkwell.dart';
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
  List<String> itemImageUrls = [
    "https://www.gamepals.co/1467-thickbox_default/camiseta-tommy-hilfiger-color-blanco.jpg",
    "https://images-na.ssl-images-amazon.com/images/I/817mCj3EqhL._UL1500_.jpg",
    "https://i.ebayimg.com/images/g/FaoAAOSwa~hZZmbX/s-l300.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 5.0,
      child: Container(
        height: 400.0,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment(0.9, 1.2),
              children: <Widget>[
                GradientBack(
                    widget.item.styleName,
                    widget.item.lineName + ' \/ ' + widget.item.productName,
                    widget.item.seasonName),
                ImageList(this.itemImageUrls),
                PriceInkWell(widget.item)
              ],
            ),
            ItemImageFoot(widget.item)
          ],
        ),
      ),
    );
  }
}
