import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/alert_property_view.dart';
import 'package:bizbultest/view/Properbuz/detailed_property_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AlertPropertyCard extends GetView<PropertiesController> {
  final int index;

  const AlertPropertyCard({Key? key, required this.index}) : super(key: key);

  Widget _iconButton(IconData iconData, double size) {
    return IconButton(
      constraints: BoxConstraints(),
      splashRadius: 20,
      icon: Icon(
        iconData,
        size: size,
      ),
      color: iconColor,
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AlertPropertyView(
                    index: index,
                    val: 4,
                  ))),
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 225,
                width: 100.0.w,
                color: Colors.grey.shade200,
                child: Image(
                  image: CachedNetworkImageProvider(
                      controller.alertProperties[index].images![0]),
                  fit: BoxFit.cover,
                )),
            Container(
              padding: EdgeInsets.only(top: 5, left: 15, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of("From") +
                        " ${controller.alertProperties[index].currency} ${controller.alertProperties[index].price}",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      // _iconButton(CustomIcons.editing, 25),
                      SizedBox(width: 5),
                      IconButton(
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                        icon: Icon(
                          Icons.notifications_on,
                          size: 28,
                        ),
                        color: hotPropertiesThemeColor,
                        onPressed: () => controller.unalertProperty(index),
                      )
                    ],
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _iconCard(
                      controller.alertProperties[index].images!.length
                          .toString(),
                      CustomIcons.camera_1,
                      20),
                  _iconCard(controller.alertProperties[index].bedrooms!,
                      CustomIcons.bed, 20),
                  _iconCard(controller.alertProperties[index].bathrooms!,
                      CustomIcons.bathtub, 20),
                  _iconCard(controller.alertProperties[index].area!,
                      CustomIcons.area, 20),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(
                        controller.alertProperties[index].type!),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    controller.alertProperties[index].location!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  )
                ],
              ),
            ),
          ],
        ),
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
}
