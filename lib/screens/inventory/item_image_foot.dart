import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/item_details_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';

class ItemImageFoot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemImageFootState();
  }
}

class _ItemImageFootState extends State<ItemImageFoot> {
  LoginBloc _loginBloc;
  ItemDetailsBloc _itemDetailsBloc;

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
                    _itemDetailsBloc.changeOriginPhoto(true);
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
                    _itemDetailsBloc.changeOriginPhoto(false);
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
    _itemDetailsBloc.changeLoadingImage(true);
    await ImagePicker.pickImage(
        source: _itemDetailsBloc.photoFromCamera.value
            ? ImageSource.camera
            : ImageSource.gallery).then((data) {
      _itemDetailsBloc.updateImageFile(data);
      _itemDetailsBloc.uploadStyleImage(_loginBloc.user.value.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Getting the login bloc
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    /// Getting the item details bloc
    _itemDetailsBloc = BlocProvider.of<ItemDetailsBloc>(context);

    /// Initialing variables in the bloc
    _itemDetailsBloc.changeOriginPhoto(false);

    _row = Row(
      children: <Widget>[
        StreamBuilder(
          stream: _itemDetailsBloc.loadingImage,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
            return snapshot.hasData ?
              snapshot.data ?
              CircularProgressIndicator() : InkWell(
                onTap: () {
                  _selectOriginPhoto();
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: Icon(Icons.add_a_photo),
                ),
              ) : InkWell(
              onTap: () {
                _selectOriginPhoto();
              },
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: Icon(Icons.add_a_photo),
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text('|'),
        )
      ],
    );

//    Loading stars
    var i = 1;
    for (i = 1; i <= _itemDetailsBloc.item.value.rank; i++) {
      this._row.children.add(Icon(
        Icons.star,
        color: Color(0xFFf2C611),
      ));

      if (i + 1 > _itemDetailsBloc.item.value.rank &&
          i != _itemDetailsBloc.item.value.rank) {
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
  void initState() {
    super.initState();
  }
}
