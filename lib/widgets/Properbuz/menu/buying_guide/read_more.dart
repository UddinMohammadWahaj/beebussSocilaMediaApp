import 'package:bizbultest/services/Properbuz/property_guides_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../Language/appLocalization.dart';

class BuyingGuideReadMore extends GetView<PropertyGuidesController> {
  final int index;

  const BuyingGuideReadMore({Key? key, required this.index}) : super(key: key);

  Widget _imageCard() {
    return Container(
      height: 30.0.h,
      width: 100.0.w,
      color: Colors.grey.shade200,
      child: Image(
        image: CachedNetworkImageProvider(controller.blogImage(index)),
        fit: BoxFit.cover,
        height: 30.0.h,
        width: 100.0.w,
      ),
    );
  }

  Widget _descriptionCard() {
    return Html(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        data: AppLocalizations.of(controller.blogsList[index].description!));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertyGuidesController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: hotPropertiesThemeColor,
        brightness: Brightness.dark,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of("Read More"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_imageCard(), _descriptionCard()],
        ),
      ),
    );
  }
}
