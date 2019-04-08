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

  Customer(
      this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.anniversaryDate,
      this.bornDate,
      this.cellphoneOne,
      this.cellphoneTwo,
      this.civilState,
      this.email,
      this.passport,
      this.telephoneOne,
      this.telephoneTwo);

  @override
  String toString() {
    return 'Customer{id: $id, gender: $gender, '
        'firstName: $firstName, lastName: $lastName, '
        'anniversaryDate: $anniversaryDate, bornDate: $bornDate, '
        'cellphoneOne: $cellphoneOne, cellphoneTwo: $cellphoneTwo, '
        'civilState: $civilState, email: $email, passport: $passport, '
        'telephoneOne: $telephoneOne, telephoneTwo: $telephoneTwo}';
  }

  Customer.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
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

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'firstName': this.firstName,
        'lastName': this.lastName,
        'gender': this.gender,
        'anniversaryDate': this.anniversaryDate,
        'bornDate': this.bornDate,
        'cellphoneOne': this.cellphoneOne,
        'cellphoneTwo': this.cellphoneTwo,
        'civilState': this.civilState,
        'email': this.email,
        'passport': this.passport,
        'telephoneOne': this.telephoneOne,
        'telephoneTwo': this.telephoneTwo
      };
}
