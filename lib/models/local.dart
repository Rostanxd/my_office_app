class Local {
  String id;
  String name;

  Local(this.id, this.name);

  Local.fromJson(Map<String, dynamic> json){
    print(json);
    this.id = json['id'];
    this.name = json['name'];
  }
}