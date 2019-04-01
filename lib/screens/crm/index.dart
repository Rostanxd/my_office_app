import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/crm_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/models/telemarketing.dart';

class CrmHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CrmHomeState();
}

class _CrmHomeState extends State<CrmHome> {
  LoginBloc _loginBloc;
  CrmBloc _crmBloc;

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _crmBloc = BlocProvider.of<CrmBloc>(context);

    /// Calling API.
    _crmBloc.fetchTelemarketingEffectiveness(
        _loginBloc.local.value.id, _loginBloc.user.value.sellerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff011e41),
        actions: <Widget>[],
      ),
      drawer: UserDrawer(),
      body: ListView(
        children: <Widget>[
          _telemarketingEffectivenessCard(),
        ],
      ),
    );
  }

  Widget _telemarketingEffectivenessCard() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Telemarketing Efectividad',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text('Semana anterior (últimos 30 días)'),
            ),
            Divider(),
            StreamBuilder<TelemarketingEffectiveness>(
              stream: _crmBloc.telemarketingEffectiveness,
              builder: (BuildContext context,
                  AsyncSnapshot<TelemarketingEffectiveness> snapshot) {
                if (snapshot.hasError) return _errorData(snapshot.error);
                return snapshot.hasData
                    ? _loadedData(snapshot.data)
                    : _loadingData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadedData(TelemarketingEffectiveness _telemarketingEffectiveness) {
    return Container(child: Text(_telemarketingEffectiveness.toString()));
  }

  Widget _loadingData() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: CircularProgressIndicator()),
    );
  }

  Widget _errorData(String error) {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 20.0, bottom: 20.0), child: Text(error)),
    );
  }
}
