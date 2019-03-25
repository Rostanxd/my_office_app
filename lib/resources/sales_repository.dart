import 'package:my_office_th_app/models/invoice.dart';
import 'package:my_office_th_app/services/fetch_invoices.dart';

class SalesRepository {
  final InvoiceApi invoiceApi = InvoiceApi();

  Future<List<Invoice>> fetchInvoice(
          String localId, String sellerId, String initDate, String finalDate) =>
      invoiceApi.fetchInvoices(localId, sellerId, initDate, finalDate);
}
