import 'package:flutter/material.dart';

import 'package:my_office_th_app/components/gradient_back.dart';
import 'package:my_office_th_app/components/image_list.dart';
import 'package:my_office_th_app/screens/inventory/item_price_inkwell.dart';
import 'package:my_office_th_app/screens/inventory/item_image_foot.dart';
import 'package:my_office_th_app/screens/inventory/item_state_container.dart';

import 'package:my_office_th_app/screens/login/login_state_container.dart';

class ItemInfoCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ItemInfoCardState();
  }
}

class ItemInfoCardState extends State<ItemInfoCard> {
  @override
  Widget build(BuildContext context) {
//    Getting data from the item sate container
    final containerItem = ItemStateContainer.of(context);
//    Getting data from the login sate container
    final containerLogin = LoginStateContainer.of(context);

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
                        containerItem.item.styleName,
                        containerItem.item.lineName +
                            ' \/ ' +
                            containerItem.item.productName,
                        containerItem.item.seasonName),
                  ),
                ),
                ImageList(containerItem.item.listImagesPath),
                Container(
                    margin: EdgeInsets.only(top: 350.0, left: 10.0),
                    child: ItemImageFoot(containerItem.item,
                        containerLogin.local, containerLogin.user)),
                Container(
                    margin: EdgeInsets.only(top: 325.0, left: 200.0),
                    child: ItemPriceInkwell(containerItem.item)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
