import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/blocs/home_validator.dart';
import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/models/card_info.dart';
import 'package:my_office_th_app/resources/home_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Object with HomeValidator implements BlocBase {
  final _assistance = BehaviorSubject<Assistance>();
  final _dateToFind = BehaviorSubject<String>();
  final _cardMonthlySales = BehaviorSubject<CardInfo>();
  final _cardWeeklySales = BehaviorSubject<CardInfo>();
  final _cardDailySales = BehaviorSubject<CardInfo>();
  final _cardCustomersWeek = BehaviorSubject<CardInfo>();
  final _cardSalesAnalysis = BehaviorSubject<CardInfo>();
  final HomeRepository _repository = HomeRepository();

  /// Retrieve data from the stream
  ValueObservable<String> get dateToFind => _dateToFind.stream;

  /// To observe the stream
  Observable<Assistance> get allAssistance => _assistance.stream;

  Observable<CardInfo> get cardMonthlySales => _cardMonthlySales.stream;

  Observable<CardInfo> get cardWeeklySales => _cardWeeklySales.stream;

  Observable<CardInfo> get cardDailySales => _cardDailySales.stream;

  Observable<CardInfo> get cardCustomersWeek => _cardCustomersWeek.stream;

  Observable<CardInfo> get cardSalesAnalysis => _cardSalesAnalysis.stream;

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

  fetchMonthlySales(String localId, String sellerId) async{
    await _repository.fetchCardInfo(localId, sellerId, 'M').timeout(Duration(seconds: Connection.timeOutSec)).then((response){
      _cardMonthlySales.sink.add(response);
    });
  }

  fetchWeeklySales(String localId, String sellerId) async{
    await _repository.fetchCardInfo(localId, sellerId, 'W').timeout(Duration(seconds: Connection.timeOutSec)).then((response){
      _cardMonthlySales.sink.add(response);
    });
  }

  fetchDailySales(String localId, String sellerId) async{
    await _repository.fetchCardInfo(localId, sellerId, 'D').timeout(Duration(seconds: Connection.timeOutSec)).then((response){
      _cardMonthlySales.sink.add(response);
    });
  }

  fetchCustomersWeek(String localId, String sellerId) async{
    await _repository.fetchCardInfo(localId, sellerId, 'C').timeout(Duration(seconds: Connection.timeOutSec)).then((response){
      _cardMonthlySales.sink.add(response);
    });
  }

  fetchSalesAnalysis(String localId, String sellerId) async{
    await _repository.fetchCardInfo(localId, sellerId, 'S').timeout(Duration(seconds: Connection.timeOutSec)).then((response){
      _cardMonthlySales.sink.add(response);
    });
  }

  /// To close the stream
  dispose() {
    _assistance.close();
    _dateToFind.close();
    _cardMonthlySales.close();
    _cardWeeklySales.close();
    _cardDailySales.close();
    _cardCustomersWeek.close();
    _cardSalesAnalysis.close();
  }
}

final homeBloc = HomeBloc();
