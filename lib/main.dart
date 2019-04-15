import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/screens/home/index.dart';
import 'package:my_office_th_app/screens/inventory/index.dart';
import 'package:my_office_th_app/screens/login/index.dart';
import 'package:my_office_th_app/screens/settings/device_info.dart';
import 'package:my_office_th_app/screens/settings/index.dart';
import 'package:my_office_th_app/screens/settings/signup.dart';

void main() => runApp(BlocProvider<SettingsBloc>(
    bloc: settingsBloc,
    child: BlocProvider<LoginBloc>(bloc: loginBloc, child: MyApp())));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// To set-up vertical orientation (portrait).
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) =>
            new MyLoginPage(settingsBloc, loginBloc),
        '/signup': (BuildContext context) => new SignupPage(),
        '/home': (BuildContext context) => new HomePage(),
        '/item_home': (BuildContext context) => new InventoryHome(),
        '/device_info': (BuildContext context) => new DeviceInfo(),
        '/settings': (BuildContext context) => new SettingsHome(),
      },
      home: MyLoginPage(settingsBloc, loginBloc),
    );
  }
}
