import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GradientBack extends StatelessWidget {

  String title = 'Title';
  String subtitleOne = 'Subtitle One';
  String subtitleTwo = 'Subtitle Two';
  MediaQueryData _queryData;
  double _queryMediaHeight, _queryMediaWidth;

  GradientBack(this.title, this.subtitleOne, this.subtitleTwo);

  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);
    _queryMediaHeight = _queryData.size.height;
    _queryMediaWidth = _queryData.size.width;
    return Container(
      height: _queryMediaHeight * 0.9,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFFD80000),
                Color(0xFFFF4040)
              ],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp
          )
      ),

      child: Container(
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: _queryMediaWidth * 0.06,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              this.subtitleOne,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: _queryMediaWidth * 0.05,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              this.subtitleTwo,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: _queryMediaWidth * 0.04,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),

      alignment: Alignment(-0.9, -0.9),

    );
  }
}