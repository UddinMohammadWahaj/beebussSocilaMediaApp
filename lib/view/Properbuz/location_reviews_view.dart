import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/location_reviews_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/add_items/write_review_view.dart';
import 'package:bizbultest/view/Properbuz/general_location_reviews_view.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

class SearchLocationReviews extends GetView<ProperbuzController> {
  SearchLocationReviews({Key? key}) : super(key: key);

  final TextEditingController locationTextController = TextEditingController();

  Widget _customHeader(String title, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Text(
        title,
        style: Theme.of(context).textTheme.overline!.merge(TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15.sp)),
      ),
    );
  }

  Widget _customTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      width: 100.0.w - 20,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 1,
        ),
      ),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: -4),
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        title: Text(
          title,
          // style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
        leading: Icon(
          icon,
          size: 20,
          color: Colors.black,
        ),
        trailing: Icon(
          Icons.arrow_drop_down_sharp,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _locationField(double ht) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 1,
        ),
      ),
      child: TypeAheadFormField(
        hideSuggestionsOnKeyboardHide: true,
        hideKeyboard:
            controller.selectedCountryFinal.value.isEmpty ? true : false,
        hideOnEmpty: true,
        hideOnError: true,
        keepSuggestionsOnLoading: false,
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: locationTextController,
          onTap: () async {
            print(controller.cityList);
            if (controller.selectedCountryFinal.value.isEmpty) {
              await Get.showSnackbar(GetBar(
                messageText: Text(AppLocalizations.of("Select a country"),
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                duration: Duration(seconds: 1),
                icon: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ));
              // return true;
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIconConstraints: BoxConstraints(),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: AppLocalizations.of('Enter') +
                ' ' +
                AppLocalizations.of('Location'),
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ),
        suggestionsCallback: controller.selectedCountryFinal.value.isEmpty
            ? (pattern) async {
                return [];
              }
            : (pattern) async {
                await controller.fetchLoc(pattern);
                if (pattern == '')
                  return controller.cityList
                      .where((element) =>
                          element.city!.toLowerCase().contains(pattern))
                      .toList();
                else if (pattern != ' ') {
                  return controller.cityList
                      .where((element) => element.city!
                          .toLowerCase()
                          .contains(pattern.toLowerCase()))
                      .toList();
                } else
                  return [];
              },
        itemBuilder: (context, dynamic suggestion) {
          return ListTile(
            leading: Icon(Icons.location_city),
            title: Text(suggestion.city),
            // subtitle: Text('\$${suggestion['price']}'),
          );
        },
        onSuggestionSelected: (dynamic suggestion) async {
          if (suggestion == '') return;
          locationTextController.text = suggestion.city;
        },
      ),
    );
  }

  Widget _locationField1(double ht) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      child: TypeAheadFormField(
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
        hideOnError: true,
        keepSuggestionsOnLoading: false,
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: locationTextController,
          onTap: () {
            print(controller.cityList);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIconConstraints: BoxConstraints(),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: AppLocalizations.of('Enter') +
                ' ' +
                AppLocalizations.of('Location'),
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ),
        suggestionsCallback: (pattern) async {
          await controller.fetchLoc(pattern);

          if (pattern == '')
            return controller.cityList
                .where(
                    (element) => element.city!.toLowerCase().contains(pattern))
                .toList();
          else if (pattern != ' ') {
            return controller.cityList
                .where((element) =>
                    element.city!.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          } else
            return [];
        },
        itemBuilder: (context, dynamic suggestion) {
          return ListTile(
            leading: Icon(Icons.location_city),
            title: Text(suggestion.city),
            // subtitle: Text('\$${suggestion['price']}'),
          );
        },
        onSuggestionSelected: (dynamic suggestion) async {
          if (suggestion == '') return;
          locationTextController.text = suggestion.city;
        },
      ),
    );
  }

  Widget _locationField2() {
    return Container(
        height: 50,
        width: 100.0.w - 30,
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
          color: HexColor("#f5f7f6"),
        ),
        child: Obx(
          () => TypeAheadField(
            debounceDuration: Duration(milliseconds: 300),
            hideSuggestionsOnKeyboardHide: false,
            hideOnEmpty: true,
            hideOnError: true,
            keepSuggestionsOnLoading: false,
            getImmediateSuggestions: true,
            textFieldConfiguration: TextFieldConfiguration(
                enabled: controller.hasLoaded.value,
                controller: locationTextController,
                decoration: InputDecoration(border: OutlineInputBorder())),
            suggestionsCallback: (pattern) async {
              print('hella hasloaded=${controller.hasLoaded.value} ');

              // if (pattern == '' &&
              //     controller.hasLoadedCountry == controller.selectedCountryFinal)
              if (controller.hasLoaded.value) {
                print(
                    'hella ${controller.selectedCountryFinal.value} loc=${controller.listOfLoc}');
                if (pattern == '')
                  return controller.listOfLoc
                      .where((element) =>
                          element.toString().toLowerCase().contains(pattern))
                      .toList();
                else
                  return controller.listOfLoc
                      .where((element) => element
                          .toString()
                          .toLowerCase()
                          .contains(pattern.toLowerCase()))
                      .toList();
              } else
                return [];
              // else if (controller.hasLoadedCountry ==
              //     controller.selectedCountryFinal)

              // else {
              //   return [];
              // }
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: Icon(Icons.location_city),
                title: Text(suggestion.toString()),
                // subtitle: Text('\$${suggestion['price']}'),
              );
            },
            onSuggestionSelected: (suggestion) async {
              if (suggestion == '') return;
              locationTextController.text = suggestion.toString();
            },
          ),
        )

        //  TextFormField(
        //   maxLines: 1,
        //   cursorColor: Colors.grey.shade500,
        //   controller: locationController,
        //   keyboardType: TextInputType.text,
        //   textCapitalization: TextCapitalization.sentences,
        //   style: TextStyle(color: Colors.black, fontSize: 16),
        //   decoration: InputDecoration(
        //     prefixIcon: Container(
        //       padding: EdgeInsets.only(right: 30),
        //       child: Icon(
        //         CupertinoIcons.location_solid,
        //         size: 20,
        //         color: properbuzBlueColor,
        //       ),
        //     ),
        //     border: InputBorder.none,
        //     suffixIconConstraints: BoxConstraints(),
        //     prefixIconConstraints: BoxConstraints(),
        //     focusedBorder: InputBorder.none,
        //     enabledBorder: InputBorder.none,
        //     errorBorder: InputBorder.none,
        //     disabledBorder: InputBorder.none,
        //     hintText: AppLocalizations.of(
        //       "Location",
        //     ),
        //     hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        //   ),
        // ),
        );
  }

  Widget _reviewList() {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }

  Widget _actionButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
        decoration: new BoxDecoration(
          color: hotPropertiesThemeColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        width: 100.0.w,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

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

  Future<bool> validation() async {
    if (controller.selectedCountryFinal.value.isEmpty) {
      await Get.showSnackbar(GetBar(
        messageText: Text(AppLocalizations.of("Select a country"),
            style: TextStyle(color: Colors.white, fontSize: 20)),
        duration: Duration(seconds: 1),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      ));
      return true;
    } else if (locationTextController.text.length < 1) {
      await Get.showSnackbar(GetBar(
        messageText: Text(
            AppLocalizations.of("Enter") +
                " " +
                AppLocalizations.of("Location"),
            style: TextStyle(color: Colors.white, fontSize: 20)),
        duration: Duration(seconds: 1),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      ));
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of("Search") +
            " " +
            AppLocalizations.of("Location") +
            " " +
            AppLocalizations.of("Reviews")),
        brightness: Brightness.dark,
        backgroundColor: hotPropertiesThemeColor,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 25,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            // Get.delete<ProperbuzController>();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customHeader(
                      AppLocalizations.of(
                        "Search Location Reviews",
                      ),
                      context),
                  _customTile(
                      (controller.selectedCountryFinal.value == '')
                          ? AppLocalizations.of(
                              "Select Country",
                            )
                          : (controller.selectedCountryFinal.value),
                      CupertinoIcons.location_solid, () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) async {
                        controller.selectCountry(country);
                      },
                      // showPhoneCode: true,
                      countryListTheme: CountryListThemeData(
                        bottomSheetHeight:
                            MediaQuery.of(context).size.height / 2,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                    );
                  }),
                  _locationField(50.0),
                  SizedBox(
                    height: 20,
                  ),
                  // _locationField1(50.0),
                  _actionButton(AppLocalizations.of('Search'), () async {
                    print(controller.selectedCountryFinal.value);
                    // await Dio()
                    //     .get(
                    //         'https://www.bebuzee.com/webservices/get_reviews_by_country_city.php?country=${controller.selectedCountryFinal.value}&city=${locationController.text}')
                    //     .then((value) =>
                    //         print("search location review ${value.data}"));
                    if (await validation()) {
                      return;
                    }
                    LocationReviewsController locationController =
                        Get.put(LocationReviewsController());
                    locationController.selectedCountry.value =
                        controller.selectedCountryFinal.value;
                    locationController.selectedCity.value =
                        locationTextController.text;
                    locationController.getLocationReviews();

                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GeneralLocationReviewsView(),
                        ));

                    controller.selectedCountryFinal.value = "";
                    locationTextController.clear();
                    // Get.delete<ProperbuzController>();
                    print("locattion page selected");
                  }),
                ],
              ),
            ),
            // _actionButton(
            //     AppLocalizations.of(
            //       "Write a Review",
            //     ), () {
            //   Get.to(WriteLocationReviewView());
            // }),
          ],
        ),
      ),
    );
  }
}
