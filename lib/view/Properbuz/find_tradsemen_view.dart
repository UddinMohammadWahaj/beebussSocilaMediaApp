import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Properbuz/SearchTextLocationModel.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmen_country_list_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmen_subcat_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmens_work_category_model.dart';
import 'package:bizbultest/models/TradesmenCountryModel.dart';
import 'package:bizbultest/models/Tradesmen/TradesmenWorkCategoryModel.dart';
import 'package:bizbultest/services/Properbuz/TradsMen_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Chat/set_status_page.dart';
import 'package:bizbultest/view/Properbuz/find_trades_searchLocation.dart';
import 'package:bizbultest/view/Properbuz/menu/detailed_tradesmen_view.dart';
import 'package:bizbultest/view/Properbuz/searc_by_map_view.dart';
import 'package:bizbultest/view/Properbuz/tradesmen_results_view.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:commons/commons.dart';

import '../../services/Properbuz/searchbymapcontroller.dart';
import '../../services/Properbuz/tradesmen_results_controller.dart';
import '../../widgets/Properbuz/GoogleMap/searchbymapentrywidget.dart';
import '../../widgets/Properbuz/home/search/add_tradesmen_location_search_page.dart';
import 'package:geolocator/geolocator.dart';

final TextEditingController locationController = TextEditingController();

// ignore: must_be_immutable
class FindTradsmenView extends StatefulWidget {
  const FindTradsmenView({Key? key}) : super(key: key);

  @override
  State<FindTradsmenView> createState() => _FindTradsmenViewState();
}

class _FindTradsmenViewState extends State<FindTradsmenView> {
  @override
  void initState() {
    super.initState();

    ctr.checkGps();
  }

  TradsmenController ctrl = Get.put(TradsmenController());
  TradesmenResultsController ctr = Get.put(TradesmenResultsController());

  TextEditingController locationText1Controller = TextEditingController();
  int? selectedIndex;
  int? SlectedIteam;
  bool flag = false;
  List emptylist = [];
  String? category;

  List imagesIcon = [
    {"image": "assets/icons/carpenter.png"},
    {"image": "assets/icons/concrete.png"},
    {"image": "assets/icons/electrician.png"},
    {"image": "assets/icons/HVAC.png"},
    {"image": "assets/icons/industrial.png"},
    {"image": "assets/icons/other_category.png"},
    {"image": "assets/icons/pipe-fitting.png"},
    {"image": "assets/icons/plumber.png"},
    {"image": "assets/icons/services.png"},
    {"image": "assets/icons/welder.png"},
  ];

