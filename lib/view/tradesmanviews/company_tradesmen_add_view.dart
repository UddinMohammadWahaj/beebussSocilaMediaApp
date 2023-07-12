import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as logDev;
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:bizbultest/utilities/values.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_album_image_view.dart';
import 'package:bizbultest/view/Properbuz/add_items/tradesmanpayment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';
import '../../../models/Properbuz/country_list_model.dart';
import '../../../models/Tradesmen/tradesmen_subcat_model.dart';
import '../../../models/Tradesmen/tradesmens_work_category_model.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../utilities/Chat/colors.dart';
import '../../../utilities/colors.dart';
import '../../../widgets/Properbuz/home/search/add_tradesmen_location_search_page.dart';
import '../../services/Tradesmen/new_add_tradesmen_controller.dart';
import '../../services/current_user.dart';

class NewCompanyTradesmenView extends StatefulWidget {
  String companyType;
  String companyId;
  List preFillData;
  String? from;
  Function? refresh;
  NewCompanyTradesmenView(this.companyType, this.companyId, this.preFillData,
      {Key? key, this.from, this.refresh})
      : super(key: key);

  @override
  State<NewCompanyTradesmenView> createState() =>
      _NewCompanyTradesmenViewState();
}

class _NewCompanyTradesmenViewState extends State<NewCompanyTradesmenView> {
  @override
  void initState() {
    if (widget.preFillData.length > 0) {
      print(
          "object... cat : ${widget.preFillData[10]} subCat : ${widget.preFillData[11]} country : ${widget.preFillData[7]} loaction : ${widget.preFillData[8]}");
      ctr.fetchAlubmList(
          comId: 0,
          trdId: int.parse(widget.preFillData[17]),
          setsate: setState);

      newData();
    }

    super.initState();
  }

  newData() async {
    countyid = widget.preFillData[7];
    ctr.fetchCountryList(() async {
      setState(() {
        for (int i = 0; i <= ctr.countrylist.length; i++) {
          setState(() {
            if (ctr.countrylist[i].countryID == countyid) {
              setState(() {
                ctr.currentCountry.value = ctr.countrylist[i].country!;
              });
            }
          });
        }
      });
    });

    workLoctionController.text = widget.preFillData[9];
    setState(() {
      var wL = (workLoctionController.text.split(','));
      workArea = wL;
    });

    typeOfWorkController.text = widget.preFillData[12];
    typeOfWorkController.text ==
            "${ctr.textsWorkList[0]},${ctr.textsWorkList[1]}"
        ? selectIndex = 2
        : typeOfWorkController.text == ctr.textsWorkList[0]
            ? selectIndex = 0
            : selectIndex = 1;

    callOut = int.parse(widget.preFillData[13]);
    publicLiability = int.parse(widget.preFillData[14]);
    workUndertaken = int.parse(widget.preFillData[15]);
    setState(() {
      callOut == 1 ? ctr.availabel.value = true : ctr.availabel.value = false;
      publicLiability == 1
          ? ctr.publiclibelity.value = true
          : ctr.publiclibelity.value = false;
      workUndertaken == 1
          ? ctr.workUndertaking.value = true
          : ctr.workUndertaking.value = false;
    });

    nameController.text = widget.preFillData[2];
    contactController.text = widget.preFillData[3];
    alternativContact.text = widget.preFillData[4];
    emailController.text = widget.preFillData[5];
    experienceController.text = widget.preFillData[6];

    locationController.text = widget.preFillData[8];

    serviceDescribeController.text = widget.preFillData[16];
    ctr.image.value = File(widget.preFillData[1]);
    catId = widget.preFillData[10];

    data123(catId);

    workSubCatController.text = widget.preFillData[11];
    var ab = (workSubCatController.text.split(','));
    subCatId = ab;
    setState(() async {
      await ctr.fetchsubData(catId);
      ctr.lstWorksubCat();

      for (int i = 0; i <= ctr.lstWorksubCat.length; i++) {
        subCatId
            .map((e) => {
                  setState(() {
                    setState(() {
                      if (ctr.lstWorksubCat[i].tradeSubcatId == e) {
                        setState(() {
                          subCat.add(ctr.lstWorksubCat[i].tradeSubcatName!);
                        });
                      }
                    });
                  }),
                })
            .toList();
      }
    });
  }

