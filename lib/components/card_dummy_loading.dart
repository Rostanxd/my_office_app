import 'package:flutter/material.dart';

class CardDummyLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 100.0,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                ),
                child: new CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
