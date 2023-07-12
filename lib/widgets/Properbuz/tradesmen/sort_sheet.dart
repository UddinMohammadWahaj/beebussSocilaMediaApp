import 'dart:async';

import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

class TradesmenResultsSortSheet extends GetView<TradesmenResultsController> {
  TradesmenResultsSortSheet(
      {Key? key,
      this.catId,
      this.countryId,
      this.location,
      this.subCatId,
      this.setstate})
      : super(key: key);

  final String? catId;
  final String? subCatId;
  final String? countryId;
  final String? location;
  StateSetter? setstate;

  Widget _customListTile(
    String title,
    VoidCallback ontap,
    int index,
  ) {
    return ListTile(
      tileColor: controller.selectedIndex == index
          ? settingsColor
          : Colors.transparent,
      onTap: ontap,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: controller.selectedIndex == index
                ? Colors.white
                : settingsColor),
      ),
    );
  }

  Widget _settingsCard(String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: 50.0.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                icon,
                size: 25,
                color: settingsColor,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 16,
                  color: settingsColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TradesmenResultsController());
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _settingsCard(AppLocalizations.of("Cancel").toUpperCase(),
                    Icons.cancel_outlined, () {
                  setState(() {
                    controller.selectedIndex = -1;
                    controller.shortBy.value = "";

                    Navigator.of(context).pop();
                    controller.fetchData(
                      catId: catId!,
                      countryId: countryId!,
                      location: location!,
                      subCatId: controller.subCatId!.value == ""
                          ? subCatId!
                          : controller.subCatId.value,
                    );
                    setstate!(() {
                      controller.loader.value = false;
                    });

                    setstate!(() {
                      controller.loader.value = false;
                    });
                    Timer(Duration(seconds: 2), () {
                      setstate!(
                        () {
                          controller.loader.value = true;
                        },
                      );
                    });
                  });
                }),
                _settingsCard(AppLocalizations.of("Done").toUpperCase(),
                    Icons.done_rounded, () async {
                  if (controller.selectedIndex == 1) {
                    if (controller.haspermission.isTrue) {
                      Navigator.of(context).pop();
                      await controller.getLocation();

                      await controller.fetchData(
                        catId: catId!,
                        countryId: countryId!,
                        location: location!,
                        subCatId: controller.subCatId!.value == ""
                            ? subCatId!
                            : controller.subCatId.value,
                        shortBy: controller.shortBy.value,
                        latitude: double.parse(controller.lat.value),
                        longitude: double.parse(controller.long.value),
                      );
                    } else {
                      print(
                          "------- permission ----- ${controller.haspermission.value}");
                      controller.checkGps();
                    }
                  } else {
                    Navigator.of(context).pop();
                    controller.fetchData(
                      catId: catId!,
                      countryId: countryId!,
                      location: location!,
                      subCatId: controller!.subCatId!.value! == ""
                          ? subCatId!
                          : controller.subCatId.value,
                      shortBy: controller.shortBy.value,
                      latitude: 0.0,
                      longitude: 0.0,
                      distance: 0,
                      keyWords: "",
                      typeOfWork: "",
                    );
                    setstate!(() {
                      controller.loader.value = false;
                    });
                  }

                  setstate!(() {
                    controller.loader.value = false;
                  });
                  Timer(Duration(seconds: 2), () {
                    setstate!(
                      () {
                        controller.loader.value = true;
                      },
                    );
                  });
                }),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            _customListTile(AppLocalizations.of("Nearest"), () {
              setState(() {
                controller.selectedIndex = 1;
                controller.shortBy.value = "nearest";
              });
            }, 1),
            _customListTile(AppLocalizations.of("Most recent feedback"), () {
              setState(() {
                controller.selectedIndex = 2;
                controller.shortBy.value = "most_feedback";
              });
            }, 2),
            _customListTile(AppLocalizations.of("Longest serving member"), () {
              setState(() {
                controller.selectedIndex = 3;
                controller.shortBy.value = "longest_serving";
              });
            }, 3),
          ],
        ),
      );
    });
  }
}
