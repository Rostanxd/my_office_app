import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';

class User extends Object {
  String user;
  String name;
  String level;
  String accessId;
  String sellerId;
  Holding holding;
  Local local;

  User(this.user, this.name, this.level, this.accessId, this.sellerId,
      this.holding, this.local);

  User.fromJson(Map<String, dynamic> json){
   print(json);
   this.user = json['user'];
   this.name = json['name'];
   this.level = json['level'];
   this.accessId = json['accessId'];
   this.sellerId = json['sellerId'];
   this.holding = new Holding(json['holdingId'], json['holdingName']);
   this.local = new Local(json['localId'], json['localName']);
  }
}
