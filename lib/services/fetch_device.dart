import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/utils/connection.dart';

class DeviceApi {
  final _httpClient = new http.Client();

  Future<Device> fetchDevice(String id) async{
    Device _device;
    print('fetchDevice >> $id');
    var response = await _httpClient.post(Connection.host + '/rest/WsManDispositivos',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"id": "$id"}));

    print('fetchDevice << ${response.body}');

    /// To get easily the gx response
    Map<String, dynamic> gxResponse = json.decode(response.body);

    /// Loading variable
    _device = Device(
      gxResponse['SdtWsDevices'][0]['id'],
      gxResponse['SdtWsDevices'][0]['state'],
      gxResponse['SdtWsDevices'][0]['ios'],
      gxResponse['SdtWsDevices'][0]['version'],
      gxResponse['SdtWsDevices'][0]['model'],
      gxResponse['SdtWsDevices'][0]['name'],
      gxResponse['SdtWsDevices'][0]['isPhysic'],
      gxResponse['SdtWsDevices'][0]['userCreated'],
      gxResponse['SdtWsDevices'][0]['dateCreated'],
      gxResponse['SdtWsDevices'][0]['userUpdated'],
      gxResponse['SdtWsDevices'][0]['dateUpdated']
    );

    return _device;
  }
}