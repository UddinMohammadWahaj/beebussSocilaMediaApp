import 'dart:ui';

import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/TradesmenCountryModel.dart';
import 'package:bizbultest/models/Tradesmen/TradesmenWorkCategoryModel.dart';
import 'package:bizbultest/services/Properbuz/add_tradesman_controller.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/home/search/add_tradesmen_location_search_page.dart';
import 'package:bizbultest/widgets/Properbuz/home/search/location_search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_property_view.dart';
import 'detailed_add_tradesmen_view.dart';

class AddTradesmenView extends StatefulWidget {
  String city;
  AddTradesmenView(this.city, {Key? key}) : super(key: key);
  @override
  State<AddTradesmenView> createState() => _AddTradesmenViewState();
}

class _AddTradesmenViewState extends State<AddTradesmenView> {
  AddTradesmenController ctr = Get.put(AddTradesmenController());
  String dropdownvalue = 'Select Country';
  String dropdownvalue2 = 'Work Category';
  @override
  void initState() {
    // locationController.clear();
    // ctr.image.value.delete();

    ctr.fetchcountryData();
    // ctr.fetchData();
    //locationController.text = widget.city;

    locationController.text = ctr.message.value;
    super.initState();
  }

  TextEditingController locationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController describe = TextEditingController();

  String catId = "";
  String countyid = "";
  String countryName = "";
  String subCategoryId = "";
  String dropdownvalue3 = 'Select Sub category';

  Widget _headerCard(BuildContext context) {
    return Text("Sign Up for Properbuz Local Trade account!",
        style: Theme.of(context).textTheme.headline6);
  }

