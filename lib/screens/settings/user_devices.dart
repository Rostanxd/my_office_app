import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/user.dart';

class UserDevices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserDevicesState();
}

class _UserDevicesState extends State<UserDevices> {
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
    _settingsBloc.fetchUsersDevices();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('UserDevices >> build');

    _settingsBloc.messageUsrDevice.listen((message) {
      if (message != null)
        _keyScaffold.currentState
            .showSnackBar(SnackBar(content: Text(message)));
    });

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text('Usuarios y sus dispositivos'),
          backgroundColor: Color(0xff011e41),
        ),
        body: _usersDevices());
  }

  Widget _usersDevices() {
    return StreamBuilder(
      stream: _settingsBloc.users,
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasError)
          return Container(
            child: Text('Error'),
          );
        return snapshot.hasData
            ? _userListView(snapshot.data)
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget _userListView(List<User> _userList) {
    return ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (BuildContext context, int index) => Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Card(
              elevation: 5.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 10.0),
                    child: Text(
                      '${_userList[index].user} - ${_userList[index].name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _userDevicesList(
                      _userList[index].user, _userList[index].deviceList),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              ),
            ),
          ),
    );
  }

  Widget _userDevicesList(String _userId, List<UserDevice> _deviceList) {
    Column _column = Column(
      children: <Widget>[],
    );

    _column.children.addAll(_deviceList
        .map((d) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text('${d.deviceId}')),
                Container(
                  child: Switch(
                    value: d.state == 'A' ? true : false,
                    onChanged: (bool e) => _changeUserDeviceState(_userId, d),
                    activeColor: Colors.green,
                  ),
                )
              ],
            ))
        .toList());

    return Container(
        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 20.0),
        child: _column);
  }

  bool _changeUserDeviceState(String _userId, UserDevice d) {
    _settingsBloc.postUserDeviceState(
        _userId, d.deviceId, d.state == 'A' ? 'I' : 'A');
    return d.state == 'A' ? false : true;
  }
}
