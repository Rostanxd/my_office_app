import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';

class DeviceInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  SettingsBloc _settingsBloc;

  @override
  Widget build(BuildContext context) {
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Información del dispositivo'),
        backgroundColor: Color(0xff011e41),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Platform.isAndroid ? StreamBuilder<AndroidDeviceInfo>(
          stream: _settingsBloc.androidDeviceInfo,
          builder: (BuildContext context,
              AsyncSnapshot<AndroidDeviceInfo> snapshot) {
            return snapshot.hasData
                ? _deviceAndroidInfo(snapshot.data)
                : CircularProgressIndicator();
          },
        ) : StreamBuilder<IosDeviceInfo>(
          stream: _settingsBloc.iosDeviceInfo,
          builder: (BuildContext context,
              AsyncSnapshot<IosDeviceInfo> snapshot) {
            return snapshot.hasData
                ? _deviceIosInfo(snapshot.data)
                : CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _deviceAndroidInfo(AndroidDeviceInfo data) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Model'),
          subtitle: Text(data.model),
        ),
        Divider(),
        ListTile(
          title: Text('Id'),
          subtitle: Text(data.id),
        ),
        Divider(),
        ListTile(
          title: Text('Type'),
          subtitle: Text(data.type),
        ),
        Divider(),
        ListTile(
          title: Text('Host'),
          subtitle: Text(data.host),
        ),
        Divider(),
        ListTile(
          title: Text('Android Id'),
          subtitle: Text(data.androidId),
        ),
        Divider(),
        ListTile(
          title: Text('Board'),
          subtitle: Text(data.board),
        ),
        Divider(),
        ListTile(
          title: Text('Boot Loader'),
          subtitle: Text(data.bootloader),
        ),
        Divider(),
        ListTile(
          title: Text('Type'),
          subtitle: Text(data.brand),
        ),
        Divider(),
        ListTile(
          title: Text('Device'),
          subtitle: Text(data.device),
        ),
        Divider(),
        ListTile(
          title: Text('Display'),
          subtitle: Text(data.display),
        ),
        Divider(),
        ListTile(
          title: Text('Fingerprint'),
          subtitle: Text(data.fingerprint),
        ), Divider(),
        ListTile(
          title: Text('Hardware'),
          subtitle: Text(data.hardware),
        ),
        Divider(),
        ListTile(
          title: Text('Is Physical Device ?'),
          subtitle: Text(data.isPhysicalDevice.toString()),
        ),
        Divider(),
        ListTile(
          title: Text('Manufacturer'),
          subtitle: Text(data.manufacturer),
        ),
        Divider(),
        ListTile(
          title: Text('Product'),
          subtitle: Text(data.product),
        ),
        Divider(),
        ListTile(
          title: Text('Tags'),
          subtitle: Text(data.tags),
        ),
        Divider(),
        ListTile(
          title: Text('Version'),
          subtitle: Text(data.version.sdkInt.toString()),
        ),
        Divider(),
        ListTile(
          title: Text('Ip'),
          subtitle: Text(_settingsBloc.myIp.value),
        ),
      ],
    );
  }

  Widget _deviceIosInfo(IosDeviceInfo data) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Model'),
          subtitle: Text(data.model),
        ),
        Divider(),
        ListTile(
          title: Text('Id'),
          subtitle: Text(data.identifierForVendor),
        ),
        Divider(),
        ListTile(
          title: Text('Ip'),
          subtitle: Text(_settingsBloc.myIp.value),
        ),
      ],
    );
  }
}
