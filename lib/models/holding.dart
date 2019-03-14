class Holding {
  String id;
  String name;

  Holding(this.id, this.name);

  Holding.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.name = json['name'];
  }
}