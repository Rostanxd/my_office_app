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
        this.name = 'Super Administrador';
        break;
      case 'A':
        this.name = 'Administrador';
        break;
      case 'B':
        this.name = 'Sub-Administrador';
        break;
      case 'V':
        this.name = 'Vendedor';
        break;
      case '0':
        this.name = 'Sistemas';
        break;
    }
  }
}
