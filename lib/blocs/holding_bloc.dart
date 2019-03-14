import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/resources/holding_repository.dart';
import 'package:rxdart/rxdart.dart';

class HoldingBloc {
  final HoldingRepository _repository = HoldingRepository();
  final _holdingFetcher = PublishSubject<List<Holding>>();

  /// To observe the stream
  Observable<List<Holding>> get allHoldings => _holdingFetcher.stream;

  /// To call de api
  fetchAllHoldings() async {
    List<Holding> holdingList = await _repository.fetchAllHoldings();
    _holdingFetcher.sink.add(holdingList);
  }

  /// To close the stream
  dispose() {
    _holdingFetcher.close();
  }
}