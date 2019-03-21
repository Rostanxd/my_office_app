import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/blocs/home_validator.dart';
import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/resources/home_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Object with HomeValidator implements BlocBase {
  final _assistanceFetcher = BehaviorSubject<Assistance>();
  final _dateToFind = BehaviorSubject<String>();
  final HomeRepository _repository = HomeRepository();

  /// Retrieve data from the stream
  Stream<String> get dateToFind => _dateToFind.stream.transform(validateDate);

  /// To observe the stream
  Observable<Assistance> get allAssistance => _assistanceFetcher.stream;

  /// Add data to stream
  Function(String) get changeDateToFind => _dateToFind.sink.add;

  /// To call de api
  fetchAssistance(String employeeId) async {
    await _repository.fetchDateAssistance(_dateToFind.value, employeeId).then((response) {
      _assistanceFetcher.sink.add(response);
    }, onError: (error){
      print('fetchDateAssistance << ' + error.toString());
      _assistanceFetcher.sink.addError('No data');
    }).catchError((error){
      print('fetchDateAssistance << ' +error.toString());
      _assistanceFetcher.sink.addError(error.toString());
    });
  }

  /// To close the stream
  dispose() {
    _assistanceFetcher.close();
    _dateToFind.close();
  }
}

final homeBloc = HomeBloc();
