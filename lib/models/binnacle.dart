class Binnacle extends Object{
  String userId;
  String dateTime;
  String programId;
  String action;
  String programName;
  String programDescription;
  String programType;
  String observation;

  Binnacle(this.userId, this.dateTime, this.programId, this.action,
      this.programName, this.programDescription, this.programType,
      this.observation);

  Binnacle.fromJson(Map<String, dynamic> json){
   this.userId = json['userId'];
   this.dateTime = json['dateTime'];
   this.programId = json['programId'];
   this.action = json['action'];
   this.programName = json['programName'];
   this.programDescription = json['programDescription'];
   this.programType = json['programType'];
   this.observation = json['observation'];
  }

}