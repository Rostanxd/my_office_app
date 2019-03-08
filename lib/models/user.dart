import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';

class User {
  final String user;
  final String name;
  final String level;
  final String accessId;
  final String sellerId;
  final Holding holding;
  final Local local;

  User(this.user, this.name, this.level, this.accessId, this.sellerId,
      this.holding, this.local);
}
