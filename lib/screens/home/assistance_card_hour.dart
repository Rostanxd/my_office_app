import 'package:flutter/material.dart';

class AssistanceCardHour extends StatelessWidget {

  String pathIcon;
  String title;
  String hour;
  String state;

  AssistanceCardHour(this.pathIcon, this.title, this.hour, this.state);

  Color getColorState(String state){
    if (state == "Late!") {
      return Color(0xFFeb2227);
    } else if (state == "No record.") {
      return Color(0xFFffa200);
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final title = Container(
      margin: EdgeInsets.only(
        left: 20.0
      ),
      child: Text(
        this.title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: Color(0xff011e41)
        ),
      ),
    );

    final hour = Container(
      margin: EdgeInsets.only(
          left: 20.0
      ),
      child: Text(
        this.hour,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 13.0,
            color: Color(0xFFa3a5a7)
        ),
      ),
    );

    final comment = Container(
      margin: EdgeInsets.only(
          left: 20.0
      ),
      child: Text(
        this.state,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 13.0,
            color: getColorState(this.state)
        ),
      ),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title,
        hour,
        comment,
      ],
    );

    final photo = Container (
      margin: EdgeInsets.only(
          top: 20.0,
          left: 20.0
      ),

      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(this.pathIcon)
          )
      ),
    );

    return Row(
      children: <Widget>[
        photo,
        details
      ],
    );
  }

}