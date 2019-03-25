import 'package:my_office_th_app/blocs/bloc_base.dart';
import 'package:my_office_th_app/models/invoice.dart';
import 'package:my_office_th_app/resources/sales_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

class InvoiceBloc extends Object implements BlocBase {
  final _initDate = BehaviorSubject<String>();
  final _finalDate = BehaviorSubject<String>();
  final _invoiceList = BehaviorSubject<List<Invoice>>();
  final _invoice = BehaviorSubject<Invoice>();
  SalesRepository _salesRepository = SalesRepository();

  /// Steamers
  ValueObservable<String> get initDate => _initDate.stream;

  ValueObservable<String> get finalDate => _finalDate.stream;

  Observable<List<Invoice>> get invoiceList => _invoiceList.stream;

  Observable<Invoice> get invoice => _invoice.stream;

  /// Sinks
  Function(String) get changeInitDate => _initDate.sink.add;

  Function(String) get changeFinalDate => _finalDate.sink.add;

  Function(Invoice) get changeCurrentInvoice => _invoice.sink.add;

  /// Functions to call the apis
  fetchInvoicesByDates(String localId, String sellerId, String initDate,
      String finalDate) async {
    await _salesRepository
        .fetchInvoice(localId, sellerId, initDate, finalDate)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
          _invoiceList.sink.add(response);
    }, onError: (error){
          if (error.runtimeType == RangeError){
            _invoiceList.sink.addError('No Data');
          } else {
            _invoiceList.sink.addError(error.runtimeType.toString());
          }
    }).catchError((error){
      _invoiceList.sink.addError(error.runtimeType.toString());
    });
  }

  @override
  void dispose() {
    _initDate.close();
    _finalDate.close();
    _invoiceList.close();
    _invoice.close();
  }
}
