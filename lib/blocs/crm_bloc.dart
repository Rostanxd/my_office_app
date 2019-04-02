import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/resources/crm_repository.dart';
import 'package:my_office_th_app/utils/connection.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_base.dart';

class CrmBloc extends BlocBase {
  final _telemarketingEffectiveness =
      BehaviorSubject<TelemarketingEffectiveness>();
  final _message = BehaviorSubject<String>();
  CrmRepository _crmRepository = CrmRepository();

  Observable<TelemarketingEffectiveness> get telemarketingEffectiveness =>
      _telemarketingEffectiveness.stream;

  Observable<String> get message => _message.stream;

  Function(String message) get addMessage => _message.sink.add;

  fetchTelemarketingEffectiveness(String localId, String sellerId) async {
    _telemarketingEffectiveness.sink.add(null);
    await _crmRepository
        .fetchTelemarketingEffectiveness(localId, sellerId)
        .timeout(Duration(seconds: Connection.timeOutSec))
        .then((response) {
      _telemarketingEffectiveness.sink.add(response);
    }, onError: (error) {
      print(error.toString());
      _telemarketingEffectiveness.sink.addError(error.runtimeType.toString());
    }).catchError((error) {
      print(error.toString());
      _telemarketingEffectiveness.sink.addError(error.runtimeType.toString());
    });
  }

  fetchAllCardInfo(String localId, String sellerId){
    fetchTelemarketingEffectiveness(localId, sellerId);
  }

  @override
  void dispose() {
    _telemarketingEffectiveness.close();
    _message.close();
  }
}