  Widget setupAlertDialoadContainer(context, StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          width: double.infinity,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of('Select Sub category'),
              style: TextStyle(
                  color: settingsColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            // color: settingsColor,
          ),
        ),
        Divider(
          thickness: 3,
          color: settingsColor,
        ),
        SizedBox(
          height: 7,
        ),
        Container(
            // color: Colors.grey,
            height: 350.0,
            width: 350.0,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: ctrl.lstWorksubCat.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: (() {
                      setState(() {
                        selectedIndex = index;

                        subcatid = ctrl.lstWorksubCat[index].tradeSubcatId!;

                        setState(() {});
                      });
                      // Navigator.pop(context);
                    }),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        AppLocalizations.of(
                            ctrl.lstWorksubCat[index].tradeSubcatName!),
                        style: TextStyle(
                            color: selectedIndex == index
                                ? hotPropertiesThemeColor
                                : Colors.black,
                            fontWeight: selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: selectedIndex == index ? 20 : 15),
                      ),
                    ),
                  );
                })),
        SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  // color: settingsColor,
                  onPressed: () {
                    Navigator.pop(context);
                    selectedIndex = -1;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                        color: settingsColor,
                      ),
                      Text(AppLocalizations.of("Back"),
                          style: TextStyle(color: settingsColor, fontSize: 15)),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(settingsColor)),
                onPressed: () {
                  setState(() {
                    dialog2(context);
                    selectedIndex = -1;
                    ctrl.getLocations();
                  });
                },
                child: Text(AppLocalizations.of("Next"),
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ],
    );
  }

  void dialog1(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return ctrl.lstWorksubCat.length > 0
                  ? setupAlertDialoadContainer(context, setState)
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
          );
        });
  }

  void dialog2(BuildContext context) {
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              ctrl.getLocations();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of('Select your Location'),
                          style: TextStyle(
                              color: settingsColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        // color: settingsColor,
                      ),
                    ),
                    Divider(
                      thickness: 3,
                      color: settingsColor,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Obx(
                      () => _customSelectButton(
                          AppLocalizations.of(ctrl.currentCountry.value == ''
                              ? ctrl.select + " (e.g. UK)"
                              : ctrl.currentCountry.value), () async {
                        ctrl.iconLoadCountry.value = true;
                        ctrl.fetchCountryList(() async {
                          customBarBottomSheetCountryList(Get.size.height / 1.5,
                              'Country', ctrl.countrylist);
                          ctrl.getLocations();
                        });
                      }, ctrl.iconLoadCountry,
                          Icon(Icons.location_on, size: 16)),
                    ),
                    Container(
                        // color: Colors.grey,
                        height: 300.0,
                        width: 300.0,
                        child: FindTradesmenLocationSearchPage(
                            ctrl.currentCountry.value, setState)),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                              // color: settingsColor,
                              onPressed: () {
                                Navigator.pop(context);
                                ctrl.locationFieldController.clear();
                                ctrl.currentCountry.value = "";
                                ctrl.locations.value = [];
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: 15,
                                    color: settingsColor,
                                  ),
                                  Text(AppLocalizations.of("Back"),
                                      style: TextStyle(
                                          color: settingsColor, fontSize: 15)),
                                ],
                              )),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(settingsColor)),
                            onPressed: () {
                              setState(() {
                                // locationText1Controller.text =
                                //     ctrl.locationFieldController.text;
                                print("object.. country $countryid");
                                if (validation()) {
                                  // locationText1Controller.text =
                                  //     ctrl.locationFieldController.text;
                                  print("object.. loction ${countryid}");
                                  var country = ctrl.currentCountry.value;
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TradesmenResultsView(
                                        catId: catId,
                                        subCatId: subcatid,
                                        countryId: countryid.toString(),
                                        countryName: country,
                                        location: ctrl
                                            .newlocationFieldController.text,
                                        category: category,
                                      ),
                                    ),
                                  );

                                  ctrl.locationFieldController.clear();
                                  ctrl.currentCountry.value = "";
                                  ctrl.locations.value = [];
                                }
                              });
                            },
                            child: Text(AppLocalizations.of("Next"),
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  Widget _customHeader(String title, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Text(
        title,
        style: Theme.of(context).textTheme.overline!.merge(TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 11.0.sp)),
      ),
    );
  }

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14,
              color: properbuzBlueColor,
              fontWeight: FontWeight.w500),
        ));
  }

  Widget _customSelectButton(
      String val, VoidCallback onTap, RxBool isLoad, Icon icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        // padding: EdgeInsets.symmetric(
        //   horizontal: 10,
        // ),
        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        height: 50,
        width: 100.0.w - 30,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  icon,
                  SizedBox(
                    width: 5.0,
                  ),
                  SizedBox(
                    width: 50.0.w - 10,
                    child: Text(
                      val,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                    ),
              SizedBox(
                width: 2.0,
              ),
            ],
          ),
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
        onTap: () {
          ctrl.searchCountry.clear();
        },
        onChanged: (v) {
          setState(() {
            ctrl.updateCountryList(v);
          });
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

  Future customBarBottomSheetCountryList(
      double h, String title, List<TradesCountry> dataList) async {
    await showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard('Select ' + title),
                _customTextFieldCountry(
                    ctrl.searchCountry, "Enter Country", 50.0),
                Container(
                    height: h,
                    child: Obx(
                      () => ctrl.searchCountry.text.isEmpty &&
                              ctrl.searchCountryList.length == 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataList.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  ctrl.currentCountry.value =
                                      dataList[index].country!;
                                  ctrl.currentCountryIndex.value = index;

                                  countryid = dataList[index].countryId!;

                                  print("11 -- $countryid");

                                  Navigator.of(Get.context!).pop();
                                  ctrl.currentCountryIndex.value = 0;
                                },
                                title: Text(
                                  dataList[index].country!,
                                  style: TextStyle(
                                      color: (index ==
                                              ctrl.currentCountryIndex.value)
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                tileColor:
                                    (index == ctrl.currentCountryIndex.value)
                                        ? settingsColor
                                        : Colors.transparent,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: ctrl.searchCountryList.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  ctrl.currentCountry.value =
                                      ctrl.searchCountryList[index].country;
                                  ctrl.currentCountryIndex.value = index;
                                  countryid =
                                      ctrl.searchCountryList[index].countryId;
                                  print("11 -- $countryid");

                                  Navigator.of(Get.context!).pop();
                                  ctrl.currentCountryIndex.value = 0;
                                  ctrl.searchCountryList.value = [];
                                  ctrl.searchCountry.clear();
                                },
                                title: Text(
                                  ctrl.searchCountryList[index].country,
                                  style: TextStyle(
                                      color: (index ==
                                              ctrl.currentCountryIndex.value)
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                tileColor:
                                    (index == ctrl.currentCountryIndex.value)
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

  Widget cardView(BuildContext context) {
    return ctrl.lstWorkCat.length > 0
        ? Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: ctrl.lstWorkCat.length,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() async {
                            setState(() {
                              SlectedIteam = index;
                              category = ctrl.lstWorkCat[index].tradeCatName;
                            });

                            catId = ctrl.lstWorkCat[index].tradeCatId!;
                            ctrl.lstWorksubCat.clear();

                            await ctrl.fetchsubData(catId);
                            setState(() {
                              SlectedIteam = -1;
                            });

                            dialog1(context);
                          });
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: 110.0,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: SlectedIteam == index
                                ? lightGrey
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 5,
                            child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      color: Colors.transparent,
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3),
                                        child: Image.asset(
                                          imagesIcon[index]['image'],
                                          // color: settingsColor,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                          ctrl.lstWorkCat[index].tradeCatName!),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    })),
          )
        : Center(
            child: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: settingsColor,
              ),
            ),
          );
  }

  String catId = "";
  String subcatid = "";
  String countryid = "";
  String subcountyid = "";
  String subcountryName = "";

  String countryName = "";

  String dropdownvalue = 'Trade (e.g. electrician)';
  String dropdownvalue2 = 'Select Sub category';

  bool validation() {
    if (catId == "") {
      _customErrorTextCard("Select Trade", "Error", Icons.error, Colors.red);
      return false;
    } else if (subcatid == "") {
      _customErrorTextCard(
          "Select sub Category", "Error", Icons.error, Colors.red);
      return false;
    } else if (countryid == "") {
      _customErrorTextCard("Select country", "Error", Icons.error, Colors.red);
      return false;
    } else if (ctrl.currentCountry.value == "") {
      _customErrorTextCard("Select Country", "Error", Icons.error, Colors.red);
      return false;
    } else if (ctrl.newlocationFieldController.text.length < 1) {
      _customErrorTextCard("Select Location", "Error", Icons.error, Colors.red);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => (ProperbuzController()), fenix: true);
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
          },
        ),
        title: Text(
          AppLocalizations.of("Find Tradesmen"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: GetX<TradsmenController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of("Find a"),
                              style: TextStyle(
                                  fontSize: 30,
                                  color: hotPropertiesThemeColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              AppLocalizations.of("Guaranteed"),
                              style: TextStyle(
                                  fontSize: 30,
                                  color: hotPropertiesThemeColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              AppLocalizations.of("Tradesperson") + " *",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: hotPropertiesThemeColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(right: 20, top: 20),
                      child: Icon(
                        CustomIcons.customer,
                        size: 90,
                        color: settingsColor,
                      ),
                    ),
                  ],
                ),
                _customHeader(
                    AppLocalizations.of(
                        "Search for a Tradesperson/Company near you"),
                    context),
                cardView(context),
              ],
            );
          },
        ),
      ),
    );
  }
}
