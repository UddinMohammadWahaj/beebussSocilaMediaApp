import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_detail_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../services/Properbuz/user_properties_controller.dart';

class PopularRealEstateItem extends GetView<PopularRealEstateMarketController> {
  final index;
  PopularRealEstateItem(this.index);
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

  Widget _imageCard() {
    var r = Random();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Obx(
          () => Image(
            image:

                //  (controller
                //             .lstofpopularrealestatemodel[index].images.length ==
                //         0)
                //     ? CachedNetworkImageProvider(
                //         controller.images[r.nextInt(controller.images.length)])
                //     :

                NetworkImage(controller
                    .lstofpopularrealestatemodel[index].images!.first),
            fit: BoxFit.cover,
            height: 90,
            width: 90,
          ),
        ),
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
              "${controller.lstofpopularrealestatemodel[index].propertyCode}"),
          _customTextCard(
              AppLocalizations.of(
                "Property Name",
              ),
              "${controller.lstofpopularrealestatemodel[index].propertyTitle}"),

          _customTextCard(
              AppLocalizations.of(
                "Currency",
              ),
              "${controller.lstofpopularrealestatemodel[index].currency}"),

          _customTextCard(
              AppLocalizations.of(
                "Property Price",
              ),
              "${controller.lstofpopularrealestatemodel[index].cost}"),

