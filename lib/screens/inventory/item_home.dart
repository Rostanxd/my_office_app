import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_office_th_app/models/user.dart' as mu;
import 'package:my_office_th_app/models/item.dart' as mi;
import 'package:my_office_th_app/screens/home/user_drawer.dart';
import 'package:my_office_th_app/screens/inventory/item_home_list_view.dart';

class ItemHome extends StatefulWidget {
  final mu.User user;

  ItemHome(this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemHomeState();
  }
}

class _ItemHomeState extends State<ItemHome> {
  String barcode = '';
  mi.Item item;
  ItemHomeListView itemHomeListView;

  Future barcodeScanning() async {
    try {
      var _barcode = await BarcodeScanner.scan();
      setState(() =>  this.barcode = _barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() => this.barcode = '');
      } else {
        setState(() => this.barcode = '');
      }
    } on FormatException {
      setState(() => this.barcode = '');
    } catch (e) {
      setState(() => this.barcode = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget cardEmpty = Align(
        alignment: Alignment.center,
        child: Container(
            height: 100.0,
            width: 200.0,
            child: Center(
                child: Text(
              'Search the item!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ))));

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(''),
          backgroundColor: Color(0xff011e41),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () {
                barcodeScanning();
              },
            )
          ],
        ),
        drawer: UserDrawer(widget.user),
        body: this.barcode.isNotEmpty ? ItemHomeListView(barcode) : cardEmpty,
      ),
    );
  }
}

//Implementation of search bar writing
class DataSearch extends SearchDelegate<String> {
  final cities = ['Milagro', 'Guayaquil', 'Quito', 'Manta', 'Cuenca'];
  final recentCities = ['Milagro', 'Guayaquil', 'Quito'];
  String itemStr;

  @override
  List<Widget> buildActions(BuildContext context) {
//    Actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
//    Leading icon on the left of the app
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //    Show some result based on the selection
    return ItemHomeListView(itemStr);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
//    Show when someone searches for something
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);
              this.itemStr = suggestionList[index].toString();
            },
            leading: Icon(Icons.location_city),
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ])),
          ),
      itemCount: suggestionList.length,
    );
  }
}
