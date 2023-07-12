import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/models/add_multiple_stories_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'new_highlight_from_multiple_stories.dart';

class MultipleStoriesTabBar extends StatefulWidget {
  final FileElement? allFiles;
  final Function? setNavbar;
  final VoidCallback? select;

  MultipleStoriesTabBar({Key? key, this.setNavbar, this.allFiles, this.select})
      : super(key: key);

  @override
  _MultipleStoriesTabBarState createState() => _MultipleStoriesTabBarState();
}

class _MultipleStoriesTabBarState extends State<MultipleStoriesTabBar>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 9 / 16,
            child: GestureDetector(
              onTap: widget.select ?? () {},
              child: Opacity(
                opacity: widget.allFiles!.isSelected! ? 0.7 : 1,
                child: Container(
                  child: Image.network(
                    widget.allFiles!.image!.replaceAll(".mp4", ".jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          widget.allFiles!.position!.length > 0
              ? Stack(
                  children: widget.allFiles!.position!
                      .map((e) => Positioned.fill(
                            left: double.parse(e.posx!),
                            top: double.parse(e.posy!),
                            child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: double.parse(e.height!),
                                  width: double.parse(e.width!),
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      e.text!,
                                      style: GoogleFonts.getFont(e.name ==
                                                  "Raleway_regular"
                                              ? "Raleway"
                                              : e.name ==
                                                      "PlayfairDisplay_regular"
                                                  ? "Playfair Display"
                                                  : e.name ==
                                                          "OpenSansCondensed_300"
                                                      ? "Open Sans Condensed"
                                                      : e.name ==
                                                              "Anton_regular"
                                                          ? "Anton"
                                                          : e.name ==
                                                                  "BebasNeue_regular"
                                                              ? "Bebas Neue"
                                                              : e.name ==
                                                                      "DancingScript_regular"
                                                                  ? "Dancing Script"
                                                                  : e.name ==
                                                                          "AmaticaSC_regular"
                                                                      ? "Amatica SC"
                                                                      : e.name ==
                                                                              "Sacramento_regular"
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
                                      textAlign: TextAlign.center,
                                      textScaleFactor: double.parse(e.scale!),
                                    ),
                                  ),
                                )),
                          ))
                      .toList(),
                )
              : Container(),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  children: [
                    Text(
                      widget.allFiles!.time!.split(" ")[0],
                      style: TextStyle(
                          fontSize: 9.0.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.allFiles!.time!.split(" ")[1],
                      style: TextStyle(
                          fontSize: 7.0.sp, fontWeight: FontWeight.normal),
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
                backgroundColor: widget.allFiles!.isSelected!
                    ? Colors.blue
                    : Colors.transparent,
                child: Icon(Icons.check,
                    size: 15,
                    color: widget.allFiles!.isSelected!
                        ? Colors.white
                        : Colors.transparent),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
