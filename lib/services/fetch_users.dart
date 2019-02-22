import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:my_office_th_app/factories/user.dart';
import 'package:my_office_th_app/models/user.dart' as m;
import 'package:my_office_th_app/utils/connection.dart' as con;

Future<List<User>> fetchUsers(http.Client client, String user, String password) async {
  final response = await client.post(
      con.Connection.host +  '/rest/WsLogin',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user":"$user", "password":"$password"})
  );

  return compute(parseUsers, response.body);
}

Future<m.User> fetchAnUser(http.Client client, String user, String password) async {
  var userModel;
  var response = await client.post(
      con.Connection.host +  '/rest/WsLogin',
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user":"$user", "password":"$password"})
  );

  print(response.body);

  Map<String, dynamic> mapResponse = json.decode(response.body);

  for (var i=0; i < mapResponse['SdtUsers'].length; i++){
    userModel = m.User(mapResponse['SdtUsers'][i]['user'],
        mapResponse['SdtUsers'][i]['name'],
        mapResponse['SdtUsers'][i]['level']);
  }

//  If we don't have connection with the server, or the user is bad.
  if (userModel == null){
    userModel = new m.User(
      'GUEST', 'GUEST', '0'
    );
  }

  return userModel;
}

List<User> parseUsers(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<User>((json) => User.fromJson(json)).toList();
}