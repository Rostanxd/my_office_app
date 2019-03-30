import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/models/card_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginBloc _loginBloc;
  HomeBloc _homeBloc;

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);

    _homeBloc.fetchAllCardInfo(
        _loginBloc.local.value.id, _loginBloc.user.value.sellerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xff011e41),
      ),
      drawer: UserDrawer(),
      body: ListView(children: <Widget>[
        _cardInfoMonthlySales(),
        _cardInfoWeeklySales(),
        _cardInfoDailySales(),
        _cardInfoCustomersWeek(),
        _cardInfoSalesAnalysis(),

//          Container(
//            height: 300.0,
//            margin: EdgeInsets.all(10.0),
//            child: WebView(
//              initialUrl: 'https://flutter.dev/',
//              gestureRecognizers: Set()
//                ..add(Factory<VerticalDragGestureRecognizer>(
//                    () => VerticalDragGestureRecognizer())),
//            ),
//          ),
      ]),
      floatingActionButton: StreamBuilder<bool>(
        stream: _homeBloc.refreshHome,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData ) print(snapshot.data);
          return snapshot.hasData && snapshot.data
              ? FloatingActionButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    _homeBloc.fetchAllCardInfo(_loginBloc.local.value.id,
                        _loginBloc.user.value.sellerId);
                  })
              : FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.refresh),
                  onPressed: () {});
        },
      ),
    );
  }

  Widget _cardInfoMonthlySales() {
    final _color1 = Color(0xFF303f9f);
    final _color2 = Color(0xFF7b1fa2);
    return StreamBuilder<CardInfo>(
      stream: _homeBloc.cardMonthlySales,
      builder: (BuildContext context, AsyncSnapshot<CardInfo> snapshot) {
        if (snapshot.hasError)
          _cardData('', Icon(Icons.attach_money), _color1, _color2,
              'Ventas del mes', snapshot.error, '', '');

        return snapshot.hasData
            ? _cardData(
                snapshot.data.image,
                Icon(Icons.attach_money),
                _color1,
                _color2,
                snapshot.data.title1,
                snapshot.data.title2,
                snapshot.data.subtitle1,
                snapshot.data.subtitle2)
            : _cardDataLoading(_color1, _color2, 'Ventas del mes...');
      },
    );
  }

  Widget _cardInfoWeeklySales() {
    final _color1 = Color(0xFF0288d1);
    final _color2 = Color(0xFF26c6da);
    return StreamBuilder<CardInfo>(
      stream: _homeBloc.cardWeeklySales,
      builder: (BuildContext context, AsyncSnapshot<CardInfo> snapshot) {
        if (snapshot.hasError)
          _cardData('', Icon(Icons.attach_money), _color1, _color2,
              'Ventas de la semana', snapshot.error, '', '');
        return snapshot.hasData
            ? _cardData(
                snapshot.data.image,
                Icon(Icons.attach_money),
                _color1,
                _color2,
                snapshot.data.title1,
                snapshot.data.title2,
                snapshot.data.subtitle1,
                snapshot.data.subtitle2)
            : _cardDataLoading(_color1, _color2, 'Ventas de la semana...');
      },
    );
  }

  Widget _cardInfoDailySales() {
    final _color1 = Color(0xFF43A047);
    final _color2 = Color(0xFF1de9b6);
    return StreamBuilder<CardInfo>(
      stream: _homeBloc.cardDailySales,
      builder: (BuildContext context, AsyncSnapshot<CardInfo> snapshot) {
        if (snapshot.hasError)
          _cardData('', Icon(Icons.attach_money), _color1, _color2,
              'Ventas del día', snapshot.error, '', '');
        return snapshot.hasData
            ? _cardData(
                snapshot.data.image,
                Icon(Icons.attach_money),
                _color1,
                _color2,
                snapshot.data.title1,
                snapshot.data.title2,
                snapshot.data.subtitle1,
                snapshot.data.subtitle2)
            : _cardDataLoading(_color1, _color2, 'Ventas del día...');
      },
    );
  }

  Widget _cardInfoCustomersWeek() {
    final _color1 = Color(0xFFFF5252);
    final _color2 = Color(0xFFf48fb1);
    return StreamBuilder<CardInfo>(
      stream: _homeBloc.cardCustomersWeek,
      builder: (BuildContext context, AsyncSnapshot<CardInfo> snapshot) {
        if (snapshot.hasError)
          _cardData('', Icon(Icons.person), _color1, _color2,
              'Clientes de la semana', snapshot.error, '', '');
        return snapshot.hasData
            ? _cardData(
                '',
                Icon(Icons.person),
                _color1,
                _color2,
                snapshot.data.title1,
                snapshot.data.title2,
                snapshot.data.subtitle1,
                snapshot.data.subtitle2)
            : _cardDataLoading(_color1, _color2, 'Clientes de la semana...');
      },
    );
  }

  Widget _cardInfoSalesAnalysis() {
    final _color1 = Color(0xFFff6f00);
    final _color2 = Color(0xFFffca28);
    return StreamBuilder<CardInfo>(
      stream: _homeBloc.cardSalesAnalysis,
      builder: (BuildContext context, AsyncSnapshot<CardInfo> snapshot) {
        if (snapshot.hasError)
          _cardData('', Icon(Icons.show_chart), _color1, _color2,
              'Análisis de ventas', snapshot.error, '', '');
        return snapshot.hasData
            ? _cardData(
                '',
                Icon(Icons.show_chart),
                _color1,
                _color2,
                snapshot.data.title1,
                snapshot.data.title2,
                snapshot.data.subtitle1,
                snapshot.data.subtitle2)
            : _cardDataLoading(_color1, _color2, 'Análisis de ventas...');
      },
    );
  }

  Widget _cardDataLoading(Color _color1, Color _color2, String _message) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset(0.0, 7.0))
          ],
          gradient: LinearGradient(
              colors: [_color1, _color2],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp)),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Color.fromARGB(18, 0, 0, 0),
            child: CircularProgressIndicator()),
        title: Text(
          _message,
          style: TextStyle(
              color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(''),
      ),
    );
  }

  Widget _cardData(
      String _image,
      Icon _icon,
      Color _color1,
      Color _color2,
      String _titleLeft,
      String _titleRight,
      String _subLeft,
      String _subRight) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset(0.0, 7.0))
          ],
          gradient: LinearGradient(
              colors: [_color1, _color2],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color.fromARGB(18, 0, 0, 0),
          child: _image == null || _image.isEmpty
              ? _icon
              : Image(image: AssetImage('assets/img/$_image')),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_titleLeft,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold)),
            Text(_titleRight,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_subLeft,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.0,
                )),
            Text(_subRight,
                style: TextStyle(color: Colors.white, fontSize: 11.0)),
          ],
        ),
      ),
    );
  }
}
