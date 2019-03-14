import 'package:my_office_th_app/blocs/base_bloc.dart';
import 'package:my_office_th_app/blocs/login_validator.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/resources/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Object with LoginValidator implements BaseBloc {
  final _id = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _userFetcher = PublishSubject<User>();
  final UserRepository _repository = UserRepository();

  /// Retrieve data from stream
  Stream<String> get id => _id.stream.transform(validateId);

  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(id, password, (e, p) => true);

  /// To observe the stream
  Observable<User> get obsUser => _userFetcher.stream;

  /// Add data to stream
  Function(String) get changeId => _id.sink.add;

  Function(String) get changePassword => _password.sink.add;

  /// To call de api
  fetchUser() async {
    await _repository.fetchUser(_id.value, _password.value).then((response) {
      _userFetcher.sink.add(response);
    }, onError: (error) {
      _userFetcher.sink.addError(error);
    }).timeout(Duration(seconds: 10)) .catchError((error) {
      _userFetcher.sink.addError(error);
    });
  }

  submit() {
    final validId = _id.value;
    final validPassword = _password.value;

    fetchUser();

    print('$validId and $validPassword');
  }

  /// Overriding the class dispose from the BaseBloc
  @override
  void dispose() {
    _id.close();
    _password.close();
    _userFetcher.close();
  }
}

final bloc = LoginBloc();
