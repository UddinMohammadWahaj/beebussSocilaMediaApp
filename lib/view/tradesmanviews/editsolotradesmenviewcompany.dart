import 'dart:convert';

import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/tradesmanviews/searchtradesmenlocationpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../api/api.dart';
import '../../models/Properbuz/country_list_model.dart';
import '../../models/Tradesmen/newtradesmendetailmodel.dart';
import '../../models/Tradesmen/tradesmen_subcat_model.dart';
import '../../models/Tradesmen/tradesmens_work_category_model.dart';
import '../../services/Tradesmen/edit_tradesmen_controller.dart';
import '../../services/current_user.dart';
import '../../utilities/colors.dart';

class EditSoloTradesmenViewCompany extends StatefulWidget {
  String? tradesmenId;
  String? from;
  String? companyId;
  EditSoloTradesmenViewCompany(
      {Key? key, this.tradesmenId, this.from, this.companyId})
      : super(key: key);

  @override
  State<EditSoloTradesmenViewCompany> createState() =>
      _EditSoloTradesmenViewCompanyState();
}

class _EditSoloTradesmenViewCompanyState
    extends State<EditSoloTradesmenViewCompany> {
  get settingsColor => HexColor("#3c5f6e");

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(EditTradesmenController(
        from: widget.from, tradesmenId: widget.tradesmenId));
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

    Widget dropDownWorkCat(BuildContext context) {
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
                items: (controller.workCategoryList)
                    .map<DropdownMenuItem<WorkCategory>>((WorkCategory value) {
                  return DropdownMenuItem<WorkCategory>(
                    value: value,
                    child: Text(
                      AppLocalizations.of(value.tradeCatName!),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (val) async {
                  controller.currentWorkCategory.value = [val!];
                  controller.currentSubCategory.value = [];
                  controller.lstWorksubCat.value = [];
                  controller.fetchsubData(val!.tradeCatId!);
                },
                hint: Text(
                  AppLocalizations.of(
                          controller.currentWorkCategory[0].tradeCatName!) ??
                      "",
                  style: TextStyle(
                      fontSize:
                          controller.currentWorkCategory.length > 0 ? 16 : 14,
                      color: controller.currentWorkCategory.length > 0
                          ? Colors.black
                          : null),
                ),
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
              child:
                  DropdownButtonFormField<TradesmenSubCatModelWorkSubCategory>(
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
                items: controller.lstWorksubCat
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
                  var already = true;
                  for (var i in controller.selectedsbcat) {
                    if (i.tradeSubcatId == val!.tradeSubcatId) {
                      already = false;
                      break;
                    }
                  }
                  if (already) {
                    controller.selectedsbcat.add(val!);
                    controller.selectedsbcat.refresh();
                  }
                  setState(() {
                    // subCategoryId = val.tradeSubcatId;
                    // if (!subCat.contains(val.tradeSubcatName)) {
                    //   subCat = [val.tradeSubcatName, ...subCat];
                    // }
                    // if (!subCat.contains(val.tradeSubcatId)) {
                    //   subCatId = [val.tradeSubcatId, ...subCatId];
                    // }
                  });
                },
                hint: Obx(
                  () => Text(
                    AppLocalizations.of(controller.subcatvalue.value ?? ""),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget selectedSubCatBuilder() {
      return Obx(() => controller.selectedsbcat.length == 0
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.selectedsbcat.length,
              itemBuilder: (ctx, index) => ListTile(
                    leading:
                        Text(controller.selectedsbcat[index].tradeSubcatName!),
                    trailing: IconButton(
                        onPressed: () {
                          controller.selectedsbcat.removeAt(index);
                          controller.selectedsbcat.refresh();
                        },
                        icon: Icon(Icons.close)),
                  )));
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

    // showWorkArea(index) {
    //   showBarModalBottomSheet(context: context, builder: (ctx) {
    //     return NewSearchAddTradesmenLocationSearchPage('${controller.locationController.}', TextFiledData)
    //   });
    // }

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
                                                      controller
                                                              .tradesmendetail[
                                                                  0]
                                                              .albumImageUrl! +
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
                    onTap: () {
                      controller.albumCoverList.removeAt(index);
                      controller.albumCoverList.refresh();
                    },
                    trailing: Icon(Icons.delete),
                  ),
                ],
              )));
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
                      backgroundImage: CachedNetworkImageProvider(controller
                              .tradesmendetail[0].albumImageUrl! +
                          '/' +
                          controller.currentPhotoAlbumList[index].albumPic!),
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

    Widget _customTypeWorkData() {
      return Obx(
        () => Container(
          decoration: new BoxDecoration(
            color: HexColor("#f5f7f6"),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          width: 100.0.w - 20,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.textsWorkList.length,
            itemBuilder: (context, int index) {
              return ListTile(
                leading: IconButton(
                  onPressed: () {
                    controller.selectedWorkTypeIndex.value = index;
                    // typeOfWorkController.text = ctr.textsWorkList[selectIndex];
                    setState(() {
                      String text = controller.selectedWorkTypeIndex.value == 2
                          ? "${controller.textsWorkList[0]},${controller.textsWorkList[1]}"
                          : controller.textsWorkList[
                              controller.selectedWorkTypeIndex.value];
                      controller.typeOfWorkController.text = text;
                      print(
                          "here type=${controller.typeOfWorkController.text}");
                      controller.selectedWorkTypeIndex.refresh();
                    });
                  },
                  icon: Icon(
                    controller.selectedWorkTypeIndex.value == index
                        ? CupertinoIcons.checkmark_square
                        : CupertinoIcons.square,
                    color: settingsColor,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(controller.textsWorkList[index]),
                  style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ),
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

    return WillPopScope(
      onWillPop: () async {
        Get.delete<EditTradesmenController>();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: settingsColor,
          title: Text('Edit Tradesmen'),
        ),
        body: Obx(
          () => controller.tradesmendetail.length == 0
              ? Center(
                  child: loadingAnimation(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _headerCard(AppLocalizations.of("Personal") +
                          " " +
                          AppLocalizations.of("Infomation") +
                          " *"),
                      _customTextFieldNew(
                          AppLocalizations.of("Enter") +
                              " " +
                              AppLocalizations.of("Your") +
                              " " +
                              AppLocalizations.of("Name"),
                          controller.namcontroller),
                      _customTextFieldNew(
                          AppLocalizations.of("Contact") +
                              " " +
                              AppLocalizations.of("No"),
                          controller.contactcontroller),
                      _customTextFieldNew(
                          AppLocalizations.of("Alternative") +
                              " " +
                              AppLocalizations.of("No"),
                          controller.alternativecontactcontroller),
                      _customTextFieldNew(
                          AppLocalizations.of("Enter") +
                              " " +
                              AppLocalizations.of("Email"),
                          controller.emailController),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _headerCard(AppLocalizations.of(
                            "How many years of Experience in this filed ?")),
                      ),
                      _customTextFieldNew(AppLocalizations.of("Experience"),
                          controller.experiencecontroller),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _headerCard(AppLocalizations.of("Your") +
                            " " +
                            AppLocalizations.of("Location") +
                            " * "),
                      ),
                      Obx(
                        () => _customSelectButton(
                          AppLocalizations.of(
                              controller.currentCountry.value.length == 0
                                  ? " (e.g. UK)"
                                  : controller
                                      .currentCountry.value[0].country!),
                          () async {
                            controller.iconLoadCountry.value = true;
                            customBarBottomSheetCountryList(
                                Get.size.height / 1.5,
                                AppLocalizations.of('Country'),
                                controller.countryList);
                            // controller.fetchCountry(() async {
                            //   customBarBottomSheetCountryList(
                            //       Get.size.height / 1.5,
                            //       AppLocalizations.of('Country'),
                            //       controller.countryList);
                            // }, countryId: controller.currentCountryIid);
                          },
                        ),
                      ),
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
                            return NewSearchAddTradesmenLocationSearchPage(
                                controller.currentCountry[0].country!,
                                AppLocalizations.of("Location"));
                          }));

                          setState(() {
                            controller.locationController.text =
                                returnData['city'];
                          });
                        } else {
                          _customErrorTextCard(
                              AppLocalizations.of("Select Country"),
                              "Error",
                              Icons.error,
                              Colors.red);
                        }
                      })),
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
                            return NewSearchAddTradesmenLocationSearchPage(
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
                          _customErrorTextCard(
                              AppLocalizations.of("Select Country"),
                              "Error",
                              Icons.error,
                              Colors.red);
                        }
                      })),

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
                                        title: Text(
                                            controller.workArea[index].city),
                                        trailing: IconButton(
                                            onPressed: () {
                                              controller.workArea
                                                  .removeAt(index);
                                            },
                                            icon: Icon(Icons.close)),
                                      ),
                                    )),
                      ),

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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _headerCard(AppLocalizations.of("Work") +
                            " " +
                            AppLocalizations.of("Category") +
                            " *"),
                      ),
                      // _customTextFieldCountry(),

                      Obx(() => controller.workCategoryList.length > 0
                          ? dropDownWorkCat(context)
                          : Container()),
                      Obx(() => controller.lstWorksubCat.length > 0
                          ? dropDown2(context)
                          : Container()),
                      selectedSubCatBuilder(),
                      Obx(() => _customYesNoRow(
                            AppLocalizations.of("24 " +
                                    AppLocalizations.of("Hour") +
                                    " " +
                                    AppLocalizations.of("Call-Out")) +
                                " *",
                            controller.available24.value,
                            controller.updateAvailabel,
                          )),
                      Obx(() => _customYesNoRow(
                            AppLocalizations.of("Insurance") +
                                " " +
                                AppLocalizations.of("work") +
                                " " +
                                AppLocalizations.of("undertaken") +
                                " *",
                            controller.workUndertaking.value,
                            controller.updateWorkUnderTaking,
                          )),
                      Obx(() => _customYesNoRow(
                            AppLocalizations.of("Public") +
                                " " +
                                AppLocalizations.of("Liability") +
                                " " +
                                AppLocalizations.of("Insurance") +
                                " *",
                            controller.publicliability.value,
                            controller.updatePublic,
                          )),
                      widget.from == "company"
                          ? Container()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: _headerCard(AppLocalizations.of("Photo") +
                                  " " +
                                  AppLocalizations.of("Album") +
                                  " *"),
                            ),
                      widget.from == "company"
                          ? Container()
                          : Card(
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
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            if (widget.from == 'company') {
              var formData = dio.FormData();
              // controller.workArea.addAll(controller.lisofworkareafromapi);
              var data = {
                "tradesmen_id": controller.tradesmenId,
                "full_name": controller.namcontroller.text,
                "user_id": CurrentUser().currentUser.memberID,
                // "email": controller.emailController.text,
                "contact_number": controller.contactcontroller.text,
                'alternative_contact_number':
                    controller.alternativecontactcontroller.text,
                'profile_image': '',
                "company_id": widget.companyId,
                'experience': controller.experiencecontroller.text,
                "country_id": controller.currentCountryIid,
                'location': controller.locationController.text,
                "work_category": controller.currentWorkCategory[0].tradeCatId,
                "service_description":
                    controller.serviceDescribeController.text,
                "work_type": controller.typeOfWorkController.text.isEmpty
                    ? controller.tradesmendetail[0].workType
                    : controller.typeOfWorkController.text,
                "call_out": controller.available24.value ? 'Yes' : 'No',
                "insurance": controller.workUndertaking.value ? 'Yes' : 'No',
                "undertaken": controller.workUndertaking.value ? 'Yes' : 'No',

                "work_area": jsonEncode(controller.workArea
                    .map((element) => element.areaId)
                    .toList()),
                "work_subcategory": jsonEncode(controller.selectedsbcat.value
                    .map((e) => e.tradeSubcatId)
                    .toList())
              };
              print("totdata=${data} ");

              data.forEach((key, value) {
                formData.fields.add(MapEntry(key, value!));
              });
              controller.updateCompanyTradesmen(data, () {
                Get.snackbar('Success', 'Updated successfully!!',
                    backgroundColor: Colors.white,
                    duration: Duration(milliseconds: 700));
                Navigator.of(context).pop();
              });
              // return data;
            }
            var albumdata = [];
            for (int i = 0; i < controller.currentPhotoAlbumList.length; i++) {
              var listofimages = controller.currentPhotoAlbumList[i].images;
              var data = AlbumDatum2(
                  id: controller.currentPhotoAlbumList[i].id == null
                      ? ''
                      : controller.currentPhotoAlbumList[i].id.toString(),
                  albumName: controller.currentPhotoAlbumList[i].albumName,
                  albumPic: controller.currentPhotoAlbumList[i].albumPic,
                  images: '');
              var csv = '';
              for (var i in listofimages!) {
                csv += i + ',';
              }
              data.images = csv;
              controller.currentPhotoAlbumList2.add(data);
            }
            controller.currentPhotoAlbumList2.forEach((element) {
              albumdata.add(jsonEncode(element.toJson()));
            });
            var formData = dio.FormData();
            var data = {
              "full_name": controller.namcontroller.text,
              "user_id": CurrentUser().currentUser.memberID,
              // "email": controller.emailController.text,
              "contact_number": controller.contactcontroller.text,
              'alternative_contact_number':
                  controller.alternativecontactcontroller.text,
              'profile_image': '',
              'experience': controller.experiencecontroller.text,
              "country_id": controller.currentCountryIid,
              'location': controller.locationController.text,
              "work_category": controller.currentWorkCategory[0].tradeCatId,
              "service_description": controller.serviceDescribeController.text,
              "work_type": controller.typeOfWorkController.text.isEmpty
                  ? controller.tradesmendetail[0].workType
                  : controller.typeOfWorkController.text,
              "call_out": controller.available24.value ? 'Yes' : 'No',
              "insurance": controller.workUndertaking.value ? 'Yes' : 'No',
              "undertaken": controller.workUndertaking.value ? 'Yes' : 'No',
              "album_media": albumdata.toString(),
              "work_area": jsonEncode(controller.workArea
                  .map((element) => element['area_id'])
                  .toList()),
              "work_subcategory": jsonEncode(controller.selectedsbcat.value
                  .map((e) => e.tradeSubcatId)
                  .toList())
            };
            print("totdata=${data}");

            data.forEach((key, value) {
              formData.fields.add(MapEntry(key, value!));
            });
            // return data;
            var url = 'http://www.bebuzee.com/api/tradesmen/soloDetailsUpdate';
            var datas = await ApiProvider()
                .fireApiWithParamsPost(url, formdata: formData)
                .then((value) => value);
            print("datas=${datas.data}");
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: settingsColor,
            child: Center(
                child: Text(
              AppLocalizations.of("Update"),
              style: TextStyle(fontSize: 16, color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }
}
