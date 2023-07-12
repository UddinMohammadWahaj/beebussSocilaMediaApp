import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/add_feature_list_model.dart';
import 'package:bizbultest/models/Properbuz/add_fixture_list_model.dart';
import 'package:bizbultest/models/Properbuz/add_property_list_model.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/Properbuz/listing_type_model.dart';
import 'package:bizbultest/services/Properbuz/add_property_controller.dart';
import 'package:bizbultest/services/Properbuz/api/add_facilities_model.dart';
import 'package:bizbultest/services/Properbuz/api/add_outin_space_model.dart';
import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_property_search_view.dart';
import 'package:bizbultest/view/Properbuz/add_property_map_view.dart';
import 'package:bizbultest/widgets/Properbuz/GoogleMap/MapSample.dart';
import 'package:bizbultest/widgets/Properbuz/GoogleMap/editpropmap.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Language/appLocalization.dart';
import '../../Buzzfeed/buzzfeedplayer.dart';
import '../../Buzzfeed/buzzfeedvideoplayer.dart';
import '../searc_by_map_view.dart';
import '../travel_time_search_view.dart';

class AddPropertyView extends GetView<AddPropertyController> {
  const AddPropertyView({Key? key}) : super(key: key);
  // static TextEditingController propertyTitle = new TextEditingController();
  // static TextEditingController propertyPrice = new TextEditingController();
  // static TextEditingController propertyWidth = new TextEditingController();
  // static TextEditingController propertyLength = new TextEditingController();
  // static TextEditingController propertyLandArea = new TextEditingController();
  // static TextEditingController propertyDescription =
  //     new TextEditingController();
  // static TextEditingController propertyLocation = new TextEditingController();
  // static TextEditingController propertyHouseName = new TextEditingController();
  // static TextEditingController propertStreet1 = new TextEditingController();
  // static TextEditingController propertyStreet2 = new TextEditingController();
  // static TextEditingController propertyZipCode = new TextEditingController();
  // static TextEditingController propertyLat = new TextEditingController();
  // static TextEditingController propertyLong = new TextEditingController();
  // static TextEditin g Controller propertyNeighbourhood =    new TextEditingController();

