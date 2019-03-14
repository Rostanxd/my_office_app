import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/resources/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userFetcher = PublishSubject<User>();
  final UserRepository _repository = UserRepository();

  /// To observe the stream
  Observable<User> get allLocals => _userFetcher.stream;

  /// To call de api
  fetchUser(String id, String password) async {
    User user = await _repository.fetchUser(id, password);
    _userFetcher.sink.add(user);
  }

  /// To close the stream
  dispose() {
    _userFetcher.close();
  }

}