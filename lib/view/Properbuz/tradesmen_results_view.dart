import 'dart:async';

import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/refine_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/sort_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/tradesmen_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../services/Properbuz/add_tradesman_controller.dart';

class TradesmenResultsView extends StatefulWidget {
  final String? catId;
  final String? subCatId;
  final String? countryId;
  final String? countryName;
  final String? location;
  final String? category;
  const TradesmenResultsView(
      {Key? key,
      this.catId,
      this.subCatId,
      this.countryName,
      this.countryId,
      this.location,
      this.category})
      : super(key: key);

  @override
  State<TradesmenResultsView> createState() => _TradesmenResultsViewState();
}

class _TradesmenResultsViewState extends State<TradesmenResultsView> {
  TradesmenResultsController controller = Get.put(TradesmenResultsController());
  AddTradesmenController ctr = Get.put(AddTradesmenController());
  // bool va1 = false;

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

  Widget _settingsRow() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _settingsCard(
              AppLocalizations.of("Refine").toUpperCase(), CustomIcons.filter,
              () {
            controller.keyWordController.clear();
            Get.bottomSheet(
                TradesmenResultsRefineSheet(
                  catId: widget.catId,
                  catrgoryName: widget.category,
                  countryId: widget.countryId,
                  loction: widget.location,
                  setstate: setState,
                ),
                enableDrag: false,
                isScrollControlled: true,
                ignoreSafeArea: false,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))));
            // setState(() {
            //   controller.loader.value = false;
            // });
            // Timer(Duration(seconds: 2), () {
            //   setState(() {
            //     controller.loader.value = true;
            //   });
            // });
          }),
          _settingsCard(AppLocalizations.of("SORT BY"), CustomIcons.sort, () {
            Get.bottomSheet(
              TradesmenResultsSortSheet(
                catId: widget.catId,
                subCatId: widget.subCatId,
                countryId: widget.countryId,
                location: widget.location,
                setstate: setState,
              ),
              isScrollControlled: false,
              ignoreSafeArea: false,
              backgroundColor: Colors.white,
            );
          }),
        ],
      ),
    );
  }

  Widget _appBarTitle() {
    return Container(
      width: 100.0.w - 80,
      decoration: new BoxDecoration(
        color: appBarLightColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(widget.countryName!),
            // "Plumber",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          Text(
            AppLocalizations.of(widget.location!),
            // "London, United Kingdom",
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.finalSubCatId.value = widget.subCatId!;
    controller.fetchData(
        catId: widget.catId,
        countryId: widget.countryId,
        location: widget.location,
        subCatId: widget.subCatId);
    ctr.fetchsubData(widget.catId!);
    if (controller.haspermission.isTrue) {
      controller.getLocation();
    } else {
      print("------- permission ----- ${controller.haspermission.value}");
      controller.checkGps();
    }
    Timer(Duration(seconds: 2), () {
      setState(
        () {
          controller.loader.value = true;
        },
      );
    });
  }

  @override
  void dispose() {
    Get.delete<TradesmenResultsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              toolbarHeight: 70,
              titleSpacing: 5,
              pinned: true,
              floating: true,
              elevation: 0,
              brightness: Brightness.dark,
              backgroundColor: appBarColor,
              title: _appBarTitle(),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(55), child: _settingsRow()),
              automaticallyImplyLeading: true,
            )
          ];
        },
        body: controller.loader.value == true
            ? Container(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GetX<TradesmenResultsController>(
                    builder: (controlr) {
                      return controlr.findtradesmenlist.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controlr.findtradesmenlist.length,
                              itemBuilder: (context, index) {
                                return TradesmenCard(
                                  index: index,
                                  objTradesmanSearchModel:
                                      controlr.findtradesmenlist[index],
                                );
                              },
                            )
                          : noDataView();
                    },
                  ),
                ),
              )
            : Center(
                child: Container(
                    height: 30,
                    child: CircularProgressIndicator(
                      color: settingsColor,
                    ))),
      ),
    );
  }

  Widget noDataView() {
    return Center(
      child: Container(
          // height: 100,
          // width: double.infinity,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CustomIcons.customer,
            size: 70,
            color: settingsColor,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            AppLocalizations.of("No Searched tradesman's History Yet..!"),
            style: TextStyle(fontSize: 20, color: settingsColor),
          ),
        ],
      )),
    );
  }
}
