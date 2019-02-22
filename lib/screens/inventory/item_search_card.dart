import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_office_th_app/models/item.dart';

class ItemSearchCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemSearchCardState();
  }
}

class _ItemSearchCardState extends State<ItemSearchCard> {
  TextEditingController _itmController = new TextEditingController();
  Item _item;

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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
}
