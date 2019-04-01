import 'package:device_info/device_info.dart';
import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/device.dart';
import 'package:my_office_th_app/resources/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends Object implements BlocBase {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final _androidDeviceInfo = BehaviorSubject<AndroidDeviceInfo>();
  final _iosDeviceInfo = BehaviorSubject<IosDeviceInfo>();
  final _device = BehaviorSubject<Device>();
  final _deviceId = BehaviorSubject<String>();
  final _loadingData = BehaviorSubject<bool>();
  final SettingsRepository _settingRepository = SettingsRepository();

  /// Retrieve data from the stream
  Observable<AndroidDeviceInfo> get androidDeviceInfo =>
      _androidDeviceInfo.stream;

  Observable<IosDeviceInfo> get iosDeviceInfo => _iosDeviceInfo.stream;

  Observable<Device> get authorizedDevice => _device.stream;

  ValueObservable<String> get deviceId => _deviceId.stream;

  Observable<bool> get loadingData => _loadingData.stream;

  /// Add data to the stream
  Function(bool) get changeLoadingData => _loadingData.sink.add;

  fetchAndroidInfo() async {
    await _deviceInfoPlugin.androidInfo.then((response) {
      _androidDeviceInfo.sink.add(response);
      _deviceId.sink.add(_androidDeviceInfo.value.androidId);
      fetchInfoDevice(response.androidId);
    });
  }

  fetchIosInfo() async {
    await _deviceInfoPlugin.iosInfo.then((response) {
      _iosDeviceInfo.sink.add(response);
    });
  }

  fetchInfoDevice(String deviceId) async {
    _loadingData.sink.add(true);
    await _settingRepository.deviceApi.fetchDevice(deviceId).then(
        (response) {
      _device.sink.add(response);
      _loadingData.sink.add(false);
    }, onError: (error) {
      if (error.runtimeType == RangeError) {
        _device.sink.addError(
            'Lo sentimos.\nEl dispositivo no se encuentra registrado.');
      } else {
        _device.sink.addError(error.runtimeType.toString());
      }
      _loadingData.sink.add(false);
    }).catchError((error) {
      _device.sink.addError(error.runtimeType.toString());
      _loadingData.sink.add(false);
    });
  }

  @override
  void dispose() {
    _androidDeviceInfo.close();
    _iosDeviceInfo.close();
    _device.close();
    _deviceId.close();
    _loadingData.close();
  }
}

final settingsBloc = SettingsBloc();