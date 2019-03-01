import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;

  ImageCard(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final card = Container(
      height: 350.0,
      width: 250.0,
      margin: EdgeInsets.only(top: 80, left: 20.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: this.imageUrl.isNotEmpty
                  ? NetworkImage(this.imageUrl)
                  : AssetImage('assets/img/noImageAvailable.jpg')),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset(0.0, 7.0))
          ]),
    );

    return card;
  }
}
