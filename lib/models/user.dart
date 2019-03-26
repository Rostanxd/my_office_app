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
  String identification;
  List<UserDevice> deviceList;

  User(this.user, this.name, this.level, this.accessId, this.sellerId,
      this.holding, this.local, this.identification, this.deviceList);

  User.fromJson(Map<String, dynamic> json){
   this.user = json['user'];
   this.name = json['name'];
   this.level = json['level'];
   this.accessId = json['accessId'];
   this.sellerId = json['sellerId'];
   this.holding = new Holding(json['holdingId'], json['holdingName']);
   this.local = new Local(json['localId'], json['localName']);
   this.identification = json['identification'];
   this.deviceList = json['deviceList'].cast<UserDevice>();
  }
}

class UserDevice extends Object {
  String user;
  String deviceId;
  String state;
  String userCreated;
  String dateCreated;
  String userUpdated;
  String dateUpdated;

  UserDevice(this.user, this.deviceId, this.state, this.userCreated,
      this.dateCreated, this.userUpdated, this.dateUpdated);

  UserDevice.fromJson(Map<String, dynamic> json){
    this.user = json['user'];
    this.deviceId = json['deviceId'];
    this.state = json['state'];
    this.userCreated = json['userCreated'];
    this.dateCreated = json['dateCreated'];
    this.userUpdated = json['userUpdated'];
    this.dateUpdated = json['dateUpdated'];
  }
}