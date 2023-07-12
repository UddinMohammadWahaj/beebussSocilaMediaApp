import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyInfoCard extends GetView<PropertiesController> {
  final double? padding;
  final int? index;
  final int? val;
  const PropertyInfoCard({
    Key? key,
    this.padding,
    this.index,
    this.val,
  }) : super(key: key);

  Widget _priceRow() {
    return Container(
      padding: EdgeInsets.only(top: 5, left: padding!, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of("From") +
                " ${controller.properties(val!)[index!].currency} ${controller.properties(val!)[index!].price}",
            style: TextStyle(
                fontSize: 22,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _infoTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(
              controller.properties(val!)[index!].type!,
            ),
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500),
          ),
          Text(
            AppLocalizations.of(
              controller.properties(val!)[index!].location!,
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
      padding: EdgeInsets.only(left: padding!, right: 4),
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
            value,
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
          _iconCard(
              controller.properties(val!)[index!].images!.length.toString(),
              CustomIcons.camera_1,
              20),
          _iconCard(controller.properties(val!)[index!].bedrooms!,
              CustomIcons.bed, 20),
          _iconCard(controller.properties(val!)[index!].bathrooms!,
              CustomIcons.bathtub, 20),
          _iconCard(
              controller.properties(val!)[index!].area!, CustomIcons.area, 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_priceRow(), _iconRow(), _infoTile()],
      ),
    );
  }
}
