import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_office_th_app/models/user.dart' as mu;
import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/screens/home/user_drawer.dart';
import 'package:my_office_th_app/screens/inventory/item_info_card.dart';
import 'package:my_office_th_app/screens/inventory/item_stock_card.dart';

class ItemHome extends StatefulWidget {

  final mu.User _user;

  ItemHome(this._user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemHomeState();
  }
}

class _ItemHomeState extends State<ItemHome> {

  Card _searchCard = new Card();
  TextEditingController _itmController = new TextEditingController();
  mi.Item _item;

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this._itmController.text = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._itmController.text = 'No camera permission!';
        });
      } else {
        setState(() => this._itmController.text = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this._itmController.text = 'Nothing captured.');
    } catch (e) {
      setState(() => this._itmController.text = 'Unknown error: $e');
    }
  }

  @override
  void initState() {
    this._item = new mi.Item(
        'TH CORE FLAG',
        'TH CORE FLAG',
        'ACCESORIES MEN',
        'CAMISETAS',
        'SPRING 2017',
        40.00,
        44.80,
        "https://www.gamepals.co/1467-thickbox_default/camiseta-tommy-hilfiger-color-blanco.jpg");

    this._searchCard = new Card(
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          Form(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    bottom: 20.0,
                  ),
                  child: Text(
                    'Item:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 150.0,
                  margin: EdgeInsets.only(
                      top: 20.0, left: 10.0, right: 20.0, bottom: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    controller: _itmController,
                  ),
                ),
                Container(
                  child: new RaisedButton(
                      onPressed: barcodeScanning, child: Icon(Icons.search)),
                  padding: const EdgeInsets.all(8.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(''),
        ),
        drawer: UserDrawer(widget._user),
        body: ListView(
          children: <Widget>[
            this._searchCard,
            ItemInfoCard(this._item),
            ItemStockCard(this._item),
          ],
        ),
      ),
    );
  }
}
