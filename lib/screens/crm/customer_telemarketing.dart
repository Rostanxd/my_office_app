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
              StreamBuilder<List<Telemarketing>>(
                stream: _customerDetailBloc.telemarketingList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Telemarketing>> snapshot) {
                  return snapshot.hasData
                      ? _telemarketingList(snapshot.data)
                      : Center(
                          child: Container(
                              margin: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator()),
                        );
                },
              ),
            ],
          )),
    );
  }

  Widget _telemarketingList(List<Telemarketing> data) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => ListTile(
            title: Text('${data[index].date} ${data[index].motivate}'),
            subtitle: Text(
                'Resultado: ${data[index].result}; Intentos: ${data[index].attempts}'),
            leading: Icon(Icons.person),
          ),
      itemCount: data.length,
    );
  }
}
