import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: missing_return
Fluttertoast? customToastWhite(
    String message, double fontSize, ToastGravity gravity) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    backgroundColor: Colors.white,
    textColor: Colors.black87,
    fontSize: fontSize,
  );
  return null;
}

// ignore: missing_return
Fluttertoast? customToastBlack(
    String message, double fontSize, ToastGravity gravity) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    backgroundColor: Colors.black.withOpacity(0.8),
    textColor: Colors.white,
    fontSize: fontSize,
  );
  return null;
}
