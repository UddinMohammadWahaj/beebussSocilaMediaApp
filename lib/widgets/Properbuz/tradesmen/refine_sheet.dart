import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/property/common_appbar_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../../models/Tradesmen/tradesmen_subcat_model.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../utilities/Chat/colors.dart';

class TradesmenResultsRefineSheet extends GetView<TradesmenResultsController> {
  String? catId;
  String? catrgoryName;
  String? countryId;
  String? loction;
  StateSetter? setstate;
  TradesmenResultsRefineSheet({
    Key? key,
    this.catId,
    this.catrgoryName,
    this.countryId,
    this.loction,
    this.setstate,
  }) : super(key: key);

  AddTradesmenController ctr = Get.put(AddTradesmenController());

  // static final TextEditingController editingController =
  //     TextEditingController();

  String dropdownvalue3 = 'Select Sub category';

  static final List<String> work = [
    "Domestic",
    "Commercial",
    "Both Domestic and Commercial",
    "24 Hour call-out",
    "Public liability insurance",
    "Insurance work undertaken"
  ];

  Widget _divider() {
    return Divider(
      thickness: 0.2,
      color: settingsColor,
    );
  }

  BoxDecoration _customDecoration() {
    return new BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    );
  }

  Widget _appBarTitle(Context) {
    return CommonAppBarTitle(
      title: AppLocalizations.of(
        "Refine",
      ),
      buttonTitle: AppLocalizations.of(
        "RESET",
      ),
      onTap: () async {
        controller.subCatId.value = "";
        controller.workType.value = "";
        controller.keyWordController.clear();
        controller.distance.value = 100.0;
        print("object... subcatId -- ${controller.subCatId.value}");
        await controller.fetchData(
            catId: catId!,
            countryId: countryId!,
            location: loction!,
            subCatId: controller.finalSubCatId.value);
        Navigator.of(Context).pop();
        setstate!(() {
          controller.loader.value = false;
        });
        Timer(Duration(seconds: 2), () {
          setstate!(() {
            controller.loader.value = true;
          });
        });
      },
    );
  }

  Widget _headerCard(String value) {
    return Container(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
        child: Text(
          value,
          style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500),
        ));
  }

  Widget _customWrapCard(TradesmenSubCatModelWorkSubCategory value) {
    return GestureDetector(
      onTap: () {
        controller.subCatId.value = value.tradeSubcatId!;

        print(
            "vallllllllllll ----- ${value.tradeSubcatName} -- ${controller.subCatId.value}");
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          color: controller.subCatId.value == value.tradeSubcatId
              ? settingsColor
              : Colors.white,
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: settingsColor,
            width: 0.8,
          ),
        ),
        child: Text(
          AppLocalizations.of(value.tradeSubcatName!),
          style: TextStyle(
              color: controller.subCatId.value == value.tradeSubcatId
                  ? Colors.white
                  : settingsColor,
              fontSize: 15),
        ),
      ),
    );
  }

  Widget _plumberWrapBuilder() {
    return Container(
      padding: EdgeInsets.only(bottom: 5, left: 10),
      // margin: EdgeInsets.only(left: 10),
      child: Obx(
        () => Wrap(
          children: ctr.lstWorksubCat.map((e) => _customWrapCard(e)).toList(),
        ),
      ),
    );
  }

  Widget _customWrapCard1(String value) {
    return GestureDetector(
      onTap: () {
        controller.workType.value = value;
        if (value == "Domestic") {
          controller.passWorkType.value = "Domestic";
        } else if (value == "Commercial") {
          controller.passWorkType.value = "Commercial";
        } else if (value == "Both Domestic and Commercial") {
          controller.passWorkType.value = "Domestic,Commercial";
        } else if (value == "24 Hour call-out") {
          controller.passWorkType.value = "call_out_hours";
        } else if (value == "Public liability insurance") {
          controller.passWorkType.value = "public_libility";
        } else if (value == "Insurance work undertaken") {
          controller.passWorkType.value = "work_undertaken";
        } else {
          controller.passWorkType.value = "";
        }
        print("vallllllllllll ----- ${controller.workType}");
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          shape: BoxShape.rectangle,
          color:
              controller.workType.value == value ? settingsColor : Colors.white,
          border: new Border.all(
            color: settingsColor,
            width: 0.8,
          ),
        ),
        child: Text(
          AppLocalizations.of(value),
          style: TextStyle(
              color: controller.workType.value == value
                  ? Colors.white
                  : settingsColor,
              fontSize: 15),
        ),
      ),
    );
  }

  Widget _typeOfWorkWrapBuilder() {
    return Container(
      padding: EdgeInsets.only(bottom: 5, left: 10),
      // margin: EdgeInsets.only(left: 10),
      child: Obx(
        () => Wrap(
          children: work.map((e) => _customWrapCard1(e)).toList(),
        ),
      ),
    );
  }

  Widget _customTextField() {
    return Container(
      height: 50,
      width: 100.0.w - 20,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        color: HexColor("#f5f7f6"),
      ),
      child: TextFormField(
        maxLines: 1,
        cursorColor: Colors.grey.shade500,
        controller: controller.keyWordController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(
            "e.g. polite",
          ),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ),
    );
  }

  Widget _distanceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                controller.distance.value.toInt().toString() + " KM",
                style: TextStyle(
                    fontSize: 16,
                    color: settingsColor,
                    fontWeight: FontWeight.w500),
              ),
            )),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
              ),
              child: Slider(
                  // thumbColor: settingsColor,
                  inactiveColor: Colors.grey.shade500,
                  activeColor: featuredColor,
                  max: 100,
                  divisions: 10,
                  min: 10,
                  value: controller.distance.value,
                  onChanged: (val) {
                    controller.distance.value = val;
                  }),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(
                  "10 KM",
                ),
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              Text(
                AppLocalizations.of(
                  "100 KM",
                ),
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customListTile(String title) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.arrow_turn_down_right,
            color: settingsColor,
            size: 20,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                color: settingsColor,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget? errorView(msg) {
    Get.showSnackbar(GetBar(
      messageText:
          Text(msg, style: TextStyle(color: Colors.white, fontSize: 20)),
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.error,
        color: Colors.red,
      ),
    ));
    return null;
  }

  bool validation() {
    if (controller.subCatId.value.isEmpty &&
        controller.workType.value.isEmpty &&
        controller.keyWordController.text.length < 1 &&
        controller.distance.value == 100.0) {
      print("reached error");
      errorView(AppLocalizations.of("Select any Refine item "));
      return false;
    }

    return true;
  }

  Widget _nextButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          if (validation()) {
            await controller.fetchData(
              catId: catId!,
              countryId: countryId!,
              location: loction!,
              subCatId: controller.subCatId.value == ""
                  ? controller.finalSubCatId.value
                  : controller.subCatId.value,
              keyWords: controller.keyWordController.text,
              distance: controller.distance.value == 100.0
                  ? 0
                  : controller.distance.value.toInt(),
              longitude:

                  //  controller.distance.value != 100.0
                  //     ? double.parse(
                  //         controller.long.value == "" ? 0.0 : controller.long.value)
                  //     :

                  0.0,
              latitude:
                  // controller.distance.value != 100.0
                  //     ? double.parse(
                  //         controller.lat.value == "" ? 0.0 : controller.lat.value)
                  //     :

                  0.0,
              typeOfWork: controller.passWorkType.value,
              shortBy: "",
            );
            setstate!(() {
              controller.loader.value = false;
            });

            Navigator.of(context).pop();
            setstate!(() {
              controller.loader.value = false;
            });
            Timer(Duration(seconds: 2), () {
              setstate!(() {
                controller.loader.value = true;
              });
            });
          }
        } catch (e) {
          print("error= ${controller.lat.value}");
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: settingsColor,
        child: Center(
            child: Text(
          AppLocalizations.of("Refine").toUpperCase(),
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TradesmenResultsController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        elevation: 0,
        brightness: Brightness.dark,
        title: _appBarTitle(context),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(
              AppLocalizations.of(
                catrgoryName!,
              ),
            ),
            _plumberWrapBuilder(),
            _divider(),
            _headerCard(
              AppLocalizations.of("Keyword search"),
            ),
            _customTextField(),
            _divider(),
            _headerCard(
              AppLocalizations.of("Distance from you"),
            ),
            _distanceCard(),
            _divider(),
            _headerCard(
              AppLocalizations.of("Type of work"),
            ),
            _typeOfWorkWrapBuilder()
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(0),
        child: _nextButton(context),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
