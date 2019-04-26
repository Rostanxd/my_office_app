import 'package:flutter/material.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/screens/settings/devices.dart';
import 'package:my_office_th_app/screens/settings/user_devices.dart';

class SettingsHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  @override
  void initState() {
    print('SettingsHomeState >> initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('SettingsHomeState >> didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('SettingsHomeState >> build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        backgroundColor: Color(0xff011e41),
      ),
      drawer: UserDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
            child: Text(
              'Dispositivos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text(
              'Control de dispositivos',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: Text('Información, activar e inactivar dispositivos'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Devices()));
            },
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            title: Text('Control de usuarios y sus dispositivos',
                style: TextStyle(fontSize: 16)),
            subtitle: Text('Activar/Inactivar dispositivos por usuario'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserDevices()));
            },
            trailing: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}
