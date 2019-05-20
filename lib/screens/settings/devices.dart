import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/device.dart';

class Devices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  SettingsBloc _settingsBloc;
  GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print('UserDevices >> initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('UserDevices >> didChangeDependencies');
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _settingsBloc.fetchDevices();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Devices >> build');

    _settingsBloc.messageDevice.listen((message) {
      if (message != null)
        _keyScaffold.currentState
            .showSnackBar(SnackBar(content: Text(message)));
    });

    return Scaffold(
        key: _keyScaffold,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text('Dispositivos del sistema'),
          backgroundColor: Color(0xff011e41),
        ),
        body: _devices());
  }

  /// List of devices
  Widget _devices() {
    return StreamBuilder(
      stream: _settingsBloc.devices,
      builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
        if (snapshot.hasError)
          return Container(
            margin: EdgeInsets.all(10.0),
            child: Text(snapshot.error),
          );

        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _deviceCard(snapshot.data[index]);
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  /// Card for each device
  Widget _deviceCard(Device _device) {
    TextEditingController _modelCtrl =
        TextEditingController(text: _device.model);
    TextEditingController _iosCtrl = TextEditingController(text: _device.ios);
    TextEditingController _versionCtrl =
        TextEditingController(text: _device.version);
    TextEditingController _nameCtrl = TextEditingController(text: _device.name);
    TextEditingController _dateCtrl =
        TextEditingController(text: _device.dateUpdated);

    return Container(
      margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    width: _settingsBloc.queryData.value.size.width * 0.5,
                    child: Text(
                      _device.id,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    child: Switch(
                      value: _device.state == 'A' ? true : false,
                      onChanged: (bool e) => _changeDeviceState(_device),
                      activeColor: Colors.green,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                  enabled: false,
                  controller: _modelCtrl,
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011e41))),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                  enabled: false,
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011e41))),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                  enabled: false,
                  controller: _iosCtrl,
                  decoration: InputDecoration(
                    labelText: 'Sistema',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011e41))),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                  enabled: false,
                  controller: _versionCtrl,
                  decoration: InputDecoration(
                    labelText: 'Versión',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011e41))),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: TextField(
                  enabled: false,
                  controller: _dateCtrl,
                  decoration: InputDecoration(
                    labelText: 'Última actualización',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011e41))),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  bool _changeDeviceState(Device _device) {
    _settingsBloc.postDeviceState(_device, _device.state == 'A' ? 'I' : 'A');
    return _device.state == 'A' ? false : true;
  }
}
