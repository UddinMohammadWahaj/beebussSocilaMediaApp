import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/add_items_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_New_tradesmen_view.dart';
import 'package:bizbultest/view/Properbuz/find_tradsemen_view.dart';
import 'package:bizbultest/view/Properbuz/menu/manage_tradesmen_selection.dart';
import 'package:bizbultest/view/Properbuz/request_tradesmen.dart';
import 'package:bizbultest/view/Properbuz/request_tradesmen_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'newfindtradesmen.dart';

// import 'add_items/add_property_view.dart';
// import 'add_items/add_solo_tradesmen.dart';
// import 'add_items/add_tradesman_existing_company.dart';
// import 'add_items/add_tradesmen_view.dart';
// import 'add_items/add_virtual_tour_view.dart';
// import 'add_items/detailed_add_tradesmen_view.dart';
// import 'add_items/upload_xml_view.dart';
// import 'add_items/write_review_view.dart';

class TradesmanPageView extends GetView<AddItemsController> {
  const TradesmanPageView({Key? key}) : super(key: key);

  Widget _customAddListTile(
      String title, IconData icon, VoidCallback onTap, BorderStyle style) {
    final double statusBarHeight =
        MediaQueryData.fromWindow(window).padding.top;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100.0.w,
        height: (100.0.h - (56 + 55 + statusBarHeight)) / 5,
        color: Colors.white,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey.shade300, width: 1, style: style),
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: controller.settingsColor,
                size: 35,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: controller.settingsColor,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AddItemsController());
    return Container(child: NewFindTradsmenView()

        //  Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     _customAddListTile(
        //         AppLocalizations.of(
        //           "Find Tradesmen",
        //         ),
        //         CustomIcons.search__1_,
        //         () => Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => FindTradsmenView(),
        //               //  WriteLocationReviewView(),
        //             )),
        //         BorderStyle.solid),
        //     _customAddListTile(
        //         AppLocalizations.of("Add") +
        //             " " +
        //             AppLocalizations.of("Tradesmen"),
        //         CustomIcons.employee,
        //         () => Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => CurrentUser()
        //                             .currentUser
        //                             .tradesmanType
        //                             .toLowerCase() ==
        //                         'solo'
        //                     ? SoloTradesmenView("solo", "0", [])
        //                     : CurrentUser()
        //                                 .currentUser
        //                                 .tradesmanType
        //                                 .toLowerCase() ==
        //                             'company'
        //                         ? AddNewTradesmenView("company", [])
        //                         : Container()

        //                 // ExitingCompanyView(),
        //                 // AddTradesmenView(null)
        //                 )),
        //         BorderStyle.solid),
        //     _customAddListTile(
        //         AppLocalizations.of(
        //           "Manage Tradesmen",
        //         ),
        //         CustomIcons.manager,
        //         () => Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => ChoicePageView(),
        //               //  WriteLocationReviewView(),
        //             )),
        //         BorderStyle.solid),
        //     _customAddListTile(
        //         AppLocalizations.of(
        //           "Requested Tradesmen",
        //         ),
        //         CustomIcons.rebuzz,
        //         () => Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => RequestTradesmenView(),
        //               //  WriteLocationReviewView(),
        //             )),
        //         BorderStyle.none)
        //   ],
        // ),
        );
  }
}