  Widget _headerCardloc(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  bool validation() {
    if (catId == "") {
      Fluttertoast.showToast(msg: "Select Trade");
      return false;
    } else if (subCategoryId == "") {
      Fluttertoast.showToast(msg: "select sub category");
      return false;
    } else if (describe.text.length < 1) {
      Fluttertoast.showToast(msg: "enter description");
      return false;
    } else if (locationController.text.length < 1) {
      Fluttertoast.showToast(msg: "enter location");
      return false;
    } else if (ctr.currentCountry.value == "") {
      Fluttertoast.showToast(msg: "Select Country");
      return false;
    } else if (companyNameController.text.length < 1) {
      Fluttertoast.showToast(msg: "enter company name");
      return false;
    } else if (!ctr.isImagePicked.value) {
      Fluttertoast.showToast(msg: "Select Company Logo");
      return false;
    }
    return true;
  }

  Widget _customSelectButton(String val, VoidCallback onTap, RxBool isLoad) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 50,
        width: 100.0.w - 20,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.flag_rounded,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    val,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              (isLoad.value == false)
                  ? Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    )
                  : CircularProgressIndicator(
                      color: settingsColor,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDown(BuildContext context, ctr) {
    return Container(
      decoration: new BoxDecoration(
        color: HexColor("#f5f7f6"),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            color: Colors.grey.shade600,
          ),
          Obx(
            () => Expanded(
              child: DropdownButtonFormField<TradesmenCountryModel>(
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1!.color),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5),
                  hintStyle: TextStyle(color: secondaryColor, fontSize: 18),
                ),
                icon: Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 20,
                  color: properbuzBlueColor,
                ),
                iconSize: 20,
                items: ctr.lstWorkcountryCat
                    .map<DropdownMenuItem<TradesmenCountryModel>>(
                        (TradesmenCountryModel value) {
                  return DropdownMenuItem<TradesmenCountryModel>(
                    value: value,
                    child: Text(
                      value.country!,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (val) async {
                  countyid = val!.countryId!;
                  countryName = val!.country!;

                  await ctr.fetchlocation("19");
                },
                hint: Text(
                  dropdownvalue ?? "",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget dropDown(BuildContext context) {
  //   return Container(
  //     decoration: new BoxDecoration(
  //       color: HexColor("#f5f7f6"),
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       shape: BoxShape.rectangle,
  //     ),
  //     margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
  //     padding: EdgeInsets.symmetric(horizontal: 15),
  //     child: Column(
  //       children: [
  //         TextField(
  //             controller: ctr.locationController,
  //             cursorColor: Colors.black,
  //             decoration: InputDecoration(
  //                 hintText: "Select a Country",
  //                 border: InputBorder.none,
  //                 focusedBorder: InputBorder.none,
  //                 enabledBorder: InputBorder.none,
  //                 errorBorder: InputBorder.none,
  //                 disabledBorder: InputBorder.none,
  //                 icon: Icon(
  //                   Icons.location_on_rounded,
  //                   color: Colors.grey.shade600,
  //                 )),
  //             //      onTap: () => {ctrl.isSearching.value = true},
  //             onChanged: (val) {
  //               ctr.searchCountry(val);
  //             }),
  //       ],
  //     ),
  //   );
  // }

  // Widget dropDown3(BuildContext context) {
  //   return Container(
  //     decoration: new BoxDecoration(
  //       color: HexColor("#f5f7f6"),
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       shape: BoxShape.rectangle,
  //     ),
  //     margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
  //     padding: EdgeInsets.symmetric(horizontal: 15),
  //     child: Row(
  //       children: [
  //         Icon(
  //           CupertinoIcons.bag_fill,
  //           color: Colors.grey.shade600,
  //         ),
  //         Expanded(
  //           child: DropdownButtonFormField<TradesmenWorkSubCatModel>(
  //             dropdownColor: Theme.of(context).scaffoldBackgroundColor,
  //             style:
  //                 TextStyle(color: Theme.of(context).textTheme.headline1.color),
  //             decoration: InputDecoration(
  //               border: InputBorder.none,
  //               contentPadding: EdgeInsets.only(left: 5),
  //               hintStyle: TextStyle(color: secondaryColor, fontSize: 18),
  //             ),
  //             icon: Icon(
  //               Icons.arrow_drop_down_sharp,
  //               size: 20,
  //               color: properbuzBlueColor,
  //             ),
  //             iconSize: 20,
  //             items: ctr.lstWorksubCat
  //                 .map<DropdownMenuItem<TradesmenWorkSubCatModel>>(
  //                     (TradesmenWorkSubCatModel value) {
  //               return DropdownMenuItem<TradesmenWorkSubCatModel>(
  //                 value: value,
  //                 child: Text(
  //                   value.tradeSubcatName,
  //                   style: TextStyle(fontSize: 16, color: Colors.black),
  //                 ),
  //               );
  //             }).toList(),
  //             onChanged: (val) {
  //               subCategoryId = val.tradeSubcatId;

  //               // subCategoryId = val;
  //               //subcatid = val.tradeSubcatId;
  //             },
  //             hint: Text(
  //               dropdownvalue3 ?? "",
  //               style: TextStyle(fontSize: 14),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget dropDown2(BuildContext context) {
  //   return Container(
  //     decoration: new BoxDecoration(
  //       color: HexColor("#f5f7f6"),
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       shape: BoxShape.rectangle,
  //     ),
  //     margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
  //     padding: EdgeInsets.symmetric(horizontal: 15),
  //     child: Row(
  //       children: [
  //         Icon(
  //           Icons.person,
  //           color: Colors.grey.shade600,
  //         ),
  //         Obx(
  //           () => Expanded(
  //             child: DropdownButtonFormField<TradesmenWorkCategoryModel>(
  //               dropdownColor: Theme.of(context).scaffoldBackgroundColor,
  //               style: TextStyle(
  //                   color: Theme.of(context).textTheme.headline1.color),
  //               decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 contentPadding: EdgeInsets.only(left: 5),
  //                 hintStyle: TextStyle(color: secondaryColor, fontSize: 18),
  //               ),
  //               icon: Icon(
  //                 Icons.arrow_drop_down_sharp,
  //                 size: 20,
  //                 color: properbuzBlueColor,
  //               ),
  //               iconSize: 20,
  //               items: ctr.lstWorkCat
  //                   .map<DropdownMenuItem<TradesmenWorkCategoryModel>>(
  //                       (TradesmenWorkCategoryModel value) {
  //                 return DropdownMenuItem<TradesmenWorkCategoryModel>(
  //                   value: value,
  //                   child: Text(
  //                     value.tradeCatName,
  //                     style: TextStyle(fontSize: 16, color: Colors.black),
  //                   ),
  //                 );
  //               }).toList(),
  //               onChanged: (val) async {
  //                 // ctr.lstWorksubCat.clear();

  //                 catId = val.tradeCatId;
  //                 ctr.lstWorksubCat.clear();

  //                 await ctr.fetchsubData(catId);
  //               },
  //               hint: Text(
  //                 dropdownvalue2 ?? "",
  //                 style: TextStyle(fontSize: 14),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _customTextField(
      String hintText, IconData icon, TextEditingController controller) {
    return Container(
      height: 50,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: new BoxDecoration(
        // color: Colors.grey.shade100,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                color: Colors.grey.shade600,
              )),
          prefixIconConstraints: BoxConstraints(),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _selectionCard(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 100,
          width: 100.0.w - 20,
          decoration: new BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: settingsColor,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          )),
    );
  }

  Widget _nextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (validation()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedAddTradesmenView(
                        countryId: countyid,
                        countryName: countryName,
                        logo: ctr.image.value,
                        categoryId: catId,
                        companyName: companyNameController.text,
                        location: locationController.text,
                      )));
        }
      },
      child: Container(
        height: 50,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            color: settingsColor),
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Center(
            child: Text(
          "Next",
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
      ),
    );
  }

  Widget _customTextField2(
      String hintText, IconData icon, TextEditingController controller) {
    return Container(
      height: 50,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: new BoxDecoration(
        // color: Colors.grey.shade100,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        readOnly: true,
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Container(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                color: Colors.grey.shade600,
              )),
          suffixIcon: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(settingsColor)),
            // color: settingsColor,
            onPressed: () async {
              // if (ctr.currentCountry.value.isNotEmpty) {
              //   ctr.currentCountry.value = ctr.currentCountry.value;
              //   var returnData = await Navigator.push(context,
              //       MaterialPageRoute(builder: (context) {
              //     return AddTradesmenLocationSearchPage(
              //         ctr.currentCountry.value);
              //   }));
              //   locationController.text = returnData;

              //   print(ctr.message.value);
              // } else {
              //   Fluttertoast.showToast(
              //       msg: "Please Select Country!",
              //       toastLength: Toast.LENGTH_SHORT,
              //       timeInSecForIosWeb: 1,
              //       backgroundColor: Colors.black,
              //       textColor: Colors.white,
              //       fontSize: 16.0);
              // }
            },
            child: Text(
              "Select",
              style: TextStyle(color: Colors.white),
            ),
          ),
          prefixIconConstraints: BoxConstraints(),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _customTextFieldCountry(
      TextEditingController textcontroller, String hintText, double ht) {
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
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: textcontroller,
        onChanged: (v) {
          print("here $v");
          ctr.updateCountryList(v);
        },
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
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500)),
      ),
    );
  }

  Widget _headerCardservice(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  Widget _headerCardloc1(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  Future customBarBottomSheetCountryList(
      double h, String title, List<CountryListModel> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCardloc1('Select ' + title),
                _customTextFieldCountry(
                    ctr.searchCountryloc, "Enter Country", 50.0),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: h,
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: (ctr.searchCountryloc.text.isEmpty)
                            ? dataList.length
                            : ctr.searchCountryList.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            if (ctr.searchCountryList.length == 0) {
                              ctr.currentCountry.value =
                                  dataList[index].country!;
                              ctr.currentCountryIndex.value = index;
                            } else {
                              ctr.currentCountry.value =
                                  ctr.searchCountryList[index].country;
                              ctr.currentCountryIndex.value = index;
                            }
                            Navigator.of(Get.context!).pop();
                          },
                          title: Text(
                            (ctr.searchCountryList.length == 0)
                                ? dataList[index].country
                                : ctr.searchCountryList[index].country,
                            style: TextStyle(
                                color: (index == ctr.currentCountryIndex.value)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          tileColor: (index == ctr.currentCountryIndex.value)
                              ? settingsColor
                              : Colors.transparent,
                        ),
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  Widget _customListBuilder1(Map<String, dynamic> map) {
    List keys = map.keys.toList();
    List values = map.values.toList();
    return Container(
        width: 100.0.w - 20,
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: keys.length,
            itemBuilder: (context, index) {
              return _customCheckBox1(keys[index], map[keys[index]]);
            }));
  }

  Widget _customCheckBox1(String text, bool val) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Colors.transparent,
      width: 100.0.w - 40,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ctr.updateServiceCategories(text, !val);
            },
            icon: Icon(
              val ? CupertinoIcons.checkmark_square : CupertinoIcons.square,
              color: settingsColor,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customTextFieldservice(
      TextEditingController controller, String hintText, double ht) {
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
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
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
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
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
        backgroundColor: appBarColor,
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

            Get.delete<AddTradesmenController>();
          },
        ),
        title: Text(
          "Add a tradesmen",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Get.delete<AddTradesmenController>();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  height: 100.0.h -
                      (56 + MediaQueryData.fromWindow(window).padding.top + 80),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // _headerCard(context),
                        _customTextField("Enter Company Name", Icons.home,
                            companyNameController),
                        // dropDown2(context),

                        // Obx(() => dropDown3(context)),

                        Obx(
                          () => _customSelectButton(
                              ctr.currentCountry.value == ''
                                  ? ctr.select + " (e.g. UK)"
                                  : ctr.currentCountry.value, () async {
                            ctr.iconLoadCountry.value = true;
                            ctr.fetchCountryList(() async {
                              customBarBottomSheetCountryList(
                                  Get.size.height / 1.5,
                                  'Country',
                                  ctr.countrylist);
                            });
                          }, ctr.iconLoadCountry),
                        ),
                        //     dropDown(context, ctr),

                        Obx(() => ctr.searchedCountry.length > 0
                            ? Card(
                                elevation: 20.0,
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 10.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: 0.0,
                                    maxHeight: 100.0,
                                  ),
                                  child: ListView.builder(
                                      itemCount: ctr.searchedCountry.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            countyid = ctr
                                                .searchedCountry[index]
                                                .countryId!;
                                            countryName =
                                                ctr.currentCountry.value;
                                            ctr.locationController.text = ctr
                                                .searchedCountry[index]
                                                .country!;
                                            ctr.searchedCountry.value = [];
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              ctr.searchedCountry[index]
                                                  .country!,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Container()),
                        _customTextField2("Select Location",
                            Icons.location_on_rounded, locationController),

                        Obx(
                          () => ctr.isImagePicked.value
                              ? Center(
                                  child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Image.file(
                                      ctr.image.value,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ))
                              : _selectionCard("Select company logo", () {
                                  ctr.pickImage();
                                }),
                        ),
                        _headerCardservice("Service Categories"),
                        Obx(() =>
                            _customListBuilder1(ctr.serviceCategories.value)),
                        _headerCardservice("Service Description"),
                        _customTextFieldservice(
                            describe, "Describe your Service", 125),
                      ],
                    ),
                  ),
                ),
                _nextButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
