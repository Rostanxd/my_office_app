import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_telemarketing_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/customer.dart';

class CustomerTelemarketingForm extends StatefulWidget {
  final Customer _customer;
  final CustomerTelemarketingBloc _customerTelemarketingBloc;

  CustomerTelemarketingForm(this._customer, this._customerTelemarketingBloc);

  @override
  State<StatefulWidget> createState() => _CustomerTelemarketingFormState();
}

class _CustomerTelemarketingFormState extends State<CustomerTelemarketingForm> {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  TextEditingController _customerIdCtrl = TextEditingController();
  TextEditingController _customerFullName = TextEditingController();
  List<DropdownMenuItem<String>> _attemptsList =
      List<DropdownMenuItem<String>>();
  List<DropdownMenuItem<String>> _resultList = List<DropdownMenuItem<String>>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _loadAttemptsDropdown() {
    for (var i = 1; i <= 6; i++) {
      _attemptsList.add(DropdownMenuItem(
        child: Text(i.toString()),
        value: i.toString(),
      ));
    }
  }

  void _loadResultDropdown() {
    /// Loading drop down item
    _resultList.add(DropdownMenuItem(
      child: Text('Seleccionar...'),
      value: '',
    ));
    _resultList.add(DropdownMenuItem(
      child: Text('Llamada exitosa'),
      value: 'X',
    ));
    _resultList.add(DropdownMenuItem(
      child: Text('No contestaron'),
      value: 'C',
    ));
    _resultList.add(DropdownMenuItem(
      child: Text('No estaba'),
      value: 'E',
    ));
    _resultList.add(DropdownMenuItem(
      child: Text('Número equivocado'),
      value: 'Q',
    ));
    _resultList.add(DropdownMenuItem(
      child: Text('Número ocupado'),
      value: 'O',
    ));
    _resultList.add(DropdownMenuItem(
      child: Text('Fuera de servicio'),
      value: 'F',
    ));
    _resultList.add(DropdownMenuItem(
      child: Text('Otro'),
      value: 'T',
    ));
  }

  @override
  void initState() {
    print('CustomerTelemarketingForm >> initState');
    _customerIdCtrl.text = widget._customer.id;
    _customerFullName.text =
        widget._customer.lastName + ' ' + widget._customer.firstName;

    /// Loading the drop down
    _loadAttemptsDropdown();
    _loadResultDropdown();

    /// Initializing the drop down with a empty value
    widget._customerTelemarketingBloc.changeAttempts('1');
    widget._customerTelemarketingBloc.changeResult('');

    /// Posting listener
    widget._customerTelemarketingBloc.posting.listen((data) {
      if (data)
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Guardando')));
    }, onError: (error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error)));
    });

    /// Posted
    widget._customerTelemarketingBloc.posted.listen((data) {
      if (data) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Registro guardado!')));
        Navigator.pop(context);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('CustomerTelemarketingForm >> didChangeDependencies');
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    widget._customerTelemarketingBloc.changeCustomerId(widget._customer.id);
    widget._customerTelemarketingBloc
        .changeSellerId(_loginBloc.user.value.sellerId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('CustomerTelemarketingForm >> dispose');
    widget._customerTelemarketingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('CustomerTelemarketingForm >> build');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff011e41),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: Card(
                elevation: 5.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        'Ingreso de telemarketing',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                    Divider(),
                    _telemarketingForm()
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _telemarketingForm() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
                enabled: false,
                controller: _customerIdCtrl,
                decoration: InputDecoration(
                  labelText: 'Cédula/RUC',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff011e41))),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
                enabled: false,
                controller: _customerFullName,
                decoration: InputDecoration(
                  labelText: 'Nombres del cliente',
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff011e41))),
                )),
          ),
          StreamBuilder(
            stream: widget._customerTelemarketingBloc.motivate,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                    maxLength: 30,
                    onChanged: widget._customerTelemarketingBloc.changeMotivate,
                    decoration: InputDecoration(
                        labelText: 'Motivo',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff011e41))),
                        errorText: snapshot.error)),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80.0,
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Text(
                  'Intentos',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              StreamBuilder(
                stream: widget._customerTelemarketingBloc.attempts,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Container(
                    margin:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: DropdownButton(
                        value: snapshot.data,
                        items: _attemptsList,
                        onChanged:
                            widget._customerTelemarketingBloc.changeAttempts),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80.0,
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Text(
                  'Resultado',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              StreamBuilder(
                stream: widget._customerTelemarketingBloc.result,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Container(
                    margin:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: DropdownButton(
                        value: snapshot.data,
                        items: _resultList,
                        onChanged:
                            widget._customerTelemarketingBloc.changeResult),
                  );
                },
              ),
            ],
          ),
          StreamBuilder(
            stream: widget._customerTelemarketingBloc.note,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: TextField(
                    maxLength: 300,
                    onChanged: widget._customerTelemarketingBloc.changeNote,
                    decoration: InputDecoration(
                        labelText: 'Detalle general acerca del resultado',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff011e41))),
                        errorText: snapshot.error)),
              );
            },
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 5.0, right: 20.0, bottom: 5.0),
                  child: StreamBuilder(
                    stream:
                        widget._customerTelemarketingBloc.submitTelemarketing,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return snapshot.hasData && snapshot.data
                          ? IconButton(
                              onPressed: () {
                                widget._customerTelemarketingBloc
                                    .postCustomerTelemarketing(
                                        _loginBloc.user.value.user,
                                        _settingsBloc.device.value.id);
                              },
                              icon: Icon(
                                Icons.save,
                                color: Colors.lightBlue,
                              ),
                            )
                          : IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.save,
                                color: Colors.grey,
                              ),
                            );
                    },
                  ))
            ],
          )
        ],
      ),
    );
  }
}
