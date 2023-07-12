import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class SimpleWebView extends StatefulWidget {
  final String url;
  final String? heading;

  SimpleWebView({
    required this.url,
    this.heading,
  });

  @override
  _SimpleWebViewState createState() => _SimpleWebViewState();
}

class _SimpleWebViewState extends State<SimpleWebView> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool showTutorial = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  String from = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: AppBar(
          elevation: 2,
          brightness: Brightness.light,
          title: Text(
            widget.heading!,
            style: TextStyle(
              color: primaryBlackColor,
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              isIOS ? Icons.keyboard_arrow_left : Icons.keyboard_backspace,
              size: 30,
              color: primaryBlackColor,
            ),
          ),
          backgroundColor: primaryWhiteColor,
          actions: [
            _isLoading
                ? CupertinoActivityIndicator(
                    radius: 20,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: primaryBlackColor,
                      size: 30,
                    ),
                    onPressed: () {
                      _controller!.reload();
                    },
                  ),
          ],
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            //   print('Page started loading: $url');
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            //   print('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }
}
