import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/hot_properties_view.dart';
import 'package:bizbultest/view/Properbuz/searc_by_map_view.dart';
import 'package:bizbultest/view/Properbuz/travel_time_search_view.dart';
import 'package:bizbultest/widgets/Properbuz/GoogleMap/searchbymapentrywidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class PropertyCardHome extends GetView<ProperbuzController> {
  const PropertyCardHome({Key? key}) : super(key: key);

  Widget _header() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(
                "Filter Properties",
              ),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              CupertinoIcons.house_alt,
              color: Colors.black,
            )
          ],
        ));
  }

  Widget _imageAsset() {
    return Image.asset(
      "assets/images/add_property.png",
      height: 40,
      width: 40,
    );
  }

  Widget _startButton() {
    return Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle,
          color: HexColor("#4b5869"),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          AppLocalizations.of(
            "Start Here",
          ),
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        ));
  }

  Widget _addPropertyTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      leading: _imageAsset(),
      title: Text(
        AppLocalizations.of(
          "Add a property for free",
        ),
        style: TextStyle(fontSize: 11.0.sp, fontWeight: FontWeight.w500),
      ),
      trailing: _startButton(),
    );
  }

  Widget _filterPropertyCard(String value, String assetPath, double leftPadding,
      double rightPadding, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.only(left: leftPadding, right: rightPadding),
        width: 175,
        child: Column(
          children: [
            Image.asset(
              assetPath,
              height: 35,
              width: 35,
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: hotPropertiesThemeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPropertyBuilder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_header(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterPropertyCard(
                  AppLocalizations.of(
                    "Hot Properties",
                  ),
                  "assets/images/hot_properties_1.png",
                  15,
                  0, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotPropertiesView()));
              }),
              _filterPropertyCard(
                  AppLocalizations.of(
                    "Search By Map",
                  ),
                  "assets/images/search_bymap_1.png",
                  15,
                  0, () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchByMapEntry(),
                ));
              }),
              _filterPropertyCard(
                  AppLocalizations.of(
                    "Travel Time Search",
                  ),
                  "assets/images/travel_search_1.png",
                  15,
                  15, () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => TravelTimeSearchView()));
              })
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => (ProperbuzController()), fenix: true);
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          // _addPropertyTile(),
          _filterPropertyBuilder(context)
        ],
      ),
    );
  }
}
