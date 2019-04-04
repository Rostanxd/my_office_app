import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:rxdart/rxdart.dart';

class CustomerDetailBloc implements BlocBase{
  final _customer = BehaviorSubject<Customer>();
  final _index = BehaviorSubject<int>();
  final _editing = BehaviorSubject<bool>();

  /// Observables
  Observable<Customer> get customer => _customer.stream;

  ValueObservable<int> get index => _index.stream;

  Observable<bool> get editing => _editing.stream;

  /// Functions
  Function(Customer) get changeCustomer => _customer.sink.add;

  Function(int) get changeIndex => _index.sink.add;

  Function(bool) get changeEditing => _editing.sink.add;

  @override
  void dispose() {
    _customer.close();
    _index.close();
    _editing.close();
  }

}