import 'package:flutter/material.dart';

import 'package:my_office_th_app/components/gradient_back.dart';
import 'package:my_office_th_app/components/image_list.dart';
import 'package:my_office_th_app/screens/inventory/item_price_inkwell.dart';
import 'package:my_office_th_app/screens/inventory/item_image_foot.dart';
import 'package:my_office_th_app/screens/inventory/item_state_container.dart';

import 'package:my_office_th_app/models/local.dart' as ml;
import 'package:my_office_th_app/models/user.dart' as mu;

class ItemInfoCard extends StatefulWidget {
  final ml.Local local;
  final mu.User user;

  ItemInfoCard(this.local, this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemInfoCardState();
  }
}

class ItemInfoCardState extends State<ItemInfoCard> {
  @override
  Widget build(BuildContext context) {

//    Getting data from the item sate container
    final container = ItemStateContainer.of(context);

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
                        container.item.styleName,
                        container.item.lineName + ' \/ ' + container.item.productName,
                        container.item.seasonName),
                  ),
                ),
                ImageList(container.item.listImagesPath),
                Container(
                    margin: EdgeInsets.only(top: 350.0, left: 10.0),
                    child:
                        ItemImageFoot(container.item, widget.local, widget.user)),
                Container(
                    margin: EdgeInsets.only(top: 325.0, left: 200.0),
                    child: ItemPriceInkwell(container.item)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
