import 'package:bizbultest/view/login_page.dart';

import 'package:bizbultest/view/onboarding/signup_page1.dart';
import 'package:bizbultest/view/onboarding/signup_page2.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //Todo: Change when home screen is created
      case '/':
        return MaterialPageRoute(builder: (_) => SignUpPage1());
      case SignUpPage1.routeName:
        return MaterialPageRoute(
          builder: (_) => SignUpPage1(),
        );
      case SignUpPage2.routeName:
        return MaterialPageRoute(
          builder: (_) => SignUpPage2(),
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );


        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return SignUpPage1();
    });
  }
}

/// Sample use:    Navigator.pushNamed(context, '/webView', arguments: news);
