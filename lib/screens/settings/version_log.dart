import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VersionLog extends StatelessWidget {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Actualizaciones'),
        backgroundColor: Color(0xff011e41),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'http://info.thgye.com.ec/LogVersiones.html',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reload();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
