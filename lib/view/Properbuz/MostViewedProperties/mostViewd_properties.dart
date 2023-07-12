import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/MostViewedProperties/mostViewedController.dart';
import 'package:bizbultest/view/Properbuz/menu/manage_properties/insights_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import '../menu/premium_package_view.dart';

class MostViewdProperties extends StatefulWidget {
  const MostViewdProperties({Key? key}) : super(key: key);

  @override
  _MostViewdPropertiesState createState() => _MostViewdPropertiesState();
}

class _MostViewdPropertiesState extends State<MostViewdProperties>
    with TickerProviderStateMixin {
  MostViewedController controller = Get.put(MostViewedController());

  @override
  void initState() {
    controller.managePropertiesController = new TabController(
        vsync: this, length: 2, initialIndex: controller.currentIndex.value);
    super.initState();
  }

  Widget _tab(String tabTitle) {
    return Tab(
      text: tabTitle.toUpperCase(),
    );
  }

  @override
  void dispose() {
    Get.delete<MostViewedController>();
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
              leading: IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.keyboard_backspace,
                  size: 28,
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              toolbarHeight: 50,
              titleSpacing: 5,
              pinned: true,
              floating: true,
              elevation: 0,
              brightness: Brightness.dark,
              backgroundColor: Colors.white,
              title: Text(
                AppLocalizations.of("Most Viewed Properties"),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: TabBar(
                    indicatorColor: hotPropertiesThemeColor,
                    labelColor: hotPropertiesThemeColor,
                    labelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    unselectedLabelColor: Colors.grey.shade600,
                    controller: controller.managePropertiesController,
                    onTap: (index) => controller.switchTabs(index),
                    tabs: [
                      _tab(AppLocalizations.of("Sale")),
                      _tab(AppLocalizations.of("Rental")),
                    ],
                  )),
              automaticallyImplyLeading: false,
            )
          ];
        },
        body: Obx(
          () => controller.mostViewLoder.isTrue
              ? Center(
                  child:
                      CircularProgressIndicator(color: hotPropertiesThemeColor),
                )
              : IndexedStack(
                  index: controller.currentIndex.value,
                  children: [
                    mostViewSaleTab(),
                    mostrentalTab(),
                    // SalePropertiesTab(),
                    // RentalPropertiesTab(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget mostrentalTab() {
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GetX<MostViewedController>(
          builder: (controller) {
            return ListView.builder(
              itemCount: controller.lstMostRentalPropertyModel.length,
              itemBuilder: (context, index) {
                // print(
                // "----- 12 ---- ${controller.lstMostRentalPropertyModel[0].imageGallery}");
                // print(
                // "----- 12 ---- ${controller.lstMostRentalPropertyModel[4].images}");

                // if (controller.lstMostRentalPropertyModel != null &&
                //     controller.lstMostRentalPropertyModel.length > 0) {
                //   for (var i = 0;
                //       i < controller.lstMostRentalPropertyModel.length;
                //       i++) {
                //     String imageName = "";
                //     List<String> aa = controller
                //         .lstMostRentalPropertyModel[i].imageGallery
                //         .split("~~");

                //     if (aa[0] != null && aa[0] != "") {
                //       controller.lstMostRentalPropertyModel[i].imageList = aa;
                //       imageName = aa[0];
                //       List<String> bb = aa[0].split("^^");
                //       if (bb[0] != null && bb[0] != "") {
                //         imageName = bb[0];
                //       }
                //     }
                //     controller.lstMostRentalPropertyModel[i].oneImage =
                //         imageName;
                // print(
                // "----- 12 ${controller.lstMostRentalPropertyModel[i].oneImage}");
                // }
                // }
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image(
                                image: CachedNetworkImageProvider(
                                    // "https://properbuz.bebuzee.com/gallery/main/" +
                                    controller.lstMostRentalPropertyModel[index]
                                        .images![0]
                                        .toString()),
                                fit: BoxFit.cover,
                                height: 90,
                                width: 90,
                              ),
                            ),
                          ),
                          Container(
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
                                    '${controller.lstMostRentalPropertyModel[index].propertyCode}'),
                                _customTextCard(
                                    AppLocalizations.of(
                                      "Property Name",
                                    ),
                                    '${controller.lstMostViewdPropertyModel[index].propertyTitle}'),
                                _customTextCard(
                                    AppLocalizations.of(
                                      "Property Type",
                                    ),
                                    "${controller.lstMostRentalPropertyModel[index].propertyType}"),
                                _customTextCard(
                                    AppLocalizations.of(
                                      "Listing Type",
                                    ),
                                    // "RENTAL"),
                                    "${controller.lstMostRentalPropertyModel[index].viewed}"),
                                _statusCard()
                              ],
                            ),
                          ),
                        ],
                      ),
                      _viewInsightsCard(context,
                          "${controller.lstMostViewdPropertyModel[index].propertyId}"),
                      _actionRow()
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget mostViewSaleTab() {
    return Container(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GetX<MostViewedController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.lstMostViewdPropertyModel.length,
              itemBuilder: (context, index) {
                if (controller.lstMostViewdPropertyModel != null &&
                    controller.lstMostViewdPropertyModel.length > 0) {
                  for (var i = 0;
                      i < controller.lstMostViewdPropertyModel.length;
                      i++) {
                    String imageName = "";
                    List<String> aa = controller
                        .lstMostViewdPropertyModel[i].imageGallery!
                        .split("~~");

                    if (aa[0] != null && aa[0] != "") {
                      controller.lstMostViewdPropertyModel[i].imageList = aa;
                      imageName = aa[0];
                      List<String> bb = aa[0].split("^^");
                      if (bb[0] != null && bb[0] != "") {
                        imageName = bb[0];
                      }
                    }
                    controller.lstMostViewdPropertyModel[i].oneImage =
                        imageName;
                    // print("---- ${controller.lstMostViewdPropertyModel[i].p}")
                  }
                }

                return Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image(
                                image: CachedNetworkImageProvider(
                                    // "https://properbuz.bebuzee.com/gallery/main/" +
                                    controller.lstMostViewdPropertyModel[index]
                                        .images![0]
                                        //.oneImage),

                                        .toString()),
                                fit: BoxFit.cover,
                                height: 90,
                                width: 90,
                              ),
                            ),
                          ),
                          Container(
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
                                    '${controller.lstMostViewdPropertyModel[index].propertyCode}'),
                                _customTextCard(
                                    AppLocalizations.of(
                                      "Property Name",
                                    ),
                                    '${controller.lstMostViewdPropertyModel[index].propertyTitle}'),
                                _customTextCard(
                                    AppLocalizations.of(
                                      "Property Type",
                                    ),
                                    "${controller.lstMostViewdPropertyModel[index].propertyType}"),
                                _customTextCard(
                                    AppLocalizations.of(
                                      "Listing Type",
                                    ),
                                    "SALE"),
                                // "${controller.lstMostViewdPropertyModel[index].listingType}"),
                                _statusCard()
                              ],
                            ),
                          ),
                        ],
                      ),
                      _viewInsightsCard(context,
                          "${controller.lstMostViewdPropertyModel[index].propertyId}"),
                      _actionRow()
                    ],
                  ),
                );
              },
            );
          })

          // Obx(
          //   () => ListView.builder(
          //     itemCount: controller.lstMostViewdPropertyModel.length,
          //     itemBuilder: (context, index) {
          //       if (controller.lstMostViewdPropertyModel != null && controller.lstMostViewdPropertyModel.length > 0) {
          //         for (var i = 0; i < controller.lstMostViewdPropertyModel.length; i++) {
          //           String imageName = "";
          //           List<String> aa = controller.lstMostViewdPropertyModel[i].imageGallery.split("~~");

          //           if (aa[0] != null && aa[0] != "") {
          //             controller.lstMostViewdPropertyModel[i].imageList = aa;
          //             imageName = aa[0];
          //             List<String> bb = aa[0].split("^^");
          //             if (bb[0] != null && bb[0] != "") {
          //               imageName = bb[0];
          //             }
          //           }
          //           controller.lstMostViewdPropertyModel[i].oneImage = imageName;
          //         }
          //       }

          //       return Container(
          //         padding: EdgeInsets.only(top: 20),
          //         child: Column(
          //           children: [
          //             Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Container(
          //                   padding: EdgeInsets.symmetric(horizontal: 15),
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(3),
          //                     child: Image(
          //                       image: CachedNetworkImageProvider(
          //                           "https://properbuz.bebuzee.com/gallery/main/" + controller.lstMostViewdPropertyModel[index].oneImage),
          //                       fit: BoxFit.cover,
          //                       height: 90,
          //                       width: 90,
          //                     ),
          //                   ),
          //                 ),
          //                 Container(
          //                   width: 100.0.w - 130,
          //                   padding: EdgeInsets.only(bottom: 15),
          //                   color: Colors.transparent,
          //                   margin: EdgeInsets.only(right: 10),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       _customTextCard(
          //                           AppLocalizations.of(
          //                             "Property Code",
          //                           ),
          //                           '${controller.lstMostViewdPropertyModel[index].propertyCode}'),
          //                       _customTextCard(
          //                           AppLocalizations.of(
          //                             "Property Name",
          //                           ),
          //                           "null"),
          //                       _customTextCard(
          //                           AppLocalizations.of(
          //                             "Property Type",
          //                           ),
          //                           "${controller.lstMostViewdPropertyModel[index].propertyType}"),
          //                       _customTextCard(
          //                           AppLocalizations.of(
          //                             "Listing Type",
          //                           ),
          //                           "${controller.lstMostViewdPropertyModel[index].listingType}"),
          //                       _statusCard()
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             _viewInsightsCard(context),
          //             _actionRow()
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
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

  Widget _actionRow() {
    return Row(
      children: [
        _customTextButton(
            AppLocalizations.of(
              "Upgrade",
            ),
            Colors.white,
            hotPropertiesThemeColor, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PremiumPackageView()));
        }),
        _customTextButton(
            AppLocalizations.of(
              "Edit",
            ),
            hotPropertiesThemeColor,
            Colors.grey.shade200, () {
          print(
              "----- 12 ---- ${controller.lstMostRentalPropertyModel[0].imageGallery}");
        }),
      ],
    );
  }

  Widget _viewInsightsCard(BuildContext context, String pid) {
    return GestureDetector(
      onTap: () {
        print("----- $pid");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InsightsView(id: pid),
          ),
        );
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

  Widget _customTextCard(String title, String value) {
    return Container(
      padding: EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text(
            title + ": ",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          Container(
            // color: Colors.pink,
            width: 40.0.w,
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
}
