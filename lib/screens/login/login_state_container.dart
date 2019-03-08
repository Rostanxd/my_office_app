import 'package:flutter/material.dart';

import 'package:my_office_th_app/models/holding.dart';
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
  final Holding holding;
  final Local local;

  LoginStateContainer(
      {@required this.child, this.user, this.holding, this.local});

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
  Holding holding;
  Local local;

  void updateUser(User user) {
    if (this.user == null) {
      setState(() => this.user = user);
    }
  }

  void updateHolding(Holding holding) {
    if (this.holding == null) {
      setState(() => this.holding = holding);
    }
  }

  void updateLogin(Local local) {
    if (this.local == null) {
      setState(() => this.local = local);
    }
  }

  void logOut() {
    this.user = null;
    this.local = null;
    this.holding = null;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLoginStateContainer(data: this, child: widget.child);
  }
}
