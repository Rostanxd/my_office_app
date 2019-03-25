import 'package:my_office_th_app/models/person.dart';

class Customer implements Person{
  String customerId;

  String gender;

  @override
  String firstName;

  @override
  String lastName;

  Customer(this.customerId, this.gender, this.firstName, this.lastName);

  Customer.fromJson(Map<String, dynamic> json){
    this.customerId = json['customerId'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.gender = json['gender'];
  }
}