import 'package:flutter/material.dart';

class GradientBack extends StatelessWidget {

  String title = 'Title';
  String subtitleOne = 'Subtitle One';
  String subtitleTwo = 'Subtitle Two';

  GradientBack(this.title, this.subtitleOne, this.subtitleTwo);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 350.0,
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
                  fontSize: 20.0,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              this.subtitleOne,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              this.subtitleTwo,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
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