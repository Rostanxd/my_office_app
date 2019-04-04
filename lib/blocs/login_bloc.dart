import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/blocs/login_validator.dart';
import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/resources/login_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Object with LoginUserValidator implements BlocBase {
  final _id = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _logging = BehaviorSubject<bool>();
  final _user = BehaviorSubject<User>();
  final _local = BehaviorSubject<Local>();
  final _holding = BehaviorSubject<Holding>();
  final _localList = BehaviorSubject<List<Local>>();
  final _holdingList = BehaviorSubject<List<Holding>>();
  final LoginRepository _loginRepository = LoginRepository();

  /// Retrieve data from stream
  Stream<String> get id => _id.stream.transform(validateId);

  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(id, password, (e, p) => true);

  Stream<bool> get logging => _logging.stream;

  ValueObservable<Local> get local => _local.stream;

  ValueObservable<Holding> get holding => _holding.stream;

  ValueObservable<User> get user => _user.stream;

  ValueObservable<List<Local>> get localList => _localList.stream;

  ValueObservable<List<Holding>> get holdingList => _holdingList.stream;

  /// Add data to stream
  Function(String) get changeId => _id.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get changeLogging => _logging.sink.add;

  Function(Local) get changeCurrentLocal => _local.sink.add;

  Function(Holding) get changeCurrentHolding => _holding.sink.add;

  /// To call the user api
  fetchUser(String deviceId, String myIp) async {
    List<UserDevice> _userDevice;
    bool _deviceValid = false;
    _logging.sink.add(true);

    await _loginRepository
        .fetchUser(_id.value, _password.value)
        .then((response) {
          /// Validation by the ip prefix if is a seller or a sub-admin
          if (((response.accessId == '08' && response.level != '4') ||
                  response.accessId == '05') &&
              !(myIp.contains(response.ipPrefix))) {
            _user.sink.addError('Acceso denegado.');
            _logging.sink.add(false);
            return;
          }

          /// Finding for the device in the user's device list
          _userDevice = response.deviceList;
          for (var i = 0; i < _userDevice.length; i++) {
            print('${_userDevice[i].deviceId} == $deviceId');
            if (_userDevice[i].deviceId == deviceId &&
                _userDevice[i].state == 'A') {
              _deviceValid = true;
            }
          }

          /// Returning user or error to the stream.
          _deviceValid
              ? _user.sink.add(response)
              : _user.sink.addError('Dispositivo no vinculado');

          _logging.sink.add(false);
        }, onError: (error) {
          ///  If we got an error we add the error to the stream
          if (error.runtimeType == RangeError) {
            _user.sink.addError('Login error.');
          } else {
            _user.sink.addError(error.runtimeType.toString());
          }
          _logging.sink.add(false);
          print(error.toString());
        })
        .timeout(Duration(seconds: Connection.timeOutSec))
        .catchError((error) {
          ///  If we got a time out we add the error to the stream
          _user.sink.addError(error.runtimeType.toString());
          _logging.sink.add(false);
          print(error.toString());
        })
        .whenComplete(() => print('fetchUser >> Complete!'));
  }

  /// To call holding api
  fetchAllHolding() async {
    await _loginRepository
        .fetchAllHoldings()
        .then((response) {
          _holdingList.sink.add(response);
          _holding.sink.add(response[0]);
        }, onError: (error) {
          /// If we got an error we add the error on the stream
          if (error.runtimeType == RangeError) {
            _holdingList.sink.addError('No hay datos');
          } else {
            _holdingList.sink.addError(error.runtimeType.toString());
          }
          print(error.toString());
        })
        .timeout(Duration(seconds: Connection.timeOutSec))
        .catchError((error) {
          /// If we got an error we add the error on the stream
          _holdingList.sink.addError(error);
          print(error.toString());
        })
        .whenComplete(() => print('fetchAllHolding >> Complete!!'));
  }

  /// To call local api
  fetchLocal(String holdingId) async {
    await _loginRepository
        .fetchAllLocals(holdingId)
        .then((response) {
          _localList.sink.add(response);
          _local.sink.add(response[0]);
        }, onError: (error) {
          /// If we got an error we add the error on the stream
          if (error.runtimeType == RangeError) {
            _localList.sink.addError('No hay datos');
          } else {
            _localList.sink.addError(error.runtimeType.toString());
          }
          print(error.toString());
        })
        .timeout(Duration(seconds: Connection.timeOutSec))
        .catchError((error) {
          /// If we got an error we add the error on the stream
          _localList.sink.addError(runtimeType.toString());
          print(error.toString());
        })
        .whenComplete(() => print('fetchLocal >> Complete!!'));
  }

  logIn(String deviceId, String myIp) {
    fetchUser(deviceId, myIp);
  }

  logOut() {
    _user.sink.add(null);
    _local.sink.add(null);
    _password.sink.add(null);
    changeCurrentLocal(null);
    changeCurrentHolding(null);
  }

  /// Overriding the class dispose from the BaseBloc
  @override
  void dispose() {
    _id.close();
    _password.close();
    _user.close();
    _logging.close();
    _local.close();
    _holding.close();
    _localList.close();
    _holdingList.close();
  }
}

final loginBloc = LoginBloc();
