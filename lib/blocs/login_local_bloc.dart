import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/resources/holding_repository.dart';
import 'package:my_office_th_app/resources/local_repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginLocalBloc extends Object implements BlocBase {
  final _local = BehaviorSubject<Local>();
  final _holding = BehaviorSubject<Holding>();
  final _localList = PublishSubject<List<Local>>();
  final _holdingList = PublishSubject<List<Holding>>();
  final HoldingRepository _holdingRepository = HoldingRepository();
  final LocalRepository _localRepository = LocalRepository();

  /// Retrieve data from stream
  Stream<Local> get local => _local.stream;

  Stream<Holding> get holding => _holding.stream;

  Observable<List<Local>> get obsLocalList => _localList.stream;

  Observable<List<Holding>> get obsHoldingList => _holdingList.stream;

  /// Add data to the streams
  Function(Local) get changeCurrentLocal => _local.sink.add;

  Function(Holding) get changeCurrentHolding => _holding.sink.add;

  /// To call holding api
  fetchAllHolding() async {
    await _holdingRepository.fetchAllHoldings().then((response){
      _holdingList.sink.add(response);
    }, onError: (error){
      /// If we got an error we add the error on the stream
      _holdingList.sink.addError('Error loading data!');
      print(error.toString());
    }).catchError((error){
      /// If we got an error we add the error on the stream
      _holdingList.sink.addError(error.toString());
    }).whenComplete(() => print('fetchAllHolding >> Complete!!'));
  }

  /// To call local api
  fetchLocal(String holdingId) async {
    await _localRepository.fetchAllLocals(holdingId).then((response){
      _localList.sink.add(response);
    }, onError: (error){
      /// If we got an error we add the error on the stream
      _localList.sink.addError('Error loading data!');
      print(error.toString());
    }).catchError((error){
      /// If we got an error we add the error on the stream
      _localList.sink.addError(error.toString());
    }).whenComplete(() => print('fetchLocal >> Complete!!'));
  }

  @override
  void dispose() {
    _local.close();
    _holding.close();
    _localList.close();
    _holdingList.close();
  }
}

final loginLocalBloc = LoginLocalBloc();