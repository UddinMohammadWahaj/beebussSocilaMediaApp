import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/property/filter_bottom_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/property/property_card.dart';
import 'package:bizbultest/widgets/Properbuz/property/sort_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../services/Properbuz/search_property_sort_widget.dart';
import '../../../widgets/Properbuz/utils/header_footer.dart';

class SearchedPropertiesView extends StatefulWidget {
  final String? location;
  final String? locationId;
  const SearchedPropertiesView({Key? key, this.location, this.locationId})
      : super(key: key);

  @override
  State<SearchedPropertiesView> createState() => _SearchedPropertiesViewState();
}

class _SearchedPropertiesViewState extends State<SearchedPropertiesView> {
  PropertiesController controller = Get.put(PropertiesController());

  Widget _appBarTitle(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
                width: 100.0.w - 80,
                decoration: new BoxDecoration(
                  color: hotPropertiesThemeLightColor,
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
                      AppLocalizations.of(
                        widget.location!,
                      ),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      AppLocalizations.of("Home") +
                          " - " +
                          AppLocalizations.of("Apartment") +
                          " " +
                          AppLocalizations.of("For Sale"),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                )),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
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
                  child: Icon(icon, size: 25, color: hotPropertiesThemeColor)),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    color: hotPropertiesThemeColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
    );
  }

  Widget _settingsRow() {
    return Container(
      height: 57,
      color: Colors.white,
      child: Row(
        children: [
          _settingsCard(
              AppLocalizations.of(
                "FILTERS",
              ),
              CustomIcons.filter, () {
            Get.bottomSheet(FilterPropertyBottomSheet(index: 0, val: 0),
                enableDrag: false,
                isScrollControlled: true,
                ignoreSafeArea: false,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))));
          }),
          _settingsCard(
              AppLocalizations.of(
                "SORT BY",
              ),
              CustomIcons.sort, () {
            Get.bottomSheet(
              SearchSortPropertyBottomSheet(),
              isScrollControlled: true,
              ignoreSafeArea: false,
              backgroundColor: Colors.white,
            );
          }),
        ],
      ),
    );
  }

  Widget _noPropertiesCard() {
    return Center(
      child: Container(
        child: Text(
          AppLocalizations.of("No properties found"),
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0.sp),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller.getSearchedProperties();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PropertiesController>();
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
                backgroundColor: hotPropertiesThemeColor,
                title: _appBarTitle(context),
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(57), child: _settingsRow()),
                automaticallyImplyLeading: false,
              )
            ];
          },
          body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Obx(
              () => Container(
                child: controller.isLoadingSearch.isTrue
                    ? Center(
                        child: CircularProgressIndicator(
                            color: hotPropertiesThemeColor),
                      )
                    : Container(
                        child: controller.searchedProperties.length == 0
                            ? _noPropertiesCard()
                            : SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                header: customHeader(),
                                footer: customFooter(),
                                controller: controller.refreshController,
                                onRefresh: () =>
                                    controller.propertSearchRefreshData(),
                                onLoading: () =>
                                    controller.propertSearchLoadMoreData(),
                                child: ListView.builder(
                                    itemCount:
                                        controller.searchedProperties.length,
                                    itemBuilder: (context, index) {
                                      return PropertyCard(
                                        val: 3,
                                        index: index,
                                      );
                                    }),
                              ),
                      ),
              ),
            ),
          ),
        ));
  }
}
