import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/blogbuzz_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/blogbuzz_single_category_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/view/recipe_category_page.dart';

import 'Recipe/country_selection_page.dart';

class BlogBuzzMultipleCategoriesCard extends StatefulWidget {
  final BlogBuzzModel? blog;
  final int? index;
  final String? category;
  final List? categoryList;
  final int? firstIndex;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? refresh;
  final Function? refreshFromShortbuz;
  final Function? refreshFromMultipleStories;

  BlogBuzzMultipleCategoriesCard(
      {Key? key,
      this.blog,
      this.index,
      this.category,
      this.categoryList,
      this.firstIndex,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.refresh,
      this.refreshFromShortbuz,
      this.refreshFromMultipleStories})
      : super(key: key);

  @override
  _BlogBuzzMultipleCategoriesCardState createState() =>
      _BlogBuzzMultipleCategoriesCardState();
}

class _BlogBuzzMultipleCategoriesCardState
    extends State<BlogBuzzMultipleCategoriesCard> {
  var keyText = GlobalKey();
  double width = 50;

  void calculateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("called binding");
      // final RenderObject? box = keyText.currentContext!.findRenderObject();
      final RenderRepaintBoundary? box =
          keyText.currentContext!.findRenderObject() as RenderRepaintBoundary;
      setState(() {
        width = box!.size.width;
      });
      print(width);
    });
  }

  Widget _title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        AppLocalizations.of(
          "Blogbuz Feed",
        ),
        style: blackBold.copyWith(fontSize: 28, fontFamily: 'Arial'),
      ),
    );
  }

  Widget _categoryCard(dynamic e) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {
          print("bia tap on ${e.categoryVal.toString().toLowerCase()}");
          if (e.categoryVal.toString().toLowerCase() == "recipe") {
            print("Inside recipe");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecipeCategoryPage()));
          } else {
            print(widget.blog!.category);
            print(widget.blog!.categoryVal);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlogBuzzCountryPage(
                          category: e.categoryName,
                        )));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => BlogBuzzCategoryMainPage(
            //               isChannelOpen: widget.isChannelOpen,
            //               refreshFromShortbuz: widget.refreshFromShortbuz,
            //               refresh: widget.refresh,
            //               setNavBar: widget.setNavBar,
            //               refreshFromMultipleStories: widget.refreshFromMultipleStories,
            //               index: widget.index,
            //               category: e.categoryVal,
            //             )));
          }
        },
        child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: e.color == true ? primaryBlueColor : Colors.black,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              AppLocalizations.of(e.categoryName.toUpperCase()),
              style: blackBold.copyWith(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: e.color == true ? primaryBlueColor : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Row(
          children: widget.categoryList!.map((e) => _categoryCard(e)).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("called binding");
        calculateHeight();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("bia");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogBuzzCategoryMainPage(
                      refreshFromShortbuz: widget.refreshFromShortbuz!,
                      refresh: widget.refresh!,
                      refreshFromMultipleStories:
                          widget.refreshFromMultipleStories!,
                      setNavBar: widget.setNavBar!,
                      isChannelOpen: widget.isChannelOpen!,
                      changeColor: widget.changeColor!,
                      category: widget.blog!.categoryVal,
                    )));
      },
      child: Container(
          child: widget.index == 0
              ? Container(
                  child: Column(
                    children: [
                      widget.firstIndex == 0 ? _title() : Container(),
                      widget.firstIndex == 0 ? _categoryList() : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.black,
                              height: 3,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 25,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.black,
                                    height: 8,
                                    width: width,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    key: keyText,
                                    child: Text(
                                      widget.blog!.category!,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Image(
                            image:
                                CachedNetworkImageProvider(widget.blog!.image!),
                            fit: BoxFit.cover,
                            width: 100.0.w,
                          ),
                          Positioned.fill(
                            bottom: 2.0.h,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 80.0.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.blog!.postContent!,
                                      style: whiteNormal.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Georgie'),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.5.h),
                                      child: Text(
                                        "BY " +
                                            widget.blog!.userName!
                                                .toUpperCase(),
                                        style: whiteNormal.copyWith(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Arial'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlogBuzzCategoryMainPage(
                                  setNavBar: widget.setNavBar!,
                                  isChannelOpen: widget.isChannelOpen!,
                                  category: widget.blog!.categoryVal,
                                )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 1.5.h, vertical: 2.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(
                          image:
                              CachedNetworkImageProvider(widget.blog!.image!),
                          fit: BoxFit.cover,
                          width: 35.0.w,
                          height: 50.0.w,
                        ),
                        Container(
                          width: 55.0.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.blog!.postContent!,
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Georgie'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1.0.h),
                                child: Text(
                                  AppLocalizations.of("BY ") +
                                      widget.blog!.userName!.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontFamily: 'Arial'),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
