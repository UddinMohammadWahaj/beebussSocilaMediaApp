import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';

SnackBar showSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: primaryBlueColor,
    duration: Duration(seconds: 1),
  );
}

SnackBar blackSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: Colors.white,
    duration: Duration(seconds: 2),
  );
}


SnackBar customSnackBar(String message, Color textColor, double fontSize, Color backgroundColor, int seconds) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: backgroundColor,
    duration: Duration(seconds: seconds),
  );
}