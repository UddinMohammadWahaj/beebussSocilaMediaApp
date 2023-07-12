import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/Tradesmen/new_add_company_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/tradesmanviews/searchtradesmenlocationpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../models/Properbuz/country_list_model.dart';
import '../../models/Tradesmen/CompanyTradesmenList.dart';
import '../../models/Tradesmen/newtradesmendetailmodel.dart';
import '../../services/Tradesmen/tradesmanapi.dart';
import 'companylist.dart';
import 'newsearchaddcompanytradesmen.dart';

class NewAddCompanyView extends StatefulWidget {
  CompanyListingController? companylistingctr;
  CompanyTradesmenListRecord? companyDetails;
  String? type;
  NewAddCompanyView(
      {Key? key, this.companylistingctr, this.companyDetails, this.type = ''})
      : super(key: key);

  @override
  State<NewAddCompanyView> createState() => _NewAddCompanyViewState();
}

class _NewAddCompanyViewState extends State<NewAddCompanyView> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AddTradesmenCompanyConttroller(
        companyDetails: widget.companyDetails, type: widget.type));

    void successExit() {
      widget.companylistingctr!.onRefresh();
      Navigator.of(context).pop();
      Get.snackbar('Success', 'Added company sccessfully ',
          duration: Duration(milliseconds: 650));
      Get.delete<AddTradesmenCompanyConttroller>();
    }

    Widget _headerCard(String header) {
      return Container(
          padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
          child: Text(
            AppLocalizations.of(header),
            style: TextStyle(
                fontSize: 14,
                color: settingsColor,
                fontWeight: FontWeight.w500),
          ));
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
          onTap: (() {}),
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

    _customErrorTextCard(
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

    showAlbumPhotoAdd(index) {
      showBarModalBottomSheet(
          enableDrag: false,
          expand: true,
          context: context,
          builder: (ctx) => Obx(
                () => Container(
                    height: 100.0.h,
                    child: controller
                                .currentPhotoAlbumList[index].images!.length ==
                            0
                        ? Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  controller.pickAlbumImages(index, setState);
                                },
                                child: Text('Add photos')),
                          )
                        : Column(
                            children: [
                              ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.close)),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0,
                                ),
                                itemCount: controller
                                    .currentPhotoAlbumList[index]
                                    .images!
                                    .length,
                                itemBuilder: (ctx, ind) => Container(
                                  height: 20.0.h,
                                  width: 50.0.w,
                                  child: Stack(
                                    children: [
                                      Card(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: CachedNetworkImageProvider(
                                                      'http://www.bebuzee.com/upload/images/properbuz/tradesmen/images' +
                                                          '/' +
                                                          controller
                                                              .currentPhotoAlbumList[
                                                                  index]
                                                              .images![ind]))),
                                          height: 20.0.h,
                                          width: 25.0.w,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // controller.currentPhotoAlbumList[index].images
                                          //     .removeAt(ind);
                                          showBarModalBottomSheet(
                                              context: context,
                                              builder: (ctx) => Container(
                                                    height: 20.0.h,
                                                    child: Column(children: [
                                                      // ListTile(
                                                      //   title: Text('Edit'),
                                                      //   trailing:
                                                      //       Icon(Icons.edit),
                                                      //   onTap: () {},
                                                      // ),
                                                      ListTile(
                                                        onTap: () {
                                                          controller
                                                              .currentPhotoAlbumList[
                                                                  index]
                                                              .images!
                                                              .removeAt(ind);
                                                        },
                                                        title: Text('Delete'),
                                                        trailing:
                                                            Icon(Icons.delete),
                                                      ),
                                                    ]),
                                                  ));
                                          // controller.currentPhotoAlbumList[index].images.refresh();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.black.withOpacity(0.3),
                                          child: Icon(Icons.more_vert,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                //  Stack(
                                //       children: [

                                //       ],
                                //     )
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    controller.pickAlbumImages(index, setState);
                                  },
                                  child: Text('Add More'))
                              // Card(
                              //   child: ListTile(
                              //     leading: Icon(Icons.add_a_photo_outlined),
                              //     title: Text('Add More'),
                              //   ),
                              // )
                            ],
                          )),
              ));
    }

    showPopUpAlbum(index) {
      showBarModalBottomSheet(
          context: context,
          builder: (ctx) => Container(
              height: 25.0.h,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Add photos'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showAlbumPhotoAdd(index);
                    },
                    trailing: Icon(Icons.add_a_photo_outlined),
                  ),
                  ListTile(
                    title: Text('Delete album'),
                    onTap: () async {
                      if (widget.type == 'edit') {
                        await TradesmanApi.deleteTradesmenAlbum(
                            controller.currentPhotoAlbumList[index].id);
                      }
                      controller.albumCoverList.removeAt(index);
                      controller.albumCoverList.refresh();
                    },
                    trailing: Icon(Icons.delete),
                  ),
                ],
              )));
    }

    Widget photoAlbumList() {
      return Obx(() => controller.currentPhotoAlbumList.value.length == 0
          ? Container()
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.currentPhotoAlbumList.value.length,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                          'http://www.bebuzee.com/upload/images/properbuz/tradesmen/images' +
                              '/' +
                              controller
                                  .currentPhotoAlbumList[index].albumPic!),
                    ),
                    title: Text(
                        '${controller.currentPhotoAlbumList[index].albumName}'),
                    trailing: IconButton(
                        onPressed: () {
                          showPopUpAlbum(index);
                        },
                        icon: Icon(Icons.more_vert_sharp)),
                  ),
                );
              })));
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

    Widget _headerCardloc1(String header) {
      return Container(
          padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
          child: Text(
            AppLocalizations.of(header),
            style: TextStyle(
                fontSize: 14,
                color: settingsColor,
                fontWeight: FontWeight.w500),
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
            // setState(() {
            //   print("here... $value");
            //   ctr.currentCountry.value = "";
            // });
          },
          onChanged: (v) {
            // print("here ${textcontroller.text}");
            controller.updateCountryList(v);
            // ctr.updateCountryList(v);
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
                      controller.searchCountryloc,
                      AppLocalizations.of("Enter") +
                          " " +
                          AppLocalizations.of("Country"),
                      50.0),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: h,
                      child: Obx(() => controller
                                  .searchCountryloc.text.isEmpty &&
                              controller.searchCountryList.length == 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataList.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  controller.currentCountry.value = [
                                    dataList[index]
                                  ];
                                  Navigator.of(context).pop();
                                  // ctr.currentCountry.value =
                                  //     dataList[index].country;
                                  // ctr.currentCountryIndex.value = index;
                                  // countyid = dataList[index].countryID;

                                  // print("id -==1 ${countyid}");

                                  // Navigator.of(Get.context).pop();
                                  // ctr.currentCountryIndex.value = 0;
                                },
                                title: Text(
                                  AppLocalizations.of(dataList[index].country!),
                                  style: TextStyle(
                                      color:
                                          //  (
                                          //   index ==
                                          //         ctr.currentCountryIndex.value
                                          //         )
                                          //     ? Colors.white
                                          //     :

                                          Colors.black),
                                ),
                                tileColor:
                                    // (index == ctr.currentCountryIndex.value)
                                    //     ? settingsColor
                                    //     :
                                    Colors.transparent,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.searchCountryList.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  controller.currentCountry.value = [
                                    controller.searchCountryList[index]
                                  ];
                                  // ctr.currentCountry.value =
                                  //     ctr.searchCountryList[index].country;
                                  // ctr.currentCountryIndex.value = index;
                                  // countyid =
                                  //     ctr.searchCountryList[index].countryID;
                                  controller.searchCountryloc.clear();

                                  // print("id -== ${countyid}");

                                  Navigator.of(Get.context!).pop();
                                  // ctr.currentCountryIndex.value = 0;
                                },
                                title: Text(
                                  AppLocalizations.of(controller
                                      .searchCountryList[index].country!),
                                  style: TextStyle(
                                      color:
                                          //  (index ==
                                          //         controller.currentCountryIndex.value)
                                          //     ? Colors.white
                                          // :
                                          Colors.black),
                                ),
                                tileColor:
                                    // (index == ctr.currentCountryIndex.value)
                                    //     ? settingsColor
                                    //     :

                                    Colors.transparent,
                              ),
                            ))),
                ],
              ),
            )),
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

    Widget errorText(msg) {
      return Container(
        width: 100.0.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            msg + ' is required',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.left,
          ),
        ),
      );
    }

    showAlbumAdd() {
      showBarModalBottomSheet(
          context: context,
          builder: (context) => Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            controller.albumCoverList.value = [];
                            Navigator.of(context).pop();
                          }),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _headerCard(AppLocalizations.of("Enter") +
                          " " +
                          AppLocalizations.of("Album name") +
                          " *"),
                    ),
                    _customTextFieldNew(AppLocalizations.of("Album name"),
                        controller.tradesmenalbumnamecontroller),
                    Text(
                      'Album name is required*',
                      style: TextStyle(color: Colors.red),
                    ),
                    Card(
                      child: Obx(
                        () => ListTile(
                          leading: controller.albumCoverList.value.length != 0
                              ? CircleAvatar(
                                  backgroundImage: FileImage(
                                  controller.albumCoverList[0],
                                ))
                              //  Container(
                              //     height: 12.0.h,
                              //     width: 17.0.w,

                              //     decoration: BoxDecoration(
                              //         image: DecorationImage(
                              //             fit: BoxFit.cover,
                              //             image: FileImage(
                              //                 ctr.albumCoverList[
                              //                     0]))),
                              //   )
                              : Icon(Icons.image),
                          title: Text(
                              controller.albumCoverList.value.length != 0
                                  ? 'Album Cover added'
                                  : 'Select album cover image',
                              style: TextStyle(color: Colors.grey)),
                          trailing: controller.albumCoverList.length != 0
                              ? Icon(Icons.edit)
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                          onTap: () {
                            controller.pickAlbumCover();
                          },
                        ),
                      ),
                    ),
                    Text(
                      'Album cover imageg is required*',
                      style: TextStyle(color: Colors.red),
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (controller.albumCoverList.length == 0 ||
                                controller.tradesmenalbumnamecontroller.text
                                    .isEmpty) {
                              Get.snackbar(
                                  'Error', 'Enter the required details',
                                  backgroundColor: Colors.white,
                                  duration: Duration(milliseconds: 500));

                              return;
                            }
                            controller.addtoTradesmenAlbum();

                            Navigator.of(context).pop();
                          },
                          child: Text('Done')),
                    )
                  ],
                ),
              ));
    }

    return WillPopScope(
      onWillPop: () async {
        Get.delete<AddTradesmenCompanyConttroller>();
        print("getx controller removed");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.type == "edit" ? 'Update Company' : 'Add Company'),
          backgroundColor: settingsColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _headerCard(
                    AppLocalizations.of("Company Information") + " *"),
              ),
              _customTextFieldNew(
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Company Name"),
                  controller.nameController),
              errorText('Company name'),
              widget.type == 'edit'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => controller.companyCoverEdit.value.length ==
                                    0 &&
                                controller.companyCover.length == 0
                            ? _selectionCard(
                                AppLocalizations.of("Select cover picture "),
                                () {
                                controller.pickCompanyCover();
                              })
                            : controller.companyCover.length != 0
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          decoration: new BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            // color: Colors.grey.shade200,
                                            shape: BoxShape.rectangle,
                                            border: new Border.all(
                                              color: settingsColor,
                                              width: 0.5,
                                            ),
                                          ),
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.1,
                                          child: Image.file(
                                            controller.companyCover[0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            child: CircleAvatar(
                                          backgroundColor:
                                              Colors.black.withOpacity(0.3),
                                          radius: 4.0.w,
                                          child: IconButton(
                                            icon: Icon(Icons.close,
                                                color: Colors.white,
                                                size: 4.0.w),
                                            onPressed: () {
                                              controller.companyCover.value =
                                                  [];
                                            },
                                          ),
                                        ))
                                      ],
                                    ),
                                  ))
                                : Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          decoration: new BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            // color: Colors.grey.shade200,
                                            shape: BoxShape.rectangle,
                                            border: new Border.all(
                                              color: settingsColor,
                                              width: 0.5,
                                            ),
                                          ),
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.1,
                                          child: Image.network(
                                            controller.companyCoverEdit[0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            child: CircleAvatar(
                                          backgroundColor:
                                              Colors.black.withOpacity(0.3),
                                          radius: 4.0.w,
                                          child: IconButton(
                                            icon: Icon(Icons.close,
                                                color: Colors.white,
                                                size: 4.0.w),
                                            onPressed: () {
                                              controller
                                                  .companyCoverEdit.value = [];
                                            },
                                          ),
                                        ))
                                      ],
                                    ),
                                  ))),
                        Obx(() => controller.companyLogoEdit.value.length ==
                                    0 &&
                                controller.companyLogo.value.length == 0
                            ? _selectionCard(
                                AppLocalizations.of("Select company logo "),
                                () {
                                controller.pickCompanyLogo();
                                // ctr.pickImage();
                              })
                            : controller.companyLogo.value.length != 0
                                ? Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                // color: Colors.grey.shade200,
                                                shape: BoxShape.rectangle,
                                                border: new Border.all(
                                                  color: settingsColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.1,
                                              child: Image.file(
                                                controller.companyLogo[0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                                child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.3),
                                              radius: 4.0.w,
                                              child: IconButton(
                                                icon: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 4.0.w),
                                                onPressed: () {
                                                  controller.companyLogo.value =
                                                      [];
                                                },
                                              ),
                                            ))
                                          ],
                                        )))
                                : Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                // color: Colors.grey.shade200,
                                                shape: BoxShape.rectangle,
                                                border: new Border.all(
                                                  color: settingsColor,
                                                  width: 0.5,
                                                ),
                                              ),
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.1,
                                              child: Image.network(
                                                controller.companyLogoEdit[0],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                                child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.3),
                                              radius: 4.0.w,
                                              child: IconButton(
                                                icon: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 4.0.w),
                                                onPressed: () {
                                                  controller.companyLogoEdit
                                                      .value = [];
                                                },
                                              ),
                                            ))
                                          ],
                                        ))))
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => controller.companyCover.value.length == 0
                            ? _selectionCard(
                                AppLocalizations.of("Select cover picture "),
                                () {
                                controller.pickCompanyCover();
                              })
                            : Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    // color: Colors.grey.shade200,
                                    shape: BoxShape.rectangle,
                                    border: new Border.all(
                                      color: settingsColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width / 3.1,
                                  child: Image.file(
                                    controller.companyCover[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))),
                        Obx(() => controller.companyLogo.value.length == 0
                            ? _selectionCard(
                                AppLocalizations.of("Select company logo "),
                                () {
                                controller.pickCompanyLogo();
                                // ctr.pickImage();
                              })
                            : Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    // color: Colors.grey.shade200,
                                    shape: BoxShape.rectangle,
                                    border: new Border.all(
                                      color: settingsColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width / 3.1,
                                  child: Image.file(
                                    controller.companyLogo[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )))
                      ],
                    ),
              errorText('Company cover and logo'),
              _customTextFieldNew(
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Company Email"),
                  controller.emailController),
              errorText('Company Email'),
              _customTextFieldNew(
                  AppLocalizations.of("Enter") +
                      " " +
                      AppLocalizations.of("Company Contact No"),
                  controller.contactcontroller),
              errorText('Company Contact'),
              _customTextFieldNew(AppLocalizations.of(" Website"),
                  controller.websiteController),
              errorText('Company Website'),
              Align(
                alignment: Alignment.centerLeft,
                child:
                    _headerCard(AppLocalizations.of("Company Location") + " *"),
              ),
              Obx(
                () => _customSelectButton(
                  AppLocalizations.of(
                      controller.currentCountry.value.length == 0
                          ? "Select country (e.g. UK)"
                          : controller.currentCountry.value[0].country!),
                  () async {
                    controller.iconLoadCountry.value = true;
                    customBarBottomSheetCountryList(Get.size.height / 1.5,
                        AppLocalizations.of('Country'), controller.countryList);
                    // controller.fetchCountry(() async {
                    //   customBarBottomSheetCountryList(
                    //       Get.size.height / 1.5,
                    //       AppLocalizations.of('Country'),
                    //       controller.countryList);
                    // }, countryId: controller.currentCountryIid);
                  },
                ),
              ),
              errorText('Company Country'),
              _customTextField2(
                  AppLocalizations.of("Select") +
                      " " +
                      AppLocalizations.of("Location"),
                  Icons.location_on_rounded,
                  controller.locationController, (() async {
                if (controller.currentCountry[0].country!.isNotEmpty) {
                  controller.locationFieldController.clear();
                  controller.locationtext.value = "";
                  controller.currentCountry.value =
                      controller.currentCountry.value;
                  var returnData = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return NewSearchAddCompanyTradesmenLocationSearchPage(
                        controller.currentCountry[0].country!,
                        AppLocalizations.of("Location"));
                  }));

                  setState(() {
                    controller.locationController.text = returnData['city'];
                  });
                } else {
                  _customErrorTextCard(AppLocalizations.of("Select Country"),
                      "Error", Icons.error, Colors.red);
                }
              })),
              errorText('Company Location'),
              _customTextField2(
                  AppLocalizations.of("Select") +
                      " " +
                      AppLocalizations.of("Work Area"),
                  Icons.location_on_rounded,
                  controller.workarealocationController, (() async {
                if (controller.currentCountry[0].country!.isNotEmpty) {
                  controller.locationFieldController.clear();
                  controller.locationtext.value = "";
                  controller.currentCountry.value =
                      controller.currentCountry.value;
                  var returnData = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return NewSearchAddCompanyTradesmenLocationSearchPage(
                        controller.currentCountry[0].country!,
                        AppLocalizations.of("Location"));
                  }));
                  if (returnData != null) {
                    controller.workArea.add(returnData);
                    print("added workarea=${returnData}");

                    // setState(() {
                    //   controller.locationController.text =
                    //       returnData['city'];
                    // });
                  }
                } else {
                  _customErrorTextCard(AppLocalizations.of("Select Country"),
                      "Error", Icons.error, Colors.red);
                }
              })),
              errorText('Company Work area'),
              Obx(
                () => controller.workArea.length == 0
                    ? Container()
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.workArea.length,
                        itemBuilder: (ctx, index) => Card(
                              color: Colors.grey.shade100,
                              child: ListTile(
                                title:
                                    Text(controller.workArea[index].city ?? ""),
                                trailing: IconButton(
                                    onPressed: () {
                                      controller.workArea.removeAt(index);
                                    },
                                    icon: Icon(Icons.close)),
                              ),
                            )),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child:
                    _headerCard(AppLocalizations.of("Manager Details") + " *"),
              ),
              _customTextFieldNew(AppLocalizations.of("Manager Name"),
                  controller.managerNameController),
              errorText('Manager Name'),
              _customTextFieldNew(AppLocalizations.of("Manager Contact Number"),
                  controller.managerContactNoController),
              Align(
                alignment: Alignment.centerLeft,
                child: _headerCard(AppLocalizations.of("Photo") +
                    " " +
                    AppLocalizations.of("Album") +
                    " *"),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Add Album'),
                  onTap: () {
                    showAlbumAdd();
                  },
                ),
              ),
              photoAlbumList(),
              Align(
                alignment: Alignment.centerLeft,
                child: _headerCard(AppLocalizations.of("Service") +
                    " " +
                    AppLocalizations.of("Description") +
                    " *"),
              ),
              _customTextFieldservice(
                  controller.serviceDescribeController,
                  AppLocalizations.of("Describe") +
                      " " +
                      AppLocalizations.of("your") +
                      " " +
                      AppLocalizations.of("Service"),
                  125),
              errorText('Service Description'),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            color: settingsColor,
            height: 7.0.h,
            width: 100.0.w,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(settingsColor)),
                onPressed: () async {
                  if (widget.type == "edit") {
                    if (controller.nameController.text.isEmpty ||
                        controller.emailController.text.isEmpty ||
                        controller.websiteController.text.isEmpty ||
                        controller.currentCountry.length == 0 ||
                        controller.locationtext.isEmpty ||
                        controller.contactcontroller.text.isEmpty ||
                        controller.workArea.length == 0) {
                      print(
                          "datas=${((controller.companyCover.length == 0) ^ (controller.companyCoverEdit.length == 0))}${controller.emailController.text.isEmpty}${controller.websiteController.text.isEmpty}${controller.currentCountry.length == 0}");
                      Get.snackbar('Error', 'Enter the required fields',
                          backgroundColor: Colors.white,
                          duration: Duration(milliseconds: 700));

                      return;
                    }
                    if (((controller.companyCover.length == 0) ^
                            (controller.companyCoverEdit.length == 0)) ==
                        false) {
                      Get.snackbar('Error', 'Enter the required fields',
                          backgroundColor: Colors.white,
                          duration: Duration(milliseconds: 700));

                      return;
                    }
                    if (((controller.companyLogo.length == 0) ^
                            (controller.companyLogoEdit.length == 0)) ==
                        false) {
                      Get.snackbar('Error', 'Enter the required fields',
                          backgroundColor: Colors.white,
                          duration: Duration(milliseconds: 700));

                      return;
                    }
                    var url =
                        'http://www.bebuzee.com/api/tradesmen/updateCompany';

                    var albumdata = [];
                    for (int i = 0;
                        i < controller.currentPhotoAlbumList.length;
                        i++) {
                      var listofimages =
                          controller.currentPhotoAlbumList[i].images;
                      var data = AlbumDatum2(
                          id: controller.currentPhotoAlbumList[i].id == null
                              ? ''
                              : controller.currentPhotoAlbumList[i].id
                                  .toString(),
                          albumName:
                              controller.currentPhotoAlbumList[i].albumName,
                          albumPic:
                              controller.currentPhotoAlbumList[i].albumPic,
                          images: '');
                      var csv = '';
                      for (var i in listofimages!) {
                        csv += i + ',';
                      }
                      data.images = csv.substring(0, csv.length - 1);
                      controller.currentPhotoAlbumList2.add(data);
                    }
                    controller.currentPhotoAlbumList2.forEach((element) {
                      albumdata.add(jsonEncode(element.toJson()));
                    });
                    var formData = dio.FormData();
                    var data = {
                      "company_id":
                          controller.companyDetails!.companyId.toString(),
                      "company_name": controller.nameController.text,
                      "user_id": CurrentUser().currentUser.memberID,
                      "company_email": controller.emailController.text,
                      "company_website": controller.websiteController.text,
                      "country_id": controller.currentCountry[0].countryID,
                      "company_location": controller.locationtext.value,
                      "company_contact_number":
                          controller.contactcontroller.text,
                      "manager_name": controller.managerNameController.text,
                      "manager_contact_number":
                          controller.managerContactNoController.text,
                      "service_description":
                          controller.serviceDescribeController.text,
                      "album_media": albumdata.toString(),
                      "work_area": controller.workArea.length > 0
                          ? jsonEncode(controller.workArea
                              .map((element) => element.areaId)
                              .toList())
                          : jsonEncode([]),
                    };
                    data.forEach((key, value) {
                      formData.fields.add(MapEntry(key, value!));
                    });
                    print("dataSend=$data ");
                    if (controller.companyCover.length != 0)
                      formData.files.add(MapEntry(
                          'company_cover_photo',
                          await dio.MultipartFile.fromFile(
                              controller.companyCover[0].path)));

                    if (controller.companyLogo.length != 0)
                      formData.files.add(MapEntry(
                          'company_logo',
                          await dio.MultipartFile.fromFile(
                              controller.companyLogo[0].path)));
                    var response = await ApiProvider()
                        .fireApiWithParamsPost(url, formdata: formData)
                        .then((value) => value);
                    if (response.data['status'] == 1) {
                      print("dataSend=$data  ${response.data}");
                      successExit();
                    }
                    return;
                  }
                  if (controller.nameController.text.isEmpty ||
                      controller.emailController.text.isEmpty ||
                      controller.websiteController.text.isEmpty ||
                      controller.currentCountry.length == 0 ||
                      controller.locationtext.isEmpty ||
                      controller.contactcontroller.text.isEmpty ||
                      controller.companyCover.length == 0 ||
                      controller.companyLogo.length == 0 ||
                      controller.workArea.length == 0) {
                    Get.snackbar('Error', 'Enter the required fields',
                        backgroundColor: Colors.white,
                        duration: Duration(milliseconds: 650));

                    return;
                  }
                  var url = 'http://www.bebuzee.com/api/tradesmen/storeCompany';
                  var albumdata = [];
                  for (int i = 0;
                      i < controller.currentPhotoAlbumList.length;
                      i++) {
                    var listofimages =
                        controller.currentPhotoAlbumList[i].images;
                    var data = AlbumDatum2(
                        id: controller.currentPhotoAlbumList[i].id == null
                            ? ''
                            : controller.currentPhotoAlbumList[i].id.toString(),
                        albumName:
                            controller.currentPhotoAlbumList[i].albumName,
                        albumPic: controller.currentPhotoAlbumList[i].albumPic,
                        images: '');
                    var csv = '';
                    for (var i in listofimages!) {
                      csv += i + ',';
                    }
                    data.images = csv.substring(0, csv.length - 1);
                    controller.currentPhotoAlbumList2.add(data);
                  }
                  controller.currentPhotoAlbumList2.forEach((element) {
                    albumdata.add(jsonEncode(element.toJson()));
                  });
                  var formData = dio.FormData();
                  var data = {
                    "company_name": controller.nameController.text,
                    "user_id": CurrentUser().currentUser.memberID,
                    "company_email": controller.emailController.text,
                    "company_website": controller.websiteController.text,
                    "country_id": controller.currentCountry[0].countryID,
                    "company_location": controller.locationtext.value,
                    "company_contact_number": controller.contactcontroller.text,
                    "manager_name": controller.managerNameController.text,
                    "manager_contact_number":
                        controller.managerContactNoController.text,
                    "service_description":
                        controller.serviceDescribeController.text,
                    "album_media": albumdata.toString(),
                    "work_area": controller.workArea.length > 0
                        ? jsonEncode(controller.workArea
                            .map((element) => element.areaId)
                            .toList())
                        : jsonEncode([]),
                  };
                  data.forEach((key, value) {
                    formData.fields.add(MapEntry(key, value!));
                  });
                  print("dataSend=$data ");

                  if (controller.companyCover.length != 0) {
                    print("company cover=${controller.companyCover[0].path}");
                    formData.files.add(MapEntry(
                        'company_cover_photo',
                        await dio.MultipartFile.fromFile(
                            controller.companyCover[0].path)));
                  }

                  if (controller.companyLogo.length != 0)
                    formData.files.add(MapEntry(
                        'company_logo',
                        await dio.MultipartFile.fromFile(
                            controller.companyLogo[0].path)));
                  var response = await ApiProvider()
                      .fireApiWithParamsPost(url, formdata: formData)
                      .then((value) => value);
                  if (response.data['status'] == 1) {
                    print("dataSend=$data  ${response.data}");
                    successExit();
                  }
                },
                child: Text(
                    widget.type == "edit" ? 'Update Company' : 'Add Company'))),
      ),
    );
  }
}
