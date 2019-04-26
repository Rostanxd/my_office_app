import 'dart:async';

import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/services/fetch_device.dart';
import 'package:my_office_th_app/services/fetch_users.dart';

class SettingsRepository {
  final deviceApi = DeviceApi();
  final userApi = UserApi();

  Future<Device> fetchDeviceById(String id) => deviceApi.fetchDevice(id);

  Future<List<Device>> fetchDevices() => deviceApi.fetchDevices();

  Future<String> postDevice(Device device) => deviceApi.postDevice(device);

  Future<String> postUserDevice(String userId, Device device) =>
      deviceApi.postUserDevice(userId, device);

  Future<List<User>> fetchUsers() => userApi.fetchUsers();
}
