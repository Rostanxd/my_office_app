import 'package:flutter/material.dart';

class FloatingActionButtonGreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FloatingActionButtonGreen();
  }

}

class _FloatingActionButtonGreen extends State<FloatingActionButtonGreen> {

  bool _pressed = false;

  void onPressedFav(){
    setState(() {
      _pressed = !this._pressed;
    });

    Scaffold.of(context).showSnackBar(
        this._pressed ? SnackBar(content: Text("Agregado a favoritos!")) :
        SnackBar(content: Text("Eliminado de tus favoritos!"))
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      backgroundColor: Color(0xff011e41),
      mini: true,
      tooltip: "Fav",
      onPressed: onPressedFav,
      child: Icon(
//          this.pressed ? Icons.favorite : Icons.favorite_border
        Icons.add
      ),
    );
  }

}