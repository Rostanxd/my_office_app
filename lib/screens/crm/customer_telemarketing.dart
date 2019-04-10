import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/models/telemarketing.dart';

class CustomerTelemarketing extends StatefulWidget {
  final Customer customer;

  CustomerTelemarketing(this.customer);

  @override
  State<StatefulWidget> createState() => _CustomerTelemarketingState();
}

class _CustomerTelemarketingState extends State<CustomerTelemarketing> {
  LoginBloc _loginBloc;
  CustomerDetailBloc _customerDetailBloc;

  @override
  void initState() {
    print('CustomerTelemarketing >> initSate');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('CustomerTelemarketing >> didChangeDependencies');
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);

    /// Calling the api to search the customer telemarketing
    _customerDetailBloc.fetchCustomerTelemarketing(
        _loginBloc.user.value.sellerId, widget.customer.id);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('CustomerTelemarketing >> build');
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Telemarketing del cliente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              Divider(),
              Container(
                height: 300.0,
                child: StreamBuilder<List<Telemarketing>>(
                  stream: _customerDetailBloc.telemarketingList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Telemarketing>> snapshot) {
                    if (snapshot.hasError)
                      return Center(
                        child: Text(snapshot.error),
                      );
                    return snapshot.hasData
                        ? _telemarketingList(snapshot.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget _telemarketingList(List<Telemarketing> data) {
    if (data.length == 0)
      return Container(
        child: Center(
          child: Text('No hay datos'),
        ),
      );
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => ListTile(
            title: Text('${data[index].motivate}'),
            subtitle: Text(
                'Fecha: ${data[index].date} - Intentos: ${data[index].attempts}'),
            leading: Icon(Icons.person),
          ),
      itemCount: data.length,
    );
  }
}
