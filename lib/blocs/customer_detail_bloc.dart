import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/blocs/customer_validator.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/resources/crm_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class CustomerDetailBloc with CustomerValidator implements BlocBase {
  final _index = BehaviorSubject<int>();
  final _editing = BehaviorSubject<bool>();
  final _updating = BehaviorSubject<bool>();
  final _customer = BehaviorSubject<Customer>();

  /// Customer fields
  final _id = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _firstName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _cellphone = BehaviorSubject<String>();
  final _telephone = BehaviorSubject<String>();
  final _bornDate = BehaviorSubject<String>();
  CrmRepository _crmRepository = CrmRepository();

  /// Observables
  ValueObservable<int> get index => _index.stream;

  Observable<bool> get editing => _editing.stream;

  Observable<bool> get updating => _updating.stream;

  ValueObservable<Customer> get customer => _customer.stream;

  Observable<String> get id => _id.stream;

  Observable<String> get lastName => _lastName.stream.transform(validateLastName);

  Observable<String> get firstName => _firstName.stream.transform(validateFirstName);

  Observable<String> get email => _email.stream.transform(validateEmail);

  Observable<String> get cellphone => _cellphone.stream;

  Observable<String> get telephone => _telephone.stream;

  Observable<String> get bornDate => _bornDate.stream;

  Stream<Customer> get updatedCustomer => Observable.combineLatest6(
      firstName,
      lastName,
      bornDate,
      cellphone,
      email,
      telephone,
      (a, b, c, d, e, f) => Customer(
          _id.value,
          '',
          _firstName.value,
          _lastName.value,
          '',
          _bornDate.value,
          _cellphone.value,
          '',
          '',
          _email.value,
          '',
          _telephone.value,
          ''));

  Stream<bool> get submitCustomer => Observable.combineLatest6(
      firstName,
      lastName,
      bornDate,
      cellphone,
      email,
      telephone,
      (a, b, c, d, e, f) => true);

  /// Functions
  Function(int) get changeIndex => _index.sink.add;

  Function(bool) get changeEditing => _editing.sink.add;

  Function(bool) get changeUpdating => _updating.sink.add;

  Function(Customer) get changeCustomer => _customer.sink.add;

  Function(String) get changeBornDate => _bornDate.sink.add;

  Function(String) get changeId => _id.sink.add;

  Function(String) get changeLastName => _lastName.sink.add;

  Function(String) get changeFirstName => _firstName.sink.add;

  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changeCellphone => _cellphone.sink.add;

  Function(String) get changeTelephone => _telephone.sink.add;

  loadCustomerStreams() {
    changeId(_customer.value.id);
    changeLastName(_customer.value.lastName);
    changeFirstName(_customer.value.firstName);
    changeEmail(_customer.value.email);
    changeCellphone(_customer.value.cellphoneOne);
    changeTelephone(_customer.value.telephoneOne);
    changeBornDate(_customer.value.bornDate);
  }

  updateCustomer(String userId) {
    changeUpdating(true);
    updatedCustomer.first.then((data) async {
      changeCustomer(data);
      await _crmRepository
          .updateCustomerData(data, userId)
          .timeout(Duration(seconds: Connection.timeOutSec))
          .then((response) {
        print(response);
        changeUpdating(false);
      }, onError: (error) {
        print(error.toString());
        changeUpdating(false);
      }).catchError((error) {
        print(error.toString());
        changeUpdating(false);
      });
    });
  }

  @override
  void dispose() {
    _index.close();
    _editing.close();
    _updating.close();
    _customer.close();
    _id.close();
    _lastName.close();
    _firstName.close();
    _email.close();
    _cellphone.close();
    _telephone.close();
    _bornDate.close();
  }
}