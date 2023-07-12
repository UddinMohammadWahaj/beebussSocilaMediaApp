import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProperbuzWebView extends StatelessWidget {
  final String? url;

  const ProperbuzWebView({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
        ));
  }
}
