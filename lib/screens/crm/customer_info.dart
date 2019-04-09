import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';

class CustomerInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  CustomerDetailBloc _customerDetailBloc;
  LoginBloc _loginBloc;
  TextEditingController _idCtrl = TextEditingController();
  TextEditingController _lastNameCtrl = TextEditingController();
  TextEditingController _firstNameCtrl = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _cellphone = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  String _bornDate = '';
  DateTime _now = new DateTime.now();
  DateFormat formatter = new DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
  }

  ///  Future to show the date picker
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _bornDate != '' ? formatter.parse(_bornDate) : _now,
        firstDate: DateTime(1900),
        lastDate: DateTime(_now.year + 1));

    if (picked != null) {
      _bornDate = formatter.format(picked).toString();
      _customerDetailBloc.changeBornDate(_bornDate);
    }
  }

  @override
  void didChangeDependencies() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);

    /// Loading the text fields controls
    _customerDetailBloc.customer.listen((data){
      _idCtrl.text = data.id;
      _lastNameCtrl.text = data.lastName;
      _firstNameCtrl.text = data.firstName;
      _email.text = data.email;
      _cellphone.text = data.cellphoneOne;
      _telephone.text = data.telephoneOne;
      if (data.bornDate != null) _bornDate = data.bornDate;
    });

    /// Loading the streams
    _customerDetailBloc.loadCustomerStreams();

    /// To call the customer update dialog
    _customerDetailBloc.updating.listen((data) {
      data ? _showUpdatingDialog() : Navigator.pop(context);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Datos Generales',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              Divider(),
              StreamBuilder(
                  stream: _customerDetailBloc.editing,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasError)
                      return Text(snapshot.error.runtimeType.toString());
                    return snapshot.hasData
                        ? _customerForm(snapshot.data)
                        : _customerForm(false);
                  }),
            ],
          )),
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
                        labelText: 'Nombes',
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
                    controller: _email,
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
                    controller: _cellphone,
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
                      controller: _telephone,
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
                  return snapshot.hasData
                      ? Text(
                          snapshot.data,
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 18.0),
                        )
                      : Text(
                          _bornDate.isEmpty ? 'dd/MM/yyyy' : _bornDate,
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 18.0),
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
                child: Text(
              _bornDate.isEmpty ? 'dd/MM/yyyy' : _bornDate,
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            )),
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
                  child: RaisedButton(
                    onPressed: () {
                      _customerDetailBloc.changeEditing(false);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
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
                  child: RaisedButton(
                    onPressed: () {
                      _customerDetailBloc.changeEditing(true);
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    color: Colors.lightBlue,
                  ))
            ],
          );
  }

  Widget _confirmButton(bool _submit) {
    return Container(
        margin: EdgeInsets.only(top: 20.0, right: 5.0, bottom: 20.0),
        child: RaisedButton(
          onPressed: () {
            if (_submit) _confirmDialog();
          },
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          color: _submit ? Colors.lightBlue : Colors.grey,
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
                  _customerDetailBloc
                      .updateCustomer(_loginBloc.user.value.user);
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
