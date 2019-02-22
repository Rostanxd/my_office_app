import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;

  InputFieldArea({this.hint, this.obscure, this.icon});

  @override
  Widget build(BuildContext context) {
    return (new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: Colors.black,
          ),
        ),
      ),
      child: new TextFormField(
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: "Lato"
        ),
        decoration: new InputDecoration(
          icon: new Icon(
            icon,
            color: Colors.black,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontFamily: "Lato"
          ),
          contentPadding: const EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
      ),
    ));
  }
}