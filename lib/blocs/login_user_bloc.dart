import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/blocs/login_validator.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/resources/user_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class LoginUserBloc extends Object with LoginUserValidator implements BlocBase {
  final _id = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _logging = BehaviorSubject<bool>();
  final _userFetcher = PublishSubject<User>();
  final UserRepository _repository = UserRepository();

  /// Retrieve data from stream
  Stream<String> get id => _id.stream.transform(validateId);

  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(id, password, (e, p) => true);

  Stream<bool> get logging => _logging.stream;

  /// To observe the stream
  Observable<User> get obsUser => _userFetcher.stream;

  /// Add data to stream
  Function(String) get changeId => _id.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get changeLogging => _logging.sink.add;

  /// To call the user api
  fetchUser() async {
    _logging.sink.add(true);

    await _repository
        .fetchUser(_id.value, _password.value)
        .then((response) {
          _userFetcher.sink.add(response);
          _logging.sink.add(false);
        }, onError: (error) {
          ///  If we got an error we add the error to the stream
          _userFetcher.sink.addError('Login error!');
          _logging.sink.add(false);
          print('onError');
        })
        .timeout(Duration(seconds: Connection.timeOutSec))
        .catchError((error) {
          ///  If we got a time out we add the error to the stream
          _userFetcher.sink.addError(error.toString());
          _logging.sink.add(false);
          print('catchError');
        }).whenComplete(() => print('fetchUser >> Complete!'));
  }

  submit() {
    fetchUser();
    print('${_id.value} and ${_password.value}');
  }

  /// Overriding the class dispose from the BaseBloc
  @override
  void dispose() {
    _id.close();
    _password.close();
    _userFetcher.close();
    _logging.close();
  }
}

final loginUserBloc = LoginUserBloc();