  data123(catId) async {
    await ctr.fetchDat1();
    // ctr.lstWorkCat1();
    for (int i = 0; i <= ctr.lstWorkCat1.length; i++) {
      setState(() {
        if (ctr.lstWorkCat1[i].tradeCatId == catId) {
          setState(() {
            dropdownvalue2 = ctr.lstWorkCat1[i].tradeCatName!;
          });
        }
      });
    }
  }

  NewAddTradesmenController ctr = Get.put(NewAddTradesmenController());
  TextEditingController alternativContact = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController locationIdController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController workLoctionController = TextEditingController();
  TextEditingController workLoctionIdController = TextEditingController();
  TextEditingController serviceDescribeController = TextEditingController();
  TextEditingController typeOfWorkController = TextEditingController();
  TextEditingController workSubCatController = TextEditingController();
  TextEditingController albumTitleController = TextEditingController();

  late int callOut;
  late int publicLiability;
  late int workUndertaken;
  late int selectIndex;
  String perFillCategory = "";
  String countyid = "";
  String countryName = "";
  String catId = "";
  String subCategoryId = "";
  String dropdownvalue3 = 'Select Sub category';
  String dropdownvalue = 'Select Country';
  String dropdownvalue2 = 'Work Category';
  List<String> workArea = [];
  List<String> workAreaId = [];
  List<String> subCat = [];
  List<String> subCatId = [];
  List<String> typeWork = [];

