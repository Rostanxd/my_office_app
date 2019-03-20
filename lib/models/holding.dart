class Holding {
  String id;
  String name;

  Holding(this.id, this.name);

  Holding.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.name = json['name'];
  }

//  @override
//  // ignore: missing_return
//  bool operator ==(Object other) {
//    identical(this, other) ||
//    other is Holding &&
//    runtimeType == other.runtimeType &&
//    // ignore: unnecessary_statements
//    name == other.name;
//  }
//
//  @override
//  // ignore: missing_return
//  int get hashCode {
//    name.hashCode;
//  }
}