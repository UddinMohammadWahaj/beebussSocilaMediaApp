import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/searc_by_map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:ui' as ui;

import '../../../Language/appLocalization.dart';

class SearchByMapEntry extends GetView<SearchByMapController> {
  var textColor = HexColor("#727a85");
  var textBgColor = HexColor("#f5f7f6");

  // SearchByMapEntry(String  PageFrom);

  Widget _customTextField(
      TextEditingController textEditingController, String labelText) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container(
          //     padding: EdgeInsets.symmetric(vertical: 5),
          //     child: Text(
          //       labelText,
          //       style: TextStyle(fontSize: 15, color: textColor),
          //     )),
          Text(
            AppLocalizations.of('Search By Map'),
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'SpecialElite',
                fontSize: 25,
                fontWeight: FontWeight.normal),
          )

          // Container(
          //   margin: EdgeInsets.only(bottom: 10),
          //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   height: 45,
          //   decoration: new BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: BorderRadius.all(Radius.circular(5)),
          //     shape: BoxShape.rectangle,
          //   ),
          //   child:

          //   TextFormField(
          //     textAlign: TextAlign.center,
          //     cursorColor: textColor,
          //     autofocus: false,
          //     controller: textEditingController,
          //     maxLines: 1,
          //     keyboardType: TextInputType.text,
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 14,
          //         fontWeight: FontWeight.normal),
          //     decoration: InputDecoration(
          //       hintText: "Enter municipaluty,area or metro",
          //       hintTextDirection: TextDirection.ltr,
          //       hintStyle:
          //           TextStyle(fontSize: 17, decoration: TextDecoration.none),
          //       contentPadding: EdgeInsets.all(10),
          //       border: InputBorder.none,

          //       focusedBorder: InputBorder.none,
          //       enabledBorder: InputBorder.none,
          //       errorBorder: InputBorder.none,
          //       disabledBorder: InputBorder.none,
          //       // 48 -> icon width
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget _customListTile(
        String title, String subtitle, Icon icon, VoidCallback onTap) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Card(
          child: ListTile(
            onTap: onTap,
            contentPadding: EdgeInsets.all(10),
            leading: icon,
            title: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: Colors.grey, fontSize: 17),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: hotPropertiesThemeColor,
        toolbarHeight: kToolbarHeight * 1.2,
        title: Text(
          AppLocalizations.of('Search By Map'),
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'SpecialElite',
              fontSize: 25,
              fontWeight: FontWeight.normal),
        ),
        // _customTextField(TextEditingController(), ''),
        actions: [],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            _customListTile(
                AppLocalizations.of('Search') +
                    ' ' +
                    AppLocalizations.of('By') +
                    ' ' +
                    AppLocalizations.of('Name'),
                AppLocalizations.of('Search by province') +
                    ' , ' +
                    AppLocalizations.of('municipality area of metro'),
                Icon(
                  Icons.text_fields,
                  color: hotPropertiesThemeColor,
                  size: 40,
                ), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchByMapView(
                            maptype: MapSearchType.searchByName,
                          )));
            }),
            Divider(
              height: 5,
            ),
            _customListTile(
                AppLocalizations.of('Draw') +
                    ' ' +
                    AppLocalizations.of('area') +
                    ' ' +
                    AppLocalizations.of('on') +
                    ' ' +
                    AppLocalizations.of('map'),
                AppLocalizations.of(
                    'Draw the area on map where you want to search'),
                Icon(Icons.brush, color: hotPropertiesThemeColor, size: 40),
                () {
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                    builder: (context) => SearchByMapView(
                          maptype: MapSearchType.searchByDraw,
                        )),
              );
            }),
            _customListTile(
                AppLocalizations.of('Search') +
                    ' ' +
                    AppLocalizations.of('By') +
                    ' ' +
                    AppLocalizations.of('Metro'),
                AppLocalizations.of('Look near one or more metro stations'),
                Icon(Icons.directions_railway_filled,
                    color: hotPropertiesThemeColor, size: 40), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchByMapView(
                      maptype: MapSearchType.searchByMetro,
                    ),
                  ));
            }),
          ],
        ),
        height: Get.size.height,
        width: Get.size.width,
      ),
    );
  }
}
