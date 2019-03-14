import 'dart:async';

import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/services/fetch_users.dart';

class UserRepository {
  final userApi = UserApi();

  Future<User> fetchUser(String id, String password) =>
      userApi.fetchUser(id, password);
}
