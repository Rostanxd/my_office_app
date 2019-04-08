import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/resources/crm_repository.dart';
import 'package:rxdart/rxdart.dart';

class CustomerDetailBloc implements BlocBase {
  final _customer = BehaviorSubject<Customer>();
  final _index = BehaviorSubject<int>();
  final _editing = BehaviorSubject<bool>();

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
  Observable<Customer> get customer => _customer.stream;

  ValueObservable<int> get index => _index.stream;

  Observable<bool> get editing => _editing.stream;

  Observable<String> get id => _id.stream;

  Observable<String> get lastName => _lastName.stream;

  Observable<String> get firstName => _firstName.stream;

  Observable<String> get email => _email.stream;

  Observable<String> get cellphone => _cellphone.stream;

  Observable<String> get telephone => _telephone.stream;

  Observable<String> get bornDate => _bornDate.stream;

  /// Functions
  Function(Customer) get changeCustomer => _customer.sink.add;

  Function(int) get changeIndex => _index.sink.add;

  Function(bool) get changeEditing => _editing.sink.add;

  Function(String) get changeBornDate => _bornDate.sink.add;

  Function(String) get changeLastName => _lastName.sink.add;

  Function(String) get changeFirstName => _firstName.sink.add;

  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changeCellphone => _cellphone.sink.add;

  Function(String) get changeTelephone => _telephone.sink.add;

  updateCustomer(String userId) async {
    Customer _customer = Customer(
        '0923175756',
        'M',
        'ROBERTH STANLEY',
        _lastName.value,
        'a',
        '09/05/1990',
        '0981258796',
        'a',
        'a',
        'allowed_g@hotmail.com',
        'a',
        'a',
        'a'
    );
    await _crmRepository.updateCustomerData(_customer, userId).then((response) {
      print(response);
    });
  }

  void updateLastName(String lastName){
    print("updateLastName >> $lastName");
    _lastName.sink.add(lastName);
    _lastName.toString();
  }

  @override
  void dispose() {
    _customer.close();
    _index.close();
    _editing.close();
    _lastName.close();
    _firstName.close();
    _id.close();
    _email.close();
    _cellphone.close();
    _telephone.close();
    _bornDate.close();
  }

}