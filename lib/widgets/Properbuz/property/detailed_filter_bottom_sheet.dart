import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DetailedFilterBottomSheet extends GetView<PropertiesController> {
  final int filterType;
  final String title;

  const DetailedFilterBottomSheet({
    Key? key,
    required this.filterType,
    required this.title,
  }) : super(key: key);

  Widget _appBarTitle() {
    return Container(
      color: Colors.white,
      height: 56,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 0),
          splashRadius: 20,
          icon: Icon(
            Icons.close,
            size: 28,
            color: Colors.grey.shade600,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Container(
            child: Text(
          AppLocalizations.of(title),
          style: TextStyle(
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700),
        )),
      ),
    );
  }

  Widget _customListCard(String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
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
          color: Colors.grey.shade400,
          width: 1,
        ),
      ),
      child: TextFormField(
        onChanged: (val) {
          controller.selectedLocation.value = val;
        },
        maxLines: 1,
        cursorColor: Colors.white,
        controller: controller.locationFieldController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(
            AppLocalizations.of("location") +
                " in ${controller.selectedCountry.value}",
          ),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _filterItem() {
    switch (filterType) {
      case 1:
        return ListView.builder(
            itemCount: controller.countriesList.length,
            itemBuilder: (context, index) {
              return _customListCard(controller.countriesList[index].country!,
                  () {
                controller.selectedCountry.value =
                    controller.countriesList[index].country!;
                controller.selectedCountryID.value =
                    controller.countriesList[index].countryId!;
                controller.locationFieldController.clear();
                controller.selectedLocation.value = "";
                Get.back();
              });
            });
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Obx(
          () => ListView.builder(
              itemCount: controller.minPricesList.length,
              itemBuilder: (context, index) {
                return _customListCard(
                    controller.minPricesList[index].toString(), () {
                  controller.minPrice.value =
                      controller.minPricesList[index].toString();
                  Get.back();
                });
              }),
        );
        break;
      case 4:
        return Obx(
          () => ListView.builder(
              itemCount: controller.maxPricesList.length,
              itemBuilder: (context, index) {
                return _customListCard(
                    controller.maxPricesList[index].toString(), () {
                  controller.maxPrice.value =
                      controller.maxPricesList[index].toString();
                  Get.back();
                });
              }),
        );
        break;
      case 5:
        return ListView.builder(
            itemCount: controller.bedrooms.length,
            itemBuilder: (context, index) {
              return _customListCard(controller.bedrooms[index]['bedroom'], () {
                controller.rooms.value = controller.bedrooms[index]['bedroom'];
                Get.back();
              });
            });
        break;
      case 6:
        return ListView.builder(
            itemCount: controller.propertyTypesList.length,
            itemBuilder: (context, index) {
              return _customListCard(
                  controller.propertyTypesList[index].propertyType!, () {
                controller.propertyType.value =
                    controller.propertyTypesList[index].propertyType!;
                controller.selectedPropertyTypeID.value =
                    controller.propertyTypesList[index].propertyTypeId!;
                Get.back();
              });
            });
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: hotPropertiesThemeColor,
        elevation: 0,
        brightness: Brightness.dark,
        title: _appBarTitle(),
      ),
      body: _filterItem(),
    );
  }
}
