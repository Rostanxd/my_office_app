class Binnacle extends Object{
  String userId;
  String dateTime;
  String programId;
  String equipment;
  String action;
  String programName;
  String programDescription;
  String programType;
  String observation;

  Binnacle(this.userId, this.dateTime, this.programId, this.equipment, this.action,
      this.programName, this.programDescription, this.programType,
      this.observation);

  Binnacle.fromJson(Map<String, dynamic> json){
   this.userId = json['userId'];
   this.dateTime = json['dateTime'];
   this.programId = json['programId'];
   this.equipment = json['equipment'];
   this.action = json['action'];
   this.programName = json['programName'];
   this.programDescription = json['programDescription'];
   this.programType = json['programType'];
   this.observation = json['observation'];
  }

  Map<String, dynamic> toJson() => {
    'userId': this.userId,
    'dateTime': this.dateTime,
    'programId': this.programId,
    'equipment': this.equipment,
    'action': this.action,
    'programName': this.programName,
    'programDescription': this.programDescription,
    'programType': this.programType,
    'observation': this.observation
  };
}