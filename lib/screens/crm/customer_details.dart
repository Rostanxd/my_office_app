import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/screens/crm/customer_info.dart';
import 'package:my_office_th_app/screens/crm/customer_telemarketing.dart';
import 'package:my_office_th_app/screens/crm/customer_summary.dart';

class CustomerDetail extends StatefulWidget {
  final Customer customer;

  CustomerDetail(this.customer);

  @override
  State<StatefulWidget> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  CustomerDetailBloc _customerDetailBloc;

  @override
  void didChangeDependencies() {
    print('CustomerDetails >> didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('CustomerDetails >> dispose');
    _customerDetailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('CustomerDetails >> build');
    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);

    /// Default index for the bottom navigation bar.
    _customerDetailBloc.changeIndex(0);

    var _widgetOptions = [
      CustomerInfo(widget.customer),
      CustomerSummary(widget.customer),
      CustomerTelemarketing(widget.customer),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff011e41),
      ),
      body: Center(
        child: StreamBuilder<int>(
            stream: _customerDetailBloc.index,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? _widgetOptions.elementAt(_customerDetailBloc.index.value)
                  : CardDummyLoading();
            }),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _customerDetailBloc.index,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasError) print(snapshot.error.toString());
          return snapshot.hasData
              ? BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.info), title: Text('Info')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_cart), title: Text('Compras')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.monetization_on),
                        title: Text('Telemarketing')),
                  ],
                  currentIndex: snapshot.data,
                  fixedColor: Colors.deepPurple,
                  onTap: (index) {
                    _customerDetailBloc.changeIndex(index);
                  },
                )
              : CardDummyLoading();
        },
      ),
    );
  }
}
