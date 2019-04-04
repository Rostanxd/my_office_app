import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);

    _idCtrl.text = widget.customer.id;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
          elevation: 5.0,
          child: StreamBuilder(
              stream: _customerDetailBloc.editing,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasError)
                  return Text(snapshot.error.runtimeType.toString());
                return snapshot.hasData
                    ? _customerForm(snapshot.data)
                    : CircularProgressIndicator();
              })),
    );
  }

  Widget _customerForm(bool _editing) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5.0),
            child: TextField(
                controller: _idCtrl,
                enabled: _editing,
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
            margin: EdgeInsets.all(5.0),
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
            margin: EdgeInsets.all(5.0),
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
          )
        ],
      ),
    );
  }
}
