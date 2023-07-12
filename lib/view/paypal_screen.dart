import 'dart:core';

import 'package:bizbultest/services/payment/paypalservice.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function? onFinish;
  final String? amount;

  PaypalPayment({this.onFinish, this.amount});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String checkoutUrl;
  late String executeUrl;
  late String accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        //print("access");
        accessToken = (await services.getAccessToken())!;

        //print(accessToken);

        final transactions = getOrderParams();
        // print(transactions.toString());
        final res =
            await services.createPaypalPayment(transactions, accessToken);

        print(res.toString() + '  :res');
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"]!;
            executeUrl = res["executeUrl"]!;
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
            .showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'Premium package';
  String itemPrice = '99.99';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    // String totalAmount = '99.99';
    // String subTotalAmount = '99.99';
    // String shippingCost = '0';
    // int shippingDiscountCost = 0;
    // String userFirstName = 'John';
    // String userLastName = 'Doe';
    // String addressCity = 'Delhi';
    // String addressStreet = 'Mathura Road';
    // String addressZipCode = '110014';
    // String addressCountry = 'India';
    // String addressState = 'Delhi';
    // String addressPhoneNumber = '2026801009';

    // Map<String, dynamic> temp = {
    //   "intent": "CAPTURE",
    //   "payer": {"payment_method": "paypal"},
    //   "transactions": [
    //     {
    //       "amount": {
    //         "total": totalAmount,
    //         "currency": defaultCurrency["currency"],
    //         "details": {
    //           "subtotal": subTotalAmount,
    //           "shipping": shippingCost,
    //           "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
    //         }
    //       },
    //       "description": "The payment transaction description.",
    //       "payment_options": {
    //         "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
    //       },
    //       "item_list": {
    //         "items": items,
    //         if (isEnableShipping && isEnableAddress)
    //           "shipping_address": {
    //             "recipient_name": userFirstName + " " + userLastName,
    //             "line1": addressStreet,
    //             "line2": "",
    //             "city": addressCity,
    //             "country_code": addressCountry,
    //             "postal_code": addressZipCode,
    //             "phone": addressPhoneNumber,
    //             "state": addressState
    //           },
    //       }
    //     }
    //   ],
    //   "note_to_payer": "Contact us for any questions on your order.",
    //   "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    // };
    String amount = widget.amount!;
    print(amount + '  :amount');
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "redirect_urls": {
        "return_url": "http://www.example.com/return_url",
        "cancel_url": "http://www.example.com.br/cancel"
      },
      "transactions": [
        {
          "amount": {
            "currency": "USD",
            "total": amount,
            "details": {"shipping": "0.00", "subtotal": amount}
          },
          "item_list": {
            "items": [
              {
                "name": "Premium package",
                "currency": "USD",
                "sku": "123",
                "quantity": "1",
                "price": amount
              }
            ]
          },
          "description": "Payment description"
        }
      ]
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              print(payerID.toString() + "payer id");
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  print("success payment");
                  widget.onFinish!(id);
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
