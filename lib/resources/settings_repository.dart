import 'dart:async';

import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/services/fetch_device.dart';

class SettingsRepository {
  final deviceApi = DeviceApi();

  Future<Device> fetchDeviceById(String id) => deviceApi.fetchDevice(id);
}
