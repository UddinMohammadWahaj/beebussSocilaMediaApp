import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/manage_prop_detail_view.dart';
import 'package:bizbultest/view/Properbuz/menu/manage_properties/insights_view.dart';
import 'package:bizbultest/view/Properbuz/menu/manage_properties/manage_properties_edit_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../../../services/Properbuz/api/add_prop_api.dart';
import '../../../../services/Properbuz/api/edit_property_controller.dart';
import '../../../../view/Properbuz/menu/premium_package_view.dart';

class ManagePropertiesCard extends GetView<UserPropertiesController> {
  final String listingType;
  final int index;
  ManagePropertiesCard(
      {Key? key, required this.listingType, required this.index})
      : super(key: key);

  Widget _imageCard() {
    var r = Random();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Image(
          image: NetworkImage(this.listingType != "Rental"
              ? controller.saleProperties[index].images![0]
              : controller.rentalProperties[index].images![0])
          // : CachedNetworkImageProvider(
          //     controller.images[r.nextInt(controller.images.length)]),
          ,
          fit: BoxFit.cover,
          height: 90,
          width: 90,
        ),
      ),
    );
  }

  Widget _customTextCard(String title, String value) {
    return Container(
      padding: EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text(
            title + ": ",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          Flexible(
            child: Text(
              value,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

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
              (this.listingType != "Rental")
                  ? '${controller.saleProperties[index].propertycode}'
                  : '${controller.rentalProperties[index].propertycode}'),
          _customTextCard(
              AppLocalizations.of(
                "Property Name",
              ),
              (this.listingType != "Rental")
                  ? "${controller.saleProperties[index].propertytitle}"
                  : "${controller.rentalProperties[index].propertytitle}"),
          _customTextCard(
              AppLocalizations.of(
                "Property Type",
              ),
              (this.listingType != "Rental")
                  ? "${controller.saleProperties[index].propertytype}"
                  : "${controller.rentalProperties[index].propertytype}"),
          _customTextCard(
              AppLocalizations.of(
                "Property Category",
              ),
              (this.listingType != "Rental")
                  ? "${controller.saleProperties[index].propertyCategory}"
                  : "${controller.rentalProperties[index].propertyCategory}"),
          _customTextCard(
              AppLocalizations.of(
                "Properety Sold",
              ),
              (this.listingType != "Rental")
                  ? "${controller.saleProperties[index].propertySold}"
                  : "${controller.rentalProperties[index].propertySold}"),
          _statusCard()
        ],
      ),
    );
  }

  Widget _statusCard() {
    return Row(
      children: [
        Text(
          AppLocalizations.of("Status") + ": ",
          style: TextStyle(color: Colors.grey.shade700),
        ),
        Icon(
          Icons.lock,
          size: 16,
          color: Colors.black,
        )
      ],
    );
  }

  Widget _customTextButton(
      String value, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 40,
          width: 50.0.w,
          color: bgColor,
          child: Center(
              child: Text(
            value,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 15),
          ))),
    );
  }

  upgradePropertyTypeCard(title, VoidCallback onTap) {
    return ListTile(title: Text(title), onTap: onTap);
  }

  upgradePopup() async {
    await showBarModalBottomSheet(
        context: Get.context!,
        builder: (ctx) => Container(
            height: 30.0.h,
            child: Column(children: [
              // ListTile(trailing: IconButton(child),)
              ListTile(
                  trailing: Icon(Icons.close),
                  onTap: () {
                    Navigator.of(Get.context!).pop();
                  }),
              upgradePropertyTypeCard('Featured Property', () {
                Navigator.push(
                    Get.context!,
                    MaterialPageRoute(
                        builder: (context) => PremiumPackageView(
                            propertyId:
                                controller.saleProperties[index].propertyid,
                            duration: '1 month')));
              }),
              upgradePropertyTypeCard('Premium Property', () {}),
              // ListTile(title:Text('Featured Property')),
              // ListTile(title:Text('Premium Property')),
            ])));
  }

  Widget _actionRow(context) {
    return Row(
      children: [
        _customTextButton(
            AppLocalizations.of(
              "Upgrade",
            ),
            Colors.white,
            hotPropertiesThemeColor, () {
          upgradePopup();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => PremiumPackageView()));
        }),
        _customTextButton(
            AppLocalizations.of(
              "Edit",
            ),
            hotPropertiesThemeColor,
            Colors.grey.shade200, () {
          var proid = this.listingType != "Rental"
              ? controller.saleProperties[index].propertyid
              : controller.rentalProperties[index].propertyid;
          EditPropertyController ctr = Get.put(EditPropertyController(proid));
          ctr.fetchEditPropertyDetail(proid);
          Navigator.of(Get.context!)
              .push(MaterialPageRoute(
            builder: (context) => ManagePropertiesEdit(
                propid: this.listingType != "Rental"
                    ? controller.saleProperties[index].propertyid
                    : controller.rentalProperties[index].propertyid),
          ))
              .then((value) {
            controller.getManageProperties();
            // Get.delete<EditPropertyController>();
          });
        }),
      ],
    );
  }

  Widget _viewInsightsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InsightsView(
                    id: (this.listingType != "Rental")
                        ? "${controller.saleProperties[index].propertyid}"
                        : "${controller.rentalProperties[index].propertyid}")));
      },
      child: Container(
          decoration: new BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border(
              top: BorderSide(color: hotPropertiesThemeColor, width: 1),
              bottom: BorderSide(color: hotPropertiesThemeColor, width: 1),
            ),
          ),
          height: 40,
          child: Center(
              child: Text(
            AppLocalizations.of("View Insights"),
            style: TextStyle(fontSize: 15, color: hotPropertiesThemeColor),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    return GestureDetector(
      onTap: () async {
        int val = this.listingType != "Rental" ? 1 : 2;
        controller.getFloorImages(controller.value(val)[index].propertyid);
        print("--- 55 -- ${controller.floorImagesNew}");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ManagePropertyDetailView(index, val)));
      },
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageCard(),
                _descriptionCard(),
              ],
            ),
            _viewInsightsCard(context),
            _actionRow(context),
          ],
        ),
      ),
    );
  }
}
