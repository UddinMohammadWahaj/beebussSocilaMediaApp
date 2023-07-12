import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/property_features_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Language/appLocalization.dart';

class DetailedInfoRow extends GetView<PropertiesController> {
  final int index;
  final int val;
  const DetailedInfoRow({
    Key? key,
    required this.index,
    required this.val,
  }) : super(key: key);

  Widget _infoCard(IconData icon, String info, double left, double right,
      BuildContext context, int feature, String title) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PropertyFeaturesView(
                    index: index,
                    val: val,
                    feature: feature,
                    title: title,
                  ))),
      child: Container(
        margin: EdgeInsets.only(left: left, right: right),
        height: 70,
        width: 95,
        child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: hotPropertiesThemeColor,
                  size: 22,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(info),
                  style:
                      TextStyle(fontSize: 13, color: hotPropertiesThemeColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _infoCard(
                CustomIcons.photo_camera,
                "${controller.properties(val)[index].images!.length.toString()} " +
                    AppLocalizations.of("Photos"),
                15,
                0,
                context,
                1,
                "Photos"),
            _infoCard(
                CustomIcons.stairs,
                AppLocalizations.of("Floor") +
                    " " +
                    AppLocalizations.of("Plan"),
                5,
                0,
                context,
                2,
                "Floor Plan"),
            _infoCard(
                CustomIcons.virtual_reality,
                AppLocalizations.of("Virtual") +
                    " " +
                    AppLocalizations.of("tour"),
                5,
                0,
                context,
                3,
                "Virtual Tour"),
            _infoCard(CustomIcons.video_player, AppLocalizations.of("Video"), 5,
                0, context, 4, "Video"),
            _infoCard(CustomIcons.pin, AppLocalizations.of("Map"), 5, 15,
                context, 5, "Map"),
          ],
        ),
      ),
    );
  }
}
