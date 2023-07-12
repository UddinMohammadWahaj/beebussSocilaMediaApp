import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/add_multiple_stories_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Highlights/select_cover_from_gallery.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sizer/sizer.dart';

class EditHighlightCover extends StatefulWidget {
  final List<String>? selectedStoriesID;
  final List<FileElement>? selectedFiles;
  final Function? setCover;
  final Function? clear;
  final Function? coverFromGallery;
  final Function? isImageFromGallery;

  EditHighlightCover(
      {Key? key,
      this.selectedStoriesID,
      this.selectedFiles,
      this.setCover,
      this.clear,
      this.coverFromGallery,
      this.isImageFromGallery})
      : super(key: key);

  @override
  _EditHighlightCoverState createState() => _EditHighlightCoverState();
}

class _EditHighlightCoverState extends State<EditHighlightCover> {
  String selectedCoverID = "";
  String selectedCoverImage = "";
  PreloadPageController _pageController = PreloadPageController();
  CarouselController carouselController = CarouselController();
  int selectedIndex = 0;
  File? cover;
  bool isCoverFromGallery = false;

  @override
  void initState() {
    selectedCoverID = widget.selectedStoriesID![0];
    selectedCoverImage =
        widget.selectedFiles![0].image!.replaceAll(".mp4", ".jpg");
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
                widget.clear!();
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
                  Text(
                    AppLocalizations.of(
                      "Edit Cover",
                    ),
                    style: blackBold.copyWith(fontSize: 14.0.sp),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.setCover!(selectedCoverID, selectedCoverImage);
                    widget.clear!();
                    if (isCoverFromGallery) {
                      widget.coverFromGallery!(cover);
                    } else {
                      widget.isImageFromGallery!();
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        AppLocalizations.of(
                          "Done",
                        ),
                        style: TextStyle(
                            color: primaryBlueColor, fontSize: 12.0.sp),
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

          widget.clear!();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 75.0.h,
                  child: isCoverFromGallery
                      ? Container(
                          child: cover != null
                              ? Image.file(
                                  cover!,
                                  fit: BoxFit.cover,
                                )
                              : Container())
                      : PreloadPageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (val) {
                            carouselController.animateToPage(val);
                            setState(() {
                              selectedIndex = val;
                              selectedCoverID = widget.selectedStoriesID![val];
                              selectedCoverImage = widget
                                  .selectedFiles![val].image!
                                  .replaceAll(".mp4", ".jpg");
                            });
                          },
                          itemCount: widget.selectedFiles!.length,
                          itemBuilder: (context, pageIndex) {
                            return Stack(
                              children: [
                                Container(
                                  height: 75.0.h,
                                  width: 100.0.w,
                                  child: Image.network(
                                    widget.selectedFiles![pageIndex].image!
                                        .replaceAll(".mp4", ".jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                widget.selectedFiles![pageIndex].position!
                                            .length >
                                        0
                                    ? Stack(
                                        children: widget
                                            .selectedFiles![pageIndex].position!
                                            .map((e) => Positioned.fill(
                                                  left: double.parse(e.posx!),
                                                  top: double.parse(e.posy!),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        height: double.parse(
                                                            e.height!),
                                                        width: double.parse(
                                                            e.width!),
                                                        color:
                                                            Colors.transparent,
                                                        child: Center(
                                                          child: Text(
                                                            e.text!,
                                                            style: GoogleFonts.getFont(e
                                                                            .name ==
                                                                        "Raleway_regular"
                                                                    ? "Raleway"
                                                                    : e.name ==
                                                                            "PlayfairDisplay_regular"
                                                                        ? "Playfair Display"
                                                                        : e.name ==
                                                                                "OpenSansCondensed_300"
                                                                            ? "Open Sans Condensed"
                                                                            : e.name == "Anton_regular"
                                                                                ? "Anton"
                                                                                : e.name == "BebasNeue_regular"
                                                                                    ? "Bebas Neue"
                                                                                    : e.name == "DancingScript_regular"
                                                                                        ? "Dancing Script"
                                                                                        : e.name == "AmaticaSC_regular"
                                                                                            ? "Amatica SC"
                                                                                            : e.name == "Sacramento_regular"
                                                                                                ? "Sacramento"
                                                                                                : e.name == "SpecialElite_regular"
                                                                                                    ? "Special Elite"
                                                                                                    : e.name == "PoiretOne_regular"
                                                                                                        ? "Poiret One"
                                                                                                        : e.name == "Monoton_regular"
                                                                                                            ? "Monoton"
                                                                                                            : e.name == "FingerPaint_regular"
                                                                                                                ? "Finger Paint"
                                                                                                                : e.name == "VastShadow_regular"
                                                                                                                    ? "Vast Shadow"
                                                                                                                    : e.name == "Flavors_regular"
                                                                                                                        ? "Flavors"
                                                                                                                        : e.name == "RibeyeMarrow_regular"
                                                                                                                            ? "Ribeye Marrow"
                                                                                                                            : e.name == "Jomhuria_regular"
                                                                                                                                ? "Jomhuria"
                                                                                                                                : e.name == "ZillaSlabHighlight_regular"
                                                                                                                                    ? "Zilla Slab Highlight"
                                                                                                                                    : e.name == "Monofett_regular"
                                                                                                                                        ? "Monofett"
                                                                                                                                        : "Roboto")
                                                                .copyWith(fontWeight: FontWeight.bold, color: Color.fromRGBO(int.parse(e.color!.split(",")[0]), int.parse(e.color!.split(",")[1]), int.parse(e.color!.split(",")[2]), 1), fontSize: 16.0.sp),
                                                            textAlign: TextAlign
                                                                .center,
                                                            textScaleFactor:
                                                                double.parse(
                                                                    e.scale!),
                                                          ),
                                                        ),
                                                      )),
                                                ))
                                            .toList(),
                                      )
                                    : Container(),
                              ],
                            );
                          }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0.h),
                  child: Container(
                    child: CarouselSlider.builder(
                        carouselController: carouselController,
                        itemCount: widget.selectedFiles!.length + 1,
                        itemBuilder: (context, index, ind) {
                          if (index == 0) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectCoverFromGallery(
                                                coverFromGallery: (coverFile) {
                                                  setState(() {
                                                    cover = coverFile;
                                                    isCoverFromGallery = true;
                                                  });
                                                },
                                              )));
                                },
                                child: Container(
                                    child: Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                )));
                          }
                          return GestureDetector(
                            onTap: () {
                              if (isCoverFromGallery) {
                                setState(() {
                                  isCoverFromGallery = false;
                                  widget.isImageFromGallery!();
                                });
                              }
                              setState(() {
                                selectedIndex = index - 1;
                                selectedCoverID =
                                    widget.selectedStoriesID![index - 1];
                                selectedCoverImage = widget
                                    .selectedFiles![index - 1].image!
                                    .replaceAll(".mp4", ".jpg");
                              });
                              print(selectedIndex);
                              print(index);
                              setState(() {
                                carouselController.jumpToPage(index - 1);
                              });
                              _pageController.animateToPage(index - 1,
                                  duration: new Duration(milliseconds: 1),
                                  curve: Curves.easeInOut);
                            },
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: new Border.all(
                                  color: index - 1 == selectedIndex
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: index - 1 == selectedIndex ? 1 : 0,
                                ),
                              ),
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: new Border.all(
                                    color: index - 1 == selectedIndex
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: index - 1 == selectedIndex ? 1.5 : 0,
                                  ),
                                ),
                                child: Image.network(
                                  widget.selectedFiles![index - 1].image!
                                      .replaceAll(".mp4", ".jpg"),
                                  fit: BoxFit.cover,
                                  width: 45,
                                  height: 45,
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          onPageChanged: (ind, res) {
                            if (isCoverFromGallery) {
                              setState(() {
                                isCoverFromGallery = false;
                                widget.isImageFromGallery!();
                              });
                            }
                            _pageController.animateToPage(ind,
                                duration: new Duration(milliseconds: 1),
                                curve: Curves.easeInOut);
                            setState(() {
                              selectedIndex = ind;
                              selectedCoverID = widget.selectedStoriesID![ind];
                              selectedCoverImage = widget
                                  .selectedFiles![ind].image!
                                  .replaceAll(".mp4", ".jpg");
                            });
                          },
                          enableInfiniteScroll: false,
                          enlargeCenterPage: false,
                          viewportFraction: 0.1,
                          height: 45,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
