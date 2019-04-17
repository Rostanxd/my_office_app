class Telemarketing extends Object {
  String sellerId;
  String date;
  String result;
  String customerId;
  String motivate;
  String note;
  String attempts;
  String dateCreated;
  String dateUpdated;

  Telemarketing(
      this.sellerId,
      this.date,
      this.result,
      this.customerId,
      this.motivate,
      this.note,
      this.attempts,
      this.dateCreated,
      this.dateUpdated);

  Telemarketing.fromJson(Map<String, dynamic> json) {
    this.sellerId = json['sellerId'];
    this.date = json['date'];
    this.result = json['result'];
    this.customerId = json['customerId'];
    this.motivate = json['motivate'];
    this.note = json['note'];
    this.attempts = json['attempts'];
    this.dateCreated = json['dateCreated'];
    this.dateUpdated = json['dateUpdated'];
  }

  Map<String, dynamic> toJson() => {
    'sellerId': this.sellerId,
    'date': this.date,
    'result': this.result,
    'customerId': this.customerId,
    'motivate': this.motivate,
    'note': this.note,
    'attempts': this.attempts,
    'dateCreated': this.dateCreated,
    'dateUpdated': this.dateUpdated
  };

  @override
  String toString() {
    return 'Telemarketing{sellerId: $sellerId, date: $date, '
        'result: $result, customerId: $customerId, motivate: $motivate, '
        'note: $note, attempts: $attempts, dateCreated: $dateCreated, '
        'dateUpdated: $dateUpdated}';
  }
}

class TelemarketingEffectiveness extends Object {
  String managementCalls;
  String managementCustomers;
  String managementCallsVsCustomers;
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
      this.managementCallsVsCustomers,
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
    this.managementCallsVsCustomers = json['managementCallsVsCustomers'];
    this.returnCustomers = json['returnCustomers'];
    this.returnAmount = json['returnAmount'];
    this.returnCustomersVsSalesCustomers =
        json['returnCustomersVsSalesCustomers'];
    this.returnAmountVsSalesAmount = json['returnAmountVsSalesAmount'];
    this.returnCustomersVsManagementCustomers =
        json['returnCustomersVsManagementCustomers'];
    this.salesCustomers = json['salesCustomers'];
    this.salesAmount = json['salesAmount'];
  }
}

class CustomerAnniversary {
  String customerId;
  String customerNames;
  String date;
  String type;
  String years;
  String image;
  String management;
  String message;

  CustomerAnniversary(this.customerId, this.customerNames, this.date, this.type,
      this.years, this.image, this.management, this.message);

  CustomerAnniversary.fromJson(Map<String, dynamic> json) {
    this.customerId = json['customerId'];
    this.customerNames = json['customerNames'];
    this.date = json['date'];
    this.type = json['type'];
    this.years = json['years'];
    this.image = json['image'];
    this.management = json['management'];
    this.message = json['message'];
  }
}
