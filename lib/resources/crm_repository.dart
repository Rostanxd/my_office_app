import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/services/fetch_telemarketing.dart';

class CrmRepository {
  TelemarketingApi _telemarketingApi = TelemarketingApi();

  Future<TelemarketingEffectiveness> fetchTelemarketingEffectiveness(
          String localId, String sellerId) =>
      _telemarketingApi.fetchTelemarketingEffectiveness(localId, sellerId);
}
