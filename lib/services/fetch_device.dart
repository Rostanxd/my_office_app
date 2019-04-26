import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/utils/connection.dart';

class DeviceApi {
  final _httpClient = new http.Client();

  Future<Device> fetchDevice(String id) async{
    print('fetchDevice >> $id');
    var response = await _httpClient.post(Connection.host + '/rest/WsManDispositivos',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"id": "$id"}));

    print('fetchDevice << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsDevices'] as List;

    /// Loading variable
    return responseList.map((f) => Device.fromJson((f))).toList()[0];
  }

  Future<List<Device>> fetchDevices() async{
    print('fetchDevice >>');
    var response = await _httpClient.post(Connection.host + '/rest/WsManDispositivos',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"id": ""}));

    print('fetchDevice << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Genexus response structure
    var responseList = gxResponse['SdtWsDevices'] as List;

    /// Loading variable
    return responseList.map((f) => Device.fromJson((f))).toList();
  }

  Future<String> postDevice(Device _device) async {

    List _deviceList = List();

    _deviceList.add(_device);

    print("postDevice >> ${json.encode({
      "SdtWsDevices": _deviceList
    })}");

    final response = await _httpClient.post(
      Connection.host + '/rest/WsManDispositivoPost',
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "SdtWsDevices": _deviceList
        }));

    print('postDevice << ${response.body}');

    return response.body;
  }

  Future<String> postUserDevice(String _userId, Device _device) async {
    List _deviceList = List();

    _deviceList.add(_device);

    print("postDevice >> ${json.encode({
      "userId": "$_userId",
      "SdtWsDevices": _deviceList
    })}");

    final response = await _httpClient.post(
        Connection.host + '/rest/WsManUsuarioDispositivoPost',
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": "$_userId",
          "SdtWsDevices": _deviceList
        }));

    print('postDevice << ${response.body}');

    return response.body;
  }
}