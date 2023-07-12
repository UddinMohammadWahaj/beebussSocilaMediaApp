import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BuzzFeedLocation extends StatefulWidget {
  const BuzzFeedLocation({Key? key, BuzzerfeedController? controller})
      : super(key: key);

  @override
  State<BuzzFeedLocation> createState() => _BuzzFeedLocationState();
}

class _BuzzFeedLocationState extends State<BuzzFeedLocation> {
  var controller = Get.find<BuzzerfeedController>();
  Widget _locationField() {
    return Column(
      children: [
        Container(
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
              controller.message.value = val;
              print("message=${controller.message.value}");
            },
            maxLines: 1,
            cursorColor: Colors.black,
            controller: controller.userLocation,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: Colors.black, fontSize: 16),
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
              hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
        ),
        selectedLocationCard(),
      ],
    );
  }

  Widget selectedLocationCard() {
    return Obx(
      () => controller.currentCity.value == ''
          ? Container()
          : ListTile(
              minLeadingWidth: 5,
              tileColor: Colors.black,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              onTap: () {
                // controller.locationselected.value = !controller.locationselected.value;
                // controller.currentCity.value = controller.locations[index];
                // Navigator.of(context).pop();
              },
              leading: Icon(
                CupertinoIcons.location_solid,
                color: Colors.white,
              ),
              trailing: IconButton(
                  onPressed: () {
                    controller.locationselected.value = false;
                    controller.currentCity.value = '';
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
              title: Text(
                AppLocalizations.of(controller.currentCity.value),
                style: TextStyle(fontSize: 15, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
  }

  Widget _locationCard(int index, BuildContext context) {
    return ListTile(
      minLeadingWidth: 5,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      onTap: () {
        controller.locationselected.value = !controller.locationselected.value;
        controller.currentCity.value = controller.locations[index];
        Navigator.of(context).pop();
      },
      leading: Icon(
        CupertinoIcons.location_solid,
        color: Colors.grey.shade700,
      ),
      title: Text(
        AppLocalizations.of(controller.locations[index]),
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
          AppLocalizations.of("No places found"),
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.dark,
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
        centerTitle: true,
        title: Text(
          AppLocalizations.of("Tag location"),
          style: TextStyle(
              fontSize: 14.0.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(12.0.h), child: _locationField()),
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
                  child: controller.locations.length == 0
                      // &&
                      // controller.propertyLocation.text.isNotEmpty
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
