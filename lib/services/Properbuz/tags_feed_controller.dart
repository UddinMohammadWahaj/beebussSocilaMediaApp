import 'package:bizbultest/models/Properbuz/properbuz_feeds_model.dart';
import 'package:bizbultest/services/Properbuz/api/properbuz_feeds_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class TagsFeedController extends GetxController {
  Color appBarColor = HexColor("#2b6482");
  Color appBarLightColor = HexColor("#488aa4");
  Color settingsColor = HexColor("#3c5f6e");
  Color featuredColor = HexColor("#377fa9");
  Color iconColor = HexColor("#6d8f9f");
  Color statusBarColor = HexColor("#1e475b");


  var page = 1.obs;

  var feeds = <ProperbuzFeedsModel>[].obs;





}