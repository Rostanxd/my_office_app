import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/invoice_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/models/invoice.dart';

class InvoiceHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InvoiceHomeState();
}

class _InvoiceHomeState extends State<InvoiceHome> {
  LoginBloc _loginBloc;
  InvoiceBloc _invoiceBloc;
  DateTime _now = new DateTime.now();
  DateFormat formatter = new DateFormat('yyyy-MM-dd');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _callScaffold(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('$message')));
  }

  /// Function to call the futures of the calendar
  Future _selectInitDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(_invoiceBloc.initDate.value),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));

    if (picked != null) {
      _invoiceBloc.changeInitDate(formatter.format(picked).toString());

      /// Calling the api to update the invoice list
      _invoiceBloc.fetchInvoicesByDates(_loginBloc.local.value.id, '',
          _invoiceBloc.initDate.value, _invoiceBloc.finalDate.value);
    }
  }

  Future _selectFinalDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(_invoiceBloc.finalDate.value),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));

    if (picked != null) {
      _invoiceBloc.changeFinalDate(formatter.format(picked).toString());

      /// Calling the api to update the invoice list
      _invoiceBloc.fetchInvoicesByDates(_loginBloc.local.value.id, '',
          _invoiceBloc.initDate.value, _invoiceBloc.finalDate.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Getting the login bloc
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    /// Getting the invoice bloc
    _invoiceBloc = BlocProvider.of<InvoiceBloc>(context);

    /// Initialize the dates
    _invoiceBloc.changeInitDate(formatter.format(_now).toString());
    _invoiceBloc.changeFinalDate(formatter.format(_now).toString());

    /// Getting the invoices
    _invoiceBloc.fetchInvoicesByDates(_loginBloc.local.value.id, '',
        _invoiceBloc.initDate.value, _invoiceBloc.finalDate.value);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Facturación'),
        backgroundColor: Color(0xff011e41),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      drawer: _drawer(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _callScaffold('Crear una nueva factura. En desarrollo.');
          }),
      body: Stack(
        children: <Widget>[
          _invoiceListStream(),
          _filterCard(),
        ],
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Text(''),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(''),
          ),
        ],
      ),
    );
  }

  Widget _filterCard() {
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 10.0),
                  child: Text(
                    'Filtrar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin:
                        EdgeInsets.only(top: 10.0, left: 20.0, bottom: 20.0),
                    child: Text('Desde')),
                Container(
                    margin:
                        EdgeInsets.only(top: 10.0, left: 20.0, bottom: 20.0),
                    child: InkWell(
                      child: StreamBuilder(
                        stream: _invoiceBloc.initDate,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return snapshot.hasData
                              ? Text(
                                  _invoiceBloc.initDate.value,
                                  style: TextStyle(color: Colors.blueAccent),
                                )
                              : Text('No Data');
                        },
                      ),
                      onTap: () {
                        _selectInitDate();
                      },
                    )),
                Container(
                    margin:
                        EdgeInsets.only(top: 10.0, left: 20.0, bottom: 20.0),
                    child: Text('Hasta')),
                Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 20.0, bottom: 20.0, right: 20.0),
                    child: InkWell(
                      child: StreamBuilder(
                        stream: _invoiceBloc.finalDate,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return snapshot.hasData
                              ? Text(
                                  _invoiceBloc.finalDate.value,
                                  style: TextStyle(color: Colors.blueAccent),
                                )
                              : Text('No Data');
                        },
                      ),
                      onTap: () {
                        _selectFinalDate();
                      },
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _invoiceListStream() {
    return Container(
        margin: EdgeInsets.only(top: 120.0),
        child: Center(
          child: StreamBuilder<List<Invoice>>(
              stream: _invoiceBloc.invoiceList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Invoice>> snapshot) {
                if (snapshot.hasError) print(snapshot.error.toString());
                return snapshot.hasData
                    ? _buildInvoiceList(snapshot.data)
                    : CircularProgressIndicator();
              }),
        ));
  }

  Widget _buildInvoiceList(List<Invoice> _invoiceList) {
    return _invoiceList.length != 0
        ? Card(
            elevation: 5.0,
            child: ListView.builder(
                itemCount: _invoiceList.length,
                itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          border: BorderDirectional(
                              bottom: BorderSide(color: Colors.grey))),
                      child: ListTile(
                        onTap: () {
                          /// Updating invoice stream
                          _invoiceBloc
                              .changeCurrentInvoice(_invoiceList[index]);

                          /// Calling the invoice page.
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Presentando detalle de la factura. En desarrollo.')));
                        },
                        leading: Icon(Icons.filter_none),
                        title: Text('${_invoiceList[index].sequence}'),
                        subtitle: Text('Und. ${_invoiceList[index].quantity} '
                            'Val. \$ ${_invoiceList[index].amount}'),
                      ),
                    )),
          )
        : Text('No hay datos.');
  }
}
