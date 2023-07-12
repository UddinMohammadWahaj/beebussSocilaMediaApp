import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/user.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/services/Properbuz/properbuz_menu_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/MostViewedProperties/mostViewd_properties.dart';
import 'package:bizbultest/view/Properbuz/saved_posts_view.dart';
import 'package:bizbultest/view/Properbuz/user_posts_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../edit_profile_page.dart';
import 'menu/featured_property_analytics.dart';
import 'menu/manage_properties_view.dart';
import 'menu/manage_tradesman_view.dart';
import 'menu/manage_tradesmen_selection.dart';
import 'menu/premium_package_view.dart';
import 'menu/property_guides_view.dart';
import 'menu/user_properties_view.dart';

class ProperbuzMenuView extends GetView<ProperbuzMenuController> {
  const ProperbuzMenuView({Key? key}) : super(key: key);

  Widget _customTimeCard(String value, VoidCallback onTap, bool showBorder) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: showBorder
            ? Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              )
            : null,
      ),
      child: ListTile(
        // tileColor: hotPropertiesThemeColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        onTap: onTap,
        title: Text(
          value,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          size: 22,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzMenuController());
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _customTimeCard(
                AppLocalizations.of("Saved") +
                    " " +
                    AppLocalizations.of("Posts"),
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedPostsView())),
                true),
            _customTimeCard(
                AppLocalizations.of("Your") +
                    " " +
                    AppLocalizations.of("Activities"),
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserPostsView())),
                true),
            _customTimeCard(
                AppLocalizations.of(
                  "Premium Package",
                ),
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PremiumPackageView())),
                true),
            _customTimeCard(
                AppLocalizations.of(
                  "Searched Properties",
                ),
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPropertiesView(
                              index: 0,
                            ))),
                true),

            _customTimeCard(
                AppLocalizations.of(
                  "Saved Properties",
                ),
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPropertiesView(
                              index: 1,
                            ))),
                true),
            _customTimeCard(
                AppLocalizations.of(
                  "Alerts",
                ),
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPropertiesView(
                              index: 2,
                            ))),
                true),
            // _customTimeCard(
            //     AppLocalizations.of(
            //       "Location Reviews",
            //     ),
            //     () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => UserPropertiesView(
            //               index: 3,
            //             ),
            //           ),
            //         ),
            //     true),
            _customTimeCard(
                AppLocalizations.of(
                  "Manage Properties",
                ),
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManagePropertiesView())),
                true),
            _customTimeCard(
                AppLocalizations.of(
                  "Most Viewed Properties",
                ), () async {
              String memberId = CurrentUser().currentUser.memberID!;

              UserDetailModel objUserDetailModel =
                  await ApiProvider().getUserDetail(memberId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MostViewdProperties(),
                  ));
              return;

              if (objUserDetailModel != null &&
                  objUserDetailModel.memebertype != null &&
                  objUserDetailModel.memebertype == "0") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MostViewdProperties(),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                    msg: AppLocalizations.of("User not an Estate Agent"));
              }
            }, true),
            _customTimeCard(
                AppLocalizations.of(
                  "Featured Property Analytics",
                ),
                () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeaturedPropertyAnalytics(),
                      ),
                    ),
                true),
            _customTimeCard(
                AppLocalizations.of(
                  "Property Buying Guides",
                ),
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PropertyGuidesView())),
                false),
          ],
        ),
      ),
    );
  }
}
