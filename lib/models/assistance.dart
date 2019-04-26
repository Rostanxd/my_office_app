class Assistance {
  String day;
  String employeeId;
  String entryHour;
  String lunchOutHour;
  String lunchInHour;
  String exitHour;
  String entryMsg;
  String lunchOutMsg;
  String lunchInMsg;
  String exitMsg;

  Assistance(this.day, this.employeeId, this.entryHour,
      this.lunchOutHour, this.lunchInHour, this.exitHour,
      this.entryMsg, this.lunchOutMsg, this.lunchInMsg, this.exitMsg);

  Assistance.fromJson(Map<String, dynamic> json){
    this.day = json['day'];
    this.employeeId = json['employeeId'];
    this.entryHour = json['entryHour'];
    this.lunchOutHour = json['lunchOutHour'];
    this.lunchInHour = json['lunchInHour'];
    this.exitHour = json['exitHour'];
    this.entryMsg = json['entryMsg'];
    this.lunchOutMsg = json['lunchOutMsg'];
    this.lunchInMsg = json['lunchInMsg'];
    this.exitMsg = json['exitMsg'];
  }
}