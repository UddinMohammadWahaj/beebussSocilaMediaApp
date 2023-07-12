import 'dart:math';

import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Properbuz/manage_properties_content_card.dart';
import 'package:bizbultest/widgets/Properbuz/manage_properties_description_card.dart';
import 'package:bizbultest/widgets/Properbuz/manage_properties_detailed_info_row.dart';
import 'package:bizbultest/widgets/Properbuz/manage_property_property_info_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../manage_property_image_page_view.dart';

class ManagePropertyDetailView extends GetView<UserPropertiesController> {
  int index;
  int value;
  ManagePropertyDetailView(this.index, this.value);
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

  Future showSnack(String errorMsg, int resp) async {
    await Get.showSnackbar(GetBar(
      backgroundColor: Colors.black,
      title: (resp == 1)
          ? AppLocalizations.of("Success")
          : AppLocalizations.of("Error"),
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
                        itemCount:
                            controller.value(value)[index].images!.length,
                        itemBuilder: (context, i) {
                          return _photoCard(
                            controller.value(value)[this.index].images![i],
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
                    '${controller.value(value)[index].propertytitle}',
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

  Future shareWidget() async {
    print("shareurl =${controller.value(value)[index].shareurl}");
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
            label: Text(AppLocalizations.of('Close'),
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
                      '${controller.value(value)[index].propertytitle} \n ${controller.value(value)[index].propertydescription}',
                  linkUrl: controller.value(value)[index].shareurl);
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
                      controller.value(value)[index].propertyid!,
                      controller.value(value)[index].shareurl!, (resp) {
                    controller.isShare.value = false;
                    Navigator.of(context).pop();
                    print("resp is $resp");

                    if (resp == 1) {
                      showSnack('Shared Successfully ', resp);
                    } else
                      showSnack('Sharing failed', resp);
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
                    '${CurrentUser().currentUser.fullName}',
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
                Obx(() => (controller.value(value)[index].images!.length != 0)
                    ? _listOfimageCard()
                    : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: hotPropertiesThemeColor,
        actions: [
          _iconButton(Icons.share, 25, () async {
            shareWidget();
          }, Colors.white),
          _iconButton(CupertinoIcons.delete_solid, 22, () async {
            // controller.removeProperty(index)
          }, Colors.white),
        ],
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      body: Container(
          child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              (controller.value(value)[index].images!.length == 0)
                  ? _imageCard()
                  : ManagePropertyImagesPageView(
                      index: index,
                      value: this.value,
                    ),
              ManagePropertyDetailedInfoRow(
                index: this.index,
                val: this.value,
              ),
              ManagePropertyInfoCard(
                index: this.index,
                val: this.index,
                padding: 15,
              ),
              ManagePropertyDescriptionCard(index: index, val: value),
              FutureBuilder(
                future: controller
                    .fetchDetails(controller.value(value)[index].propertyid),
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.data != null)
                    return ManagePropertyContentCard(
                      index: index,
                      val: value,
                      padding: 8,
                    );
                  else
                    return Container();
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
