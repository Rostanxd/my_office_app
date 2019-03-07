import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/item.dart';

class _InheritedItemStateContainer extends InheritedWidget {
  final ItemStateContainerState data;

  _InheritedItemStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedItemStateContainer oldWidget) => true;
}

class ItemStateContainer extends StatefulWidget {
  final Widget child;
  final Item item;

  ItemStateContainer({@required this.child, this.item});

  static ItemStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedItemStateContainer)
            as _InheritedItemStateContainer)
        .data;
  }

  @override
  State<StatefulWidget> createState() => ItemStateContainerState();
}

class ItemStateContainerState extends State<ItemStateContainer> {

  Item item;

  @override
  Widget build(BuildContext context) {
    this.item = widget.item;
    return _InheritedItemStateContainer(data: this, child: widget.child);
  }
}
