import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/crm_bloc.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/models/telemarketing.dart';
import 'package:my_office_th_app/screens/crm/customer_details.dart';

class CrmHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CrmHomeState();
}

class _CrmHomeState extends State<CrmHome> {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  CrmBloc _crmBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MediaQueryData _queryData;

  @override
  void dispose() {
    print('CrmHomeState >> dispose');
    _crmBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print('CrmHomeState >> didChangeDependencies');
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _crmBloc = BlocProvider.of<CrmBloc>(context);

    _queryData = _settingsBloc.queryData.value;

    /// Calling API.
    _crmBloc.fetchAllCardInfo(
        _loginBloc.local.value.id, _loginBloc.user.value.sellerId);

    /// Call the scaffold when the stream have a message.
    _crmBloc.message.listen((message) {
      if (message != null)
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text('$message')));
    });

    _crmBloc.customer.listen((data){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                bloc: CustomerDetailBloc(),
                child: CustomerDetail(data),
              )));
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('CrmHomeState >> build');
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Color(0xff011e41),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(_crmBloc));
              },
            ),
          ],
        ),
        drawer: UserDrawer(),
        body: ListView(
          children: <Widget>[
            _loginBloc.user.value.accessId == '05'
                ? _telemarketingAnniversaries()
                : Container(
                    margin: EdgeInsets.all(0.0),
                    padding: EdgeInsets.all(0.0),
                    child: null,
                  ),
            _telemarketingEffectivenessCard(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              _crmBloc.fetchAllCardInfo(
                  _loginBloc.local.value.id, _loginBloc.user.value.sellerId);
            }));
  }

  Widget _telemarketingAnniversaries() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Cumpleaños y Aniversarios',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Próximos 3 días',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            Divider(),
            StreamBuilder(
                stream: _crmBloc.customersAnniversaries,
                builder: (BuildContext context,
                    AsyncSnapshot<List<CustomerAnniversary>> snapshot) {
                  if (snapshot.hasError) return _errorData(snapshot.error);
                  return snapshot.hasData && snapshot.data != null
                      ? _customersAnniversariesList(snapshot.data)
                      : _loadingData();
                })
          ],
        ),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Semana anterior (últimos 30 días)',
                style: TextStyle(fontSize: 14.0),
              ),
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
    var _textDataSize = _queryData.size.width * 0.0275;
    var _cellWidth = _queryData.size.width * 0.20;
//    print(_textDataSize);
//    print(_cellWidth);
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
                width: _cellWidth,
//                color: Colors.green,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Llamadas',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
//                color: Colors.amber,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.managementCalls,
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
//                color: Colors.grey,
                margin: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.managementCallsVsCustomers} LC.',
                    style: TextStyle(
                        fontSize: _textDataSize, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    /// Message to the scaffold.
                    _crmBloc.addMessage('LC: Llamada/Cliente');
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
//                color: Colors.red,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: _textDataSize),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: _cellWidth,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Clientes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.managementCustomers,
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: _textDataSize),
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
                width: _cellWidth,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Clientes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.returnCustomers,
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.returnCustomersVsSalesCustomers}% RVC.',
                    style: TextStyle(
                        fontSize: _textDataSize, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    /// Message to the scaffold.
                    _crmBloc.addMessage('RVC: Retorno/Vta. Clientes');
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.returnCustomersVsManagementCustomers}% RGC.',
                    style: TextStyle(
                        fontSize: _textDataSize, color: Colors.blueAccent),
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
                width: _cellWidth,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Valor',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '\$ ${_telemarketingEffectiveness.returnAmount}',
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  child: Text(
                    '${_telemarketingEffectiveness.returnAmountVsSalesAmount}% RVV.',
                    style: TextStyle(
                        fontSize: _textDataSize, color: Colors.blueAccent),
                  ),
                  onTap: () {
                    /// Message to the scaffold.
                    _crmBloc.addMessage('RVV: Retorno/Vta. Valor');
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
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
                width: _cellWidth,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Clientes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  _telemarketingEffectiveness.salesCustomers,
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '',
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: _textDataSize),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: _cellWidth,
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Valor',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '\$ ${_telemarketingEffectiveness.salesAmount}',
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: _textDataSize),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: _cellWidth,
                margin: EdgeInsets.only(right: 20.0, top: 10.0),
                child: Text(
                  '',
                  style: TextStyle(fontSize: _textDataSize),
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

  Widget _customersAnniversariesList(List<CustomerAnniversary> data) {
    return data.length != 0
        ? Container(
            height: 300.0,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      data[index].customerNames,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    subtitle: Text(
                      '${data[index].message}',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  'assets/img/${data[index].image}'))),
                    ),
                    onTap: () {
                      _crmBloc.fetchCustomer(data[index].customerId);
                    },
                  );
                }),
          )
        : Container(
            height: 100.0,
            child: Center(
              child: Text('No hay datos.'),
            ),
          );
  }
}

