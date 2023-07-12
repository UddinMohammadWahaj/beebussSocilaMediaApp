import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/TradsMen_controller.dart';
import 'package:bizbultest/services/Properbuz/add_tradesman_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_tradesmen_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FindTradesmenLocationSearchPage extends GetView<TradsmenController> {
  TradsmenController ctr = Get.put(TradsmenController());
  String countryName;
  StateSetter setState;
  FindTradesmenLocationSearchPage(this.countryName, this.setState, {Key? key})
      : super(key: key);

  _customErrorTextCard(String text, String title, IconData icon, Color color) {
    Get.showSnackbar(GetBar(
      title: title,
      icon: Icon(
        icon,
        color: color,
      ),
      forwardAnimationCurve: Curves.bounceIn,
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 2),
      borderRadius: 20,
      duration: Duration(seconds: 2),
      messageText: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ));
  }

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
          color: settingsColor,
          width: 1,
        ),
      ),
      child: TextFormField(
        onChanged: (val) {
          ctr.message.value = val;
          // ctr.locationFieldController.text = val;
        },
        onTap: (() {
          setState(() {
            controller.currentCountry.value == ""
                ? _customErrorTextCard(
                    "Select Country", "Error", Icons.error, Colors.red)
                : ctr.locationFieldController.clear();
          });
        }),
        maxLines: 1,
        readOnly: controller.currentCountry.value == "" ? true : false,
        cursorColor: Colors.white,
        controller: ctr.locationFieldController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
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
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ),
    );
  }

  Widget _locationCard(int index, BuildContext context) {
    return ListTile(
      minLeadingWidth: 5,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      onTap: () {
        setState((() {
          controller.message.value = controller.locations[index]['area'];
          controller.newlocationFieldController.text = controller.message.value;
          controller.locationFieldController.clear();
          controller.locationFieldController.text =
              controller.newlocationFieldController.text;
        }));

        // Navigator.of(context).pop(controller.message.value);
      },
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
    return Container(
      alignment: Alignment.topCenter,

      child: Text(
        "No places found",
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0.sp),
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TradsmenController());
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PreferredSize(
                  preferredSize: Size.fromHeight(60), child: _locationField()),

              Obx(
                () => Container(
                  height: 250.0,
                  width: 350.0,
                  child: controller.isLocationLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey.shade400)))
                      : Container(
                          height: 250.0,
                          width: 350.0,
                          child: controller.locations.length == 0 &&
                                  controller.locationFieldController.value.text
                                      .isNotEmpty
                              ? _noLocationCard()
                              : ListView.builder(
                                  itemCount: controller.locations.length,
                                  itemBuilder: (context, index) {
                                    return _locationCard(index, context);
                                  }),
                        ),
                ),
              ),
              // ),
              // );
            ],
          ),
        ));
    // child:
  }
}
