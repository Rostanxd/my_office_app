import 'package:flutter/material.dart';

import 'package:my_office_th_app/blocs/inventory_bloc.dart';
import 'package:my_office_th_app/screens/inventory/item_details.dart';
import 'package:my_office_th_app/models/item.dart';

class ItemsStyleListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemsStyleListViewState();
}

class _ItemsStyleListViewState extends State<ItemsStyleListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: inventoryBloc.itemList,
      builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        /// Add to the item id string data
                        inventoryBloc
                            .changeCurrentItemId(snapshot.data[index].itemId);

                        /// Navigation to the item's detail
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemDetails()));
                      },
                      leading: Icon(Icons.open_in_new),
                      title: Text(snapshot.data[index].itemId),
                      subtitle: Text(
                        snapshot.data[index].styleName +
                            ' / ' +
                            snapshot.data[index].lineName,
                        style: TextStyle(fontSize: 10.00),
                      ),
                    ),
                itemCount: snapshot.data.length,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
