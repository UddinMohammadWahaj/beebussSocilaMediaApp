import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const Color primaryBlackColor = Colors.black;
const Color primaryBlueColor = Color(0xFF0110ff);
const Color primaryWhiteColor = Colors.white;
Color primaryPinkColor = HexColor("#d64242");
Color primaryBrownColor = HexColor("#873e23");
Color? feedColor = Colors.blue[900];
Color properbuzBlueColor = HexColor("#4b5869");
Color hotPropertiesThemeColor = HexColor("#ee4949");
// Color hotPropertiesThemeColor = HexColor("#d64242");
Color hotPropertiesThemeLightColor = Color.fromARGB(255, 178, 40, 40);
Color hotPropertiesThemeDarkColor = Color.fromARGB(255, 178, 40, 40);

var pIColor = '#f00a0a';
var pmiColor = '#fa6666';
var taxesColor = '#f78383';
var hoaColor = '#fa4343';
var insuranceColor = '#e8c5c5';
Color chartTextColor = Colors.blueGrey.shade400;

Color appBarColor = HexColor("#2b6482");
Color appBarLightColor = HexColor("#488aa4");
Color settingsColor = HexColor("#3c5f6e");
Color featuredColor = HexColor("#377fa9");
Color iconColor = HexColor("#6d8f9f");
Color statusBarColor = HexColor("#1e475b");

const kGoldenColor = Color(0xFFFFD700);
const Color greyColor = Colors.grey;
const Color silverColor = Color(0xFFC0C0C0);

MaterialColor primaryCustom = MaterialColor(0xFF0110ff, {
  50: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.1),
  100: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.2),
  200: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.3),
  300: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.4),
  400: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.5),
  500: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.6),
  600: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.7),
  700: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.8),
  800: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(.9),
  900: Color(int.parse("#0110ff".replaceAll("#", "0xFF"))).withOpacity(1),
});
