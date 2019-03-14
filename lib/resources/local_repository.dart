import 'dart:async';

import 'package:my_office_th_app/models/local.dart';
import 'package:my_office_th_app/services/fetch_locals.dart';

class LocalRepository {
  final localApi = LocalApi();

  Future<List<Local>> fetchAllLocals(String holdingId) =>
      localApi.fetchLocals(holdingId);
}
