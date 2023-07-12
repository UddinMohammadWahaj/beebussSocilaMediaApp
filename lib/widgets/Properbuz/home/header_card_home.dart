import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';

class HeaderCardHome extends GetView<ProperbuzController> {
  HeaderCardHome({Key? key}) : super(key: key);

  PropertiesController ctr = Get.put(PropertiesController());

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(
            "Global Real Estate Social Network",
          ),
          style: Theme.of(context).textTheme.overline!.merge(TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(
            "Find your ideal home",
          ),
          style: Theme.of(context).textTheme.overline!.merge(TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }

  Widget _tab(String name, BuildContext context, var index) {
    return GestureDetector(
      child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            name,
            style: Theme.of(context).textTheme.button!.merge(TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: index == controller.tabIndex.value
                    ? Colors.black
                    : Colors.white)),
          )),
    );
  }

  Widget _categoryBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 25),
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: 100.0.w,
      child: Obx(
        () => CupertinoSlidingSegmentedControl(
            groupValue: controller.tabIndex.value,
            backgroundColor: hotPropertiesThemeColor,
            children: <int, Widget>{
              0: _tab(
                  AppLocalizations.of(
                    "For Sale",
                  ),
                  context,
                  0),
              1: _tab(
                  AppLocalizations.of(
                    "To Rent",
                  ),
                  context,
                  1),
              2: _tab(AppLocalizations.of("New Homes"), context, 2),
            },
            onValueChanged: (index) {
              controller.switchTabs(index);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => (ProperbuzController()), fenix: true);
    return _categoryBar(context);
  }
}
