import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/resources/crm_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_base.dart';

class CrmBloc extends BlocBase {
  final _telemarketingEffectiveness =
      BehaviorSubject<TelemarketingEffectiveness>();
  final _customerAnniversaryList = BehaviorSubject<List<CustomerAnniversary>>();
  final _message = BehaviorSubject<String>();
  final _customerSearch = BehaviorSubject<String>();
  CrmRepository _crmRepository = CrmRepository();

  /// Observables

  Observable<List<Customer>> customerList;

  Observable<TelemarketingEffectiveness> get telemarketingEffectiveness =>
      _telemarketingEffectiveness.stream;

  Observable<List<CustomerAnniversary>> get customersAnniversaries =>
      _customerAnniversaryList.stream;

  Observable<String> get message => _message.stream;

  Observable<String> get customerSearch => _customerSearch.stream;

  /// Functions

  Function(String) get addMessage => _message.sink.add;

  Function(String) get changeCustomerSearch => _customerSearch.sink.add;

  fetchTelemarketingEffectiveness(String localId, String sellerId) async {
    _telemarketingEffectiveness.sink.add(null);
    await _crmRepository
        .fetchTelemarketingEffectiveness(localId, sellerId)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _telemarketingEffectiveness.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      _telemarketingEffectiveness.sink.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error.toString());
      _telemarketingEffectiveness.sink.addError(error.runtimeType.toString());
    });
  }

  fetchCustomersAnniversaries(String holdingId, String sellerId) async {
    _customerAnniversaryList.sink.add(null);

    await _crmRepository
        .fetchCustomerAnniversaries(holdingId, sellerId)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _customerAnniversaryList.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      _customerAnniversaryList.sink.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error.toString());
      _customerAnniversaryList.sink.addError(error.runtimeType.toString());
    });
  }

  fetchAllCardInfo(String localId, String sellerId) {
    fetchTelemarketingEffectiveness(localId, sellerId);
    fetchCustomersAnniversaries(localId, sellerId);
  }

  fetchCustomerList() {
    String id = '', lastName = '', firstName = '';
    customerList = _customerSearch
        .debounce(Duration(milliseconds: 500))
        .switchMap((term) async* {
      /// Process to split the term
      if (isNumeric(term)) {
        id = term;
      } else {
        if (term.contains("+")){
          lastName = term.split("+")[0];
          firstName = term.split("+")[1];
        } else {
          lastName = term;
        }
      }
      yield await _crmRepository.fetchCustomerList(id, lastName, firstName);
    });
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  void dispose() {
    _telemarketingEffectiveness.close();
    _customerAnniversaryList.close();
    _message.close();
    _customerSearch.close();
  }
}
