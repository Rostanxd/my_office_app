import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/resources/assistance_repository.dart';
import 'package:rxdart/rxdart.dart';

class AssistanceBloc {
  final _assistanceFetcher = PublishSubject<Assistance>();
  final AssistanceRepository _repository = AssistanceRepository();

  /// To observe the stream
  Observable<Assistance> get allAssistance => _assistanceFetcher.stream;

  /// To call de api
  fetchAssistance(String date, String employeeId) async {
    Assistance assistance =
        await _repository.fetchDateAssistance(date, employeeId);
    _assistanceFetcher.sink.add(assistance);
  }

  /// To close the stream
  dispose() {
    _assistanceFetcher.close();
  }
}
