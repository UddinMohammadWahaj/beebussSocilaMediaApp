import 'dart:math';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'property_info_card.dart';

class SimilarListingsCard extends GetView<PropertiesController> {
  const SimilarListingsCard({Key? key}) : super(key: key);

  Widget _imageCard() {
    var r = Random();
    return Container(
        height: 150,
        width: 70.0.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image(
            image: CachedNetworkImageProvider(
                controller.images[r.nextInt(controller.images.length)]),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _title() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          AppLocalizations.of("Similar Listings"),
          style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Container(
      color: Colors.transparent,
      height: 305,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          Container(
            height: 260,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        EdgeInsets.only(left: 15, right: index == 4 ? 15 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _imageCard(),
                        Container(
                            width: 60.0.w,
                            child: PropertyInfoCard(
                              padding: 0,
                            )),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
