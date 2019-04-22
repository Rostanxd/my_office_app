import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/models/customer.dart';

class CustomerInfo extends StatefulWidget {
  final Customer customer;

  CustomerInfo(this.customer);

  @override
  State<StatefulWidget> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  CustomerDetailBloc _customerDetailBloc;
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  MediaQueryData _queryData;
  TextEditingController _idCtrl = TextEditingController();
  TextEditingController _lastNameCtrl = TextEditingController();
  TextEditingController _firstNameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _cellphoneCtrl = TextEditingController();
  TextEditingController _telephoneCtrl = TextEditingController();
  DateTime _now = new DateTime.now();
  DateFormat formatter = new DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    print('CustomerInfo >> initState');
    super.initState();
  }

  ///  Future to show the date picker
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _customerDetailBloc.bornDate.value != ''
            ? formatter.parse(_customerDetailBloc.bornDate.value)
            : _now,
        firstDate: DateTime(1900),
        lastDate: DateTime(_now.year - 17));

    if (picked != null) {
      _customerDetailBloc.changeBornDate(formatter.format(picked).toString());
    }
  }

  @override
  void didChangeDependencies() {
    print('CustomerInfo >> didChangeDependencies');
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _queryData = _settingsBloc.queryData.value;
    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);

    /// Looking for the customer data.
    _customerDetailBloc.fetchCustomer(widget.customer.id);

    /// Loading the text controllers.
    _customerDetailBloc.customer.listen((data) {
      if (data != null) {
        _idCtrl.text = data.id;
        _lastNameCtrl.text = data.lastName;
        _firstNameCtrl.text = data.firstName;
        _emailCtrl.text = data.email;
        _cellphoneCtrl.text = data.cellphoneOne;
        _telephoneCtrl.text = data.telephoneOne;
      }
    });

    /// To call the customer update dialog
    _customerDetailBloc.updating.listen((data) {
      if (data) {
        _showUpdatingDialog();
      } else {
        Navigator.pop(context);
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('CustomerInfo >> build');
    return ListView(
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
                      'Datos Generales del Cliente',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Divider(),
                  StreamBuilder(
                    stream: _customerDetailBloc.customer,
                    builder:
                        (BuildContext context, AsyncSnapshot<Customer> snapshot) {
                      return snapshot.hasData
                          ? StreamBuilder(
                              stream: _customerDetailBloc.editing,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.hasError)
                                  return Text(
                                      snapshot.error.runtimeType.toString());
                                return snapshot.hasData
                                    ? _customerForm(snapshot.data)
                                    : _customerForm(false);
                              })
                          : Center(
                              child: Container(
                                  margin: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator()),
                            );
                    },
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _customerForm(bool _editing) {
    if (_editing == null) _editing = false;
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
                controller: _idCtrl,
                enabled: false,
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
          StreamBuilder(
            stream: _customerDetailBloc.lastName,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                    controller: _lastNameCtrl,
                    onChanged: _customerDetailBloc.changeLastName,
                    enabled: _editing,
                    decoration: InputDecoration(
                        labelText: 'Apellidos',
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
          StreamBuilder(
            stream: _customerDetailBloc.firstName,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                    controller: _firstNameCtrl,
                    onChanged: _customerDetailBloc.changeFirstName,
                    enabled: _editing,
                    decoration: InputDecoration(
                        labelText: 'Nombres',
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
          StreamBuilder(
            stream: _customerDetailBloc.email,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                    controller: _emailCtrl,
                    onChanged: _customerDetailBloc.changeEmail,
                    enabled: _editing,
                    decoration: InputDecoration(
                        labelText: 'Email',
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
          StreamBuilder(
            stream: _customerDetailBloc.cellphone,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                    controller: _cellphoneCtrl,
                    onChanged: _customerDetailBloc.changeCellphone,
                    enabled: _editing,
                    decoration: InputDecoration(
                        labelText: 'Celular',
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
          StreamBuilder(
              stream: _customerDetailBloc.telephone,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                      controller: _telephoneCtrl,
                      onChanged: _customerDetailBloc.changeTelephone,
                      enabled: _editing,
                      decoration: InputDecoration(
                          labelText: 'Teléfono',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff011e41))),
                          errorText: snapshot.error)),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                      child: Text(
                        'Nacimiento',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      )),
                  StreamBuilder<bool>(
                      stream: _customerDetailBloc.editing,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return snapshot.hasData
                            ? _editingBornDate(snapshot.data)
                            : _editingBornDate(false);
                      }),
                ],
              ),
              Container(
                child: StreamBuilder(
                    stream: _customerDetailBloc.editing,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return snapshot.hasData
                          ? _footButtons(snapshot.data)
                          : _footButtons(false);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editingBornDate(bool _editing) {
    var _textSize = _queryData.size.width * 0.044;
    return _editing
        ? Container(
            margin: EdgeInsets.only(left: 20.0, right: 10.0),
            width: 100.0,
            height: 30.0,
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom: BorderSide(
                        color: _editing ? Colors.black : Colors.grey))),
            child: InkWell(
              child: StreamBuilder<String>(
                stream: _customerDetailBloc.bornDate,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasError)
                    return Text(
                      snapshot.data.isEmpty ? 'dd/MM/yyyy' : snapshot.data,
                      style: TextStyle(
                          color: Colors.blueAccent, fontSize: _textSize),
                    );
                  return snapshot.hasData
                      ? Text(
                          snapshot.data,
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: _textSize),
                        )
                      : Text(
                          snapshot.data.isEmpty ? 'dd/MM/yyyy' : snapshot.data,
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: _textSize),
                        );
                },
              ),
              onTap: () {
                _selectDate();
              },
            ),
          )
        : Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            width: 100.0,
            height: 30.0,
            decoration: BoxDecoration(
                border:
                    BorderDirectional(bottom: BorderSide(color: Colors.grey))),
            child: InkWell(
                child: StreamBuilder(
                    stream: _customerDetailBloc.bornDate,
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return snapshot.hasData
                          ? Text(
                              snapshot.data.isEmpty
                                  ? 'dd/MM/yyyy'
                                  : snapshot.data,
                              style: TextStyle(
                                  color: Colors.black, fontSize: _textSize),
                            )
                          : Text(
                              'dd/MM/yyyy',
                              style: TextStyle(
                                  color: Colors.black, fontSize: _textSize),
                            );
                    })),
          );
  }

  Widget _footButtons(bool _editing) {
    return _editing
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              StreamBuilder(
                stream: _customerDetailBloc.submitCustomer,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return snapshot.hasData
                      ? _confirmButton(snapshot.data)
                      : _confirmButton(false);
                },
              ),
              Container(
                  margin: EdgeInsets.only(top: 20.0, right: 20.0, bottom: 20.0),
                  child: IconButton(
                    onPressed: () {
                      _customerDetailBloc.fetchCustomer(widget.customer.id);
                      _customerDetailBloc.changeEditing(false);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.redAccent,
                    ),
                    color: Colors.redAccent,
                  )),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20.0, right: 20.0, bottom: 20.0),
                  child: IconButton(
                    onPressed: () {
                      _customerDetailBloc.changeEditing(true);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.lightBlue,
                    ),
                  ))
            ],
          );
  }

  Widget _confirmButton(bool _submit) {
    return Container(
        margin: EdgeInsets.only(top: 20.0, right: 10.0, bottom: 20.0),
        child: IconButton(
          onPressed: () {
            if (_submit) _confirmDialog();
          },
          icon: Icon(
            Icons.save,
            color: _submit ? Colors.lightBlue : Colors.grey,
          ),
        ));
  }

  void _confirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Editar cliente'),
            content: Text('Está seguro de guardar los cambios?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Sí',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.lightBlue,
                onPressed: () {
                  _customerDetailBloc.updateCustomer(_loginBloc.user.value.user,
                      _settingsBloc.device.value.id);
                  Navigator.of(context).pop();
                  _customerDetailBloc.changeEditing(false);
                },
              ),
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _showUpdatingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Actualizando cliente'),
            content: Container(
                height: 40.0,
                width: 40.0,
                child: Center(child: CircularProgressIndicator())),
          );
        });
  }
}
