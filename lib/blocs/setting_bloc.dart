import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/resources/settings_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends Object implements BlocBase {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final _androidDeviceInfo = BehaviorSubject<AndroidDeviceInfo>();
  final _iosDeviceInfo = BehaviorSubject<IosDeviceInfo>();
  final _device = BehaviorSubject<Device>();
  final _loadingData = BehaviorSubject<bool>();
  final _ip = BehaviorSubject<String>();
  final _users = BehaviorSubject<List<User>>();
  final _devices = BehaviorSubject<List<Device>>();
  final _messageUsrDevice = BehaviorSubject<String>();
  final _messageDevice = BehaviorSubject<String>();
  final _queryData = BehaviorSubject<MediaQueryData>();
  final SettingsRepository _settingsRepository = SettingsRepository();

  /// Retrieve data from the stream
  Observable<AndroidDeviceInfo> get androidDeviceInfo =>
      _androidDeviceInfo.stream;

  Observable<IosDeviceInfo> get iosDeviceInfo => _iosDeviceInfo.stream;

  ValueObservable<Device> get device => _device.stream;

  Observable<List<Device>> get devices => _devices.stream;

  Observable<bool> get loadingData => _loadingData.stream;

  ValueObservable<String> get myIp => _ip.stream;

  Observable<List<User>> get users => _users.stream;

  ValueObservable<MediaQueryData> get queryData => _queryData.stream;

  Observable<String> get messageDevice => _messageDevice.stream;

  Observable<String> get messageUsrDevice => _messageUsrDevice.stream;

  /// Add data to the stream
  Function(MediaQueryData) get setQueryData => _queryData.sink.add;

  Function(bool) get changeLoadingData => _loadingData.sink.add;

  fetchAndroidInfo() async {
    await _deviceInfoPlugin.androidInfo.then((response) {
      _androidDeviceInfo.sink.add(response);

      /// Creating a device and adding to the stream
      _device.sink.add(Device(
          response.androidId,
          '',
          'Android',
          response.version.sdkInt.toString(),
          response.model,
          response.product,
          response.isPhysicalDevice.toString(),
          '',
          '',
          '',
          ''));

      fetchInfoDevice();
    });
  }

  fetchIosInfo() async {
    await _deviceInfoPlugin.iosInfo.then((response) {
      _iosDeviceInfo.sink.add(response);

      /// Creating a device and adding to the stream
      _device.sink.add(Device(
          response.identifierForVendor,
          '',
          'Android',
          '',
          response.model,
          '',
          response.isPhysicalDevice.toString(),
          '',
          '',
          '',
          ''));

      fetchInfoDevice();
    });
  }

  fetchInfoDevice() async {
    _loadingData.sink.add(true);
    await _settingsRepository.deviceApi.fetchDevice(_device.value.id).then(
            (response) {
          /// Updating device info in the backend
          postDevice();

          /// Error if the device is inactive
          if (response.state != 'A') {
            _device.sink.addError('Dispositivo inactivo');
          } else {
            _device.sink.add(response);
          }
        }, onError: (error) {
      if (error.runtimeType == RangeError) {
        /// Creating the device in the back end
        postDevice();

        /// Error if we try to find the device the first time.
        _device.sink.addError(
            'Lo sentimos.\nEl dispositivo no se encuentra registrado.');
      } else {
        _device.sink.addError(error.runtimeType.toString());
        _loadingData.sink.add(false);
      }
    }).catchError((error) {
      _device.sink.addError(error.runtimeType.toString());
      _loadingData.sink.add(false);
    });
  }

  fetchIp() async {
    try {
      await GetIp.ipAddress.then((response) {
        _ip.sink.add(response);
      });
    } catch (error) {
      _ip.sink.addError(error.runtimeType.toString());
    }
  }

  postDevice() async {
    await _settingsRepository
        .postDevice(_device.value)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _loadingData.sink.add(false);
    }, onError: (error) {
      _device.sink.addError(error.runtimeType.toString());
      _loadingData.sink.add(false);
    }).catchError((error) {
      _device.sink.addError(error.runtimeType.toString());
      _loadingData.sink.add(false);
    });
  }

  fetchUsersDevices() async {
    _settingsRepository.fetchUsers().then((response) {
      _users.sink.add(response);
    });
  }

  postUserDeviceState(String _userId, String _deviceId, String _state) async {
    Device _device = Device(
        _deviceId,
        _state,
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '');

    /// Adding the device to the user's devices
    _settingsRepository.postUserDevice(_userId, _device).then((response){
      _messageUsrDevice.sink.add('Dispositivo del usuario actualizado');
      _messageUsrDevice.sink.add(null);
    });

    fetchUsersDevices();
  }

  fetchDevices() async {
    await _settingsRepository.fetchDevices().then((data){
      _devices.sink.add(data);
    }, onError: (error){
      _devices.sink.addError(error.toString());
    });
  }

  postDeviceState(Device _device, String _state) async {
    _device.state = _state;
    _settingsRepository.postDevice(_device).then((data){
      _messageDevice.sink.add('Dispostivo actualizado');
      _messageDevice.sink.add(null);
    });

    fetchDevices();
  }

  @override
  void dispose() {
    _androidDeviceInfo.close();
    _iosDeviceInfo.close();
    _device.close();
    _loadingData.close();
    _ip.close();
    _users.close();
    _devices.close();
    _messageDevice.close();
    _messageUsrDevice.close();
    _queryData.close();
  }
}

final settingsBloc = SettingsBloc();
