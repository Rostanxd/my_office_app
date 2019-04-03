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

  @override
  String anniversaryDate;

  @override
  String bornDate;

  @override
  String cellphoneOne;

  @override
  String cellphoneTwo;

  @override
  String civilState;

  @override
  String email;

  @override
  String passport;

  @override
  String telephoneOne;

  @override
  String telephoneTwo;


  Customer(this.id, this.gender, this.firstName, this.lastName,
      this.anniversaryDate, this.bornDate, this.cellphoneOne, this.cellphoneTwo,
      this.civilState, this.email, this.passport, this.telephoneOne,
      this.telephoneTwo);

  Customer.fromJson(Map<String, dynamic> json) {
    this.id = json['customerId'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.gender = json['gender'];
    this.anniversaryDate = json['anniversaryDate'];
    this.bornDate = json['bornDate'];
    this.cellphoneOne = json['cellphoneOne'];
    this.cellphoneTwo = json['cellphoneTwo'];
    this.civilState = json['civilState'];
    this.email = json['email'];
    this.passport = json['passport'];
    this.telephoneOne = json['telephoneOne'];
    this.telephoneTwo = json['telephoneTwo'];
  }
}
