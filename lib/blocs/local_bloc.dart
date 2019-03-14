import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/resources/local_repository.dart';
import 'package:rxdart/rxdart.dart';

class LocalBloc {
  final _localFetcher = PublishSubject<List<Local>>();
  final LocalRepository _repository = LocalRepository();

  /// To observe the stream
  Observable<List<Local>> get allLocals => _localFetcher.stream;

  /// To call de api
  fetchAllLocals(String holdingId) async {
    List<Local> localList = await _repository.fetchAllLocals(holdingId);
    _localFetcher.sink.add(localList);
  }

  /// To close the stream
  dispose() {
    _localFetcher.close();
  }

}
