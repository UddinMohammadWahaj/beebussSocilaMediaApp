import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetBar properbuzSnackBar(String message) {
  return GetBar(
    snackPosition: SnackPosition.TOP,
    message: message,
    backgroundColor: hotPropertiesThemeColor,
    duration: Duration(seconds: 3),
  );
}
