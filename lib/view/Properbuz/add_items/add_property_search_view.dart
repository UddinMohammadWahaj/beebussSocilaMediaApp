import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/add_property_controller.dart';
import 'package:bizbultest/services/Properbuz/api/edit_property_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'add_New_tradesmen_view.dart';

class LocationSearchPageAdd extends GetView<AddPropertyController> {
  String? page;
  LocationSearchPageAdd({Key? key, this.page}) : super(key: key);

  Widget _locationField() {
    return Container(
      height: 50,
      width: 100.0.w,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: TextFormField(
        onChanged: (val) {
          // page == "Tradesmen" ?
          // message = val;
          //  : controller.message.value = "";
          controller.message.value = val;
        },
        maxLines: 1,
        cursorColor: Colors.white,
        controller: controller.propertyLocation,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(
            "Enter any location",
          ),
          hintStyle: TextStyle(color: Colors.grey.shade200, fontSize: 16),
        ),
      ),
    );
  }

  Widget _locationCard(int index, BuildContext context) {
    return ListTile(
      minLeadingWidth: 5,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      onTap: () => controller.setLocation(controller.locations[index]['area'],
          controller.locations[index]['area_id'], context),
      leading: Icon(
        CupertinoIcons.location_solid,
        color: Colors.grey.shade700,
      ),
      title: Text(
        controller.locations[index]['area'],
        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _noLocationCard() {
    return Center(
      child: Container(
        child: Text(
          "No places found",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AddPropertyController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: hotPropertiesThemeColor,
        brightness: Brightness.dark,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Obx(
          () => Text(
            "Search in ${controller.currentCountry.value}",
            style: TextStyle(
                fontSize: 14.0.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(50), child: _locationField()),
      ),
      body: Obx(
        () => Container(
          child: controller.isLocationLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey.shade400)))
              : Container(
                  child: controller.locations.length == 0 &&
                          controller.propertyLocation.text.isNotEmpty
                      ? _noLocationCard()
                      : ListView.builder(
                          itemCount: controller.locations.length,
                          itemBuilder: (context, index) {
                            return _locationCard(index, context);
                          }),
                ),
        ),
      ),
    );
  }
}
