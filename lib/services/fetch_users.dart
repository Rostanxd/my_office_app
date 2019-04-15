import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/utils/connection.dart';

class UserApi {
  final _httpClient = new http.Client();

  Future<User> fetchUser(String id, String password) async {
    User user;
    List<UserDevice> deviceList = List<UserDevice>();

    print('fetchUser >> $id $password');

    var response = await _httpClient.post(Connection.host + '/rest/WsManLogin',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"user": "$id", "password": "$password"}));

    print('fetchUser << ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    if (gxResponse['SdtUsers'].length > 0){
      var responseDeviceList = gxResponse['SdtUsers'][0]['deviceList'] as List;
      deviceList = responseDeviceList.map((d) => UserDevice.fromJson(d)).toList();
      user = User(
          gxResponse['SdtUsers'][0]['user'],
          gxResponse['SdtUsers'][0]['name'],
          gxResponse['SdtUsers'][0]['level'],
          gxResponse['SdtUsers'][0]['accessId'],
          gxResponse['SdtUsers'][0]['sellerId'],
          Holding(gxResponse['SdtUsers'][0]['holdingId'],
              gxResponse['SdtUsers'][0]['holdingName']),
          Local(gxResponse['SdtUsers'][0]['localId'],
              gxResponse['SdtUsers'][0]['localName']),
          gxResponse['SdtUsers'][0]['identification'],
          deviceList,
          gxResponse['SdtUsers'][0]['ipPrefix']);
    }
    return user;
  }

  Future<List<User>> fetchUsers() async {
    List<User> _userList = List();

    print('fetchUsers >> [no params]');

    var response = await _httpClient.post(Connection.host + '/rest/WsManUsuariosDis',
        headers: {"Content-Type": "application/json"},);

    print('fetchUsers << ' + response.body);

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtUsers'] as List;

    /// Loading the list from the response
    _userList = responseList.map((f) => User.fromJson((f))).toList();

    return _userList;
  }
}
