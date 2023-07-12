import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/Blogbuz/blogbuzz_featured_brand_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedProperitesCard extends GetView<UserPropertiesController> {
  final index;
  FeaturedProperitesCard({this.index});

  Widget _customTextCard(String title, String value) {
    return Container(
      padding: EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text(
            title + ": ",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: TextStyle(color: settingsColor, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _imageCard() {
    var r = Random();
    return Image(
      image: CachedNetworkImageProvider(
          controller.images[r.nextInt(controller.images.length)]),
      fit: BoxFit.cover,
      height: 30.0.h,
      width: 100.0.w,
    );
  }

  // Widget _imageCard() {
  //   // return Container(
  //   //   height: 90,
  //   //   width: 90,
  //   //   decoration: BoxDecoration(
  //   //       image: DecorationImage(
  //   //         image: NetworkImage(
  //   //             controller.featuredProperties[this.index].imagename),
  //   //         fit: BoxFit.cover,
  //   //       ),
  //   //       shape: BoxShape.rectangle),
  //   // );
  //   Random r = Random();

  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 15),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(3),
  //       child: Image(
  //         image: CachedNetworkImageProvider(
  //             controller.images[r.nextInt(controller.images.length)]),
  //         fit: BoxFit.cover,
  //         height: ,
  //         width: 100.w,
  //       ),
  //     ),
  //   );
  // }

  Widget _descriptionCard() {
    return Container(
      width: 100.0.w - 130,
      padding: EdgeInsets.only(bottom: 15),
      color: Colors.transparent,
      margin: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _customTextCard(
              AppLocalizations.of(
                "Property Code",
              ),
              '${controller.featuredProperties[index].propertycode}'),

          _customTextCard(
              AppLocalizations.of(
                "Property Type",
              ),
              "${controller.featuredProperties[index].propertytitle}"),
          _customTextCard(
              AppLocalizations.of(
                "Listing Type",
              ),
              '${controller.featuredProperties[index].listingtype}'),
          // _statusCard()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    return Container(
      padding: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_imageCard(), _descriptionCard()],
      ),
    );
  }
}
