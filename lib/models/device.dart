class Device extends Object {
 String id;
 String state;
 String ios;
 String version;
 String model;
 String name;
 String isPhysic;
 String userCreated;
 String dateCreated;
 String userUpdated;
 String dateUpdated;

 Device(this.id, this.state, this.ios, this.version, this.model, this.name,
     this.isPhysic, this.userCreated, this.dateCreated, this.userUpdated,
     this.dateUpdated);

 Device.fromJson(Map<String, dynamic> json){
   this.id = json['id'];
   this.state = json['state'];
   this.ios = json['ios'];
   this.version = json['version'];
   this.model = json['model'];
   this.name = json['name'];
   this.isPhysic = json['isPhysic'];
   this.userCreated = json['userCreated'];
   this.dateCreated = json['dateCreated'];
   this.userUpdated = json['userUpdated'];
   this.dateUpdated = json['dateUpdated'];
 }

 @override
 String toString() {
   return 'Device{id: $id, state: $state, ios: $ios, version: '
       '$version, model: $model, name: $name, isPhysic: '
       '$isPhysic, userCreated: $userCreated, dateCreated: '
       '$dateCreated, userUpdated: $userUpdated, dateUpdated: $dateUpdated}';
 }

 Map<String, dynamic> toJson() => {
   'id': this.id,
   'state': this.state,
   'ios': this.ios,
   'version': this.version,
   'model': this.model,
   'name': this.name,
   'isPhysic': this.isPhysic,
   'userCreated': this.userCreated,
   'dateCreated': this.dateCreated,
   'userUpdated': this.userUpdated,
   'dateUpdated': this.dateUpdated
 };
}