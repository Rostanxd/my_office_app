import 'package:flutter/material.dart';

class ItemDeletePhoto extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemDeletePhotoState();
  }

}

class _ItemDeletePhotoState extends State<ItemDeletePhoto> {

  bool _pressed = false;

  void onPressedFav(){
//    Process to delete item's photo
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("Photo deleted!"))
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      backgroundColor: Color(0xff011e41),
      mini: true,
      tooltip: "Delete",
      onPressed: onPressedFav,
      child: Icon(
        Icons.delete
      ),
    );
  }

}