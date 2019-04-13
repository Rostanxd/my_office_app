import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/models/user.dart';

class SettingsHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  MediaQueryData queryData;

  @override
  void didChangeDependencies() {
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _settingsBloc.fetchUsersDevices();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text('Configuración'),
          backgroundColor: Color(0xff011e41),
        ),
        drawer: UserDrawer(),
        body: ListView(
          children: <Widget>[_usersDevices()],
        ));
  }

  Widget _usersDevices() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Usuarios y dispositvos del sistema',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ),
            Divider(),
            StreamBuilder(
              stream: _settingsBloc.users,
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasError)
                  return Container(
                    child: Text('Error'),
                  );
                return snapshot.hasData
                    ? _userListView(snapshot.data)
                    : CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _userListView(List<User> _userList) {
    return Container(
      height: queryData.size.height * 0.5,
      child: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (BuildContext context, int index) => Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      '${_userList[index].user} - ${_userList[index].name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _userDevicesList(_userList[index].deviceList),
                  Divider(),
                ],
              ),
            ),
      ),
    );
  }

  Widget _userDevicesList(List<UserDevice> _deviceList) {
    Column _column = Column(
      children: <Widget>[],
    );

    _column.children.addAll(_deviceList
        .map((d) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(child: Text(d.deviceId)),
                Container(
                  child: Switch(
                    value: d.state == 'A' ? true : false,
                    onChanged: (bool e) => _changeUserDeviceState(d),
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

  bool _changeUserDeviceState(UserDevice d){
    _settingsBloc.postUserDeviceState(
        _loginBloc.user.value.user, d.deviceId, d.state == 'A' ? 'E' : 'A');
    return d.state == 'A' ? false : true;
  }
}
