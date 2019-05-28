class Profile extends Object {
  String id;
  String name;

  @override
  String toString() {
    return 'Profile{id: $id, name: $name}';
  }

  Profile.fromEvaluation(String id) {
    this.id = id;
    switch (id) {
      case 'S':
        this.name = 'SUPER ADMINISTRADOR';
        break;
      case 'A':
        this.name = 'ASMINISTRADOR';
        break;
      case 'B':
        this.name = 'SUB ADMINISTRADOR';
        break;
      case 'V':
        this.name = 'VENDEDOR';
        break;
      case '0':
        this.name = 'SISTEMAS';
        break;
    }
  }
}
