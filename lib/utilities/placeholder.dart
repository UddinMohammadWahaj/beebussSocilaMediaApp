import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Placeholder extends StatefulWidget {
  @override
  _PlaceholderState createState() => _PlaceholderState();
}

class _PlaceholderState extends State<Placeholder> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
