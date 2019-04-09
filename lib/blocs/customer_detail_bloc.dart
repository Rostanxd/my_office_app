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

  Observable<Customer> get customer => _customer.stream;

  Observable<String> get id => _id.stream;

  Observable<String> get lastName =>
      _lastName.stream.transform(validateLastName);

  Observable<String> get firstName =>
      _firstName.stream.transform(validateFirstName);

  Observable<String> get email => _email.stream.transform(validateEmail);

  Observable<String> get cellphone => _cellphone.stream;

  Observable<String> get telephone => _telephone.stream;

  ValueObservable<String> get bornDate => _bornDate.stream;

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

  changeLastName(String _lastName){
//    if(_customer.value.lastName.isNotEmpty && _lastName.isEmpty){
//      this._lastName.sink.addError('No puede eliminar información');
//      return;
//    }
    this._lastName.sink.add(_lastName);
  }

  changeFirstName(String _firstName){
    if(_customer.value.firstName.isNotEmpty && _firstName.isEmpty){
      this._firstName.sink.addError('No puede eliminar información');
      return;
    }
    this._firstName.sink.add(_firstName);
  }

  changeEmail(String _email){
    if (_customer.value.email.isNotEmpty && _email.isEmpty){
      this._email.sink.addError('No puede eliminar información');
      return;
    }

    this._email.sink.add(_email);
  }

  changeCellphone(String _cellphone){
    if (_customer.value.cellphoneOne.isEmpty &&
        _customer.value.cellphoneTwo.isNotEmpty && _cellphone.isEmpty) {
      this._cellphone.sink.addError('No puede eliminar información.');
      return;
    } else {
      if (_customer.value.cellphoneOne.isNotEmpty && _cellphone.isEmpty){
        this._cellphone.sink.addError('No puede eliminar información.');
        return;
      }
    }

    if (_cellphone.length < 10){
      this._cellphone.sink.addError('Número inválido.');
      return;
    }

    this._cellphone.sink.add(_cellphone);
  }

  changeTelephone(String _telephone) {
    if (_customer.value.telephoneOne.isEmpty &&
        _customer.value.telephoneTwo.isNotEmpty && _telephone.isEmpty) {
      this._telephone.sink.addError('No puede eliminar información.');
      return;
    } else {
      if (_customer.value.telephoneOne.isNotEmpty && _telephone.isEmpty){
        this._telephone.sink.addError('No puede eliminar información.');
        return;
      }
    }

    if (_telephone.length < 10){
      this._telephone.sink.addError('Número inválido.');
      return;
    }

    this._telephone.sink.add(_telephone);
  }

  fetchCustomer(String id) async {
    _id.sink.add(id);
    _customer.sink.add(null);

    await _crmRepository.fetchCustomer(id).then((response) {
      _customer.sink.add(response);
      _lastName.sink.add(response.lastName);
      _firstName.sink.add(response.firstName);
      _email.sink.add(response.email);

      /// Business logic
      if (response.cellphoneOne.isEmpty && response.cellphoneTwo.isNotEmpty) {
        _cellphone.sink.add(response.cellphoneTwo);
      } else {
        _cellphone.sink.add(response.cellphoneOne);
      }

      /// Business logic
      if (response.telephoneOne.isEmpty && response.telephoneTwo.isNotEmpty) {
        _telephone.sink.add(response.telephoneTwo);
      } else {
        _telephone.sink.add(response.telephoneOne);
      }
      _bornDate.sink.add(response.bornDate);
    });
  }

  updateCustomer(String userId) {
    changeUpdating(true);
    updatedCustomer.first.then((data) async {
      await _crmRepository
          .updateCustomerData(data, userId)
          .timeout(Duration(seconds: Connection.timeOutSec))
          .then((response) {
        print(data.toString());
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
