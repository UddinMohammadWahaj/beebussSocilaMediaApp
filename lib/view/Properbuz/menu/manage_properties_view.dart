import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Language/appLocalization.dart';
import 'manage_properties/rental_properties_tab.dart';
import 'manage_properties/sale_properties_tab.dart';

class ManagePropertiesView extends StatefulWidget {
  const ManagePropertiesView({Key? key}) : super(key: key);

  @override
  _ManagePropertiesViewState createState() => _ManagePropertiesViewState();
}

class _ManagePropertiesViewState extends State<ManagePropertiesView>
    with TickerProviderStateMixin {
  UserPropertiesController controller = Get.put(UserPropertiesController());

  Widget _tab(String tabTitle) {
    return Tab(
      text: tabTitle.toUpperCase(),
    );
  }

  @override
  void initState() {
    controller.managePropertiesController = new TabController(
        vsync: this, length: 2, initialIndex: controller.currentIndex.value);
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
                  Get.delete<UserPropertiesController>();
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
                AppLocalizations.of("Manage Properties"),
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
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              SalePropertiesTab(),
              RentalPropertiesTab(),
            ],
          ),
        ),
      ),
    );
  }
}
