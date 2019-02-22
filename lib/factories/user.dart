class User {
  final String user;
  final String name;
  final String level;

  User({this.user, this.name, this.level});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      user: json['user'],
      name: json['name'],
      level: json['level'],
    );
  }
}