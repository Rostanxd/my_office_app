import 'package:my_office_th_app/models/person.dart';

class Customer implements Person {
  @override
  String id;

  @override
  String gender;

  @override
  String firstName;

  @override
  String lastName;

  Customer(this.gender, this.id, this.firstName, this.lastName);

  Customer.fromJson(Map<String, dynamic> json) {
    this.id = json['customerId'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.gender = json['gender'];
  }
}
