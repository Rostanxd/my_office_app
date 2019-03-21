import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/blocs/home_validator.dart';
import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/resources/home_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Object with HomeValidator implements BlocBase {
  final _assistance = BehaviorSubject<Assistance>();
  final _dateToFind = BehaviorSubject<String>();
  final HomeRepository _repository = HomeRepository();

  /// Retrieve data from the stream
  Stream<String> get dateToFind => _dateToFind.stream.transform(validateDate);

  /// To observe the stream
  Observable<Assistance> get allAssistance => _assistance.stream;

  /// Add data to stream
  Function(String) get changeDateToFind => _dateToFind.sink.add;

  /// To call de api
  fetchAssistance(String employeeId) async {
    _assistance.sink.add(null);
    await _repository
        .fetchDateAssistance(_dateToFind.value, employeeId)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _assistance.sink.add(response);
    }, onError: (error) {
      print('fetchDateAssistance << ' + error.toString());
      if (error.runtimeType == RangeError) {
        _assistance.sink.addError('No hay datos.');
      } else {
        _assistance.sink.addError(error.runtimeType.toString());
      }
    }).catchError((error) {
      print('fetchDateAssistance << ' + error.toString());
      _assistance.sink.addError(error.runtimeType.toString());
    });
  }

  /// To close the stream
  dispose() {
    _assistance.close();
    _dateToFind.close();
  }
}

final homeBloc = HomeBloc();
