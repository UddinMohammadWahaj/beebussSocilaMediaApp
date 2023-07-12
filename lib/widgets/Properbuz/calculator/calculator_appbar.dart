
import 'package:sizer/sizer.dart';
import 'package:bizbultest/services/Properbuz/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar calculatorAppBar (BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    brightness: Brightness.dark,
    leading: IconButton(
      splashRadius: 20,
      icon: Icon(
        Icons.keyboard_backspace,
        size: 28,
        color: Colors.black,
      ),
      color: Colors.white,
      onPressed: () {
        Navigator.pop(context);
        Get.delete<CalculatorController>();
      },
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 14.0.sp, color: Colors.black, fontWeight: FontWeight.w500),
    ),
  );
}