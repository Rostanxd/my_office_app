import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_office_th_app/blocs/bloc_provider.dart';
import 'package:my_office_th_app/blocs/home_bloc.dart';
import 'package:my_office_th_app/blocs/login_bloc.dart';
import 'package:my_office_th_app/blocs/setting_bloc.dart';
import 'package:my_office_th_app/components/user_drawer.dart';
import 'package:my_office_th_app/models/card_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  SettingsBloc _settingsBloc;
  LoginBloc _loginBloc;
  HomeBloc _homeBloc;
  MediaQueryData _queryData;
  WebViewController _controller;

  @override
  void didChangeDependencies() {
    print('Home >> didChangeDependencies');
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);

    /// Managers set seller id to empty to watch all the sales
    _homeBloc.fetchAllCardInfo(
        _loginBloc.local.value.id,
        /// Sellers and Sub-Manager, they can only watch their sales
        _loginBloc.user.value.profile.id == 'V' ||
            _loginBloc.user.value.profile.id == 'S'
            ? _loginBloc.user.value.sellerId
            : '');

    _queryData = _settingsBloc.queryData.value;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Home >> build');
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
//        _cardInfoTelemarketingWeekly(),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          height: _queryData.size.height * 0.90,
          child: _loginBloc.user.value.profile.id == 'V' ||
              _loginBloc.user.value.profile.id == 'S'
              ? WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: 'http://info.thgye.com.ec/VtaSemanalCom.html?'
                    'sellerId=${_loginBloc.user.value.sellerId}&localId=${_loginBloc.local.value.id}',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                  },
                )
              : WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: 'http://info.thgye.com.ec/VtaSemanalCom.html?'
                    'sellerId=&localId=${_loginBloc.local.value.id}',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                  },
                ),
        ),
        SizedBox(height: 20.0,)
      ]),
      floatingActionButton: StreamBuilder<bool>(
        stream: _homeBloc.refreshHome,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.hasData && snapshot.data
              ? FloatingActionButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    _homeBloc.fetchAllCardInfo(_loginBloc.local.value.id,
                        _loginBloc.user.value.sellerId);
                    _controller.reload();
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
/*
  Widget _cardInfoTelemarketingWeekly() {
    final _color1 = Color(0xFF0033CC);
    final _color2 = Color(0xFF395CBE);
    return StreamBuilder<CardInfo>(
      stream: _homeBloc.cardTelemarketingWeekly,
      builder: (BuildContext context, AsyncSnapshot<CardInfo> snapshot) {
        if (snapshot.hasError)
          _cardData('', Icon(Icons.person), _color1, _color2,
              'Telemarketing Semanal', snapshot.error, '', '');
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
            : _cardDataLoading(
                _color1, _color2, 'Telemarketing de la semana...');
      },
    );
  }
*/
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
    var _textSize = _queryData.size.width * 0.035;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: _settingsBloc.queryData.value.size.width*0.25,
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(_titleLeft,
                  style: TextStyle(
                      fontSize: _textSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              width: _settingsBloc.queryData.value.size.width*0.40,
              alignment: Alignment(1, 0),
              child: Text(_titleRight,
                  style: TextStyle(
                      fontSize: _textSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(_subLeft,
                  style: TextStyle(
                    fontSize: _textSize,
                    color: Colors.white,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              alignment: Alignment(1, 0),
              child: Text(_subRight,
                  style: TextStyle(
                    fontSize: _textSize,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
