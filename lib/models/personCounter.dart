class PersonCounter {
  String state;
  int attendedClients;

  PersonCounter(this.state, this.attendedClients);

  PersonCounter.fromJson(Map<String, dynamic> json) {
    this.state = json['state'];
    this.attendedClients = json['clientesAtendidos'];
  }

}