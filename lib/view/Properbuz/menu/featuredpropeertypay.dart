import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeaturedPropertyPayWebView extends StatefulWidget {
  String? paymenetUrl;
  String? type;
  FeaturedPropertyPayWebView({Key? key, this.paymenetUrl, this.type})
      : super(key: key);

  @override
  State<FeaturedPropertyPayWebView> createState() =>
      FeaturedPropertyPayWebViewState();
}

class FeaturedPropertyPayWebViewState
    extends State<FeaturedPropertyPayWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: settingsColor,
          title: Text('Featured Property Payment')),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.paymenetUrl,
      ),
    );
  }
}
