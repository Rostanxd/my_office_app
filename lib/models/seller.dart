import 'package:my_office_th_app/models/person.dart';

class Seller implements Person{
  String sellerId;

  @override
  String firstName;

  @override
  String lastName;

  Seller(this.sellerId, this.firstName, this.lastName);

  Seller.fromJson(Map<String, dynamic> json){
    this.sellerId = json['sellerId'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
  }

}