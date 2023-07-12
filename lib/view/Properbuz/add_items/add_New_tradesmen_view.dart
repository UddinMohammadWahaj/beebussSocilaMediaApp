// ignore_for_file: non_constant_identifier_names, unnecessary_statements

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/models/Tradesmen/TradesmenWorkCategoryModel.dart';
import 'package:bizbultest/services/Properbuz/add_tradesman_controller.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_album_image_view.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_solo_tradesmen.dart';
import 'package:bizbultest/view/Properbuz/add_items/detailed_add_tradesmen_view.dart';
import 'package:bizbultest/view/Properbuz/add_items/tradesmen_price_range.dart';
import 'package:bizbultest/widgets/Properbuz/home/search/add_tradesmen_Work_area.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:camera/camera.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';
import '../../../api/ApiRepo.dart';
import '../../../models/Properbuz/country_list_model.dart';
import '../../../models/Tradesmen/tradesmen_subcat_model.dart';
import '../../../models/Tradesmen/tradesmens_work_category_model.dart';
import '../../../services/Chat/direct_api.dart';
import '../../../widgets/Properbuz/home/search/add_tradesmen_location_search_page.dart';
import '../add_tradesman_map_view.dart';
import '../find_tradsemen_view.dart';
import 'add_tradesman_existing_company.dart';

class AddNewTradesmenView extends StatefulWidget {
  String companyType = "";

  List companyPerFillData;

  AddNewTradesmenView(this.companyType, this.companyPerFillData, {Key? key})
      : super(key: key);
  @override
  State<AddNewTradesmenView> createState() => _AddNewTradesmenViewState();
}

class _AddNewTradesmenViewState extends State<AddNewTradesmenView> {
  @override
  void initState() {
    if (widget.companyPerFillData.length > 0) {
      ctr.fetchAlubmList(
          comId: int.parse(widget.companyPerFillData[0]['companyId']),
          trdId: 0,
          setsate: setState);
      // setState(() {});
      print("object...  company ${widget.companyPerFillData[0]['companyId']}");
      newData();
    }
    super.initState();
  }

  List neData = [];

  newData() async {
    // setState(() async {
    // await ctr.fetchAlubmList(
    //     comId: int.parse(widget.companyPerFillData[0]['companyId']), trdId: 0);
    countyid = widget.companyPerFillData[0]['country'];
    print("=== country == $countyid");
    ctr.fetchCountryList(() async {
      // setState(() {
      for (int i = 0; i <= ctr.countrylist.length; i++) {
        // setState(() {
        if (ctr.countrylist[i].countryID == countyid) {
          print("=== country  1 == ${ctr.countrylist[i].countryID}");
          // setState(() {
          ctr.currentCountry.value = ctr.countrylist[i].country!;
          print("=== country  11 == ${ctr.currentCountry.value}");
          // });
        }
        // });
      }
      // });/
    });

    companyNameController.text = widget.companyPerFillData[0]['name'];
    ctr.imageLogo.value = File(widget.companyPerFillData[0]['logo']);
    ctr.image.value = File(widget.companyPerFillData[0]['coverPic']);
    campanyContactController.text = widget.companyPerFillData[0]['mobile'];
    emailController.text = widget.companyPerFillData[0]['email'];
    websiteController.text = widget.companyPerFillData[0]['website'];

    locationController.text = widget.companyPerFillData[0]['location'];
    workLoctionController.text = widget.companyPerFillData[0]['workArea'];
    var ab = (workLoctionController.text.split(','));
    WebData = ab;
    managerNameController.text = widget.companyPerFillData[0]['managerName'];
    managerContactController.text = widget.companyPerFillData[0]['ManagerNum'];
    describe.text = widget.companyPerFillData[0]['details'];
    // });
    setState(() {});
  }

