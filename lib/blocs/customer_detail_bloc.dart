import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:rxdart/rxdart.dart';

class CustomerDetailBloc implements BlocBase{
  final _customer = BehaviorSubject<Customer>();
  final _index = BehaviorSubject<int>();
  final _editing = BehaviorSubject<bool>();
  /// Customer fields
  final _lastName = BehaviorSubject<String>();
  final _firstName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _cellphone = BehaviorSubject<String>();
  final _telephone = BehaviorSubject<String>();
  final _bornDate = BehaviorSubject<String>();

  /// Observables
  Observable<Customer> get customer => _customer.stream;

  ValueObservable<int> get index => _index.stream;

  Observable<bool> get editing => _editing.stream;

  Observable<String> get lastName => _lastName.stream;

  Observable<String> get firstName => _firstName.stream;

  Observable<String> get email => _email.stream;

  Observable<String> get cellphone => _cellphone.stream;

  Observable<String> get telephone => _telephone.stream;

  ValueObservable<String> get bornDate => _bornDate.stream;

  /// Functions
  Function(Customer) get changeCustomer => _customer.sink.add;

  Function(int) get changeIndex => _index.sink.add;

  Function(bool) get changeEditing => _editing.sink.add;

  Function(String) get changeBornDate => _bornDate.sink.add;

  @override
  void dispose() {
    _customer.close();
    _index.close();
    _editing.close();
    _lastName.close();
    _firstName.close();
    _email.close();
    _cellphone.close();
    _telephone.close();
    _bornDate.close();
  }

}