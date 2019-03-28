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

  /// Dialog to ask user what is the photo origin.
  Future _selectOriginPhoto() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Escoja el origen de la image'),
            contentPadding: EdgeInsets.all(25.0),
            children: <Widget>[
              RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    /// Close the dialog
                    Navigator.pop(context);

                    /// Update the stream who determinate what is the image origin.
                    _itemDetailsBloc.changeOriginPhoto(true);

                    /// Call the function to search the image.
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
                          'Desde cámara',
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
                    /// Close the dialog
                    Navigator.pop(context);

                    /// Update the stream who determinate what is the image origin.
                    _itemDetailsBloc.changeOriginPhoto(false);

                    /// Call the function to search the image
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
                          'Desde galería',
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
    /// Updating the stream to enabled the camera button
    _itemDetailsBloc.changeLoadingImage(true);

    /// Calling the pick image plugin
    await ImagePicker.pickImage(
            source: _itemDetailsBloc.photoFromCamera.value
                ? ImageSource.camera
                : ImageSource.gallery)
        .then((data) {
      _itemDetailsBloc.uploadStyleImage(_loginBloc.user.value.user, data);
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

    /// Listen the stream image file
    _itemDetailsBloc.imageFile.listen((data) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Archivo ${data.path.split("/").last} cargado correctamente!')));
    });

    _row = Row(
      children: <Widget>[
        StreamBuilder(
          stream: _itemDetailsBloc.loadingImage,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return snapshot.hasData && snapshot.data
                ? InkWell(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      _selectOriginPhoto();
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.black,
                      ),
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

    /// Loading stars
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
