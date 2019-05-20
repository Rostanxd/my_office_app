import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomerSummary extends StatelessWidget {
  final Customer customer;
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  MediaQueryData _queryData;
  CustomerDetailBloc _customerDetailBloc;
  WebViewController _controller;
  TextEditingController _dateCtrl = TextEditingController();
  TextEditingController _sellerCtrl = TextEditingController();
  TextEditingController _localCtrl = TextEditingController();
  TextEditingController _amountCtrl = TextEditingController();
  TextEditingController _averageCtrl = TextEditingController();

  CustomerSummary(this.customer);

  @override
  Widget build(BuildContext context) {
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);
    _queryData = _settingsBloc.queryData.value;

    /// Getting customer summary
    _customerDetailBloc.fetchCustomerLastSummary(
        _loginBloc.holding.value.id, customer.id);

    return ListView(
      children: <Widget>[
        _customerSummary(),
        _customerChart(),
        SizedBox(
          height: 40.0,
        )
      ],
    );
  }

  Widget _customerSummary() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Información de última compra',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              Divider(),
              StreamBuilder(
                stream: _customerDetailBloc.lastSummary,
                builder: (BuildContext context,
                    AsyncSnapshot<CustomerLastSummary> snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text(snapshot.error),
                    );
                  }
                  return snapshot.hasData
                      ? _customerSummaryForm(snapshot.data)
                      : Container(
                          margin: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ],
          )),
    );
  }

  Widget _customerSummaryForm(CustomerLastSummary data) {
    _dateCtrl.text = data.date;
    _sellerCtrl.text = data.sellerName;
    _localCtrl.text = data.localName;
    _amountCtrl.text = data.amount;
    _averageCtrl.text = data.average;

    return Container(
      child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: _queryData.size.width * 0.4,
                  margin: EdgeInsets.only(left: 20.0),
                  child: TextField(
                      controller: _dateCtrl,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Fecha',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff011e41))),
                      )),
                ),
                Container(
                  width: _queryData.size.width * 0.4,
                  margin: EdgeInsets.only(right: 20.0),
                  child: TextField(
                      controller: _amountCtrl,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Monto',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff011e41))),
                      )),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                  controller: _sellerCtrl,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Vendedor',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff011e41))),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: _queryData.size.width * 0.4,
                  margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: TextField(
                      controller: _localCtrl,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Almacén',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff011e41))),
                      )),
                ),
                Container(
                  width: _queryData.size.width * 0.4,
                  margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                  child: TextField(
                      controller: _averageCtrl,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Prom. 12 meses',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff011e41))),
                      )),
                )
              ],
            ),
          ])),
    );
  }

  Widget _customerChart() {
    var holdingId = _loginBloc.holding.value.id;
    var customerId = customer.id;
    var link = 'http://info.thgye.com.ec/VtaClienteResumen.html?'
        'customerId=${customerId.trim()}&holdingId=$holdingId';

    return Container(
        margin: EdgeInsets.only(top: 10.0),
        height: _queryData.size.height * 0.7,
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: link,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
        ));
  }
}
