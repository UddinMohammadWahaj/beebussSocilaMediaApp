import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_detailed_prop_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:bizbultest/widgets/Properbuz/property/detailed_property_description.dart';
import 'package:html/parser.dart' as htmlparser;

class PopularPropertyDescriptionCard
    extends GetView<PopularRealEstateMarketController> {
  final int index;
  final int val;
  const PopularPropertyDescriptionCard({
    Key? key,
    required this.index,
    required this.val,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          top: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              AppLocalizations.of(
                "Description",
              ),
              style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
            ),
          ),
          Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Html(
                data: controller
                    .lstofpopularrealestatemodel[index].propertyDescription
                    .toString(),
                // defaultTextStyle:
                //     TextStyle(fontSize: 16, color: Colors.grey.shade700),
              )),
          Center(
              child: InkWell(
            onTap: () {
              var parsed = htmlparser.parseFragment(controller
                  .lstofpopularrealestatemodel[index].propertyDescription);
              // parsed.
              Html(
                data: controller
                    .lstofpopularrealestatemodel[index].propertyDescription,
              );

              Get.bottomSheet(
                PopularDetailedPropertyView(
                  description: controller
                      .lstofpopularrealestatemodel[index].propertyDescription,
                ),
                enableDrag: false,
                isScrollControlled: true,
                ignoreSafeArea: false,
                backgroundColor: Colors.white,
              );
            },
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  AppLocalizations.of(
                    "READ ALL",
                  ),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )),
          ))
        ],
      ),
    );
  }
}
