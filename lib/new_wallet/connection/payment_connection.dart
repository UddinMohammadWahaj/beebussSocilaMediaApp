import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentConnection{

  Future<Map<String, dynamic>> _createPaymentIntents() async {
    final String url = 'https://api.stripe.com/v1/payment_intents';

    Map<String, dynamic> body = {
      'amount': '2000',
      'currency': 'usd',
      'payment_method_types[]': 'card'
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to create PaymentIntents.';
    }
  }
}