  late String c2;
  TextEditingController companyNameController = TextEditingController();
  AddTradesmenController ctr = Get.put(AddTradesmenController());
  TextEditingController describe = TextEditingController();
  TextEditingController managerNameController = TextEditingController();
  TextEditingController managerContactController = TextEditingController();
  TextEditingController campanyContactController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController workLoctionController = TextEditingController();
  TextEditingController albumTitleController = TextEditingController();

  String countyid = "";
  String countryName = "";
  String dropdownvalue3 = 'Select Sub category';
  String dropdownvalue = 'Select Country';
  String dropdownvalue2 = 'Work Category';
  // String currentListingType = "";
  // String companyType = "";
  var message = "".obs;
  bool iconLoadListingType = false;
  late int SelectedIndex;
  List<String> DataList = ["Company", "Solo Tradsman"];
  List<String> SubCatList1 = [];
  bool _flage = false;
  List<String> WebData = [];

  Widget _customSelectButton(String val, VoidCallback onTap) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                AppLocalizations.of(val),
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            )
          ],
        ),
      ),
      // ),
    );
  }

  void _customErrorTextCard(
      String text, String title, IconData icon, Color color) {
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

  Widget _headerCard(String header) {
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
          AppLocalizations.of(header),
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
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
                _headerCardloc1(AppLocalizations.of('Select') + " $title"),
                _customTextFieldCountry(ctr.searchCountryloc,
                    AppLocalizations.of("Enter Country"), 50.0),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: h,
                    child: Obx(() => ctr.searchCountryloc.text.isEmpty &&
                            ctr.searchCountryList.length == 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: dataList.length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                ctr.currentCountry.value =
                                    dataList[index].country!;
                                ctr.currentCountryIndex.value = index;
                                countyid = dataList[index].countryID!;

                                print("id -==1 ${countyid}");

                                Navigator.of(Get.context!).pop();
                                ctr.currentCountryIndex.value = 0;
                              },
                              title: Text(
                                AppLocalizations.of(dataList[index].country!),
                                style: TextStyle(
                                    color:
                                        (index == ctr.currentCountryIndex.value)
                                            ? Colors.white
                                            : Colors.black),
                              ),
                              tileColor:
                                  (index == ctr.currentCountryIndex.value)
                                      ? settingsColor
                                      : Colors.transparent,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: ctr.searchCountryList.length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                ctr.currentCountry.value =
                                    ctr.searchCountryList[index].country;
                                ctr.currentCountryIndex.value = index;
                                countyid =
                                    ctr.searchCountryList[index].countryID;
                                ctr.searchCountryloc.clear();

                                print("id -== ${countyid}");

                                Navigator.of(Get.context!).pop();
                                ctr.currentCountryIndex.value = 0;
                              },
                              title: Text(
                                AppLocalizations.of(
                                    ctr.searchCountryList[index].country),
                                style: TextStyle(
                                    color:
                                        (index == ctr.currentCountryIndex.value)
                                            ? Colors.white
                                            : Colors.black),
                              ),
                              tileColor:
                                  (index == ctr.currentCountryIndex.value)
                                      ? settingsColor
                                      : Colors.transparent,
                            ),
                          ))),
              ],
            ),
          )),
    );
  }

  Widget _customTextFieldNumber(
      String hintText, TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
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
        textAlign: TextAlign.justify,
        maxLines: 1,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          // prefixIcon: Container(
          //     padding: EdgeInsets.only(right: 10),
          //     child: Icon(
          //       icon,
          //       color: Colors.grey.shade600,
          //     )),
          prefixIconConstraints: BoxConstraints(),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(hintText),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _customTextFieldAlbum(
      String hintText, TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
      // height: 50,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        textAlign: TextAlign.justify,
        maxLines: 1,
        // cursorColor: settingsColor,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: settingsColor),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: settingsColor),
          ),
          // focusedBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: settingsColor),
          // ),
          // enabledBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: settingsColor),
          // ),

          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _customTextFieldNew(
      String hintText, TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
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
        textAlign: TextAlign.justify,
        maxLines: 1,
        onTap: (() {
          ctr.fetchDat1();
          ctr.lstWorkCat1();
          print("data ===111 33 ${ctr.lstWorkCat1.value}");
        }),
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          // prefixIcon: Container(
          //     padding: EdgeInsets.only(right: 10),
          //     child: Icon(
          //       icon,
          //       color: Colors.grey.shade600,
          //     )),
          prefixIconConstraints: BoxConstraints(),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(hintText),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  bool albumValidation() {
    if (albumTitleController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Album Title"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (ctr.isalbumCoverPicked.isFalse) {
      _customErrorTextCard(AppLocalizations.of("Select Album Cover Picture"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    }
    return true;
  }

  bool validation() {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);
    if (widget.companyType == "") {
      _customErrorTextCard(AppLocalizations.of("Select Type"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (companyNameController.text == "") {
      _customErrorTextCard(AppLocalizations.of("Enter Company Name"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (ctr.image.value.path.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select Cover Picture"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (ctr.imageLogo.value.path.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select Company Logo"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (emailController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Email-Id"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (emailValid != true) {
      _customErrorTextCard(AppLocalizations.of("Enter Valid Email-Id"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (campanyContactController.text.length < 1) {
      _customErrorTextCard(
          "Enter Company Contact Number", "Error", Icons.error, Colors.red);
      return false;
    } else if (!regExp.hasMatch(campanyContactController.text)) {
      _customErrorTextCard("Enter Valid Company Contact Number", "Error",
          Icons.error, Colors.red);
      return false;
    } else if (websiteController.text.length < 1) {
      _customErrorTextCard("Enter Website", "Error", Icons.error, Colors.red);
      return false;
    } else if (locationController.text.length < 1) {
      _customErrorTextCard("Select Location", "Error", Icons.error, Colors.red);
      return false;
    } else if (WebData.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select Work Area"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (managerNameController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Manager Name"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (managerContactController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Manager Contact Number"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    } else if (!regExp.hasMatch(managerContactController.text)) {
      _customErrorTextCard(
          AppLocalizations.of("Enter Valid Manager Contact Number"),
          AppLocalizations.of("Error"),
          Icons.error,
          Colors.red);
      return false;
    } else if (describe.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Description"),
          AppLocalizations.of("Error"), Icons.error, Colors.red);
      return false;
    }
    return true;
  }

  late String successms;

  OnUpadte() async {
    String msg = await ctr.updateCompanyData(
      widget.companyPerFillData[0]['companyId'],
      companyNameController.text,
      managerNameController.text,
      managerContactController.text,
      emailController.text,
      campanyContactController.text,
      countyid,
      WebData.join(","),
      websiteController.text,
      locationController.text,
      describe.text,
      ctr.imageLogo.value,
      ctr.image.value,
    );
    successms = msg;
    print("object....11 441 $successms");
    return successms;
  }

  OnAdd() async {
    String msg = await ctr.saveCompanyData(
      companyNameController.text,
      managerNameController.text,
      managerContactController.text,
      emailController.text,
      campanyContactController.text,
      countyid,
      WebData.join(","),
      websiteController.text,
      locationController.text,
      describe.text,
      ctr.imageLogo.value,
      ctr.image.value,
    );
    successms = msg;
    print("object....11 441 $successms");
    return successms;
  }

  Widget _nextButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var tradesmenId;
        print("ctr.imageLogo.value == ${ctr.imageLogo.value}");
        print("ctr.imageLogo.value == ");
        if (widget.companyPerFillData.length > 0 &&
            companyNameController.text ==
                widget.companyPerFillData[0]['name'] &&
            ctr.imageLogo.value.path == widget.companyPerFillData[0]['logo'] &&
            ctr.image.value.path == widget.companyPerFillData[0]['coverPic'] &&
            campanyContactController.text ==
                widget.companyPerFillData[0]['mobile'] &&
            emailController.text == widget.companyPerFillData[0]['email'] &&
            websiteController.text == widget.companyPerFillData[0]['website'] &&
            locationController.text ==
                widget.companyPerFillData[0]['location'] &&
            countyid == widget.companyPerFillData[0]['country'] &&
            WebData.join(",") == widget.companyPerFillData[0]['workArea'] &&
            managerNameController.text ==
                widget.companyPerFillData[0]['managerName'] &&
            managerContactController.text ==
                widget.companyPerFillData[0]['ManagerNum'] &&
            describe.text == widget.companyPerFillData[0]['details'] &&
            ctr.albumAdded.isFalse &&
            ctr.imageAdded.isFalse) {
          errorView("Not update yet..!");
        } else if (validation()) {
          waitDialog(context);
          widget.companyPerFillData.length > 0
              ? await OnUpadte()
              : await OnAdd();
          navigator!.pop(context);

          if (successms == 'false') {
            errorDialog(
              context,
              AppLocalizations.of("Please Fill in all Required Fields!"),
              showNeutralButton: false,
            );
            Timer(const Duration(seconds: 3), () {
              setState(() {
                navigator!.pop(context);
              });
            });
          } else {
            successDialog(
              context,
              AppLocalizations.of("${successms.toString()}"),
              showNeutralButton: false,
              icon: NotificationDialog.SUCCESS_ICON,
            );

            Timer(const Duration(seconds: 3), () {
              setState(() async {
                navigator!.pop(context);
                Get.delete<AddTradesmenController>();
                Navigator.of(context).pop(true);
              });
            });
          }
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: settingsColor,
        child: Center(
            child: Text(
          widget.companyPerFillData.length > 0
              ? AppLocalizations.of("Update")
              : AppLocalizations.of("Done"),
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
      ),
    );
  }

  Widget _customWorkAreaList() {
    return Container(
      // height: 200,
      width: double.infinity,

      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
          itemCount: WebData.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // color: Colors.grey.shade200,
                  shape: BoxShape.rectangle,
                  color: settingsColor,
                  border: new Border.all(
                    color: settingsColor,
                    width: 0.5,
                  ),
                ),
                // height: 40,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 10),
                  // minVerticalPadding: 0,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      WebData[index],
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: (() {
                        setState(() {
                          WebData.removeAt(index);
                        });
                      }),
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                ));
          }),
    );
  }

  Widget _customTextField2(String hintText, IconData icon,
      TextEditingController controller, VoidCallback onTap) {
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
        onTap: onTap,
        readOnly: true,
        maxLines: 1,
        cursorColor: Colors.grey.shade500,
        controller: hintText == "Work Area" ? null : controller,
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
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 23.5,
            color: Colors.black,
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
      // ),
    );
  }

  Widget _selectionCard(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 100,
          width: MediaQuery.of(context).size.width / 3.1,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
              textAlign: TextAlign.center,
            ),
          )),
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
        textInputAction: TextInputAction.done,
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

  Widget ImagesAdd() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => ctr.isImagePicked.value
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      // color: Colors.grey.shade200,
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: settingsColor,
                        width: 0.5,
                      ),
                    ),
                    height: 100,
                    width: MediaQuery.of(context).size.width / 3.1,
                    child: Image.file(
                      ctr.image.value,
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
              : _selectionCard(AppLocalizations.of("Select cover picture "),
                  () {
                  ctr.pickImage();
                }),
        ),
        Obx(
          () => ctr.isLogoPicked.value
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      // color: Colors.grey.shade200,
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: settingsColor,
                        width: 0.5,
                      ),
                    ),
                    height: 100,
                    width: MediaQuery.of(context).size.width / 3.1,
                    child: Image.file(
                      ctr.imageLogo.value,
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
              : _selectionCard(AppLocalizations.of("Select company logo "), () {
                  ctr.pickLogo();
                }),
        ),
      ],
    );
  }

  Widget ImagesRefill() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    // color: Colors.grey.shade200,
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: settingsColor,
                      width: 0.5,
                    ),
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width / 3.1,
                  child: GestureDetector(
                      onTap: (() {
                        setState(() {
                          ctr.pickLogo();
                        });
                      }),
                      child: ctr.isLogoPicked.value
                          ? Image.file(
                              ctr.imageLogo.value,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              ctr.imageLogo.value.path,
                              fit: BoxFit.cover,
                            ))),
            ),
          ),
        ),
        Obx(
          () => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    // color: Colors.grey.shade200,
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: settingsColor,
                      width: 0.5,
                    ),
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width / 3.1,
                  child: GestureDetector(
                      onTap: (() {
                        setState(() {
                          ctr.pickImage();
                        });
                      }),
                      child: ctr.isImagePicked.value
                          ? Image.file(
                              ctr.image.value,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              ctr.image.value.path,
                              fit: BoxFit.cover,
                            ))),
            ),
          ),
        ),
      ],
    );
  }

  void dialog1(BuildContext context, StateSetter setStat) {
    showDialog(
        // barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return setupAlertDialoadContainer(context, setStat);
            }),
          );
        });
  }

  Widget selectCoverImage() {
    return Obx(
      () => ctr.isalbumCoverPicked.value
          ? Center(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // color: Colors.grey.shade200,
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: settingsColor,
                    width: 0.5,
                  ),
                ),
                height: 100,
                width: MediaQuery.of(context).size.width / 3.1,
                child: Image.file(
                  ctr.albumCoverImage.value,
                  fit: BoxFit.cover,
                ),
              ),
            ))
          : _selectionCard(AppLocalizations.of("Select Album Cover Image "),
              () {
              ctr.pickAlbumCoverImage();
            }),
    );
  }

  Future showSuccess(context, msg) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        // "Feedback added Successfully..",
        AppLocalizations.of(msg),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      ),
      duration: Duration(seconds: 3),
    ));
    albumTitleController.clear();
    ctr.isalbumCoverPicked.value = false;
    ctr.albumCoverImage.value = File('');
  }

  void errorView(msg) {
    Get.showSnackbar(GetBar(
      messageText: Text(AppLocalizations.of(msg),
          style: TextStyle(color: Colors.white, fontSize: 20)),
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.error,
        color: Colors.red,
      ),
    ));
    albumTitleController.clear();
    ctr.isalbumCoverPicked.value = false;
    ctr.albumCoverImage.value = File('');
  }

  Widget setupAlertDialoadContainer(context, StateSetter setStat) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of('Create Album'),
                style: TextStyle(
                    color: settingsColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              // color: settingsColor,
            ),
          ),
          selectCoverImage(),
          _customTextFieldAlbum(
              AppLocalizations.of("Add a title"), albumTitleController),
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
                      albumTitleController.clear();
                      ctr.isalbumCoverPicked.value = false;
                      ctr.albumCoverImage.value = File('');
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
                            style:
                                TextStyle(color: settingsColor, fontSize: 15)),
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
                    setStat(() {
                      if (albumValidation()) {
                        setStat(() async {
                          String mssg = await ctr.AddAlbumData(
                            widget.companyPerFillData[0]['companyId'],
                            "0",
                            albumTitleController.text,
                            ctr.albumCoverImage.value,
                          );

                          print("object.. msg = $mssg");
                          if (mssg == "false") {
                            Navigator.pop(context);
                            return errorView(AppLocalizations.of(
                                "There is Some Issue please try again!"));
                          } else {
                            setStat(
                              () async {
                                Navigator.pop(context, true);
                                ctr.fetchAlubmList(
                                    comId: int.parse(widget
                                        .companyPerFillData[0]['companyId']),
                                    trdId: 0,
                                    setsate: setStat);
                                setStat(() {
                                  showSuccess(context, mssg);
                                });

                                return setStat(
                                  () {},
                                );
                              },
                            );
                          }
                        });
                      }
                    });
                  },
                  child: Text(AppLocalizations.of("Create"),
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showAlbumView(StateSetter setstat) {
    return Container(
      child: Column(
        children: [
          albumView(setstat),
          ctr.lstAlubmData.length > 0
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: _headerCard(AppLocalizations.of("Albums") + " *"),
                )
              : Container(),
          ctr.lstAlubmData.length > 0 ? _albumListView() : Container(),
        ],
      ),
    );
  }

  Widget albumView(StateSetter setstat) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: settingsColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      height: 40,
      width: 130,
      child: GestureDetector(
        onTap: () {
          dialog1(context, setstat);
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "+  " + AppLocalizations.of("Add Albums"),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  Widget _albumListView() {
    return StatefulBuilder(
        builder: (context, setsat) => Container(
              // height: 200,
              // width: 200,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                  itemCount: ctr.lstAlubmData.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // color: Colors.grey.shade200,
                        shape: BoxShape.rectangle,
                        // color: settingsColor,
                        border: new Border.all(
                          color: settingsColor,
                          width: 0.5,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddImageAlbumView(
                                      ctr.lstAlubmData[index].albumImage!,
                                      ctr.lstAlubmData[index].albumId!,
                                      "",
                                      ctr.lstAlubmData[index].albumName!)));
                        },
                        leading: Container(
                          // margin: EdgeInsets.only(right: 5, left: 5),
                          height: 60,
                          width: 60,
                          // color: settingsColor,
                          child: CircleAvatar(
                            backgroundColor: settingsColor,
                            child: ClipOval(
                              child: Image.network(
                                ctr.lstAlubmData[index].albumPic!,
                                fit: BoxFit.fill,
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                        ),
                        // ctr.lstAlubmData[index].albumImage.toString()),
                        title: Text(
                          AppLocalizations.of(
                              ctr.lstAlubmData[index].albumName.toString()),
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios_rounded)),
                      ),
                    );
                  }),
            ));
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
            setState(() {
              Get.delete<AddTradesmenController>();
              Navigator.pop(context);
            });
          },
        ),
        title: Text(
          widget.companyPerFillData.length > 0
              ? AppLocalizations.of("Update") +
                  " " +
                  AppLocalizations.of("Company")
              : AppLocalizations.of("Add") +
                  " " +
                  AppLocalizations.of("Company"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          setState(() {
            Navigator.pop(context);
            Get.delete<AddTradesmenController>();
          });
          return true;
        },
        child: StatefulBuilder(
          builder: (context, setsat) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.companyPerFillData.length < 1
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: _headerCard("* " +
                              AppLocalizations.of(
                                  "You can Add Albums of Photos in Manage-section for your better Profile.")),
                        )
                      : Container(),
                  widget.companyPerFillData.length < 1
                      ? Divider(
                          thickness: 1,
                        )
                      : Container(),
                  _headerCard(AppLocalizations.of("Company") +
                      " " +
                      AppLocalizations.of("Infomation") +
                      " *"),
                  _customTextFieldNew(
                      AppLocalizations.of("Enter") +
                          " " +
                          AppLocalizations.of("Company") +
                          " " +
                          AppLocalizations.of("Name"),
                      companyNameController),
                  widget.companyPerFillData == null ||
                          widget.companyPerFillData.length == 0
                      ? ImagesAdd()
                      : (ctr.imageLogo.value.path.isEmpty) ||
                              (ctr.image.value.path.isEmpty)
                          ? ImagesAdd()
                          : ImagesRefill(),
                  _customTextFieldNew(
                      AppLocalizations.of("Company") +
                          " " +
                          AppLocalizations.of("Email"),
                      emailController),
                  _customTextFieldNumber(
                      AppLocalizations.of("Company") +
                          " " +
                          AppLocalizations.of("Contact") +
                          " " +
                          AppLocalizations.of("Number"),
                      campanyContactController),
                  _customTextFieldNew(
                      AppLocalizations.of("Website"), websiteController),
                  widget.companyPerFillData.length > 0
                      ? _showAlbumView(setState)
                      : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(AppLocalizations.of("Company") +
                        " " +
                        AppLocalizations.of("Location") +
                        " * "),
                  ),
                  Obx(
                    () => _customSelectButton(
                      ctr.currentCountry.value == ''
                          ? ctr.select + " (e.g. UK)"
                          : ctr.currentCountry.value,
                      () async {
                        ctr.iconLoadCountry.value = true;
                        ctr.fetchCountryList(() async {
                          customBarBottomSheetCountryList(Get.size.height / 1.5,
                              AppLocalizations.of('Country'), ctr.countrylist);
                        });
                      },
                    ),
                  ),
                  _customTextField2(
                      AppLocalizations.of("Select") +
                          " " +
                          AppLocalizations.of("Location"),
                      Icons.location_on_rounded,
                      locationController, (() async {
                    if (ctr.currentCountry.value.isNotEmpty) {
                      ctr.locationFieldController.clear();
                      ctr.message.value = "";
                      ctr.currentCountry.value = ctr.currentCountry.value;
                      var returnData = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddTradesmenLocationSearchPage(
                            ctr.currentCountry.value,
                            AppLocalizations.of("Location"));
                      }));

                      setState(() {
                        locationController.text = returnData;
                      });
                    } else {
                      _customErrorTextCard(
                          AppLocalizations.of("Select Country"),
                          AppLocalizations.of("Error"),
                          Icons.error,
                          Colors.red);
                    }
                  })),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(AppLocalizations.of("Work") +
                        " " +
                        AppLocalizations.of("Area") +
                        " * "),
                  ),
                  _customTextField2(
                      AppLocalizations.of("Work") +
                          " " +
                          AppLocalizations.of("Area"),
                      Icons.work,
                      workLoctionController, () async {
                    if (ctr.currentCountry.value.isNotEmpty) {
                      ctr.locationFieldController.clear();
                      ctr.message.value = "";
                      ctr.currentCountry.value = ctr.currentCountry.value;
                      var returnData = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddTradesmenLocationSearchPage(
                            ctr.currentCountry.value,
                            AppLocalizations.of("Work") +
                                " " +
                                AppLocalizations.of("Location"));
                      }));

                      setState(() {
                        workLoctionController.text = returnData;
                        !WebData.contains(workLoctionController.text) &&
                                workLoctionController.text != ""
                            ? WebData = [workLoctionController.text, ...WebData]
                            : null;

                        print("Loction === " + WebData.toString());
                      });
                    } else {
                      _customErrorTextCard(
                          AppLocalizations.of("Select Country"),
                          AppLocalizations.of("Error"),
                          Icons.error,
                          Colors.red);
                    }
                  }),
                  WebData.length > 0 ? _customWorkAreaList() : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(
                        AppLocalizations.of("Manager Details") + " * "),
                  ),
                  Container(
                    child: Column(
                      children: [
                        _customTextFieldNew(
                            AppLocalizations.of("Manager") +
                                " " +
                                AppLocalizations.of("Name"),
                            managerNameController),
                        _customTextFieldNumber(
                            AppLocalizations.of("Manager") +
                                " " +
                                AppLocalizations.of("Contact") +
                                " " +
                                AppLocalizations.of("Number"),
                            managerContactController),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCardservice(AppLocalizations.of("Service") +
                        " " +
                        AppLocalizations.of("Description") +
                        " *"),
                  ),
                  _customTextFieldservice(
                      describe,
                      AppLocalizations.of("Describe") +
                          " " +
                          AppLocalizations.of("your") +
                          " " +
                          AppLocalizations.of("Service"),
                      125),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(0),
        child: _nextButton(context),
      ),
    );
  }
}
