import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/models/user.dart';

class _InheritedLoginStateContainer extends InheritedWidget {
  final LoginStateContainerState data;

  _InheritedLoginStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedLoginStateContainer oldWidget) => true;
}

class LoginStateContainer extends StatefulWidget {
  final Widget child;
  final User user;
  final Local local;

  LoginStateContainer({@required this.child, this.user, this.local});

  static LoginStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedLoginStateContainer)
            as _InheritedLoginStateContainer)
        .data;
  }

  @override
  State<StatefulWidget> createState() => LoginStateContainerState();
}

class LoginStateContainerState extends State<LoginStateContainer> {
  User user;
  Local local;

  @override
  Widget build(BuildContext context) {
    this.user = widget.user;
    this.local = widget.local;

    return _InheritedLoginStateContainer(data: this, child: widget.child);
  }
}