  Widget _addButton(context) {
    return GestureDetector(
      onTap: () async {
        print(
            "selected lat 2=${controller.propertyLat.text} selected long 2=${controller.propertyLong.text}");

        controller.getSelectedFacilities();
        controller.getSelectedFeatures();
        controller.getSelectedFixtures();
        controller.getSelectedOutinSpace();
        controller.getSelectedFeatures();

        print("lalal ${controller.topostFeatures.value}");
        Map<String, dynamic> propertydata = {
          "user_id": CurrentUser().currentUser.memberID,
          "lising_type": controller.currentListingType.value,
          "property_type_id":
              "${(controller.propertytypelist.length == 0) ? "" : controller.propertytypelist.value[controller.currentPropertyTypeIndex.value].propertytypeID}",
          "property_title": controller.propertyTitle.text,
          "youtube_video": controller.propertyVideo.text,
          "cost": controller.propertyPrice.text,
          "currency": controller.currentCurrency.value,
          "bedrooms": controller.currentBedroom.value,
          "built_up_rate": controller.currentDimension.value,
          "built_up_measure": controller.currentDimension.value,
          "built_up_dimension_width": controller.propertyWidth.text,
          "built_up_dimension_height": controller.propertyLength.text,
          "built_up_dimension_measure": controller.currentDimension.value,
          "land_area_rate": controller.currentLandArea.value,
          "land_area_measure": controller.currentLandArea.value,
          "land_dimension_width": controller.propertyWidth.text,
          "land_dimension_height": controller.propertyLength.text,
          "land_dimension_measure": controller.currentDimension.value,
          "property_description": controller.propertyDescription.text,
          "furnished":
              convertToBool(controller.isFurnishedProp['value']) ? "yes" : 'no',
          "home_listed":
              convertToBool(controller.isListedProp['value']) ? 'yes' : 'no',
          "floor": controller.currentFloor.value,
          "bathrooms": controller.currentBathroom.value,
          "special_features": controller.topostFeatures.value.isNotEmpty
              ? jsonEncode(controller.topostFeatures.value
                  .substring(0, controller.topostFeatures.value.length - 1)
                  .split(','))
              : "",
          "fixture_fitting": (controller.topostFixtures.value.isNotEmpty)
              ? jsonEncode(controller.topostFixtures.value
                  .substring(0, controller.topostFixtures.value.length - 1)
                  .split(','))
              : "",
          "outdoor_indoor_space": controller.topostOutinSpace.value.isNotEmpty
              ? jsonEncode(controller.topostOutinSpace
                  .substring(0, controller.topostOutinSpace.value.length - 1)
                  .split(','))
              : "",
          "facility": (controller.topostFacilities.value.isNotEmpty)
              ? jsonEncode(controller.topostFacilities.value
                  .substring(0, controller.topostFacilities.value.length - 1)
                  .split(','))
              : "",
          "country_id": (controller.countrylist.length == 0)
              ? " "
              : controller.countryid.value,
          "city_id": controller.cityid,
          "location": controller.message.value,
          "street_no": controller.propertStreet1.text,
          "street_name_1": controller.propertStreet1.text,
          "street_name_2": controller.propertyStreet2.text,
          "postcode": controller.propertyZipCode.text ?? "",
          "latitude": controller.propertyLat.text ?? "",
          "longitude": controller.propertyLong.text ?? "",
          "preference": controller.currentPreference.value ?? "No Preference",

          "property_neighboorhood": controller.propertyNeighbourhood.text,
          "property_available_date": controller.selectedDate.value,

          "pro_paid": controller.isproperyPaid['value'].toString() == 'true'
              ? "1"
              : "0",
          "shared_ownership":
              controller.issharedOwnership['value'].toString() == 'true'
                  ? 1
                  : 0,
          "ret_homes":
              controller.isretirementHome['value'].toString() == 'true' ? 1 : 0,
          "und_offer":
              controller.underOfferSold['value'].toString() == 'true' ? 1 : 0,
          "attachment1_filename": controller.attachmentFileList.length == 0
              ? ''
              : "${controller.attachmentFileList[0]}",
// attachment1_file:
          'attachment2_filename': controller.attachmentFileList.length >= 2
              ? controller.attachmentFileList[1]
              : '',

          'attachment3_filename': controller.attachmentFileList.length >= 3
              ? controller.attachmentFileList[2]
              : '',
          'attachment4_filename': controller.attachmentFileList.length >= 4
              ? controller.attachmentFileList[3]
              : '',
          // 'attachment1_file': '',
          // 'attachment2_file': '',
          // 'attachment3_file': '',
          // 'attachment4_file': ''
        };

        dio.FormData formData = dio.FormData();
        //ATTACHMENT ADD
        for (int i = 0; i < controller.attachmentFileList.length; i++) {
          formData.files.add(MapEntry(
              'attachment${i + 1}_file',
              await dio.MultipartFile.fromFile(
                  controller.attachmentFileList[i].path)));
        }
        //Property filee
        if (controller.photos.length > 0) {
          formData.files.add(MapEntry('default_media',
              await dio.MultipartFile.fromFile(controller.photos[0].path)));
        }
        // for (var photo in controller.photos) {
        //   formData.files.addAll([
        //     MapEntry(
        //         'default_media', await dio.MultipartFile.fromFile(photo.path))
        //   ]);
        // }
        //PROPERTY PHOTOS
        for (var photo in controller.photos) {
          formData.files.addAll([
            MapEntry('property_media[]',
                await dio.MultipartFile.fromFile(photo.path))
          ]);
        }
        //PROPERTY_VIDEOS
        for (var video in controller.videoFileList) {
          formData.files.addAll([
            MapEntry(
                'property_video', await dio.MultipartFile.fromFile(video.path))
          ]);
        }

        //PROPERTY FLOOR PLANS
        for (var floorplan in controller.floorplanphotos) {
          formData.files.addAll([
            MapEntry('floor_plan[]',
                await dio.MultipartFile.fromFile(floorplan.path))
          ]);
        }

        // print("result=${propertydata}");
        print("post data add callud ${propertydata['special_features']}");
        print("post data add callud ${propertydata['fixture_fitting']}");
        print("post data add callud ${propertydata['outdoor_indoor_space']}");
        print("post data add callud ${propertydata['facility']}");
        debugPrint("result first=${propertydata}");
        print("result second:prop image-${formData.files.first.key}");
        // return;
        controller.isaddLoad.value = true;
        controller.postData(propertydata, formData, (int resp) async {
          controller.isaddLoad.value = false;
          if (resp == 0) {
            controller.bedroomlist.length;
            controller.validateField.value = true;
            await Get.showSnackbar(GetBar(
              title: AppLocalizations.of("Error"),
              icon: Icon(
                Icons.error,
                color: hotPropertiesThemeColor,
              ),
              forwardAnimationCurve: Curves.bounceIn,
              borderRadius: 20,
              duration: Duration(seconds: 2),
              messageText: Text(
                AppLocalizations.of('Enter the necessary fields'),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ));
          } else {
            controller.validateField.value = false;
            await Get.showSnackbar(GetBar(
              title: AppLocalizations.of("Success"),
              icon: Icon(
                Icons.done_all,
                color: Colors.green,
              ),
              duration: Duration(seconds: 1),
              messageText: Text(
                AppLocalizations.of('Property Added'),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ));
            // Navigator.pop(context);
            // Get.delete<AddPropertyController>();
          }
        });
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            shape: BoxShape.rectangle,
          ),
          child: Center(
              child: Obx(
            () => controller.isaddLoad.value
                ? CircularProgressIndicator(
                    color: hotPropertiesThemeColor,
                  )
                : Text(
                    AppLocalizations.of("Add"),
                    style: TextStyle(
                        color: hotPropertiesThemeColor,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
          ))),
    );
  }

  Widget _spacer() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
    );
  }

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          AppLocalizations.of(header),
          style: TextStyle(
              fontSize: 14,
              color: hotPropertiesThemeColor,
              fontWeight: FontWeight.w500),
        ));
  }

  Future showError(String errorMsg) async {
    await Get.showSnackbar(GetBar(
      title: "Error",
      icon: Icon(
        Icons.error,
        color: hotPropertiesThemeColor,
      ),
      duration: Duration(seconds: 1),
      messageText: Text(
        '${errorMsg}',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ));
  }

  Widget _customSelectButton(String val, VoidCallback onTap, RxBool isLoad) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 50,
        width: 100.0.w - 20,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100.0.w - 80,
                child: Text(
                  val,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              (isLoad.value == false)
                  ? Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    )
                  : CircularProgressIndicator(
                      color: hotPropertiesThemeColor,
                    )
            ],
          ),
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
        keyboardType: hintText.contains('Postal')
            ? TextInputType.number
            : TextInputType.text,
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

  Widget _customTextFieldCountry(
      TextEditingController textcontroller, String hintText, double ht) {
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
        controller: textcontroller,
        onChanged: (v) {
          print("here $v");
          controller.updateCountryList(v);
        },
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

  Widget _customSmallTextField(TextEditingController controller,
      String hintText, double left, double right) {
    return Container(
      height: 50,
      width: 50.0.w - 15,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.only(left: left, right: right),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: 1,
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
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  Widget _multipleTextFieldRow(TextEditingController controller,
      String hintText, TextEditingController controller1, String hintText1) {
    return Row(
      children: [
        _customSmallTextField(controller, hintText, 10, 5),
        _customSmallTextField(controller1, hintText1, 5, 10)
      ],
    );
  }

  bool convertToBool(RxBool v) {
    return v.value;
  }

  void toggleBool(RxBool v) {
    v.value = !v.value;
  }

  bool rxconvertToBool(RxBool v) {
    return v.value;
  }

  void rxtoggleBool(RxBool v) {
    v.value = !v.value;
  }

  Widget _customErrorTextCard(String header, double fontSize, Color color) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        header,
        style: TextStyle(
            color: color, fontSize: fontSize, fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _customYesNoCard(String value, RxMap<String, dynamic> rxMap) {
    return GestureDetector(
      onTap: () {
        // toggleBool(controller.isFurnishedProp['value']);
        rxtoggleBool(rxMap['value']);

        print("tapped");
      },
      child: Obx(
        () => Container(
          width: 50.0.w - 30,
          child: Row(
            children: [
              Icon(
                // (convertToBool(controller.isFurnishedProp['value']) ^
                //         (value == "Yes"))
                (rxconvertToBool(rxMap['value']) ^ (value == "Yes"))
                    ? CupertinoIcons.circle_fill
                    : CupertinoIcons.circle,
                color: hotPropertiesThemeColor,
              ),
              SizedBox(width: 10),
              Text(
                AppLocalizations.of(value),
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _furnishedRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerCard(AppLocalizations.of("Furnished") + " * "),
        Container(
          height: 50,
          decoration: new BoxDecoration(
            color: HexColor("#f5f7f6"),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              _customYesNoCard("Yes", controller.isFurnishedProp),
              _customYesNoCard("No", controller.isFurnishedProp),
            ],
          ),
        ),
      ],
    );
  }

  Widget _newHomeRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerCard(AppLocalizations.of("Is the listing a new home") + " * "),
        Container(
          height: 50,
          decoration: new BoxDecoration(
            color: HexColor("#f5f7f6"),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              _customYesNoCard("Yes", controller.isListedProp.obs),
              _customYesNoCard("No", controller.isListedProp.obs),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customCheckBoxSingle(Map<String, dynamic> obj) {
    return GestureDetector(
      onTap: () {
        obj['value'].value = !obj['value'].value;
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        color: Colors.transparent,
        width: 50.0.w - 20,
        child: Row(
          children: [
            Obx(
              () => (obj['value'].value)
                  ? Icon(
                      CupertinoIcons.square_fill,
                      color: hotPropertiesThemeColor,
                    )
                  : Icon(
                      CupertinoIcons.square,
                      color: hotPropertiesThemeColor,
                    ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                AppLocalizations.of(obj['name']),
                style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customCheckBox(String value) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        color: Colors.transparent,
        width: 50.0.w - 20,
        child: Row(
          children: [
            Icon(
              CupertinoIcons.square,
              color: hotPropertiesThemeColor,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                AppLocalizations.of(value),
                style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkBox(String data) {
    return Container(child: Container(child: Text("text")));
  }

  Widget _checkBoxListBuilder(List<String> list) {
    return Column(
      children:
          list.map((e) => _customCheckBox(AppLocalizations.of(e))).toList(),
    );
  }

  //FEATURE
  Widget _customCheckBoxFeature(String value, String id,
      List<AddFeatureListModel> list, RxList<Icon> iconlist, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          print(id);
          print("id =$id,index=$index");
          if (iconlist[index].icon == CupertinoIcons.square)
            iconlist[index] = Icon(
              CupertinoIcons.square_fill,
              color: hotPropertiesThemeColor,
            );
          else
            iconlist[index] = Icon(
              CupertinoIcons.square,
              color: hotPropertiesThemeColor,
            );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          color: Colors.transparent,
          width: 50.0.w - 20,
          child: Row(
            children: [
              iconlist[index],
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  AppLocalizations.of(value),
                  style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkBoxListBuilderFeature(List<AddFeatureListModel> list, int n) {
    int i = 0;
    return Column(
      children: list.map((e) {
        return _customCheckBoxFeature(
            AppLocalizations.of(e.specialfeature!),
            e.featureID!,
            list,
            (n == 1)
                ? controller.feature1iconlist
                : controller.feature2iconlist,
            i++);
      }).toList(),
    );
  }

  Widget _customCheckBoxListBuilderFeature(
      RxList<AddFeatureListModel> list1, RxList<AddFeatureListModel> list2) {
    return Obx(
      () => Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _checkBoxListBuilderFeature(list1, 1),
            _checkBoxListBuilderFeature(list2, 2),
          ],
        ),
      ),
    );
  }

  ///FEATURE END
//FIXTURE

  Widget _customCheckBoxFixture(String value, String id,
      List<AddFixtureListModel> list, RxList<Icon> iconlist, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          print(id);
          print("id =$id,index=$index");
          if (iconlist[index].icon == CupertinoIcons.square)
            iconlist[index] = Icon(
              CupertinoIcons.square_fill,
              color: hotPropertiesThemeColor,
            );
          else
            iconlist[index] = Icon(
              CupertinoIcons.square,
              color: hotPropertiesThemeColor,
            );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          color: Colors.transparent,
          width: 50.0.w - 20,
          child: Row(
            children: [
              iconlist[index],
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  AppLocalizations.of(value),
                  style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkBoxListBuilderFixture(List<AddFixtureListModel> list, int n) {
    int i = 0;
    return Column(
      children: list.map((e) {
        return _customCheckBoxFixture(
            e.fixture!,
            e.fixtureID!,
            list,
            (n == 1)
                ? controller.fixture1iconlist
                : controller.fixture2iconlist,
            i++);
      }).toList(),
    );
  }

  Widget _customCheckBoxListBuilderFixture(
      RxList<AddFixtureListModel> list1, RxList<AddFixtureListModel> list2) {
    return Container(
      decoration: new BoxDecoration(
        color: HexColor("#f5f7f6"),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _checkBoxListBuilderFixture(list1, 1),
          _checkBoxListBuilderFixture(list2, 2),
        ],
      ),
    );
  }

//FIXTURE END

//INDOOROUTDOOR

  Widget _customCheckBoxOutinSpace(String value, String id,
      List<AddOutinSpaceListModel> list, RxList<Icon> iconlist, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          print(id);
          print("id =$id,index=$index");
          if (iconlist[index].icon == CupertinoIcons.square)
            iconlist[index] = Icon(
              CupertinoIcons.square_fill,
              color: hotPropertiesThemeColor,
            );
          else
            iconlist[index] = Icon(
              CupertinoIcons.square,
              color: hotPropertiesThemeColor,
            );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          color: Colors.transparent,
          width: 50.0.w - 20,
          child: Row(
            children: [
              iconlist[index],
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  AppLocalizations.of(value),
                  style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkBoxListBuilderOutinSpace(
      List<AddOutinSpaceListModel> list, int n) {
    int i = 0;
    return Column(
      children: list.map((e) {
        return _customCheckBoxOutinSpace(
            e.outinspace!,
            e.outinspaceID!,
            list,
            (n == 1)
                ? controller.outinspace1iconlist
                : controller.outinspace2iconlist,
            i++);
      }).toList(),
    );
  }

  Widget _customCheckBoxListBuilderOutinSpace(
      RxList<AddOutinSpaceListModel> list1,
      RxList<AddOutinSpaceListModel> list2) {
    return Obx(
      () => Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _checkBoxListBuilderOutinSpace(list1, 1),
            _checkBoxListBuilderOutinSpace(list2, 2),
          ],
        ),
      ),
    );
  }

//OUTDOOR

//FACILITIES

  Widget _customCheckBoxFacilities(String value, String id,
      List<AddFacilitiesModel> list, RxList<Icon> iconlist, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          print(id);
          print("id =$id,index=$index");
          if (iconlist[index].icon == CupertinoIcons.square)
            iconlist[index] = Icon(
              CupertinoIcons.square_fill,
              color: hotPropertiesThemeColor,
            );
          else
            iconlist[index] = Icon(
              CupertinoIcons.square,
              color: hotPropertiesThemeColor,
            );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          color: Colors.transparent,
          width: 50.0.w - 20,
          child: Row(
            children: [
              iconlist[index],
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  AppLocalizations.of(value),
                  style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkBoxListBuilderFacilities(List<AddFacilitiesModel> list, int n) {
    int i = 0;
    return Column(
      children: list.map((e) {
        return _customCheckBoxFacilities(
            e.facility,
            e.facilityID,
            list,
            (n == 1)
                ? controller.facilities1iconlist
                : controller.facilities2iconlist,
            i++);
      }).toList(),
    );
  }

  Widget _customCheckBoxListBuilderFacilities(
      RxList<AddFacilitiesModel> list1, RxList<AddFacilitiesModel> list2) {
    return Obx(
      () => Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _checkBoxListBuilderFacilities(list1, 1),
            _checkBoxListBuilderFacilities(list2, 2),
          ],
        ),
      ),
    );
  }

//FACILITIES

  Widget _customCheckBoxListBuilder(List<String> list1, List<String> list2) {
    return Container(
      decoration: new BoxDecoration(
        color: hotPropertiesThemeColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _checkBoxListBuilder(list1),
          _checkBoxListBuilder(list1),
          _checkBoxListBuilder(list2),
        ],
      ),
    );
  }

  // Widget _finalColumn() {
  //   return Container();
  //   print('user',)
  // }

  Widget _lastColumn() {
    return Container(
      width: 100.0.w - 20,
      decoration: new BoxDecoration(
        color: HexColor("#f5f7f6"),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _customCheckBox("Property paid"),
          _customCheckBoxSingle(controller.isproperyPaid),
          // _customCheckBox("Shared ownership"),
          _customCheckBoxSingle(controller.issharedOwnership),
          // _customCheckBox("Retirement homes"),
          _customCheckBoxSingle(controller.isretirementHome),
          // _customCheckBox("Under offer or sold STC"),
          _customCheckBoxSingle(controller.underOfferSold)
        ],
      ),
    );
  }

  Widget _attachmentCard(File file, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Text('${file.path} selected')

                // Image.file(
                //   file,
                //   fit: BoxFit.cover,
                //   height: 250,
                //   width: 100.0.w,
                // ),
                ),
          ),
          Positioned.fill(
            right: 10,
            top: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(5),
                  onPressed: () => controller.deleteAttachments(index),
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: hotPropertiesThemeColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _videoCard(File file, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SamplePlayer(
                url: file,
              ),

              // Image.file(
              //   file,
              //   fit: BoxFit.cover,
              //   height: 250,
              //   width: 100.0.w,
              // ),
            ),
          ),
          Positioned.fill(
            right: 10,
            top: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(5),
                  onPressed: () => controller.deleteFileVideo(index),
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: hotPropertiesThemeColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _photoCard(File file, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                height: 250,
                width: 100.0.w,
              ),
            ),
          ),
          Positioned.fill(
            right: 10,
            top: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(5),
                  onPressed: () => controller.deleteFile(index),
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: hotPropertiesThemeColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
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
                  "${controller.photos.length} ${controller.photosString()}",
                  style: TextStyle(
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ))),
      ),
    );
  }

  Widget _pageIndexCardFloor() {
    return Positioned.fill(
      left: 20,
      bottom: 10,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Obx(() => Text(
                  "${controller.floorplanphotos.length} ${controller.photosString()}",
                  style: TextStyle(
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ))),
      ),
    );
  }

  Widget _selectionCard(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 100,
          width: 100.0.w - 20,
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: hotPropertiesThemeColor,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          )),
    );
  }

  Widget _attachmentBuilder() {
    return Obx(
      () => Container(
          child: controller.attachmentFileList.length == 0
              ? _selectionCard(
                  AppLocalizations.of("Select") +
                      " " +
                      AppLocalizations.of("Attachment").toLowerCase(),
                  () => controller.pickAttachmentFiles(),
                )
              : Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.videoFileList.length,
                          onPageChanged: (page) => controller.changePage(page),
                          itemBuilder: (context, index) {
                            return _attachmentCard(
                                controller.attachmentFileList[index], index);
                          }),
                      // _pageIndexCardFloor()
                    ],
                  ),
                )),
    );
  }

  Widget _videoBuilder() {
    return Obx(
      () => Container(
          child: controller.videoFileList.length == 0
              ? _selectionCard(
                  AppLocalizations.of("Select") +
                      " " +
                      AppLocalizations.of("Video").toLowerCase() +
                      " " +
                      AppLocalizations.of("From").toLowerCase() +
                      " " +
                      AppLocalizations.of("Gallery").toLowerCase(),
                  () => controller.pickVideoFilesFloor(),
                )
              : Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.videoFileList.length,
                          onPageChanged: (page) => controller.changePage(page),
                          itemBuilder: (context, index) {
                            return _videoCard(
                                controller.videoFileList[index], index);
                          }),
                      // _pageIndexCardFloor()
                    ],
                  ),
                )),
    );
  }

  Widget _photosBuilderFloor() {
    return Obx(
      () => Container(
          child: controller.floorplanphotos.isEmpty
              ? _selectionCard(
                  AppLocalizations.of("Select") +
                      " " +
                      AppLocalizations.of("Photos").toLowerCase() +
                      " " +
                      AppLocalizations.of("From").toLowerCase() +
                      " " +
                      AppLocalizations.of("Gallery").toLowerCase(),
                  () => controller.pickPhotosFilesFloor(),
                )
              : Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.floorplanphotos.length,
                          onPageChanged: (page) => controller.changePage(page),
                          itemBuilder: (context, index) {
                            return _photoCard(
                                controller.floorplanphotos[index], index);
                          }),
                      _pageIndexCardFloor()
                    ],
                  ),
                )),
    );
  }

  Widget _photosBuilder() {
    return Obx(
      () => Container(
          child: controller.photos.isEmpty
              ? _selectionCard(
                  AppLocalizations.of("Select") +
                      " " +
                      AppLocalizations.of("Photos").toLowerCase() +
                      " " +
                      AppLocalizations.of("From").toLowerCase() +
                      " " +
                      AppLocalizations.of("Gallery").toLowerCase(),
                  () => controller.pickPhotosFiles(),
                )
              : Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.photos.length,
                          onPageChanged: (page) => controller.changePage(page),
                          itemBuilder: (context, index) {
                            return _photoCard(controller.photos[index], index);
                          }),
                      _pageIndexCard()
                    ],
                  ),
                )),
    );
  }

  int getCurrentIndex(title) {
    if (title.contains('Currency'))
      return controller.currentCurrencyIndex.value;
    else if (title.contains('Floor'))
      return controller.currentFloorIndex.value;
    else if (title.contains('Bathroom'))
      return controller.currentBathroomIndex.value;
    else if (title.contains('Dimension'))
      return controller.currentDimensionIndex.value;
    else if (title.contains('Land Area'))
      return controller.currentLandAreaIndex.value;
    else if (title.contains('Preference'))
      return controller.currentPreferenceIndex.value;
    else
      return controller.currentBedroomIndex.value;
  }

  Future customBarBottomSheetDynamic(
      double h, String title, List<dynamic> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of("Select ") + title),
                Container(
                    height: h / 1.2,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 0,
                      ),
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          if (title.contains('Currency')) {
                            controller.currentCurrency.value = dataList[index];
                            controller.currentCurrencyIndex.value = index;
                          } else if (title.contains('Floor')) {
                            controller.currentFloorIndex.value = index;
                            controller.currentFloor.value = dataList[index];
                          } else if (title.contains('Bathroom')) {
                            print("bathroom");
                            controller.currentBathroom.value = dataList[index];
                            controller.currentBathroomIndex.value = index;
                          } else if (title.contains('Dimension')) {
                            print("dimension");
                            controller.currentDimension.value = dataList[index];
                            controller.currentDimensionIndex.value = index;
                          } else if (title.contains('Land Area')) {
                            controller.currentLandArea.value = dataList[index];
                            controller.currentLandAreaIndex.value = index;
                          } else if (title.contains('Preference')) {
                            controller.currentPreference.value =
                                dataList[index];
                            controller.currentPreferenceIndex.value = index;
                          } else {
                            controller.currentBedroom.value = dataList[index];
                            controller.currentBedroomIndex.value = index;
                          }
                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index]),
                          style: TextStyle(
                              color: (index == getCurrentIndex(title))
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor: (index == getCurrentIndex(title))
                            ? hotPropertiesThemeColor
                            : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Future customBarBottomSheetCountryList(
      double h, String title, List<CountryListModel> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard('Select ' + title),
                _customTextFieldCountry(controller.searchCountry,
                    AppLocalizations.of("Enter Country"), 50.0),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: h,
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: (controller.searchCountry.text.isEmpty)
                            ? dataList.length
                            : controller.searchCountryList.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            if (controller.searchCountryList.length == 0) {
                              controller.currentCountry.value =
                                  dataList[index].country!;
                              controller.currentCountryIndex.value = index;
                              controller.countryid.value =
                                  dataList[index].countryID!;
                            } else {
                              controller.currentCountry.value =
                                  controller.searchCountryList[index].country;
                              controller.currentCountryIndex.value = index;
                              controller.currentCountryIndex.value = index;
                              controller.countryid.value =
                                  controller.searchCountryList[index].countryID;
                            }
                            Navigator.of(Get.context!).pop();
                          },
                          title: Text(
                            AppLocalizations.of(
                                (controller.searchCountryList.length == 0)
                                    ? dataList[index].country
                                    : controller
                                        .searchCountryList[index].country),
                            style: TextStyle(
                                color: (index ==
                                        controller.currentCountryIndex.value)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          tileColor:
                              (index == controller.currentCountryIndex.value)
                                  ? hotPropertiesThemeColor
                                  : Colors.transparent,
                        ),
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Future customBarBottomSheetVideoType(
      double h, String title, List dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of(title)),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          controller.currentVideoType.value = dataList[index];

                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index]),
                          style: TextStyle(color: Colors.black),
                        ),
                        tileColor: Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Future customBarBottomSheetListingType(
      double h, String title, List<ListingTypeModel> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of(title)),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          controller.currentListingType.value =
                              dataList[index].typeName!;
                          controller.currentListingTypeIndex.value = index;
                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index].typeName!),
                          style: TextStyle(
                              color: (index ==
                                      controller.currentListingTypeIndex.value)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor:
                            (index == controller.currentListingTypeIndex.value)
                                ? hotPropertiesThemeColor
                                : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Future customBarBottomSheetPropertyList(
      double h, String title, List<AddPropertyListModel> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of(title)),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          controller.currentPropertyTypeIndex.value = index;
                          controller.currentPropertyType.value =
                              dataList[index].propertytype!;
                          Navigator.of(Get.context!).pop();
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index].propertytype!),
                          style: TextStyle(
                              color: (index ==
                                      controller.currentPropertyTypeIndex.value)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor:
                            (index == controller.currentPropertyTypeIndex.value)
                                ? hotPropertiesThemeColor
                                : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AddPropertyController());
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<AddPropertyController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: hotPropertiesThemeColor,
          brightness: Brightness.dark,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Get.delete<AddPropertyController>();
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of("Add a property"),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              _addButton(context)
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerCard(AppLocalizations.of("Listing Type") + " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(
                        controller.currentListingType.value == ''
                            ? controller.select + " (e.g. sale)"
                            : controller.currentListingType.value), () async {
                  controller.iconLoadListingType.value = true;
                  controller.fetchListingType(() {
                    customBarBottomSheetListingType(
                        200, 'Listing Type', controller.listingtype);
                  });
                }, controller.iconLoadListingType),
              ),
              Obx(() => (controller.validateField.value == true &&
                      controller.currentListingType.value.isEmpty)
                  ? _customErrorTextCard(
                      '* ' +
                          AppLocalizations.of('Please select the Listing type'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _headerCard(AppLocalizations.of("Property Type") + " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(
                        controller.currentPropertyType.value == ''
                            ? controller.select + " (e.g. condo)"
                            : controller.currentPropertyType.value), () async {
                  controller.iconLoadPropertyType.value = true;
                  controller.fetchPropertyList(() {
                    customBarBottomSheetPropertyList(
                        Get.size.height / 2,
                        AppLocalizations.of('Property Type'),
                        controller.propertytypelist);
                  });
                }, controller.iconLoadPropertyType),
              ),
              Obx(() => (controller.validateField.value == true &&
                      controller.currentPropertyType.value.isEmpty)
                  ? _customErrorTextCard(
                      '* ' +
                          AppLocalizations.of(
                              'Please select the  the Property type'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),

              _headerCard(AppLocalizations.of("Property") +
                  " " +
                  AppLocalizations.of("Title") +
                  " * "),
              _customTextField(
                  controller.propertyTitle,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Property") +
                      " " +
                      AppLocalizations.of("Title"),
                  50),
              Obx(() => (controller.validateField.value == true &&
                      controller.propertyTitle.text.isEmpty)
                  ? _customErrorTextCard(
                      '* ' +
                          AppLocalizations.of(
                              'Please enter the Property Title'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _headerCard(AppLocalizations.of("Asking") +
                  " " +
                  AppLocalizations.of("Price") +
                  " * "),
              _customTextField(
                  controller.propertyPrice,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Asking") +
                      " " +
                      AppLocalizations.of("Price"),
                  50),
              Obx(() => (controller.validateField.value == true &&
                      controller.propertyPrice.text.isEmpty)
                  ? _customErrorTextCard(
                      '* ' + AppLocalizations.of('Please enter the Price'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _spacer(),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentCurrency.value == ''
                        ? controller.select + " (e.g. USD)"
                        : controller.currentCurrency.value), () async {
                  controller.iconLoadCurrency.value = true;
                  controller.fetchCurrencyList(() async {
                    await customBarBottomSheetDynamic(
                        Get.size.height / 2,
                        AppLocalizations.of('Currency'),
                        controller.currencylist);
                  });
                }, controller.iconLoadCurrency),
              ),
              Obx(() => (controller.validateField.value == true &&
                      controller.currentCurrency.value.isEmpty)
                  ? _customErrorTextCard(
                      '* ' + AppLocalizations.of('Please select the Currency'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _headerCard(AppLocalizations.of("Bedrooms") + " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentBedroom.value == ''
                        ? controller.select + " (e.g. 4)"
                        : controller.currentBedroom.value), () async {
                  controller.iconLoadBedroom.value = true;
                  controller.fetchBedroomList(() async {
                    customBarBottomSheetDynamic(
                        Get.size.height / 1.5,
                        AppLocalizations.of('Bedrooms'),
                        controller.bedroomlist);
                  });
                }, controller.iconLoadBedroom),
              ),
              Obx(() => (controller.validateField.value == true &&
                      controller.currentBedroom.value.isEmpty)
                  ? _customErrorTextCard(
                      '* ' + AppLocalizations.of('Please enter no of Bedrooms'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _headerCard(AppLocalizations.of("Floor") + " * "),
              Obx(() => _customSelectButton(
                    AppLocalizations.of(controller.currentFloor.value == ''
                        ? controller.select + " (e.g. Basement)"
                        : controller.currentFloor.value),
                    () async {
                      controller.iconLoadFloor.value = true;
                      controller.fetchFloornamList(() async {
                        await customBarBottomSheetDynamic(
                            Get.size.height / 2,
                            AppLocalizations.of('Floor'),
                            controller.floornamelist);
                      });
                    },
                    controller.iconLoadFloor,
                  )),
              Obx(() => (controller.validateField.value == true &&
                      controller.currentFloor.value.isEmpty)
                  ? _customErrorTextCard(
                      '* ' + AppLocalizations.of('Please Select a Floor'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _headerCard(AppLocalizations.of("Bathrooms") + " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentBathroom.value == ''
                        ? controller.select + " (e.g. 2)"
                        : controller.currentBathroom.value), () async {
                  controller.iconLoadBathroom.value = true;
                  controller.fetchBathroomList(() async {
                    await customBarBottomSheetDynamic(
                        Get.size.height / 2,
                        AppLocalizations.of('Bathrooms'),
                        controller.bathroomlist);
                  });
                }, controller.iconLoadBathroom),
              ),
              Obx(() => (controller.validateField.value == true &&
                      controller.currentBathroom.value.isEmpty)
                  ? _customErrorTextCard(
                      '* ' +
                          AppLocalizations.of('Please enter no of Bathrooms'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _headerCard(AppLocalizations.of("Dimensions") + " * "),
              _multipleTextFieldRow(
                  controller.propertyWidth,
                  AppLocalizations.of("Width"),
                  controller.propertyLength,
                  AppLocalizations.of("Length")),
              _spacer(),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentDimension.value == ''
                        ? controller.select + " (e.g. square feet)"
                        : controller.currentDimension.value), () async {
                  controller.iconLoadDimension.value = true;

                  print("loadDimension =${controller.iconLoadDimension.value}");

                  controller.fetchMeasurementList(() async {
                    await customBarBottomSheetDynamic(
                        Get.size.height / 2,
                        AppLocalizations.of('Dimensions'),
                        controller.measurementlist);
                  }, "Dimension");
                }, controller.iconLoadDimension),
              ),
              _headerCard(AppLocalizations.of("Land") +
                  " " +
                  AppLocalizations.of("Area") +
                  " * "),
              _customTextField(
                  controller.propertyLandArea,
                  AppLocalizations.of("Select") +
                      " " +
                      AppLocalizations.of("Land") +
                      " " +
                      AppLocalizations.of("Area"),
                  50),
              _spacer(),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentLandArea.value == ''
                        ? controller.select + " (e.g. square feet)"
                        : controller.currentLandArea.value), () async {
                  controller.iconLoadLandArea.value = true;
                  controller.fetchMeasurementList(() async {
                    await customBarBottomSheetDynamic(
                        Get.size.height / 2,
                        AppLocalizations.of('Land') +
                            ' ' +
                            AppLocalizations.of('Area'),
                        controller.measurementlist);
                  }, "LandArea");
                }, controller.iconLoadLandArea),
              ),
              _headerCard(AppLocalizations.of("Description") + " * "),
              _customTextField(
                  controller.propertyDescription,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Description"),
                  125),
              Obx(() => (controller.validateField.value == true &&
                      controller.propertyDescription.text.isEmpty)
                  ? _customErrorTextCard(
                      '* ' +
                          AppLocalizations.of('Please enter the Description'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard(
                      '* ' +
                          AppLocalizations.of('Please enter the Desctiprion'),
                      0,
                      Colors.white)),
              _furnishedRow(),
              _newHomeRow(),
              _headerCard(AppLocalizations.of("Special") +
                  " " +
                  AppLocalizations.of("Features")),
              Obx(
                () => (controller.featureList1.length == 0)
                    ? _customCheckBoxListBuilder(
                        controller.features1, controller.features2)
                    : _customCheckBoxListBuilderFeature(
                        controller.featureList1, controller.featureList2),
              ),
              _headerCard(AppLocalizations.of("Fixtures") +
                  " & " +
                  AppLocalizations.of("Fittings")),
              Obx(() => (controller.fixtureList1.length == 0)
                  ? Container()
                  : _customCheckBoxListBuilderFixture(
                      controller.fixtureList1, controller.fixtureList2)),
              _headerCard(AppLocalizations.of("Indoor") +
                  " & " +
                  AppLocalizations.of("Outdoor") +
                  " " +
                  AppLocalizations.of("Space")),
              Obx(() => (controller.outinspaceList1.length == 0)
                  ? _customCheckBoxListBuilder(
                      controller.spaces1, controller.spaces2)
                  : _customCheckBoxListBuilderOutinSpace(
                      controller.outinspaceList1, controller.outinspaceList2)),
              _headerCard(AppLocalizations.of("Facilities")),
              Obx(() => (controller.facilitiesList1.length == 0)
                  ? _customCheckBoxListBuilder(
                      controller.facilities1, controller.facilities2)
                  : _customCheckBoxListBuilderFacilities(
                      controller.facilitiesList1, controller.facilitiesList2)),
              _headerCard(AppLocalizations.of("Country") + " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentCountry.value == ''
                        ? controller.select + " (e.g. UK)"
                        : controller.currentCountry.value), () async {
                  controller.iconLoadCountry.value = true;
                  controller.fetchCountryList(() async {
                    customBarBottomSheetCountryList(Get.size.height / 1.5,
                        AppLocalizations.of('Country'), controller.countrylist);
                  });
                }, controller.iconLoadCountry),
              ),
              Obx(() => (controller.validateField.value == true &&
                      controller.currentCountry.value.isEmpty)
                  ? _customErrorTextCard(
                      AppLocalizations.of('Please select a country') + ' *',
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              _headerCard(AppLocalizations.of("Location") + " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.message.value == ''
                        ? 'Enter Location'
                        : controller.message.value), () async {
                  // controller.getLocations();

                  if (controller.currentCountry.value.isEmpty)
                    showError(AppLocalizations.of('Please choose a country'));
                  else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LocationSearchPageAdd(),
                    ));
                  }
                }, controller.iconLoadBathroom),
              ),
              Obx(() => (controller.validateField.value == true &&
                      controller.message.value.isEmpty)
                  ? _customErrorTextCard(
                      '*' + AppLocalizations.of('Please choose a Location'),
                      15,
                      hotPropertiesThemeLightColor)
                  : _customErrorTextCard('', 0, Colors.white)),
              // _customTextField(
              //     controller.propertyLocation, "Enter Location", 50),

              _headerCard(AppLocalizations.of("Select") +
                  " " +
                  AppLocalizations.of("Property") +
                  " " +
                  AppLocalizations.of("Location") +
                  " " +
                  AppLocalizations.of("on") +
                  " " +
                  AppLocalizations.of("Map") +
                  " * "),
              Obx(
                () =>
                    _customSelectButton('${controller.maploc.value}', () async {
                  print("Tapped on map");
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPropertyMap(),
                  ));
                  if (controller.mapcontroller == null) {
                    controller.mapcontroller = Completer();
                    controller.controller =
                        await controller.mapcontroller!.future;
                  }
                }, false.obs),
              ),
              _headerCard(AppLocalizations.of("Home") +
                  " " +
                  AppLocalizations.of("Name") +
                  "/" +
                  AppLocalizations.of("Number") +
                  " * "),
              _customTextField(
                  controller.propertyHouseName,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Home") +
                      " " +
                      AppLocalizations.of("Name") +
                      "/" +
                      AppLocalizations.of("Number"),
                  50),
              _headerCard(AppLocalizations.of("Street") +
                  " " +
                  AppLocalizations.of("Lane") +
                  " 1 * "),
              _customTextField(
                  controller.propertStreet1,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Street") +
                      " " +
                      AppLocalizations.of("Lane") +
                      "  1",
                  50),
              _headerCard(AppLocalizations.of("Street") +
                  " " +
                  AppLocalizations.of("Lane") +
                  " 2"),
              _customTextField(
                  controller.propertyStreet2,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Street") +
                      " " +
                      AppLocalizations.of("Lane") +
                      " 2",
                  50),
              _headerCard(AppLocalizations.of("Postal") +
                  "/" +
                  AppLocalizations.of("Zip") +
                  " " +
                  AppLocalizations.of("Code") +
                  " * "),
              _customTextField(
                  controller.propertyZipCode,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Postal") +
                      "/" +
                      AppLocalizations.of("Zip") +
                      " " +
                      AppLocalizations.of("Code"),
                  50),
              _headerCard(AppLocalizations.of("Latitude") + " * "),
              _customTextField(
                  controller.propertyLat,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Latitude"),
                  50),
              _headerCard(AppLocalizations.of("Longitude") + " * "),
              _customTextField(
                  controller.propertyLong,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Longitude"),
                  50),
              _headerCard(AppLocalizations.of("Preference") + " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentPreference.value == ''
                        ? controller.select + " (e.g. Retirement only)"
                        : controller.currentPreference.value), () async {
                  controller.iconLoadPreference.value = true;
                  print("load Pref=${controller.iconLoadPreference.value}");
                  controller.fetchPreferenceList(() {
                    customBarBottomSheetDynamic(
                        Get.size.height / 2,
                        AppLocalizations.of('Preference'),
                        controller.preferencelist);
                  });
                }, controller.iconLoadPreference),
              ),
              _headerCard(AppLocalizations.of("Available") +
                  " " +
                  AppLocalizations.of("Date")),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.selectedDate.value == ''
                        ? controller.select + " (e.g. 1st October, 2021)"
                        : controller.selectedDate.value), () {
                  controller.pickDate();
                }, controller.iconLoadDate),
              ),
              // _headerCard("Location on Map"),
              // _customSelectButton("Select", () async {
              //   Get.put(SearchByMapController());
              //   Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => TravelTimeSearchView(
              //       from: "addprop",
              //     ),
              //     // MyMapApp(),
              //   ));
              // }, RxBool(false)),

              _headerCard(AppLocalizations.of("Property") +
                  " " +
                  AppLocalizations.of("Photos") +
                  " * "),
              _photosBuilder(),
              _headerCard(AppLocalizations.of("Floor") +
                  " " +
                  AppLocalizations.of("Plan") +
                  " " +
                  AppLocalizations.of("Photos") +
                  " * "),
              _photosBuilderFloor(),
              _spacer(),

              _spacer(),

              _headerCard(AppLocalizations.of("Property") +
                  " " +
                  AppLocalizations.of("attachments") +
                  " * "),
              _spacer(),
              _attachmentBuilder(),
              _headerCard(AppLocalizations.of("Property") +
                  " " +
                  AppLocalizations.of("Video") +
                  " * "),
              Obx(
                () => _customSelectButton(
                    AppLocalizations.of(controller.currentVideoType.value == ''
                        ? controller.select + " video type"
                        : controller.currentVideoType.value), () async {
                  customBarBottomSheetVideoType(
                      200, 'Video Type', ['internal', 'external']);
                }, controller.iconLoadListingType),
              ),
              Obx(() => controller.currentVideoType.value == 'external'
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _customTextField(
                          controller.propertyVideo,
                          AppLocalizations.of("Enter") +
                              " " +
                              AppLocalizations.of("Video") +
                              " " +
                              AppLocalizations.of("Url"),
                          50),
                    )
                  : controller.currentVideoType.value == 'internal'
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _videoBuilder(),
                        )
                      : Container()),

              _spacer(),
              _headerCard(AppLocalizations.of("Neighbourhood") + " * "),
              _customTextField(
                  controller.propertyNeighbourhood,
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Neighbourhood"),
                  80),
              _spacer(),
              _lastColumn(),
              _spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
