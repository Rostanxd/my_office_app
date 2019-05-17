import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/customer_detail_bloc.dart';
import 'package:my_office_th_app/components/card_dummy_loading.dart';
import 'package:my_office_th_app/models/customer.dart';
import 'package:my_office_th_app/screens/crm/customer_info.dart';
import 'package:my_office_th_app/screens/crm/customer_summary_ios.dart';
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
  List<Widget> _widgetOptions = new List<Widget>();
  List<Widget> _appBarActions = new List<Widget>();
  List<BottomNavigationBarItem> _buttonNavigationBarItems =
      new List<BottomNavigationBarItem>();

  @override
  void initState() {
    /// Loading options and widgets by platform
    if (Platform.isAndroid) {
      _widgetOptions.add(CustomerInfo(widget.customer));
      _widgetOptions.add(CustomerSummary(widget.customer));
      _widgetOptions.add(CustomerTelemarketing(widget.customer));

      _buttonNavigationBarItems.add(
          BottomNavigationBarItem(icon: Icon(Icons.info), title: Text('Info')));
      _buttonNavigationBarItems.add(BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), title: Text('Compras')));
      _buttonNavigationBarItems.add(BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on), title: Text('Telemarketing')));
    } else {
      _widgetOptions.add(CustomerInfo(widget.customer));
      _widgetOptions.add(CustomerTelemarketing(widget.customer));

      _buttonNavigationBarItems.add(
          BottomNavigationBarItem(icon: Icon(Icons.info), title: Text('Info')));
      _buttonNavigationBarItems.add(BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on), title: Text('Telemarketing')));

      _appBarActions.add(Container(
        padding: EdgeInsets.all(10.0),
        child: FlatButton(
          child: Text(
            'Ver compras',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerSummaryIos(
                        widget.customer, _customerDetailBloc)));
          },
        ),
      ));
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('CustomerDetails >> didChangeDependencies');

    _customerDetailBloc = BlocProvider.of<CustomerDetailBloc>(context);

    /// Default index for the bottom navigation bar.
    _customerDetailBloc.changeIndex(0);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff011e41),
        actions: _appBarActions,
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
                  items: _buttonNavigationBarItems,
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
