import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Properbuz/hot_properties_model.dart';
import 'package:bizbultest/services/Properbuz/api/properties_api.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/detailed_property_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PropertyCard extends GetView<PropertiesController> {
  final HotPropertiesModel? property;
  final int index;
  final int val;

  const PropertyCard(
      {Key? key, this.property, required this.index, required this.val})
      : super(key: key);

  Widget _customStackCard(String value, Color textColor, Color bgColor,
      Alignment alignment, double top, double bottom) {
    return Positioned.fill(
      top: top,
      bottom: bottom,
      child: Align(
        alignment: alignment,
        child: Container(
          decoration: new BoxDecoration(
            color: bgColor,
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Text(
            AppLocalizations.of(value),
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _imageCard(String image) {
    var r = Random();
    return Stack(
      children: [
        Container(
            color: Colors.grey.shade200,
            height: 225,
            width: 100.0.w,
            child: Image(
              image: CachedNetworkImageProvider(image),
              fit: BoxFit.cover,
            )),
        /*     _customStackCard(
            AppLocalizations.of(
              "NEW CONSTRUCTION",
            ),
            settingsColor,
            Colors.white,
            Alignment.topLeft,
            15,
            0),

        _customStackCard(
            AppLocalizations.of(
              "FEATURED",
            ),
            Colors.white,
            settingsColor,
            Alignment.bottomLeft,
            0,
            15)*/
      ],
    );
  }

  Widget _pageCard() {
    return Positioned.fill(
      left: 10,
      bottom: 10,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2)),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          child: Obx(() =>
              (controller.properties(val)[index].selectedPhotoIndex!.value == 0)
                  ? Text(

                      "${(controller.properties(val)[index].selectedPhotoIndex!.value + 1).toString()}"
                      "/"
                      "${controller.properties(val)[index].images!.length.toString()}",

                      // AppLocalizations.of(
                      //     "${(controller.properties(val)[index].selectedPhotoIndex.value + 1).toString()}"
                      //     "/"
                      //     "${controller.properties(val)[index].images.length.toString()}"),

                      style: TextStyle(
                          color: hotPropertiesThemeColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )
                  : Text(

                      "${(controller.properties(val)[index].selectedPhotoIndex!.value).toString()}"
                      "/"
                      "${controller.properties(val)[index].images!.length.toString()}",

                      // AppLocalizations.of(
                      //     "${(controller.properties(val)[index].selectedPhotoIndex.value).toString()}"
                      //     "/"
                      //     "${controller.properties(val)[index].images.length.toString()}"),

                      style: TextStyle(
                          color: hotPropertiesThemeColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )),
        ),
      ),
    );
  }

  Widget _imagePageBuilder() {
    return Stack(
      children: [
        Container(
          height: 225,
          width: 100.0.w,
          child: PageView.builder(
              onPageChanged: (val) =>
                  controller.changeHomeIndex(index, val + 1),
              itemCount: controller.properties(val)[index].images!.length,
              itemBuilder: (context, imageIndex) {
                return _imageCard(
                    controller.properties(val)[index].images![imageIndex]);
              }),
        ),
        _pageCard()
      ],
    );
  }

  Widget _iconButton(IconData iconData, double size, onTap, Color color) {
    return IconButton(
      constraints: BoxConstraints(),
      splashRadius: 20,
      icon: Icon(
        iconData,
        size: size,
      ),
      color: color,
      onPressed: onTap,
    );
  }

  Widget _priceRow() {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 15, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of("From") +
                AppLocalizations.of(
                    " ${controller.properties(val)[index].currency} ${controller.properties(val)[index].price}"),
            style: TextStyle(
                fontSize: 22,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              PropertyAPI.memberID == controller.properties(val)[index].agentId
                  ? _iconButton(CupertinoIcons.delete, 22, () {
                      controller.removeProperty(index, val);
                    }, hotPropertiesThemeColor)
                  : Container(),
              SizedBox(width: 5),
              // Obx(() => _iconButton(
              //         controller.properties(val)[index].alertStatus.value
              //             ? Icons.notifications_on
              //             : Icons.notifications_none,
              //         25, () {
              //       controller.alertUnalertDetailed(index, val);
              //     },
              //         controller.properties(val)[index].alertStatus.value
              //             ? hotPropertiesThemeColor
              //             : hotPropertiesThemeColor)),
              Obx(() => _iconButton(
                      controller.properties(val)[index].savedStatus!.value
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      25, () {
                    controller.saveUnsaveDetailed(index, val);
                  },
                      controller.properties(val)[index].savedStatus!.value
                          ? hotPropertiesThemeColor
                          : hotPropertiesThemeColor)),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(
              controller.properties(val)[index].type!,
            ),
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500),
          ),
          Text(
            AppLocalizations.of(
              controller.properties(val)[index].location!,
            ),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          )
        ],
      ),
    );
  }

  Widget _iconCard(String value, IconData icon, double size) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 5),
      padding: EdgeInsets.only(left: 15, right: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(right: 6),
              child: Icon(
                icon,
                size: size,
                color: Colors.grey.shade600,
              )),
          Text(
            AppLocalizations.of(value),
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _iconRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _iconCard(controller.properties(val)[index].images!.length.toString(),
              CustomIcons.camera_1, 20),
          _iconCard(
              controller.properties(val)[index].bedrooms!, CustomIcons.bed, 20),
          //_iconCard("2", CustomIcons.stairs, 16),
          _iconCard(controller.properties(val)[index].bathrooms!,
              CustomIcons.bathtub, 20),
          _iconCard(
              controller.properties(val)[index].area!, CustomIcons.area, 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("val=$val");
    Get.put(PropertiesController());
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedPropertyView(
                    index: index,
                    val: val,
                  ))),
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imagePageBuilder(),
            _priceRow(),
            _iconRow(),
            _infoTile(),
          ],
        ),
      ),
    );
  }
}
