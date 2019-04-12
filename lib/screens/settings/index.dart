import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/models/user.dart';

class SettingsHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  SettingsBloc _settingsBloc;

  @override
  void didChangeDependencies() {
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _settingsBloc.fetchUsersDevices();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                'Dispositivos del sistema',
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
      height: 300.0,
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
                  Container(
                    margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(child: Text(''),)
                        ],
                      )
                    ],),
                  )
                ],
              ),
            ),
      ),
    );
  }
}
