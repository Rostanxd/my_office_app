class Assistance {
  final String day;
  final String employeeId;
  final String entryHour;
  final String lunchOutHour;
  final String lunchInHour;
  final String exitHour;
  final String entryMsg;
  final String lunchOutMsg;
  final String lunchInMsg;
  final String exitMsg;

  Assistance({this.day, this.employeeId,
    this.entryHour, this.lunchOutHour, this.lunchInHour, this.exitHour,
    this.entryMsg, this.lunchOutMsg, this.lunchInMsg, this.exitMsg});

  factory Assistance.fromJson(Map<String, dynamic> json){
    return Assistance(
      day: json['day'],
      employeeId: json['employeeId'],
      entryHour: json['entryHour'],
      lunchOutHour: json['lunchOutHour'],
      lunchInHour: json['lunchInHour'],
      exitHour: json['exitHour'],
      entryMsg: json['entryMsg'],
      lunchOutMsg: json['lunchOutMsg'],
      lunchInMsg: json['lunchInMsg'],
      exitMsg: json['exitMsg'],
    );
  }
}