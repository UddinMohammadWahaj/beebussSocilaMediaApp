import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePostType extends GetView<ProperbuzFeedController> {
  const ImagePostType({Key? key}) : super(key: key);

  Widget _photosLengthCard() {
    return Positioned.fill(
      left: 20,
      bottom: 10,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Obx(() => Text(
                  "${controller.images.length} ${controller.imagesString()}",
                  style: TextStyle(
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ))),
      ),
    );
  }

  Widget _imageCard(File file, int index) {
    return Container(
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.file(
              file,
              fit: BoxFit.cover,
              height: 250,
              width: 100.0.w,
            ),
          ),
          Positioned.fill(
            right: 10,
            top: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(5),
                  onPressed: () => controller.deleteImage(index),
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: hotPropertiesThemeColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Obx(
      () => SizedBox(
        child: controller.images.isEmpty
            ? Container()
            : Container(
                height: 250,
                child: Stack(
                  children: [
                    Obx(
                      () => PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.images.length,
                          itemBuilder: (context, index) {
                            return _imageCard(controller.images[index], index);
                          }),
                    ),
                    _photosLengthCard()
                  ],
                ),
              ),
      ),
    );
  }
}
