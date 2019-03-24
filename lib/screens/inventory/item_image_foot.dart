import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as im;

import 'package:my_office_th_app/utils/connection.dart';

import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/models/local.dart' as ml;
import 'package:my_office_th_app/models/user.dart' as mu;

import 'package:my_office_th_app/screens/inventory/item_details.dart';

class ItemImageFoot extends StatefulWidget {
  final mi.Item item;
  final ml.Local local;
  final mu.User user;

  ItemImageFoot(this.item, this.local, this.user);

  @override
  State<StatefulWidget> createState() {
    return _ItemImageFootState();
  }
}

class _ItemImageFootState extends State<ItemImageFoot> {
  final String postStyleImage = Connection.host + '/rest/WsEstiloImagenPost';

  File _photo, _photoThumb;
  bool _camera = false;
  var _container = new Container();
  var _row = new Row();

  Future _selectOriginPhoto() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Pick the image source'),
            contentPadding: EdgeInsets.all(25.0),
            children: <Widget>[
              RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => this._camera = true);
                    _getImage();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.cyan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Icon(Icons.add_a_photo),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          'From camera',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )),
              RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => this._camera = false);
                    _getImage();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Icon(Icons.filter),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          'From gallery',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          );
        });
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(
        source: this._camera ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      _photo = image;
      _upload();
    });
  }

  void _upload() {
    if (_photo == null) {
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: Text('No photo to load...')));
      return;
    }

    im.Image _image = im.decodeImage(_photo.readAsBytesSync());
    im.Image _thumbnail = im.copyResize(_image, 500);

    _photoThumb = _photo
      ..writeAsBytesSync(im.encodeJpg(_thumbnail, quality: 50));

    String _styleId = widget.item.styleId;
    String _imageBase64 = base64Encode(_photoThumb.readAsBytesSync());
    String _imageName = _photoThumb.path.split("/").last;
    String _user = widget.user.user;

    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: Text('Loading new photo...')));

    http
        .post(postStyleImage,
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "styleId": "$_styleId",
              "imgName": "$_imageName",
              "imgExtension": ".jpg",
              "user": "$_user",
              "image64": "$_imageBase64"
            }))
        .then((res) {
      /// Navigation to recall the item's detail and reload the list images
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemDetails(widget.item.itemId)));
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    _row = Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            _selectOriginPhoto();
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Icon(Icons.add_a_photo),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text('|'),
        )
      ],
    );

//    Loading stars
    var i = 1;
    for (i = 1; i <= widget.item.rank; i++) {
      this._row.children.add(Icon(
            Icons.star,
            color: Color(0xFFf2C611),
          ));

      if (i + 1 > widget.item.rank && i != widget.item.rank) {
        this._row.children.add(Icon(
              Icons.star_half,
              color: Color(0xFFf2C611),
            ));
      }
    }

    for (var j = this._row.children.length; j <= 6; j++) {
      this._row.children.add(Icon(
            Icons.star_border,
            color: Color(0xFFf2C611),
          ));
    }

    this._container = Container(
      margin: EdgeInsets.all(5.0),
      child: this._row,
    );

    return this._container;
  }

  @override
  void initState() {}
}
