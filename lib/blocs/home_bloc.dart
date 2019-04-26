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

  Stream<bool> get refreshHome => Observable.combineLatest5(
      _cardMonthlySales,
      _cardWeeklySales,
      _cardDailySales,
      _cardCustomersWeek,
      _cardSalesAnalysis,
      (a, b, c, d, e) {
        if (a != null && b != null && c != null && d != null && e != null){
          return true;
        } else {
          return false;
        }
      });

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

  fetchAllCardInfo(String localId, String sellerId) {
    _cardMonthlySales.sink.add(null);
    _cardWeeklySales.sink.add(null);
    _cardDailySales.sink.add(null);
    _cardCustomersWeek.sink.add(null);
    _cardSalesAnalysis.sink.add(null);

    fetchMonthlySales(localId, sellerId);
    fetchWeeklySales(localId, sellerId);
    fetchDailySales(localId, sellerId);
    fetchCustomersWeek(localId, sellerId);
    fetchSalesAnalysis(localId, sellerId);
  }

  fetchMonthlySales(String localId, String sellerId) async {
    _cardMonthlySales.sink.add(null);
    await _repository
        .fetchCardInfo(localId, sellerId, 'M')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _cardMonthlySales.sink.add(response);
    }, onError: (error) {
      print(error);
      _cardMonthlySales.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error);
      _cardMonthlySales.addError(error.runtimeType.toString());
    });
  }

  fetchWeeklySales(String localId, String sellerId) async {
    _cardWeeklySales.sink.add(null);
    await _repository
        .fetchCardInfo(localId, sellerId, 'W')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _cardWeeklySales.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      _cardWeeklySales.sink.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error.toString());
      _cardWeeklySales.sink.addError(error.runtimeType.toString());
    });
  }

  fetchDailySales(String localId, String sellerId) async {
    _cardDailySales.sink.add(null);
    await _repository
        .fetchCardInfo(localId, sellerId, 'D')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _cardDailySales.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      _cardDailySales.sink.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error.toString());
      _cardDailySales.sink.addError(error.runtimeType.toString());
    });
  }

  fetchCustomersWeek(String localId, String sellerId) async {
    _cardCustomersWeek.sink.add(null);
    await _repository
        .fetchCardInfo(localId, sellerId, 'C')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _cardCustomersWeek.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      _cardCustomersWeek.sink.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error.toString());
      _cardCustomersWeek.sink.addError(error.runtimeType.toString());
    });
  }

  fetchSalesAnalysis(String localId, String sellerId) async {
    _cardSalesAnalysis.sink.add(null);
    await _repository
        .fetchCardInfo(localId, sellerId, 'S')
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _cardSalesAnalysis.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      _cardSalesAnalysis.sink.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error.toString());
      _cardSalesAnalysis.sink.addError(error.runtimeType.toString());
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
