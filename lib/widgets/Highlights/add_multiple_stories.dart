import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/add_multiple_stories_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../services/Highlight/newhighlightcontroller.dart';
import 'new_highlight_from_multiple_stories.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

class AddMultipleStories extends StatefulWidget {
  final Function? setNavbar;

  AddMultipleStories({Key? key, this.setNavbar}) : super(key: key);

  @override
  _AddMultipleStoriesState createState() => _AddMultipleStoriesState();
}

class _AddMultipleStoriesState extends State<AddMultipleStories> {
  MultipleStories? storiesList;
  bool areStoriesLoaded = false;
  List<String> selectedStoriesID = [];
  List<String> selectedStoriesImages = [];
  List<FileElement> allFiles = [];
  String defaultCoverID = "";
  List<FileElement> selectedFiles = [];
  var controller = Get.put(AddNewHighlightController());
  Future<void> getStories() async {
    // var url = Uri.parse(
    // "https://www.bebuzee.com/app_devlope_story_data.php?action=story_data_details_data_all&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_ids=");
//
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/story_data_all_details.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "post_ids": ""
    });

    if (response!.success == 1) {
      MultipleStories storyData =
          MultipleStories.fromJson(response!.data['data']);
      allFiles = [];
      storyData.stories.forEach((element) {
        element.files!.forEach((file) {
          /*List<FileElement> all = [];
          await Future.wait(all.map((e) => Preload.cacheImage(context, e.image)).toList());*/
          if (mounted) {
            setState(() {
              allFiles.add(file);
              areStoriesLoaded = true;
            });
          }
        });
      });
    }
    if (response!.data['data'] == null || response!.success != 1) {
      if (mounted) {
        setState(() {
          areStoriesLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    // getStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Get.delete<AddNewHighlightController>();
                widget.setNavbar!(false);
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  Obx(
                    () => controller.selectedStoriesID.length > 0
                        ? Text(
                            controller.selectedStoriesID.length.toString() +
                                AppLocalizations.of(
                                  "Selected",
                                ),
                            style: blackBold.copyWith(fontSize: 14.0.sp),
                          )
                        : Text(
                            AppLocalizations.of(
                              "New Highlight",
                            ),
                            style: blackBold.copyWith(fontSize: 14.0.sp),
                          ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.selectedStoriesID.length > 0) {
                      // print(
                      //     "new page \n selected files=${controller.selectedFiles.value}");
                      // print(
                      //     "new page \n selected files=${controller.selectedStoriesID.value}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewHighlightFromMultipleStories(
                                    selectedFiles:
                                        controller.selectedFiles.value,
                                    selectedStoriesID:
                                        controller.selectedStoriesID.value,
                                    setNavbar: widget.setNavbar,
                                  )));
                    } else {
                      return null;
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Obx(
                        () => Text(
                          AppLocalizations.of(
                            "Next",
                          ),
                          style: TextStyle(
                              color: controller.selectedStoriesID.length > 0
                                  ? primaryBlueColor
                                  : Colors.grey.withOpacity(0.4),
                              fontSize: 12.0.sp),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Get.delete<AddNewHighlightController>();
          widget.setNavbar!(false);
          return true;
        },
        child: Obx(
          () => Container(
            child: controller.areStoriesLoaded.value
                ? GridView.builder(
                    itemCount: controller.allFiles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 9 / 16),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 9 / 16,
                            child: GestureDetector(
                              onTap: () {
                                print("tapa tap $index");
                                // setState(() {
                                //----------------
                                controller.allFiles.value[index].isSelected =
                                    !controller
                                        .allFiles.value[index].isSelected!;
                                controller.allFiles.refresh();
                                // // });

                                if (controller.allFiles[index].isSelected!) {
                                  // setState(() {
                                  print("selected=true");
                                  controller.selectedStoriesID.add(
                                      controller.allFiles[index].id! +
                                          "^^" +
                                          controller.allFiles[index].storyId
                                              .toString());
                                  print(
                                      'selected id=${controller.selectedStoriesID.value}');
                                  try {
                                    controller.selectedStoriesImages.add(
                                        controller.allFiles[index].image!
                                            .replaceAll(".mp4", ".jpg"));
                                  } catch (e) {
                                    print("selected files current error $e");
                                  }
                                  controller.selectedFiles.value
                                      .add(controller.allFiles[index]);
                                  print(
                                      "selected files current=${controller.selectedFiles}");
                                  controller.selectedFiles.refresh();
                                  controller.selectedStoriesID.refresh();
                                  controller.selectedStoriesImages.refresh();

                                  // });
                                } else {
                                  // setState(() {
                                  controller.selectedStoriesID.removeWhere(
                                      (element) =>
                                          element ==
                                          controller.allFiles[index].id! +
                                              "^^" +
                                              controller.allFiles[index].storyId
                                                  .toString());
                                  controller.selectedStoriesImages.removeWhere(
                                      (element) =>
                                          element ==
                                          controller.allFiles[index].image!
                                              .replaceAll(".mp4", ".jpg"));
                                  controller.selectedFiles.removeWhere(
                                      (element) =>
                                          element ==
                                          controller.allFiles[index]);
                                  controller.selectedStoriesID.refresh();
                                  controller.selectedStoriesImages.refresh();
                                  controller.allFiles.refresh();
                                  controller.selectedFiles.refresh();
                                  // });
                                }

                                //---------------------------
                              },
                              child: Opacity(
                                opacity: controller.allFiles[index].isSelected!
                                    ? 0.7
                                    : 1,
                                child: Container(
                                  child: Image.network(
                                    controller.allFiles[index].image!
                                        .replaceAll(".mp4", ".jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // controller.allFiles[index].position.length > 0
                          //     ? Stack(
                          //         children: controller.allFiles[index].position
                          //             .map((e) => Positioned.fill(
                          //                   left: double.parse(e.posx),
                          //                   top: double.parse(e.posy),
                          //                   child: Align(
                          //                       alignment: Alignment.center,
                          //                       child: Container(
                          //                         height:
                          //                             double.parse(e.height),
                          //                         width: double.parse(e.width),
                          //                         color: Colors.transparent,
                          //                         child: Center(
                          //                           child: Text(
                          //                             e.text,
                          //                             style: GoogleFonts.getFont(e
                          //                                             .name ==
                          //                                         "Raleway_regular"
                          //                                     ? "Raleway"
                          //                                     : e.name ==
                          //                                             "PlayfairDisplay_regular"
                          //                                         ? "Playfair Display"
                          //                                         : e.name ==
                          //                                                 "OpenSansCondensed_300"
                          //                                             ? "Open Sans Condensed"
                          //                                             : e.name ==
                          //                                                     "Anton_regular"
                          //                                                 ? "Anton"
                          //                                                 : e.name == "BebasNeue_regular"
                          //                                                     ? "Bebas Neue"
                          //                                                     : e.name == "DancingScript_regular"
                          //                                                         ? "Dancing Script"
                          //                                                         : e.name == "AmaticaSC_regular"
                          //                                                             ? "Amatica SC"
                          //                                                             : e.name == "Sacramento_regular"
                          //                                                                 ? "Sacramento"
                          //                                                                 : e.name == "SpecialElite_regular"
                          //                                                                     ? "Special Elite"
                          //                                                                     : e.name == "PoiretOne_regular"
                          //                                                                         ? "Poiret One"
                          //                                                                         : e.name == "Monoton_regular"
                          //                                                                             ? "Monoton"
                          //                                                                             : e.name == "FingerPaint_regular"
                          //                                                                                 ? "Finger Paint"
                          //                                                                                 : e.name == "VastShadow_regular"
                          //                                                                                     ? "Vast Shadow"
                          //                                                                                     : e.name == "Flavors_regular"
                          //                                                                                         ? "Flavors"
                          //                                                                                         : e.name == "RibeyeMarrow_regular"
                          //                                                                                             ? "Ribeye Marrow"
                          //                                                                                             : e.name == "Jomhuria_regular"
                          //                                                                                                 ? "Jomhuria"
                          //                                                                                                 : e.name == "ZillaSlabHighlight_regular"
                          //                                                                                                     ? "Zilla Slab Highlight"
                          //                                                                                                     : e.name == "Monofett_regular"
                          //                                                                                                         ? "Monofett"
                          //                                                                                                         : "Roboto")
                          //                                 .copyWith(fontWeight: FontWeight.bold, color: Color.fromRGBO(int.parse(e.color.split(",")[0]), int.parse(e.color.split(",")[1]), int.parse(e.color.split(",")[2]), 1), fontSize: 16.0.sp),
                          //                             textAlign:
                          //                                 TextAlign.center,
                          //                             textScaleFactor:
                          //                                 double.parse(e.scale),
                          //                           ),
                          //                         ),
                          //                       )),
                          //                 ))
                          //             .toList(),
                          //       )
                          //     : GestureDetector(
                          //         onTap: () {
                          //           print("tapa tap $index other");
                          //         },
                          //         child: Container(
                          //             height: 100,
                          //             width: 100,
                          //             color: Colors.pink),
                          //       ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Column(
                                  children: [
                                    Text(
                                      controller.allFiles[index].time!
                                          .split(" ")[0],
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      controller.allFiles[index].time!
                                          .split(" ")[1],
                                      style: TextStyle(
                                          fontSize: 7.0.sp,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: Colors.white,
                                  width: 0.8,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    controller.allFiles[index].isSelected!
                                        ? Colors.blue
                                        : Colors.transparent,
                                child: Icon(Icons.check,
                                    size: 15,
                                    color:
                                        controller.allFiles[index].isSelected!
                                            ? Colors.white
                                            : Colors.transparent),
                              ),
                            ),
                          )
                        ],
                      );
                    })
                : Container(),
          ),
        ),
      ),
    );
  }
}
