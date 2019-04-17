import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/resources/crm_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class CustomerTelemarketingBloc implements BlocBase {
  final _sellerId = BehaviorSubject<String>();
  final _date = BehaviorSubject<String>();
  final _result = BehaviorSubject<String>();
  final _customerId = BehaviorSubject<String>();
  final _motivate = BehaviorSubject<String>();
  final _attempts = BehaviorSubject<String>();
  final _note = BehaviorSubject<String>();
  final _posting = BehaviorSubject<bool>();
  final _posted = BehaviorSubject<bool>();
  final CrmRepository _crmRepository = CrmRepository();
  DateTime _now = new DateTime.now();

  Observable<String> get sellerId => _sellerId.stream;

  Observable<String> get date => _date.stream;

  ValueObservable<String> get result => _result.stream;

  Observable<String> get customerId => _customerId.stream;

  Observable<String> get motivate => _motivate.stream;

  Observable<String> get attempts => _attempts.stream;

  Observable<String> get note => _note.stream;

  Observable<bool> get posting => _posting.stream;

  Observable<bool> get posted => _posted.stream;

  Function(String) get changeSellerId => _sellerId.sink.add;

  Function(String) get changeDate => _date.sink.add;

  Function(String) get changeResult => _result.sink.add;

  Function(String) get changeCustomerId => _customerId.sink.add;

  Function(String) get changeMotivate => _motivate.sink.add;

  Function(String) get changeAttempts => _attempts.sink.add;

  Function(String) get changeNote => _note.sink.add;

  Stream<bool> get submitTelemarketing =>
      Observable.combineLatest4(motivate, attempts, result, note, (a, b, c, d) {
        if (a.isEmpty) {
          _motivate.sink.addError('Ingrese el motivo');
          return false;
        }

        if (b.isEmpty) {
          _attempts.sink.addError('Ingrese los intentos');
          return false;
        }

        if (c.isEmpty) {
          _result.sink.addError('Ingrese el resultado');
          return false;
        }

        if (d.isEmpty) {
          _note.sink.addError('Ingrese el detalle general del resultado');
        }

        return true;
      });

  postCustomerTelemarketing() async {
    _posting.sink.add(true);
    _posted.sink.add(false);
    await _crmRepository
        .postCustomerTelemarketing(Telemarketing(
            _sellerId.value,
            _now.toString(),
            _result.value,
            _customerId.value,
            _motivate.value,
            _note.value,
            _attempts.value,
            _now.toString(),
            _now.toString()))
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((data) {
      _posting.sink.add(false);
      _posted.sink.add(true);
    }, onError: (error) {
      print(error);
      _posting.addError('Error ocurrido en el post.');
    });
  }

  @override
  void dispose() {
    _sellerId.close();
    _date.close();
    _result.close();
    _customerId.close();
    _motivate.close();
    _attempts.close();
    _note.close();
    _posting.close();
    _posted.close();
  }
}
