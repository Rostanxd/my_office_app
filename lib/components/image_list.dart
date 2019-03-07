import 'package:flutter/material.dart';

import 'package:my_office_th_app/components/image_card.dart';

class ImageList extends StatelessWidget {

  final List<String> imageUrls;

  ImageList(this.imageUrls);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      child: ListView(
        padding: EdgeInsets.only(
            top: 10,
            left: 25.0,
            bottom: 40.0
        ),
        scrollDirection: Axis.horizontal,
        children: this.imageUrls.length != 0 ? imageUrls.map((i) =>
            ImageCard(i)).toList() : ImageCard(''),
      ),
    );
  }

}