          // _customTextCard(
          //     AppLocalizations.of(
          //       "Property Description",
          //     ),
          //     "${controller.lstofpopularrealestatemodel[index].propertyDescription}")
        ],
      ),
    );
  }

  Widget _customTextButton(
      String value, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 20,
          width: 20.0.w,
          color: bgColor,
          child: Center(
              child: Text(
            value,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 15),
          ))),
    );
  }

  // Widget _actionRow() {
  //   return Container(
  //     child: Row(
  //       children: [
  //         _customTextButton(
  //             AppLocalizations.of(
  //               "Upgrade",
  //             ),
  //             Colors.white,
  //             appBarColor,
  //             () {}),
  //         _customTextButton(
  //             AppLocalizations.of(
  //               "Edit",
  //             ),
  //             appBarColor,
  //             Colors.grey.shade200,
  //             () {}),
  //         _customTextButton(
  //             AppLocalizations.of(
  //               "Edit",
  //             ),
  //             appBarColor,
  //             Colors.grey.shade200,
  //             () {}),
  //       ],
  //     ),
  //   );
  // }
  Widget _actionRow() {
    // Expanded(
    //   child: new Padding(
    //     padding: const EdgeInsets.all(20.0),
    //     child: countryCodePicker,
    //   ),
    // ),
    return Row(
      children: [
        Expanded(
          child: ButtonBar(children: [
            Icon(
              Icons.photo_camera,
              size: 20,
              color: settingsColor,
            ),
            Text('${controller.lstofpopularrealestatemodel[index].photos}')
          ]),
        ),
        Expanded(
          child: ButtonBar(children: [
            Icon(
              Icons.bedroom_child_rounded,
              size: 20,
              color: settingsColor,
            ),
            Text('${controller.lstofpopularrealestatemodel[index].bedrooms}')
          ]),
        ),
        Expanded(
          child: ButtonBar(children: [
            Icon(
              Icons.bathtub_outlined,
              size: 20,
              color: settingsColor,
            ),
            Text('${controller.lstofpopularrealestatemodel[index].bathrooms}')
          ]),
        ),
        Expanded(
          child: ButtonBar(children: [
            Icon(
              Icons.square_foot,
              size: 20,
              color: settingsColor,
            ),
            Text(
                // '${controller.lstofpopularrealestatemodel[index].landDimensionMeasure}')
                '${controller.lstofpopularrealestatemodel[index].landDimensionHeight}X${controller.lstofpopularrealestatemodel[index].landDimensionWidth}')
          ]),
        )
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

  Future showYesNoDialog() async {
    await showCupertinoDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of("Are you sure?"),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () {
                controller.removeProperty(index);
              },
              child: Text(AppLocalizations.of("Yes"),
                  style: TextStyle(color: hotPropertiesThemeColor))),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of("No"),
                  style: TextStyle(color: hotPropertiesThemeColor)))
        ],
      ),
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
                " ${controller.lstofpopularrealestatemodel[index].currency} ${controller.lstofpopularrealestatemodel[index].cost}",
            style: TextStyle(
                fontSize: 22,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              // Obx(() => _iconButton(
              //         (controller.lstofpopularrealestatemodel[index]
              //                 .followStatus.value)
              //             ? Icons.person_add_alt_1
              //             : Icons.person_add_alt,
              //         22, () {
              //       controller.followTheAgent(
              //           controller.lstofpopularrealestatemodel[index].agentId,
              //           index);
              //     }, settingsColor)),
              _iconButton(CupertinoIcons.delete, 22, () async {
                await showYesNoDialog();
                // controller.removeProperty(index);
              }, hotPropertiesThemeColor),
              SizedBox(width: 5),
              Obx(() => _iconButton(
                      controller.lstofpopularrealestatemodel[index].savedStatus!
                              .value
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      25, () {
                    controller.saveAndUnSave(index);
                  },
                      controller.lstofpopularrealestatemodel[index].savedStatus!
                              .value
                          ? hotPropertiesThemeColor
                          : hotPropertiesThemeColor)),
              // _iconButton(CupertinoIcons.heart, 25, () {}, iconColor),
            ],
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

  Widget _infoTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(controller.lstofpopularrealestatemodel[index].propertyCreatedDate != null) ? controller.lstofpopularrealestatemodel[index].propertyCreatedDate!.toLocal().toString().split(' ')[0] : ""}',
            style: TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (controller.lstofpopularrealestatemodel[index].listingType ==
                              "1"
                          ? AppLocalizations.of("SALE")
                          : AppLocalizations.of("RENTAL")) +
                      ", ${controller.lstofpopularrealestatemodel[index].propertyType ?? ""}",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
                // FittedBox(
                //   child: TextButton.icon(
                //     style: ButtonStyle(
                //         shape:
                //             MaterialStateProperty.all<RoundedRectangleBorder>(
                //                 RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(18.0),
                //                     side: BorderSide(color: settingsColor))),
                //         foregroundColor:
                //             MaterialStateProperty.all(Colors.white),
                //         backgroundColor:
                //             MaterialStateProperty.all(Colors.white)),
                //     onPressed: () {
                //       controller.followTheAgent(
                //           controller.lstofpopularrealestatemodel[index].agentId,
                //           index);
                //     },
                //     icon: (controller.lstofpopularrealestatemodel[index]
                //             .followStatus.value)
                //         ? Icon(
                //             Icons.person,
                //             color: settingsColor,
                //           )
                //         : Icon(Icons.person_add_alt, color: settingsColor),
                //     label: (controller.lstofpopularrealestatemodel[index]
                //             .followStatus.value)
                //         ? Text(
                //             "Following",
                //             style: TextStyle(color: settingsColor),
                //           )
                //         : Text(
                //             "Follow",
                //             style: TextStyle(color: settingsColor),
                //           ),
                //   ),
                // ),
                // )
              ],
            ),
          ),

          // Text(
          //   '${controller.lstofpopularrealestatemodel[index].propertyType ?? ""}',
          //   style: TextStyle(
          //       fontSize: 12,
          //       color: Colors.grey.shade600,
          //       fontWeight: FontWeight.w500),
          // ),

          Text(
            AppLocalizations.of(
              controller.lstofpopularrealestatemodel[index].streetName1!,
            ),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          )
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
              '${controller.lstofpopularrealestatemodel[index].images!.length}',
              CustomIcons.camera_1,
              20),
          _iconCard(controller.lstofpopularrealestatemodel[index].bedrooms!,
              CustomIcons.bed, 20),
          //_iconCard("2", CustomIcons.stairs, 16),
          _iconCard(controller.lstofpopularrealestatemodel[index].bathrooms!,
              CustomIcons.bathtub, 20),
          _iconCard(controller.lstofpopularrealestatemodel[index].sqft!,
              CustomIcons.area, 20),
        ],
      ),
    );
  }

  Widget _listOfimageCard() {
    return Container(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  controller.lstofpopularrealestatemodel[index].images!.length,
              itemBuilder: (context, i) {
                return _photoCard(
                  controller.lstofpopularrealestatemodel[this.index].images![i],
                  index,
                );
              }),
          // _photosLengthCard()
        ],
      ),
    );
  }

  Widget _photoCard(String file, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Image.network(
            file,
            fit: BoxFit.cover,
            height: 250,
            width: 100.0.w,
          ),
        ),
      ),
    );
  }

  UserPropertiesController ctr = Get.put(UserPropertiesController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ctr.getFloorImages(
            controller.lstofpopularrealestatemodel[index].propertyId);
        print("--- 55 -- ${ctr.floorImagesNew}");
        print(
            "Latitude property=${controller.lstofpopularrealestatemodel[index].propertyId} lat=${controller.lstofpopularrealestatemodel[index].lat}");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PopularRealEstateMarketDetail(index),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_listOfimageCard(), _priceRow(), _iconRow(), _infoTile()],
        ),
      ),

      //  Container(
      //   padding: EdgeInsets.only(top: 20),
      //   child: Column(
      //     children: [
      //       Row(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           _imageCard(),
      //           _descriptionCard(),
      //         ],
      //       ),
      //       _actionRow()
      //     ],
      //   ),
      // )
    );
  }
}
