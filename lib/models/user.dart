import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/models/profile.dart';

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
  String ipPrefix;
  Profile profile;

  User(
      this.user,
      this.name,
      this.level,
      this.accessId,
      this.profile,
      this.sellerId,
      this.holding,
      this.local,
      this.identification,
      this.deviceList,
      this.ipPrefix);

  User.fromJson(Map<String, dynamic> json) {
    this.user = json['user'];
    this.name = json['name'];
    this.level = json['level'];
    this.accessId = json['accessId'];
    this.profile = Profile.fromEvaluation(json['profileId']);
    this.sellerId = json['sellerId'];
    this.holding = new Holding(json['holdingId'], json['holdingName']);
    this.local = new Local(json['localId'], json['localName']);
    this.identification = json['identification'];
    var deviceList = json['deviceList'] as List;
    this.deviceList = deviceList.map((d) => UserDevice.fromJson(d)).toList();

    this.ipPrefix = json['ipPrefix'];
  }

  @override
  String toString() {
    return 'User{user: $user, name: $name, level: $level, '
        'accessId: $accessId, sellerId: $sellerId, '
        'holding: $holding, local: $local, '
        'identification: $identification, deviceList: $deviceList, '
        'ipPrefix: $ipPrefix, profile: ${profile.toString()}';
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

  UserDevice.fromJson(Map<String, dynamic> json) {
    this.user = json['user'];
    this.deviceId = json['deviceId'];
    this.state = json['state'];
    this.userCreated = json['userCreated'];
    this.dateCreated = json['dateCreated'];
    this.userUpdated = json['userUpdated'];
    this.dateUpdated = json['dateUpdated'];
  }

  @override
  String toString() {
    return 'UserDevice{user: $user, deviceId: $deviceId, '
        'state: $state, userCreated: $userCreated, '
        'dateCreated: $dateCreated, userUpdated: $userUpdated, '
        'dateUpdated: $dateUpdated}';
  }
}
