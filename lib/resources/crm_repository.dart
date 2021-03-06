import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/services/fetch_customer.dart';
import 'package:my_office_th_app/services/fetch_telemarketing.dart';

class CrmRepository {
  TelemarketingApi _telemarketingApi = TelemarketingApi();
  CustomerApi _customerApi = CustomerApi();

  Future<List<Customer>> fetchCustomerList(
          String id, String lastName, String firstName) =>
      _customerApi.fetchCustomerList(id, lastName, firstName);

  Future<Customer> fetchCustomer(String id) => _customerApi.fetchCustomer(id);

  Future<List<Telemarketing>> fetchCustomerTelemarketing(
          String sellerId, String customerId) =>
      _telemarketingApi.fetchCustomerTelemarketing(sellerId, customerId);

  Future<TelemarketingEffectiveness> fetchTelemarketingEffectiveness(
          String localId, String sellerId) =>
      _telemarketingApi.fetchTelemarketingEffectiveness(localId, sellerId);

  Future<List<CustomerAnniversary>> fetchCustomerAnniversaries(
          String localId, String sellerId) =>
      _telemarketingApi.fetchCustomerAnniversaries(localId, sellerId);

  Future<String> updateCustomerData(Customer customer, String userId) =>
      _customerApi.updateCustomers(customer, userId);

  Future<String> postCustomerTelemarketing(Telemarketing _telemarketing) =>
      _telemarketingApi.postCustomerTelemarketing(_telemarketing);

  Future<CustomerLastSummary> fetchCustomerLastSummary(
          String holdingId, String customerId) =>
      _customerApi.fetchCustomerLastSummary(holdingId, customerId);
}
