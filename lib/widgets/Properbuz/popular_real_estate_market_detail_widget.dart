import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_advice_card.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_detailed_info_row.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_infotab.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_market_prop_description.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_prop_img_view.dart';
import 'package:bizbultest/widgets/Properbuz/popular_real_estate_prop_info_card.dart';
import 'package:bizbultest/widgets/Properbuz/property/detailed_info_row.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_description_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class PopularRealEstateMarketDetail
    extends GetView<PopularRealEstateMarketController> {
  final index;
  PopularRealEstateMarketDetail(this.index);

  Widget _reviewTitle() {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: Text(
        AppLocalizations.of(
            // "What you should know before moving to New York?",
            controller.lstofpopularrealestatemodel[index].propertyTitle!),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _reviewDescription() {
    return Container(
        padding: EdgeInsets.only(top: 3),
        child: Html(
          data:
              controller.lstofpopularrealestatemodel[index].propertyDescription,
          // defaultTextStyle: TextStyle(fontSize: 17),
        ));
  }

  Widget actionRow() {
    return Row(
      children: [
        Expanded(
          child: Icon(Icons.bathroom_outlined),
        ),
        Expanded(child: Icon(Icons.bathroom_outlined)),
      ],
    );
  }

  Widget _reviewCard() {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // _approvedCard(),
          // _locationCard(),
          // _starIcons(),

          _reviewTitle(),
          _reviewDescription(),
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

  Widget _pageIndexCard() {
    return Positioned.fill(
      left: 20,
      bottom: 10,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Obx(() => Text(
                  "${controller.lstofpopularrealestatemodel[index].images!.length} photos",
                  style: TextStyle(
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ))),
      ),
    );
  }

  Widget _listOfimageCard() {
    return Card(
      elevation: 5,
      child: Container(
          height: 250,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller
                            .lstofpopularrealestatemodel[index].images!.length,
                        itemBuilder: (context, i) {
                          return _photoCard(
                            controller.lstofpopularrealestatemodel[this.index]
                                .images![i],
                            index,
                          );
                        }),

                    // _pageIndexCard()
                  ],
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(
                        '${controller.lstofpopularrealestatemodel[index].propertyTitle}'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    // '${controller.lstofpopularrealestatemodel[index].shareUrl.substring(0, (controller.lstofpopularrealestatemodel[index].shareUrl.length / 2).toInt())}',
                    'properbuz.bebuzee.com',
                    style: TextStyle(color: hotPropertiesThemeColor),
                  ),
                ),
              )
            ],
          )),
    );
  }

  // Widget reviewCard(int index) {
  //   return Container(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         (controller.length == 0) ?
  //       ],
  //     ),
  //   );
  // }

  Widget _contactBar() {
    return Positioned.fill(
      bottom: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Obx(
          () => !controller.isContactVisible.value
              ? Container(
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _contactButton(
                        Icons.call,
                        AppLocalizations.of(
                          "CALL",
                        ), () async {
                      print(
                          'contact num= ${controller.lstofpopularrealestatemodel[index].memberContactNo}');

                      controller.callAgent(
                          'tel:${controller.lstofpopularrealestatemodel[index].memberContactNo}');
                    }, 0),
                    _contactButton(
                        Icons.email,
                        AppLocalizations.of(
                          "CONTACT",
                        ), () {
                      print(
                          'contact num= ${controller.lstofpopularrealestatemodel[index].memberEmail}');
                      controller.emailAgent(
                          '${controller.lstofpopularrealestatemodel[index].memberEmail}');
                    }, 0),
                  ],
                ))
              : Container(),
        ),
      ),
    );
  }

  Widget _contactButton(
      IconData icon, String value, VoidCallback onTap, double padding) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.0.w - padding,
        height: 55,
        color: Colors.red.shade800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                )),
            Text(
              value,
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            )
          ],
        ),
      ),
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

  Widget _iconButton2(IconData iconData, double size, onTap, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: IconButton(
        constraints: BoxConstraints(),
        splashRadius: 20,
        icon: Icon(
          iconData,
          size: size,
        ),
        color: color,
        onPressed: onTap,
      ),
    );
  }

  Widget _affordCard() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.grey.shade700,
          width: 0.5,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          CustomIcons.calculator,
          color: Colors.grey.shade700,
          size: 28,
        ),
        title: Text(
          AppLocalizations.of(
            "Can you afford it?",
          ),
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          AppLocalizations.of(
            "Find out what mortgage you can get",
          ),
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  Widget _customTextField(
      TextEditingController controller, String hintText, double ht) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIconConstraints: BoxConstraints(),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500)),
      ),
    );
  }

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14,
              color: hotPropertiesThemeColor,
              fontWeight: FontWeight.w500),
        ));
  }

  Future showSnack(String errorMsg, int resp) async {
    await Get.showSnackbar(GetBar(
      backgroundColor: Colors.black,
      title: (resp == 1) ? "Success" : "Error",
      icon: Icon(
        (resp == 1) ? Icons.done_all : Icons.error,
        color: (resp == 1) ? Colors.green : Colors.red,
      ),
      duration: Duration(seconds: 2),
      messageText: Text(
        '${errorMsg}',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ));
  }

  Widget getProfilePic() {
    return CurrentUser().currentUser.image != null &&
            CurrentUser().currentUser.image != ''
        ? Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                  CurrentUser().currentUser.image!,
                ),
              ),
            ),
          )
        : Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.person,
              color: Colors.grey,
              size: 80,
            ),
          );
  }

  Future shareWidget() async {
    print(
        "shareurl =${controller.lstofpopularrealestatemodel[index].shareUrl}");
    await showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(8),
        actionsPadding: EdgeInsets.all(10),
        actions: [
          TextButton.icon(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: hotPropertiesThemeColor))),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () async {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              size: 0,
            ),
            label: Text(AppLocalizations.of('Cancel'),
                style: TextStyle(color: hotPropertiesThemeColor)),
          ),
          TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: hotPropertiesThemeColor))),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all(hotPropertiesThemeColor)),
            onPressed: () async {
              FlutterShare.share(
                  title:
                      '${controller.lstofpopularrealestatemodel[index].propertyTitle} in ${controller.city},${controller.country}',
                  linkUrl:
                      controller.lstofpopularrealestatemodel[index].shareUrl);
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of('More')),
          ),
          Obx(
            () => TextButton.icon(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: hotPropertiesThemeColor))),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(hotPropertiesThemeColor)),
                onPressed: () async {
                  controller.isShare.value = true;
                  controller.shareProp(
                      controller.lstofpopularrealestatemodel[index].propertyId!,
                      controller.lstofpopularrealestatemodel[index].shareUrl!,
                      (resp) {
                    controller.isShare.value = false;
                    Navigator.of(context).pop();
                    print("resp is $resp");

                    if (resp == 1) {
                      showSnack(
                          AppLocalizations.of('Shared Successfully '), resp);
                    } else
                      showSnack(AppLocalizations.of('Sharing failed'), resp);
                  }, msg: controller.writeShareFeed.text);
                },
                icon: (controller.isShare.value)
                    ? CircularProgressIndicator(color: Colors.white)
                    : Icon(
                        CupertinoIcons.arrow_uturn_right,
                        color: hotPropertiesThemeColor,
                        size: 0,
                      ),
                label: Text(AppLocalizations.of('Share'))),
          ),

          //  ButtonBar(

          //   children: [
          //   IconButton(onPressed: onPressed, icon: icon,)
          //     Icon(
          //       CupertinoIcons.arrow_uturn_right_circle_fill,
          //       size: 20,
          //     ),
          //     _headerCard('Share'),
          //   ],
          // )
        ],
        content: Container(
          height: Get.size.height / 1.7,
          width: Get.size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: Get.size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: _headerCard(
                              AppLocalizations.of('Share to Feed'))),
                      IconButton(
                          onPressed: () {
                            Navigator.of(Get.context!).pop();
                          },
                          icon: Icon(
                            Icons.close_outlined,
                            size: 15,
                          ))
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(8),
                  minVerticalPadding: 1,
                  horizontalTitleGap: 1.5,
                  minLeadingWidth: 1.5,
                  leading: getProfilePic(),
                  title: Text(
                    AppLocalizations.of(
                        '${CurrentUser().currentUser.fullName}'),
                    style: TextStyle(color: settingsColor, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                _customTextField(
                  controller.writeShareFeed,
                  AppLocalizations.of(
                      'Start writing or use @ to mention people'),
                  125,
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() => (controller.lstofpopularrealestatemodel[index].images!
                            .length !=
                        0)
                    ? _listOfimageCard()
                    : Container()),
              ],
            ),
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: hotPropertiesThemeColor,
        brightness: Brightness.dark,
        actions: [
          _iconButton(Icons.share, 25, () async {
            await shareWidget();
          }, Colors.white),
          _iconButton(CupertinoIcons.delete_solid, 22, () async {
            await showYesNoDialog();
            // controller.removeProperty(index)
          }, Colors.white),
          Obx(() => _iconButton2(
                  controller
                          .lstofpopularrealestatemodel[index].savedStatus!.value
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  25, () {
                controller.saveAndUnSave(index);
              },
                  controller
                          .lstofpopularrealestatemodel[index].savedStatus!.value
                      ? hotPropertiesThemeColor
                      : hotPropertiesThemeColor)),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    // PropertyImagesPageView(
                    //   index: widget.index,
                    //   val: widget.val,
                    // ),
                    (controller.lstofpopularrealestatemodel[index].images!
                                .length ==
                            0)
                        ? _imageCard()
                        : PopularPropertyImagesPageView(
                            index: index,
                          ),
                    // DetailedInfoRow(
                    //   index: this.index,
                    //   val: this.index,
                    // ),
                    PopularDetailedInfoRow(
                      index: this.index,
                      val: this.index,
                    ),

                    PopularRealEstatePropertyInfoCard(
                      index: this.index,
                      val: this.index,
                      padding: 15,
                    ),
                    _affordCard(),

                    PopularPropertyDescriptionCard(
                      index: index,
                      val: index,
                    ),

                    FutureBuilder(
                      future: controller.fetchDetails(controller
                          .lstofpopularrealestatemodel[index].propertyId),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return PopularPropertyContentCard(
                            index: index,
                          );
                        } else
                          return Container();
                      },
                    ),
                    PopularPropertyAdviserCard(
                      index: index,
                    )
                    // PropertyDescriptionCard(
                    //   index: widget.index,
                    //   val: widget.val,
                    // ),
                    // PropertyContentCard(),
                    // PropertyAdviserCard(
                    //   index: widget.index,
                    //   val: widget.val,
                    // ),
                    //SimilarListingsCard()
                  ],
                ),
              ),
            ),
            _contactBar()
            // ContactsStackRow(
            //   index: widget.index,
            //   val: widget.val,
            // )
          ],
        ),
      ),

      // Container(
      //   padding: EdgeInsets.only(bottom: 0),
      //   child: Column(
      //     children: [
      //       (controller.lstofpopularrealestatemodel[index].images.length == 0)
      //           ? _imageCard()
      //           : _listOfimageCard(),
      //       _reviewCard()
      //     ],
      //   ),
      // )
    );
  }
}
