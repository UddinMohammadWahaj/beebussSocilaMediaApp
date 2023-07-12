import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmaincontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';

class SubscribeMerchantWebsiteView extends StatefulWidget {
  final String? memberID;
  final String? totalBudget;
  final String? adBudget;
  final String? postID;
  final String? dataID;
  final String? url;
  final String? heading;
  final Function? hideNavbar;
  final String? from;
  BebuzeeShopManagerController? shopmanager;
  SubscribeMerchantWebsiteView({
    this.memberID,
    this.totalBudget,
    this.adBudget,
    this.postID,
    this.dataID,
    this.url,
    this.heading,
    this.hideNavbar,
    this.shopmanager,
    this.from,
  });

  @override
  _SubscribeMerchantWebsiteViewState createState() =>
      _SubscribeMerchantWebsiteViewState();
}

class _SubscribeMerchantWebsiteViewState
    extends State<SubscribeMerchantWebsiteView> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool showTutorial = false;

  Future<void> confirmPayment(String token, String payerID) async {
    var url = Uri.parse("https://www.bebuzee.com/app_developenew.php");

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/paypal_success_payment.php?user_id=${widget.memberID.toString()}&payer_id=$payerID&token=$token&ad_budget=${widget.adBudget}&data_id=${widget.dataID}&post_id=${widget.postID}&total_budget=${widget.totalBudget}');

    String? tokendata =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    var client = Dio();
    final response = await client
        .postUri(
          newurl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokendata',
          }),
        )
        .then((value) => value);

    // final response = await http.post(url, body: {
    //   "user_id": widget.memberID.toString(),
    //   "payer_id": payerID,
    //   "token": token,
    //   "ad_budget": widget.adBudget,
    //   "data_id": widget.dataID,
    //   "post_id": widget.postID,
    //   "total_budget": widget.totalBudget,
    //   "action": "paypal_success_page",
    // });

    if (response.statusCode == 200) {
      print(response.data);
    }
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
    WebView.platform = SurfaceAndroidWebView(); //
    if (widget.from != null) {
      setState(() {
        from = widget.from!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("webvie =${widget.url}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryWhiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: AppBar(
          elevation: 2,
          brightness: Brightness.light,
          title: Text(
            'Merchant Subscription',
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
                Navigator.pop(context);
              }
              widget.shopmanager!.fetchsubscriptionType();

              // String paymenturl = await widget.shopmanager.fe
              //                   .subscribeMerchant('5', 'gold')
              //                   .then((value) => value);
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
          } else {
            Navigator.pop(context);
          }
          return true;
          widget.shopmanager!.fetchsubscriptionType();
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
              print('$request');
              if (request.url.startsWith(
                  'https://www.bebuzee.com/boost_post_success_mob.html')) {
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
                // confirmPayment(token, payerID);

                return NavigationDecision.navigate;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
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
