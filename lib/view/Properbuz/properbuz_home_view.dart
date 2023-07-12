import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/common_appbar.dart';
import 'package:bizbultest/utilities/custom_appbar.dart';
import 'package:bizbultest/widgets/Properbuz/AddedLocation/RecentlyAddedLocation.dart';
import 'package:bizbultest/widgets/Properbuz/PropertiesSearchedbyCity/PropertiesSearched.dart';
import 'package:bizbultest/widgets/Properbuz/home/calculator_card_home.dart';
import 'package:bizbultest/widgets/Properbuz/home/header_card_home.dart';
import 'package:bizbultest/widgets/Properbuz/home/property_card_home.dart';
import 'package:bizbultest/widgets/Properbuz/reviews/review_card_home.dart';
import 'package:bizbultest/widgets/Properbuz/home/search_card_home.dart';
import 'package:bizbultest/widgets/Properbuz/location/location_categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProperbuzHomeView extends GetView<ProperbuzController> {
  final Function? setNavbar;
  final Function? changeColor;
  final Function? isChannelOpen;
  StateSetter? setstate;
  ProperbuzHomeView(
      {Key? key,
      this.setNavbar,
      this.changeColor,
      this.isChannelOpen,
      this.setstate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => (ProperbuzController()), fenix: true);
    return Container(
      child: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          child: Column(
            children: [
              HeaderCardHome(),
              SearchCardHome(setState),
              CalculatorCardHome(),
              LocationCategories(),
              RecentlyAddLocation(),
              PropertiesSearched(),
              //ReviewCardHome(),
            ],
          ),
        ),
      ),
    );
  }
}
