import 'package:device_info/device_info.dart';
import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends Object implements BlocBase {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final _androidDeviceInfo = BehaviorSubject<AndroidDeviceInfo>();
  final _iosDeviceInfo = BehaviorSubject<IosDeviceInfo>();

  /// Retrieve data from the stream
  Observable<AndroidDeviceInfo> get androidDeviceInfo =>
      _androidDeviceInfo.stream;

  Observable<IosDeviceInfo> get iosDeviceInfo => _iosDeviceInfo.stream;

  /// Add data to the stream
  fetchAndroidInfo() async {
    await _deviceInfoPlugin.androidInfo.then((response) {
      _androidDeviceInfo.sink.add(response);
    });
  }

  fetchIosInfo() async {
    await _deviceInfoPlugin.iosInfo.then((response) {
      _iosDeviceInfo.sink.add(response);
    });
  }

  @override
  void dispose() {
    _androidDeviceInfo.close();
    _iosDeviceInfo.close();
  }
}

final settingsBloc = SettingsBloc();