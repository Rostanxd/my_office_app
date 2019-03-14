import 'dart:async';

import 'package:my_office_th_app/models/holding.dart';
import 'package:my_office_th_app/services/fetch_holdings.dart';

class HoldingRepository {
  final holdingApi = HoldingApi();

  Future<List<Holding>> fetchAllHoldings() => holdingApi.fetchAllHoldings();
}