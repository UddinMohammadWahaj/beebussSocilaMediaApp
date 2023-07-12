import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditionsWebView extends StatelessWidget {
  final String? title;
  final String? url;
  const TermsAndConditionsWebView({Key? key, this.title, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            size: 25,
            color: Colors.black,
          ),
          splashRadius: 20,
          constraints: BoxConstraints(),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title!,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 14.0.sp),
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
      ),
    );
  }
}