class DataSearch extends SearchDelegate<String> {
  final CrmBloc _crmBloc;

  DataSearch(this._crmBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    /// We don't call the showResult() method from the suggestion list,
    /// instead we call the customer detail page
    return StreamBuilder<List<Customer>>(
      stream: _crmBloc.customerList,
      builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
        if (snapshot.hasError) {
          return Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                'Se ha encontrado un Error. ' +
                    'Comunicar al Dpto. de Sistemas.\n\n'
                    'Tipo: ${snapshot.error.runtimeType}',
                style: TextStyle(fontSize: 16.0),
              ));
        }

        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return Container(
                margin: EdgeInsets.all(20.0),
                child: Text(
                  'No se han encontrado coincidencias.',
                  style: TextStyle(fontSize: 16.0),
                ));

          /// Passing the list of style from the stream to the function to
          /// build the list view
          return _buildSuggestionItems(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
          margin: EdgeInsets.all(20.0),
          child: RichText(
              text: TextSpan(
                  text:
                      'Ingrese los apellidos y nombres del cliente separados por el símbolo ',
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                    text: '"+"',
                    style: TextStyle(
                        color: Color(0xff011e41), fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ' de la siguiente forma:\n\n'
                      'Sarmiento Arias',
                ),
                TextSpan(
                    text: '+',
                    style: TextStyle(
                        color: Color(0xff011e41), fontWeight: FontWeight.bold)),
                TextSpan(
                  text: 'Andrés Javier\n\nDe conocer la cédula, solo digítela.',
                )
              ])));
    } else {
      /// Update the stream
      _crmBloc.changeCustomerSearch(query);

      /// Fetching customer by query
      _crmBloc.fetchCustomerList();

      /// Returning the stream builder
      return StreamBuilder<List<Customer>>(
        stream: _crmBloc.customerList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
          if (snapshot.hasError) {
            return Container(
                margin: EdgeInsets.all(20.0),
                child: Text(
                  'Se ha encontrado un Error. ' +
                      'Comunicar al Dpto. de Sistemas.\n\n'
                      'Tipo: ${snapshot.error.runtimeType}',
                  style: TextStyle(fontSize: 16.0),
                ));
          }

          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Container(
                  margin: EdgeInsets.all(20.0),
                  child: Text(
                    'No se han encontrado coincidencias.',
                    style: TextStyle(fontSize: 16.0),
                  ));

            /// Passing the list of style from the stream to the function to
            /// build the list view
            return _buildSuggestionItems(snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

  Widget _buildSuggestionItems(List<Customer> data) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider<CustomerDetailBloc>(
                            bloc: CustomerDetailBloc(),
                            child: CustomerDetail(data[index]),
                          )));
            },
            leading: Icon(Icons.person),
            title: Text('${data[index].lastName} ${data[index].firstName}'),
            subtitle: Text('C.I. ${data[index].id}'),
          ),
      itemCount: data.length,
    );
  }
}
