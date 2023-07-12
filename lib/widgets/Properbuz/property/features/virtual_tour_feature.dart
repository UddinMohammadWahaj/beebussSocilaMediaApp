import 'dart:math';

import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panorama/panorama.dart';

class VirtualTourFeature extends GetView<PropertiesController> {
  final int val;
  final int index;

  const VirtualTourFeature({Key? key, required this.val, required this.index})
      : super(key: key);

  Widget _toggleCard(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          color: Colors.transparent,
          height: 50,
          width: 50,
          child: Icon(
            icon,
            color: color,
          )),
    );
  }

  Widget _paginationCard() {
    return Positioned.fill(
      bottom: 15,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.white,
          height: 50,
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _toggleCard(Icons.arrow_back_ios, hotPropertiesThemeColor, () {
                if (controller
                        .properties(val)[index]
                        .selectedVirtualIndex!
                        .value !=
                    0) {
                  controller.properties(val)[index].selectedVirtualIndex!.value;
                  controller.virtualTourPageController.jumpToPage(controller
                      .properties(val)[index]
                      .selectedVirtualIndex!
                      .value);
                } else {
                  print("do nothing");
                }
              }),
              Obx(
                () => Text(
                  "${(controller.properties(val)[index].selectedVirtualIndex!.value + 1).toString()}/${controller.properties(val)[index].virtualTour!.length.toString()}",
                  style: TextStyle(
                      fontSize: 15,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              _toggleCard(
                  Icons.arrow_forward_ios_rounded, hotPropertiesThemeColor, () {
                if (controller
                        .properties(val)[index]
                        .selectedVirtualIndex!
                        .value !=
                    controller.properties(val)[index].virtualTour!.length - 1) {
                  controller
                      .properties(val)[index]
                      .selectedVirtualIndex!
                      .value++;
                  controller.virtualTourPageController.jumpToPage(controller
                      .properties(val)[index]
                      .selectedVirtualIndex!
                      .value);
                } else {
                  print("do nothing");
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _virtualImageCard(int tourIndex) {
    return Panorama(
      key: UniqueKey(),
      child: Image(
        image: CachedNetworkImageProvider(
            controller.properties(val)[index].virtualTour![tourIndex]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    print(
        "----- length =$val -- ${controller.properties(val)[index].virtualTour}");
    return Stack(
      children: [
        Obx(
          () => PageView.builder(
              controller: controller.virtualTourPageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.properties(val)[index].virtualTour!.length,
              itemBuilder: (context, tourIndex) {
                return _virtualImageCard(tourIndex);
              }),
        ),
        _paginationCard()
      ],
    );
  }
}
