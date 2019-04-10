import 'dart:async';

import 'package:my_office_th_app/models/binnacle.dart';
import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/services/fetch_device.dart';
import 'package:my_office_th_app/services/fetch_binnacles.dart';

class SettingsRepository {
  final deviceApi = DeviceApi();
  final binnacleApi = BinnacleApi();

  Future<Device> fetchDeviceById(String id) => deviceApi.fetchDevice(id);

  Future<String> postBinnacle(Binnacle binnacle) =>
      binnacleApi.postBinnacle(binnacle);
}
