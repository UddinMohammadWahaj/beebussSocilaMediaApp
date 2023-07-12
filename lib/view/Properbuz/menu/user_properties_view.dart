import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/menu/user_properties/alert_properties_tab.dart';
import 'package:bizbultest/view/Properbuz/menu/user_properties/location_reviews_tab.dart';
import 'package:bizbultest/view/Properbuz/menu/user_properties/saved_properties_tab.dart';
import 'package:bizbultest/view/Properbuz/menu/user_properties/searched_properties_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class UserPropertiesView extends StatefulWidget {
  final int? index;
  const UserPropertiesView({Key? key, this.index}) : super(key: key);

  @override
  _UserPropertiesViewState createState() => _UserPropertiesViewState();
}

class _UserPropertiesViewState extends State<UserPropertiesView>
    with TickerProviderStateMixin {
  PropertiesController controller = Get.put(PropertiesController());

  Widget _tab(String tabTitle) {
    return Tab(
      text: tabTitle.toUpperCase(),
    );
  }

  @override
  void initState() {
    controller.getSavedProperties();
    controller.getAlertProperties();
    controller.currentIndex.value = widget.index!;
    controller.userPropertiesController = new TabController(
        vsync: this, length: 4, initialIndex: controller.currentIndex.value);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<UserPropertiesController>();
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
                AppLocalizations.of(
                  "Your Properties",
                ),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: TabBar(
                    indicatorColor: hotPropertiesThemeColor,
                    labelColor: hotPropertiesThemeColor,
                    labelStyle: TextStyle(
                        fontSize: 10.0.sp, fontWeight: FontWeight.w500),
                    unselectedLabelColor: Colors.grey.shade600,
                    controller: controller.userPropertiesController,
                    onTap: (index) => controller.switchUserPropertyTabs(index),
                    tabs: [
                      _tab(
                        AppLocalizations.of("Searched"),
                      ),
                      _tab(
                        AppLocalizations.of("Saved"),
                      ),
                      _tab(
                        AppLocalizations.of("Alerts"),
                      ),
                      _tab(
                        AppLocalizations.of("Reviews"),
                      ),
                    ],
                  )),
              automaticallyImplyLeading: false,
            )
          ];
        },
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              SearchedPropertiesTab(),
              SavedPropertiesTab(),
              AlertPropertiesTab(),
              // LocationReviewsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
