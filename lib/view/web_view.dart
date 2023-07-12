import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class WebsiteView extends StatefulWidget {
  final String? memberID;
  final String? totalBudget;
  final String? adBudget;
  final String? postID;
  final String? dataID;
  final String? url;
  final String? heading;
  final Function? hideNavbar;
  final String? from;
  TabController? tabController;

  WebsiteView(
      {this.memberID,
      this.totalBudget,
      this.adBudget,
      this.postID,
      this.dataID,
      this.url,
      this.heading,
      this.hideNavbar,
      this.from,
      this.tabController});

  @override
  _WebsiteViewState createState() => _WebsiteViewState();
}

class _WebsiteViewState extends State<WebsiteView> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool showTutorial = false;

  Future<void> confirmPayment(String token, String payerID) async {
    var url = Uri.parse("https://www.bebuzee.com/app_developenew.php");

    final response = await http.post(url, body: {
      "user_id": widget.memberID.toString(),
      "payer_id": payerID,
      "token": token,
      "ad_budget": widget.adBudget,
      "data_id": widget.dataID,
      "post_id": widget.postID,
      "total_budget": widget.totalBudget,
      "action": "paypal_success_page",
    });

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  Future<String> confirmVideoPayment(String token, String payerID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/video_ad_api.php");

    final response = await http.post(url, body: {
      "user_id": widget.memberID.toString(),
      "payer_id": payerID,
      "token": token,
      "ad_budget": widget.adBudget,
      "data_id": widget.dataID,
      "total_budget": widget.totalBudget,
      "action": "paypal_success_page",
    });

    if (response.statusCode == 200) {
      print(response.body);
      print(from + " frommmmmmmmmmmm");
    }
    return "Success";
  }

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
    WebView.platform = SurfaceAndroidWebView();
    if (widget.from != null) {
      setState(() {
        from = widget.from!;
      });
    }
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
            onTap: () async {
              if (widget.hideNavbar != null) {
                Navigator.pop(context);
                // ignore: missing_return, missing_return
                widget.hideNavbar!(false);
              } else {
                print(
                    "this is back ${'https://www.bebuzee.com/api/paypal_payment_status.php?url_data_paypal=${widget.url}'}");
                var response = await ApiProvider().fireApiWithParams(
                    'https://www.bebuzee.com/api/paypal_payment_status.php',
                    params: {
                      "url_data_paypal": widget.url
                    }).then((value) => value);
                print("response of payment=${response.data}");

                Navigator.pop(context);
                if (response.data['payment_status']) {
                  widget.tabController!.animateTo(1);
                }
              }
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
                      _controller.reload();
                    },
                  ),
          ],
        ),
      ),
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          if (widget.hideNavbar != null) {
            Navigator.pop(context);
            // ignore: missing_return, missing_return
            widget.hideNavbar!(false);
            return false;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: Builder(builder: (BuildContext context) {
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
              if (request.url.startsWith(
                  'https://www.bebuzee.com/boost_post_success_video_mob.html')) {
                print('blocking navigation to $request}');
                var url = request.toString();
                var start = "token=";
                var end = "&";
                var start1 = "PayerID=";
                var end1 = ",";

                final startIndex = url.indexOf(start);
                final endIndex = url.indexOf(end, startIndex + start.length);

                final startIndex1 = url.indexOf(start1);
                final endIndex1 =
                    url.indexOf(end1, startIndex1 + start1.length);

                String token =
                    url.substring(startIndex + start.length, endIndex);
                String payerID =
                    url.substring(startIndex1 + start1.length, endIndex1);

                print("token is " + token);
                print("payerID is " + payerID);

                print("total budget is " + widget.adBudget.toString());
                print("ad budget is " + widget.totalBudget.toString());
                // confirmVideoPayment(token, payerID);

                return NavigationDecision.navigate;
              }
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
      ),
    );
  }
}
