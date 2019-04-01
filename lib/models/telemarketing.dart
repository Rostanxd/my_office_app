class Telemarketing extends Object{
  String sellerId;
  String date;
  String result;
  String customerId;
  String note;
  int attempts;
  String dateCreated;
  String dateUpdated;

  Telemarketing(this.sellerId, this.date, this.result, this.customerId,
      this.note, this.attempts, this.dateCreated, this.dateUpdated);

  Telemarketing.fromJson(Map<String, dynamic> json) {
    this.sellerId = json['sellerId'];
    this.date = json['date'];
    this.result = json['result'];
    this.customerId = json['customerId'];
    this.note = json['note'];
    this.attempts = json['attempts'];
    this.dateCreated = json['dateCreated'];
    this.dateUpdated = json['dateUpdated'];
  }
}

class TelemarketingEffectiveness extends Object {
  String managementCalls;
  String managementCustomers;
  String managementCallsVsCustomer;
  String returnCustomers;
  String returnAmount;
  String returnCustomersVsSalesCustomers;
  String returnAmountVsSalesAmount;
  String returnCustomersVsManagementCustomers;
  String salesCustomers;
  String salesAmount;

  TelemarketingEffectiveness(
      this.managementCalls,
      this.managementCustomers,
      this.managementCallsVsCustomer,
      this.returnCustomers,
      this.returnAmount,
      this.returnCustomersVsSalesCustomers,
      this.returnAmountVsSalesAmount,
      this.returnCustomersVsManagementCustomers,
      this.salesCustomers,
      this.salesAmount);

  TelemarketingEffectiveness.fromJson(Map<String, dynamic> json) {
    this.managementCalls = json['managementCalls'];
    this.managementCustomers = json['managementCustomers'];
    this.managementCallsVsCustomer = json['managementCallsVsCustomer'];
    this.returnCustomers = json['returnCustomer'];
    this.returnAmount = json['returnAmount'];
    this.returnCustomersVsSalesCustomers =
        json['returnCustomerVsSalesCustomers'];
    this.returnAmountVsSalesAmount = json['returnAmountVsSalesAmount'];
    this.returnCustomersVsManagementCustomers =
        json['returnCustomerVsManagementCustomer'];
    this.salesCustomers = json['salesCustomers'];
    this.salesAmount = json['salesAmount'];
  }
}
