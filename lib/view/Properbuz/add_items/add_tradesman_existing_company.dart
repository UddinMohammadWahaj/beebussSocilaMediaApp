import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_New_tradesmen_view.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_solo_tradesmen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';
import '../../../models/Tradesmen/tradesmens_work_category_model.dart';
import '../../../services/Chat/direct_api.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/custom_icons.dart';
import '../../../utilities/custom_icons.dart';

class ExitingCompanyView extends StatefulWidget {
  const ExitingCompanyView({Key? key}) : super(key: key);

  @override
  State<ExitingCompanyView> createState() => _ExitingCompanyViewState();
}

class _ExitingCompanyViewState extends State<ExitingCompanyView> {
  Future<List<DataCompany?>?>? ExitingCompanyData;
  AddTradesmenController ctr = Get.put(AddTradesmenController());

  late int SelectedIndex;
  List<String> DataList = ["Company", "Solo Tradesmen"];
  String currentListingType = "";
  String companyType = "";
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    print("DATATTATA value lenght === ${ExitingCompanyData}");
    setState(() {
      ExitingCompanyData = DirectApiCalls.existingCompanyList!();
      ExitingCompanyData!.then((value) => setState(() {}));
      print(
          "DATATTATA${ExitingCompanyData!.then((value) => print("valuelength$value  -- ${value!.length}"))}");
      print("DATATTATA value lenght === ${ExitingCompanyData}");
    });
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
                val,
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

  Future customBarBottomSheetPropertyList(
      double h, String title, List<String> dataList) async {
    showBarModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      builder: (context) => Container(
          height: h,
          margin: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerCard(AppLocalizations.of(title)),
                Divider(thickness: 1),
                Container(
                    height: h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          setState(() async {
                            SelectedIndex = index;
                            currentListingType = dataList[index].toString();
                            index == 0
                                ? companyType = "company"
                                : companyType = "solo";
                            Navigator.of(Get.context!).pop();
                            ctr.lstWorkCat1();
                            ctr.fetchDat1();
                            print("data ===11 ${ctr.lstWorkCat1}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => index == 0
                                      ? AddNewTradesmenView("company", [])
                                      : SoloTradesmenView("solo", "0", [])),
                            ).then((value) => setState(() {
                                  ExitingCompanyData =
                                      DirectApiCalls.existingCompanyList();
                                  print("==== #### 33 $ExitingCompanyData");
                                }));
                          });
                        },
                        title: Text(
                          AppLocalizations.of(dataList[index]),
                          style: TextStyle(
                              color: (index == SelectedIndex)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor: (index == SelectedIndex)
                            ? settingsColor
                            : Colors.transparent,
                      ),
                    )),
              ],
            ),
          )),
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
            setState(() {});
            Navigator.pop(context);

            Get.delete<AddTradesmenController>();
          },
        ),
        title: Text(
          AppLocalizations.of("Add") +
              " " +
              AppLocalizations.of("New") +
              " " +
              AppLocalizations.of("Tradesmen"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          Navigator.pop(context);
          Get.delete<AddTradesmenController>();
          return true;
          // goBack
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4.48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _headerCard(AppLocalizations.of("Add") +
                            " " +
                            AppLocalizations.of("Company") +
                            " / " +
                            AppLocalizations.of("Tradesmen") +
                            " * "),
                      ),
                      _customSelectButton(
                          AppLocalizations.of((companyType == '')
                              ? AppLocalizations.of("Please") +
                                  " " +
                                  AppLocalizations.of("select") +
                                  " (e.g. Company)"
                              : currentListingType), () async {
                        customBarBottomSheetPropertyList(200, 'Type', DataList);
                      }),
                      _headerCard(AppLocalizations.of("Exiting") +
                          " " +
                          AppLocalizations.of("Company") +
                          " *"),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 5),
                    // color: Colors.pink,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: ctr.exitingCompanyList(ExitingCompanyData, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SoloTradesmenView(
                                  "solo", ctr.companyId, [])));
                    }, "ExitingCompany")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
