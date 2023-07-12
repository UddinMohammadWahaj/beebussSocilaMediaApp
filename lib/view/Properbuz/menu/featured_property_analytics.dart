import 'package:bizbultest/models/Properbuz/featured_propert_location_list_model.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/menu/manage_properties/manage_properties_card.dart';
import 'package:bizbultest/widgets/Properbuz/menu/user_properties/featured_properties_card.dart';
import 'package:bizbultest/widgets/Properbuz/menu/user_properties/saved_property_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';

enum CardType {
  totprop,
  totsale,
  totrent,
}

class FeaturedPropertyAnalytics extends GetView<UserPropertiesController> {
  const FeaturedPropertyAnalytics({Key? key}) : super(key: key);

// Future<List> getFeaturedPropertyAnalytics()async{
//   return await Dio
// }

  Widget _customSelectButton(String val, VoidCallback onTap) {
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
              Text(
                val,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              (!controller.isLoadFeatured.value)
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

  Widget _customCard(
      Icon icon, String title, Color graphColor, CardType cardType) {
    switch (cardType) {
      case CardType.totprop:
        return Obx(
          () => _customListTile(
            2,
            icon: icon,
            title: title,
            no: (controller.featuredanalyticspropinfo.length == 0)
                ? "0"
                : '${controller.featuredanalyticspropinfo[0].totalProperty}',
            graphColor: graphColor,
          ),
        );

      case CardType.totsale:
        return Obx(
          () => _customListTile(
            2,
            icon: icon,
            title: title,
            no: (controller.featuredanalyticspropinfo.length == 0)
                ? "0"
                : '${controller.featuredanalyticspropinfo[0].totalSaleProperty}',
            graphColor: graphColor,
          ),
        );
        break;
      case CardType.totrent:
        return Obx(
          () => _customListTile(
            2,
            icon: icon,
            title: title,
            no: (controller.featuredanalyticspropinfo.length == 0)
                ? "0"
                : '${controller.featuredanalyticspropinfo[0].totalRentalProperty}',
            graphColor: graphColor,
          ),
        );
        break;
    }
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

  Future customBarBottomSheet(double h, String title,
      List<FeaturedPropertyLocationListModel> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of("Select") + " $title"),
                Container(
                    height: h / 1.2,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 0,
                      ),
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Icon(
                          Icons.home_filled,
                          color: hotPropertiesThemeColor,
                        ),
                        onTap: () {
                          controller.selectedfeaturedanalyticspropid.value =
                              dataList[index].propertyId!;
                          controller.selectedfeaturedanalyticspropname.value =
                              dataList[index].propertyTitle!;

                          Navigator.of(Get.context!).pop();
                          controller.getGraphData(dataList[index].propertyId!);
                        },
                        title: Text(
                          dataList[index].propertyTitle!,
                          style: TextStyle(color: hotPropertiesThemeColor),
                        ),
                        tileColor: Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Widget _customListTile(int type,
      {String title = "",
      String no = "0",
      String percentage = "0.00%",
      Icon? icon,
      Color? graphColor}) {
    return Container(
      child: Card(
        elevation: (type == 1) ? 2 : 0,
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: icon,
          title: Text(
            '$title',
            style: TextStyle(color: hotPropertiesThemeColor, fontSize: 15),
          ),
          subtitle: (type == 1)
              ? Text('$percentage')
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  child: SfSparkLineChart(
                    color: graphColor!,
                    //Enable the trackball
                    // trackball: SparkChartTrackball(
                    //     activationMode: SparkChartActivationMode.tap),
                    //Enable marker
                    marker: SparkChartMarker(
                        displayMode: SparkChartMarkerDisplayMode.all),
                    //Enable data label
                    // labelDisplayMode: SparkChartLabelDisplayMode.all,
                    data: <double>[
                      1,
                      5,
                      -6,
                      0,
                      1,
                      -2,
                      7,
                      -7,
                      -4,
                      -10,
                      13,
                      -6,
                      7,
                      5,
                      11,
                      5,
                      3
                    ],
                  ),
                ),
          trailing: Container(
            child: Text(
              no,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _totalPropertyCard() {
    return Container(
        child: Card(
      elevation: 5,
      child: Column(
        children: [
          Center(
            child: Text(
              AppLocalizations.of('Total') +
                  ' ' +
                  AppLocalizations.of('Property') +
                  ' ' +
                  AppLocalizations.of('Data') +
                  ' ' +
                  AppLocalizations.of('Analytics'),
              style: TextStyle(
                  color: hotPropertiesThemeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _customCard(
              Icon(
                Icons.home,
                color: hotPropertiesThemeColor,
              ),
              AppLocalizations.of("Total") +
                  " " +
                  AppLocalizations.of("Property"),
              Colors.orange,
              CardType.totprop),
          _customCard(
              Icon(
                Icons.home,
                color: hotPropertiesThemeColor,
              ),
              AppLocalizations.of("Total") +
                  " " +
                  AppLocalizations.of("Sale") +
                  " " +
                  AppLocalizations.of("Property"),
              hotPropertiesThemeColor,
              CardType.totsale),
          _customCard(
              Icon(
                Icons.home,
                color: hotPropertiesThemeColor,
              ),
              AppLocalizations.of("Total") +
                  " " +
                  AppLocalizations.of("Rental") +
                  " " +
                  AppLocalizations.of("Property"),
              Colors.amber,
              CardType.totrent)
        ],
      ),
    ));
  }

  Widget _barChart() {
    return Obx(() => Container(
            child: Card(
          child: Column(
            children: [
              Center(
                  child: Text(
                      AppLocalizations.of('Activity') +
                          ' ' +
                          AppLocalizations.of('Timeline'),
                      style: TextStyle(
                          color: hotPropertiesThemeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20))),
              Center(
                  child: Text(
                      AppLocalizations.of('Total') +
                          ' ' +
                          AppLocalizations.of('property') +
                          ' ' +
                          AppLocalizations.of('View'),
                      style: TextStyle(
                          color: hotPropertiesThemeColor,
                          fontWeight: FontWeight.w400))),
              (controller.graphdatalist.length != 0)
                  ? SfSparkBarChart(
                      axisLineWidth: 2,
                      color: hotPropertiesThemeColor,
                      data: controller.graphdatalist.value,
                    )
                  : Container(
                      child: Center(
                          child: Text(
                        AppLocalizations.of(
                            "Select a propperty to view the activity"),
                        style: TextStyle(
                            color: hotPropertiesThemeColor, fontSize: 17),
                      )),
                    ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Get.delete<UserPropertiesController>();
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.5,
              backgroundColor: Colors.white,
              brightness: Brightness.dark,
              leading: IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.keyboard_backspace,
                  size: 28,
                  color: Colors.black,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                  Get.delete<UserPropertiesController>();
                },
              ),
              title: Text(
                AppLocalizations.of("Featured Property Analytics"),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            body: Container(
              margin: EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => _customSelectButton(
                          (controller.selectedfeaturedanalyticspropname.value
                                  .isEmpty)
                              ? AppLocalizations.of("Select") +
                                  " " +
                                  AppLocalizations.of("property")
                              : controller.selectedfeaturedanalyticspropname
                                  .value, () async {
                        controller.isLoadFeatured.value = true;
                        controller.getFeaturedPropertyList(() =>
                            customBarBottomSheet(
                                Get.size.height / 2,
                                AppLocalizations.of("Property"),
                                controller.featuredPropertiesLocationList));
                      }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _customListTile(1,
                        title: AppLocalizations.of("Total") +
                            " " +
                            AppLocalizations.of("Saved") +
                            " " +
                            AppLocalizations.of("Properties"),
                        icon: Icon(
                          Icons.check_box,
                          color: hotPropertiesThemeColor,
                        )),
                    _customListTile(1,
                        title: AppLocalizations.of("Total") +
                            " " +
                            AppLocalizations.of("Searched") +
                            " " +
                            AppLocalizations.of("Properties"),
                        icon: Icon(
                          Icons.search,
                          color: hotPropertiesThemeColor,
                        )),
                    _customListTile(1,
                        title: AppLocalizations.of("Total") +
                            " " +
                            AppLocalizations.of("Property") +
                            " " +
                            AppLocalizations.of("Enquiry"),
                        icon: Icon(
                          Icons.people,
                          color: hotPropertiesThemeColor,
                        )),
                    _barChart(),
                    SizedBox(
                      height: 10,
                    ),
                    _totalPropertyCard()
                  ],
                ),
              ),
            )

            //  Obx(
            //   () => (controller.featuredProperties.length != 0)
            //       ? Center(
            //           child: Text(
            //           'No Featured Propety found!!',
            //           style: TextStyle(color: Colors.black),
            //         ))

            //  ListView.builder(
            //     itemCount: 10,
            //     itemBuilder: (context, index) {
            //       return FeaturedProperitesCard(
            //         index: 0,
            //       );
            //     })
            // : Center(
            //     child: Text(
            //     'No Featured Propety found!!',
            //     style: TextStyle(color: Colors.black),
            //   )),
            ));
  }
}
