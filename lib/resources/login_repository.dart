import 'dart:async';
import 'package:my_office_th_app/models/binnacle.dart';
import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/models/user.dart';
import 'package:my_office_th_app/services/fetch_binnacles.dart';
import 'package:my_office_th_app/services/fetch_holdings.dart';
import 'package:my_office_th_app/services/fetch_locals.dart';
import 'package:my_office_th_app/services/fetch_users.dart';

class LoginRepository {
  final userApi = UserApi();

  final localApi = LocalApi();

  final holdingApi = HoldingApi();

  final binnacleApi = BinnacleApi();

  Future<User> fetchUser(String id, String password) =>
      userApi.fetchUser(id, password);

  Future<List<Holding>> fetchAllHoldings() => holdingApi.fetchAllHoldings();

  Future<List<Local>> fetchAllLocals(String holdingId) =>
      localApi.fetchLocals(holdingId);

  Future<String> postBinnacle(Binnacle binnacle) =>
      binnacleApi.postBinnacle(binnacle);
}