  Widget dropDown9(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: HexColor("#f5f7f6"),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(
            Icons.person,
            size: 16,
          ),
          Expanded(
            child: DropdownButtonFormField<WorkCategory>(
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
              items: (ctr.lstWorkCat1)
                  .map<DropdownMenuItem<WorkCategory>>((WorkCategory value) {
                return DropdownMenuItem<WorkCategory>(
                  value: value,
                  child: Text(
                    AppLocalizations.of(value.tradeCatName!),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() async {
                  catId = val!.tradeCatId!;
                  ctr.lstWorksubCat.clear();
                  print("work cat=$catId");
                  await ctr.fetchsubData(catId);
                  setState(() {
                    subCat = [];
                  });

                  print("....1122 ${ctr.lstWorksubCat.value}");
                });
              },
              hint: Text(
                AppLocalizations.of(dropdownvalue2) ?? "",
                style: TextStyle(
                    fontSize: widget.preFillData.length > 0 ? 16 : 14,
                    color: widget.preFillData.length > 0 ? Colors.black : null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDown2(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: HexColor("#f5f7f6"),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.bag_fill,
            size: 16,
          ),
          Expanded(
            child: DropdownButtonFormField<TradesmenSubCatModelWorkSubCategory>(
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 5,
                ),
                hintStyle: TextStyle(color: secondaryColor, fontSize: 18),
              ),
              icon: Icon(
                Icons.arrow_drop_down_sharp,
                size: 20,
                color: properbuzBlueColor,
              ),
              iconSize: 20,
              onTap: () {},
              items: ctr.lstWorksubCat
                  .map<DropdownMenuItem<TradesmenSubCatModelWorkSubCategory>>(
                      (TradesmenSubCatModelWorkSubCategory value) {
                return DropdownMenuItem<TradesmenSubCatModelWorkSubCategory>(
                  value: value,
                  child: Container(
                    // color: Colors.pink,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      AppLocalizations.of(value.tradeSubcatName ?? ""),
                      // dropdownvalue2,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  subCategoryId = val!.tradeSubcatId!;
                  if (!subCat.contains(val!.tradeSubcatName)) {
                    subCat = [val!.tradeSubcatName!, ...subCat];
                  }
                  if (!subCat.contains(val!.tradeSubcatId)) {
                    subCatId = [val!.tradeSubcatId!, ...subCatId];
                  }
                });
              },
              hint: Text(
                AppLocalizations.of(dropdownvalue3 ?? ""),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          AppLocalizations.of(header),
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  Widget _customTypeWorkData() {
    return Container(
      decoration: new BoxDecoration(
        color: HexColor("#f5f7f6"),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      width: 100.0.w - 20,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ctr.textsWorkList.length,
        itemBuilder: (context, int index) {
          return ListTile(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  selectIndex = index;
                  // typeOfWorkController.text = ctr.textsWorkList[selectIndex];
                  String text = selectIndex == 2
                      ? "${ctr.textsWorkList[0]},${ctr.textsWorkList[1]}"
                      : ctr.textsWorkList[selectIndex];
                  typeOfWorkController.text = text;
                  print("here type=${typeOfWorkController.text}");
                });
              },
              icon: Icon(
                selectIndex == index
                    ? CupertinoIcons.checkmark_square
                    : CupertinoIcons.square,
                color: settingsColor,
              ),
            ),
            title: Text(
              AppLocalizations.of(ctr.textsWorkList[index]),
              style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }

  Widget _customYesNoCard(String value, bool selected, function, bool pass) {
    return Container(
      width: 50.0.w - 30,
      child: Row(
        children: [
          IconButton(
            onPressed: () => {
              function(pass),
            },
            icon: Icon(
              selected ? CupertinoIcons.circle_fill : CupertinoIcons.circle,
              color: settingsColor,
            ),
          ),
          SizedBox(width: 10),
          Text(
            AppLocalizations.of(value),
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void successExit() {
    widget.refresh!();
    Navigator.of(context).pop();
  }

  Widget _customYesNoRow(String header, bool selected, function) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerCard(header),
        Container(
          height: 50,
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
          child: Row(
            children: [
              _customYesNoCard("Yes", selected, function, true),
              _customYesNoCard("No", !selected, function, false),
            ],
          ),
        ),
      ],
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
        // readOnly:  true : false,
        textAlign: TextAlign.justify,
        maxLines: 1,
        onTap: (() {
          setState(() {
            ctr.lstWorkCat1.clear();
            ctr.fetchDat1();
            ctr.lstWorkCat1();
            print("data ===111 33 ${ctr.lstWorkCat1.value}");
          });
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
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _selectionCard2() {
    return Obx(
      () => GestureDetector(
        onTap: (() => ctr.pickImage()),
        child: Container(
          width: 120,
          height: 120,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: ctr.isImagePicked.value
                  ? Image.file(
                      ctr.image.value,
                      fit: BoxFit.fill,
                      width: 120,
                      height: 120,
                    )
                  : Image.network(
                      ctr.image.value.path,
                      fit: BoxFit.fill,
                      width: 120,
                      height: 120,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectionAlbumCard(String value, VoidCallback onTap) {
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
              AppLocalizations.of(value),
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  Widget _selectionCard(String value, VoidCallback onTap) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120,
          height: 120,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: ctr.isImagePicked.value
                  ? (ctr.image.value != null
                      ? Image.file(
                          ctr.image.value,
                          fit: BoxFit.fill,
                          width: 120,
                          height: 120,
                        )
                      : CircularProgressIndicator())
                  : Image.asset(
                      "assets/images/profile-picture.webp",
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
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

  Widget _customWorkList(List<String> list, {type: ''}) {
    return Container(
      // height: 200,
      width: double.infinity,

      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
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
                      AppLocalizations.of(list[index]),
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: (() {
                        setState(() {
                          list.removeAt(index);
                          if (type == 'workarea') workAreaId.removeAt(index);
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
    var value;
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
        maxLines: 1,
        cursorColor: Colors.grey.shade500,
        controller: textcontroller,
        onTap: () {
          setState(() {
            print("here... $value");
            ctr.currentCountry.value = "";
          });
        },
        onChanged: (v) {
          print("here ${textcontroller.text}");

          ctr.updateCountryList(v);
        },
        keyboardType: TextInputType.text,
        // textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIconConstraints: BoxConstraints(),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: AppLocalizations.of(hintText),
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
                _headerCardloc1(AppLocalizations.of('Select') + ' $title'),
                _customTextFieldCountry(
                    ctr.searchCountryloc,
                    AppLocalizations.of("Enter") +
                        " " +
                        AppLocalizations.of("Country"),
                    50.0),
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

  void _customErrorTextCard(
      String text, String title, IconData icon, Color color) {
    Get.showSnackbar(GetBar(
      title: AppLocalizations.of(title),
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
        AppLocalizations.of(text),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
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
          hintText: AppLocalizations.of(hintText),
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  OnUpdateData() async {
    String msg = await ctr.updateSoloTradesmenData(
      nameController.text,
      contactController.text,
      alternativContact.text,
      emailController.text,
      experienceController.text,
      countyid,
      locationController.text,
      workArea.join(","),
      catId,
      subCatId.join(","),
      typeOfWorkController.text,
      callOut,
      publicLiability,
      workUndertaken,
      serviceDescribeController.text,
      ctr.image.value,
      widget.preFillData[17],
    );

    successms = msg;

    return successms;
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
    print('succesfully written ${directory.path}/my_file.txt');
  }

  OnAddData() async {
    String msg = await ctr.saveSoloTradesmenData(
        int.parse(widget.companyId),
        nameController.text,
        contactController.text,
        alternativContact.text,
        emailController.text,
        experienceController.text,
        countyid,
        locationController.text,
        workArea.join(","),
        catId,
        subCatId.join(","),
        typeOfWorkController.text,
        callOut,
        publicLiability,
        workUndertaken,
        serviceDescribeController.text,
        ctr.image.value,
        widget.companyType);
    successms = msg;

    return successms;
  }

  late String successms;
  static dynamic getListMap(List<dynamic> items) {
    if (items == null) {
      return null;
    }
    List<Map<String, dynamic>> list = [];
    items.forEach((element) {
      list.add(element.toMap());
    });
    return list;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,10000}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Widget _nextButton(BuildContext context, StateSetter setsate) {
    return GestureDetector(
      onTap: () async {
        var formData = dio.FormData();

        var totdatat = {
          "company_id": widget.companyId,
          "full_name": nameController.text,
          "user_id": CurrentUser().currentUser.memberID,
          "email": emailController.text,
          "contact_number": contactController.text,
          'alternative_contact_number': alternativContact.text,
          'profile_image': '',
          'experience': experienceController.text,
          "country_id": countyid,
          'location': locationController.text,
          "work_category": catId,
          "service_description": serviceDescribeController.text,
          "work_type": typeOfWorkController.text,
          "call_out": 'yes',
          "insurance": ctr.workUndertaking.value ? 'Yes' : 'No',
          "undertaken": ctr.workUndertaking.value ? 'Yes' : 'No',
          "work_area": jsonEncode(workAreaId),
          "work_subcategory": jsonEncode(subCatId)
        };

        totdatat.forEach((key, value) {
          formData.fields.add(MapEntry(key, value!));
        });

        var url = 'http://www.bebuzee.com/api/tradesmen/addCompanyTradesmen';
        var datas = await ApiProvider()
            .fireApiWithParamsPost(url, formdata: formData)
            .then((value) => value.data);
        print("datas=${totdatat}");
        successExit();
        return;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TradesmanPaymentView(),
        ));

        // return;
        print("object.. error 11 ");
        ctr.availabel.isTrue ? callOut = 1 : callOut = 0;
        ctr.publiclibelity.isTrue ? publicLiability = 1 : publicLiability = 0;
        ctr.workUndertaking.isTrue ? workUndertaken = 1 : workUndertaken = 0;
        print("object.. error 12 ");
        if (widget.preFillData.length > 0 &&
            nameController.text == widget.preFillData[2] &&
            ctr.image.value.path == widget.preFillData[1] &&
            contactController.text == widget.preFillData[3] &&
            alternativContact.text == widget.preFillData[4] &&
            emailController.text == widget.preFillData[5] &&
            experienceController.text == widget.preFillData[6] &&
            countyid == widget.preFillData[7] &&
            locationController == widget.preFillData[8] &&
            workArea.join(",") == widget.preFillData[9] &&
            catId == widget.preFillData[10] &&
            subCatId.join(",") == widget.preFillData[11] &&
            typeOfWorkController.text == widget.preFillData[12] &&
            callOut == int.parse(widget.preFillData[13]) &&
            publicLiability == int.parse(widget.preFillData[14]) &&
            workUndertaken == int.parse(widget.preFillData[15]) &&
            serviceDescribeController.text == widget.preFillData[16] &&
            ctr.albumAdded.isFalse &&
            ctr.imageAdded.isFalse) {
          print("object.. error 13 ");
          errorView("Not update yet..!");
        } else if (validation()) {
          print("object.. error ,, ");
          waitDialog(context);

          widget.preFillData.length > 0
              ? await OnUpdateData()
              : await OnAddData();
          navigator!.pop(context);

          if (successms == 'false') {
            errorDialog(
              context,
              "Please Fill in all Required Fields!",
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
              "${successms.toString()}",
              // "Tradesmen company added successfully",
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
          AppLocalizations.of(
              widget.preFillData.length > 0 ? "Update" : "Done"),
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
      ),
    );
  }

  bool validation() {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    String patttern1 = r'([0-9])';
    RegExp regExp1 = new RegExp(patttern1);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);
    if (ctr.image.value.path.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select Profile Picture"),
          "Error", Icons.error, Colors.red);
      return false;
    } else if (nameController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Your Full Name"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (contactController.text.length < 1) {
      _customErrorTextCard(
          "Enter Your Contact Number", "Error", Icons.error, Colors.red);
      return false;
    } else if (!regExp.hasMatch(contactController.text)) {
      _customErrorTextCard(
          "Enter Valid Contact Number", "Error", Icons.error, Colors.red);
      return false;
    } else if (alternativContact.text.length < 1) {
      _customErrorTextCard(
          AppLocalizations.of("Enter Alternative Contact Number"),
          "Error",
          Icons.error,
          Colors.red);
      return false;
    } else if (emailController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Email-Id"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (emailValid != true) {
      _customErrorTextCard(AppLocalizations.of("Enter Valid Email-Id"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (experienceController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Yours Exprience years"),
          "Error", Icons.error, Colors.red);
      return false;
    } else if ((!regExp1.hasMatch(experienceController.text)) ||
        (experienceController.text.length > 2)) {
      _customErrorTextCard(
          AppLocalizations.of("Enter Valid Yours Exprience years"),
          "Error",
          Icons.error,
          Colors.red);
      return false;
    } else if (locationController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select Location"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (workArea.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select Work Area"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (catId.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select  Work Category"),
          "Error", Icons.error, Colors.red);
      return false;
    } else if (subCatId.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select SubWork Category"),
          "Error", Icons.error, Colors.red);
      return false;
    } else if (typeOfWorkController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Select Work Type"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (callOut == null) {
      _customErrorTextCard(AppLocalizations.of("Select Call Out"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (publicLiability == null) {
      _customErrorTextCard(AppLocalizations.of("Select Public Liability"),
          "Error", Icons.error, Colors.red);
      return false;
    } else if (workUndertaken == null) {
      _customErrorTextCard(
          AppLocalizations.of("Select Insurance Work Undertaken"),
          "Error",
          Icons.error,
          Colors.red);
      return false;
    } else if (serviceDescribeController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Service Description"),
          "Error", Icons.error, Colors.red);
      return false;
    }
    return true;
  }

  bool albumValidation() {
    if (albumTitleController.text.length < 1) {
      _customErrorTextCard(AppLocalizations.of("Enter Album Title"), "Error",
          Icons.error, Colors.red);
      return false;
    } else if (ctr.isalbumCoverPicked.isFalse) {
      _customErrorTextCard(AppLocalizations.of("Select Album Cover Picture"),
          "Error", Icons.error, Colors.red);
      return false;
    }
    return true;
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

          hintText: AppLocalizations.of(hintText),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
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
          : _selectionAlbumCard(AppLocalizations.of("Select Album Cover Image"),
              () {
              ctr.pickAlbumCoverImage();
            }),
    );
  }

  Future showSuccess(context, msg) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        // "Feedback added Successfully..",
        msg,
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
      messageText:
          Text(msg, style: TextStyle(color: Colors.white, fontSize: 20)),
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
                AppLocalizations.of('Create') +
                    ' ' +
                    AppLocalizations.of('Album'),
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
              AppLocalizations.of("Add") + " " + AppLocalizations.of("title"),
              albumTitleController),
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
                            "0",
                            widget.preFillData[17],
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
                                await ctr.fetchAlubmList(
                                    comId: 0,
                                    trdId: int.parse(widget.preFillData[17]),
                                    setsate: setStat);
                                showSuccess(context, mssg);
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
      width: 150,
      child: GestureDetector(
        onTap: () async {
          dialog1(context, setstat);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
              ),
              Text(
                AppLocalizations.of("Add") + " " + AppLocalizations.of("Album"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageCard(String image) {
    return Container(
      // margin: EdgeInsets.only(right: 5, left: 5),
      height: 60,
      width: 60,
      // color: settingsColor,
      child: CircleAvatar(
        backgroundColor: settingsColor,
        child: ClipOval(
          child: Image.network(
            image.toString(),
            fit: BoxFit.fill,
            height: 60,
            width: 60,
          ),
        ),
      ),
    );
  }

  Widget albumListView() {
    return StatefulBuilder(
        builder: (context, setStat) => Container(
              // height: 200,
              // width: 200,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                  itemCount: ctr.lstAlubmData.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                          setStat(
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddImageAlbumView(
                                          ctr.lstAlubmData[index].albumImage!,
                                          ctr.lstAlubmData[index].albumId!,
                                          "",
                                          ctr.lstAlubmData[index]
                                              .albumName!))).then(
                                  (value) => setStat(
                                        () {
                                          ctr.fetchAlubmList(
                                              comId: 0,
                                              trdId: int.parse(
                                                  widget.preFillData[17]));
                                        },
                                      ));
                            },
                          );
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

  Widget _showAlbumView(StateSetter setstat) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          albumView(setstat),
          ctr.lstAlubmData.length > 0
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: _headerCard(AppLocalizations.of("Albums") + " *"),
                )
              : Container(),
          ctr.lstAlubmData.length > 0 ? albumListView() : Container(),
        ],
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
          AppLocalizations.of(widget.preFillData.length > 0
              ? AppLocalizations.of("Update") +
                  " " +
                  AppLocalizations.of("Tradesmen")
              : AppLocalizations.of("Add") +
                  " " +
                  AppLocalizations.of("Tradesmen")),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Get.delete<AddTradesmenController>();
          return true;
          // goBack
        },
        child: SingleChildScrollView(
          child: Container(
              // height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  _headerCard(AppLocalizations.of("Personal") +
                      " " +
                      AppLocalizations.of("Infomation") +
                      " *"),
                  widget.preFillData == null || widget.preFillData.length == 0
                      ? _selectionCard(
                          AppLocalizations.of("Select") +
                              " " +
                              AppLocalizations.of("Profile") +
                              " " +
                              AppLocalizations.of("Picture"), () {
                          ctr.pickImage();
                        })
                      : (ctr.image.value.path.isEmpty)
                          ? _selectionCard(
                              AppLocalizations.of("Select") +
                                  " " +
                                  AppLocalizations.of("Profile") +
                                  " " +
                                  AppLocalizations.of("Picture"), () {
                              ctr.pickImage();
                            })
                          : _selectionCard2(),
                  _customTextFieldNew(
                      AppLocalizations.of("Enter") +
                          " " +
                          AppLocalizations.of("Your") +
                          " " +
                          AppLocalizations.of("Name"),
                      nameController),
                  _customTextFieldNumber(
                      AppLocalizations.of("Contact") +
                          " " +
                          AppLocalizations.of("Number"),
                      contactController),
                  _customTextFieldNumber(
                      AppLocalizations.of("Alternative") +
                          " " +
                          AppLocalizations.of("Contact") +
                          " " +
                          AppLocalizations.of("Number"),
                      alternativContact),
                  _customTextFieldNew(
                      AppLocalizations.of("Enter") +
                          " " +
                          AppLocalizations.of("Email"),
                      emailController),
                  widget.preFillData.length > 0 && widget.preFillData[0] == "0"
                      ? _showAlbumView(setState)
                      : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(AppLocalizations.of(
                        "How many years of Experience in this filed ?")),
                  ),
                  _customTextFieldNew(
                      AppLocalizations.of("Experience"), experienceController),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(AppLocalizations.of("Your") +
                        " " +
                        AppLocalizations.of("Location") +
                        " * "),
                  ),
                  Obx(
                    () => _customSelectButton(
                      AppLocalizations.of(ctr.currentCountry.value == ''
                          ? ctr.select + " (e.g. UK)"
                          : ctr.currentCountry.value),
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
                        locationController.text = returnData['city'];
                      });
                    } else {
                      _customErrorTextCard(
                          AppLocalizations.of("Select Country"),
                          "Error",
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
                        workLoctionController.text = returnData['city'];
                        workLoctionIdController.text = returnData['area_id'];
                        !workArea.contains(workLoctionController.text) &&
                                workLoctionController.text != ""
                            ? workArea = [
                                workLoctionController.text,
                                ...workArea
                              ]
                            : null;
                        !workAreaId.contains(workLoctionIdController.text) &&
                                workLoctionIdController.text != ""
                            ? workAreaId = [
                                workLoctionIdController.text,
                                ...workAreaId
                              ]
                            : null;
                        print("workarea=${workArea}");
                        print("Loction === " + workArea.toString());
                      });
                    } else {
                      _customErrorTextCard(
                          AppLocalizations.of("Select Country"),
                          "Error",
                          Icons.error,
                          Colors.red);
                    }
                  }),
                  workArea.length > 0
                      ? _customWorkList(workArea, type: 'workarea')
                      : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(AppLocalizations.of("Work") +
                        " " +
                        AppLocalizations.of("Category") +
                        " *"),
                  ),
                  Obx(
                    () => ctr.lstWorkCat1.length > 0
                        ? dropDown9(context)
                        : Container(),
                  ),
                  Obx(
                    () => ctr.lstWorksubCat.length > 0
                        ? dropDown2(context)
                        : catId.isNotEmpty
                            ? CircularProgressIndicator()
                            : Container(),
                  ),
                  subCat.length > 0 ? _customWorkList(subCat) : Container(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(AppLocalizations.of("Type") +
                        " " +
                        AppLocalizations.of("of") +
                        " " +
                        AppLocalizations.of("Work") +
                        " *"),
                  ),
                  _customTypeWorkData(),
                  Obx(() => _customYesNoRow(
                      AppLocalizations.of("24 " +
                              AppLocalizations.of("Hour") +
                              " " +
                              AppLocalizations.of("Call-Out")) +
                          " *",
                      ctr.availabel.value,
                      ctr.updateAvailabel)),
                  Obx(() => _customYesNoRow(
                      AppLocalizations.of("Public") +
                          " " +
                          AppLocalizations.of("Liability") +
                          " " +
                          AppLocalizations.of("Insurance") +
                          " *",
                      ctr.publiclibelity.value,
                      ctr.updatepublic)),
                  Obx(() => _customYesNoRow(
                      AppLocalizations.of("Insurance") +
                          " " +
                          AppLocalizations.of("work") +
                          " " +
                          AppLocalizations.of("undertaken") +
                          " *",
                      ctr.workUndertaking.value,
                      ctr.updateWorkUnderTaking)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _headerCard(AppLocalizations.of("Service") +
                        " " +
                        AppLocalizations.of("Description") +
                        " *"),
                  ),
                  _customTextFieldservice(
                      serviceDescribeController,
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
              )),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(0),
        child: _nextButton(context, setState),
      ),
    );
  }
}
