import 'package:flutter/material.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _crmBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _crmBloc = BlocProvider.of<CrmBloc>(context);

    /// Calling API.
    _crmBloc.fetchAllCardInfo(
        _loginBloc.local.value.id, _loginBloc.user.value.sellerId);

    /// Call the scaffold when the stream have a message.
    _crmBloc.message.listen((message) {
      if (message != null)
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text('$message')));
    });

    return Scaffold(
        key: _scaffoldKey,
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {}));
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
                return snapshot.hasData && snapshot.data != null
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
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          /// Management
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom: BorderSide(color: Colors.purple))),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Gestión',
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 75.0,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Llamadas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.managementCalls,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.managementCallsVsCustomers} LC.',
                    style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    /// Message to the scaffold.
                    _crmBloc.addMessage('LC: Llamada/Cliente');
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 75.0,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Clientes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.managementCustomers,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          ),

          /// Return
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            decoration: BoxDecoration(
                border:
                    BorderDirectional(bottom: BorderSide(color: Colors.cyan))),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Retorno',
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 75.0,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Clientes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.returnCustomers,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.returnCustomersVsSalesCustomers}% RVC.',
                    style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    /// Message to the scaffold.
                    _crmBloc.addMessage('RVC: Retorno/Vta. Clientes');
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.returnCustomersVsManagementCustomers}% RGC.',
                    style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    /// Message to the scaffold.
                    _crmBloc.addMessage('RGC: Retorno/Gst. Clientes');
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 75.0,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Valor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '\$ ${_telemarketingEffectiveness.returnAmount}',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.returnAmountVsSalesAmount}% RVV.',
                    style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    /// Message to the scaffold.
                    _crmBloc.addMessage('RVV: Retorno/Vta. Valor');
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                ),
              )
            ],
          ),

          /// Sales
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom: BorderSide(color: Colors.greenAccent))),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Venta',
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 75.0,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Clientes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.salesCustomers,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '',
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 75.0,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Valor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '\$ ${_telemarketingEffectiveness.salesAmount}',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 75.0,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          ),
        ],
      ),
    );
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
