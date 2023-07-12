import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/property_buying_guide_model.dart';
import 'package:bizbultest/services/Properbuz/property_guides_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/menu/user_properties/readmore.dart';
import 'package:bizbultest/widgets/Properbuz/menu/buying_guide/guide_blog_card.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class PropertyGuidesView extends StatefulWidget {
  const PropertyGuidesView({Key? key}) : super(key: key);

  @override
  _PropertyGuidesViewState createState() => _PropertyGuidesViewState();
}

class _PropertyGuidesViewState extends State<PropertyGuidesView> {
  PropertyGuidesController controller = Get.put(PropertyGuidesController());

  bool isLoading = false;
  bool real = true;
  bool finance = false;
  bool international = false;
  bool country = false;
  bool travel = false;

  Widget _filterHeader() {
    return Container(
        width: 15.w,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          AppLocalizations.of("Filter") +
              " " +
              AppLocalizations.of("by") +
              " :",
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ));
  }

  Widget _filterCard(int index) {
    return GestureDetector(
      onTap: () => controller.selectFilter(index),
      child: Obx(
        () => Container(
            margin: EdgeInsets.only(
                left: index == 0 ? 0 : 5,
                right: index == controller.filterList.length - 1 ? 10 : 0),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: new BoxDecoration(
              color: controller.filterList[index].selected.value
                  ? hotPropertiesThemeColor
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              shape: BoxShape.rectangle,
              border: new Border.all(
                color: hotPropertiesThemeColor,
                width: 1,
              ),
            ),
            child: Container(
              child: Text(
                AppLocalizations.of("${controller.filterList[index].filter}"),
                style: TextStyle(
                    color: !controller.filterList[index].selected.value
                        ? hotPropertiesThemeColor
                        : Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            )),
      ),
    );
  }

  Widget _filterListBuilder() {
    return Container(
      width: 85.0.w,
      height: 35,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.filterList.length,
          itemBuilder: (context, index) {
            return _filterCard(index);
          }),
    );
  }

  Widget _filterRow() {
    return Container(
      height: 72,
      decoration: new BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        children: [
          _filterHeader(),
          _filterListBuilder(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<PropertyGuidesController>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                AppLocalizations.of(
                  "Latest Stories",
                ),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(72), child: _filterRow()),
              automaticallyImplyLeading: false,
            )
          ];
        },
        body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Obx(
              () => controller.belogLoding.isTrue
                  ? Center(
                      child: CircularProgressIndicator(
                      color: hotPropertiesThemeColor,
                    ))
                  : controller.blogsList.length == 0
                      ? Center(
                          child: Text(AppLocalizations.of(
                              "No Latest Stroies available yet..!!")))
                      : SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: customHeader(),
                          footer: customFooter(),
                          controller: controller.refreshController,
                          onRefresh: () => controller.refreshData(),
                          onLoading: () => controller.loadMoreData(),
                          child: ListView.builder(
                            itemCount: controller.blogsList.length,
                            itemBuilder: (context, index) {
                              return GuideBlogCard(
                                index: index,
                              );
                            },
                          ),
                        ),
            )),
      ),
    );
  }
}
