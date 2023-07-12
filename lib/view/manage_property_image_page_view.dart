import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ManagePropertyImagesPageView extends GetView<UserPropertiesController> {
  final int index;
  final int value;

  const ManagePropertyImagesPageView(
      {Key? key, required this.index, required this.value})
      : super(key: key);

  Widget _imageCard(String image) {
    return Container(
      color: Colors.grey.shade200,
      child: Image(
        image: CachedNetworkImageProvider(image),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _pageCard() {
    return Positioned.fill(
      left: 10,
      bottom: 15,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: new BoxDecoration(
            color: hotPropertiesThemeColor,
            borderRadius: BorderRadius.all(Radius.circular(2)),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Obx(() => Text(
                "${(controller.value(value)[index].selectedPhotoIndex!.value + 1).toString()}/${controller.value(value)[index].images!.length}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 5),
          height: 50.0.h,
          width: 100.0.w,
          child: PageView.builder(
              onPageChanged: (page) =>
                  controller.changePropertyImagesPage(page, index, value),
              itemCount: controller.value(value)[index].images!.length,
              itemBuilder: (context, imageIndex) {
                return _imageCard(
                    controller.value(value)[index].images![imageIndex]);
              }),
        ),
        _pageCard()
      ],
    );
  }
}
