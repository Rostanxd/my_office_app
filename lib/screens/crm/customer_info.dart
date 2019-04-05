import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/models/customer.dart';

class CustomerInfo extends StatefulWidget {
  final Customer customer;

  CustomerInfo(this.customer);

  @override
  State<StatefulWidget> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  CustomerDetailBloc _customerDetailBloc;
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
    print(widget.customer.bornDate);
    _idCtrl.text = widget.customer.id;
    _lastNameCtrl.text = widget.customer.lastName;
    _firstNameCtrl.text = widget.customer.firstName;
    _email.text = widget.customer.email;
    _cellphone.text = widget.customer.cellphoneOne;
    _telephone.text = widget.customer.telephoneOne;
    if (widget.customer.bornDate != null) _bornDate = widget.customer.bornDate;

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
  Widget build(BuildContext context) {
    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);

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
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
                controller: _lastNameCtrl,
                enabled: _editing,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
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
                controller: _firstNameCtrl,
                enabled: _editing,
                decoration: InputDecoration(
                  labelText: 'Nombes',
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
                controller: _email,
                enabled: _editing,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                controller: _cellphone,
                enabled: _editing,
                decoration: InputDecoration(
                  labelText: 'Celular',
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
                controller: _telephone,
                enabled: _editing,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
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
              Container(
                  margin: EdgeInsets.only(top: 20.0, right: 5.0, bottom: 20.0),
                  child: RaisedButton(
                    onPressed: () {
                      _confirmDialog();
                    },
                    child: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    color: Colors.lightBlue,
                  )),
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
}
