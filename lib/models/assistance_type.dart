class AssistanceType {
  String value;
  String name;

  AssistanceType(this.value, this.name);

  AssistanceType.fromJson(Map<String, dynamic> json){
    this.value = json['value'];
    this.value = json['name'];
  }
}