import 'dart:async';

import 'package:my_office_th_app/models/assistance.dart';
import 'package:my_office_th_app/models/card_info.dart';
import 'package:my_office_th_app/services/fetch_home.dart';
import 'package:my_office_th_app/services/fetch_assistances.dart';
import 'package:my_office_th_app/models/personCounter.dart';

class HomeRepository {
  final AssistanceApi assistanceApi = AssistanceApi();
  final HomeApi homeApi = HomeApi();

  Future<Assistance> fetchDateAssistance(String date, String employeeId) =>
      assistanceApi.fetchDateAssistance(date, employeeId);

  Future<CardInfo> fetchCardInfo(
          String localId, String sellerId, String type) =>
      homeApi.fetchCardInfo(localId, sellerId, type);

  Future<PersonCounter> postCustomerCounter(
          String userId, String deviceId, String localId, String sellerId) =>
      homeApi.postCustomerCounter(userId, deviceId, localId, sellerId);
}
