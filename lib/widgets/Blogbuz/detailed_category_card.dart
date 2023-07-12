import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/blogbuzz_list_model.dart';
import 'package:bizbultest/models/blogbuzz_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/blogbuzz_single_category_page.dart';
import 'package:bizbultest/view/expanded_blog_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/view/recipe_category_page.dart';

import '../../api/api.dart';
import '../../utilities/custom_icons.dart';
import '../../utilities/simple_web_view.dart';
import '../Bookmark/save_to_board_sheet.dart';
import 'Recipe/country_selection_page.dart';
import 'category_list_card.dart';

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
  var isBannerLoaded = false;
  var banneradImage = '';
  var banneradButton = '';
  var banneradUrl = '';
  var banneradContent = '';
  var bannerid = '';
  late Future _blogsFuture;
  var currentUrlStr = "";
  double width = 50;

  void calculateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final RenderObject? box = keyText.currentContext!.findRenderObject();
      final RenderRepaintBoundary? box =
          keyText.currentContext!.findRenderObject() as RenderRepaintBoundary;
      setState(() {
        width = box!.size.width;
      });
      print(width);
    });
  }

  Future getAdBanner() async {
    var url =
        'https://www.bebuzee.com/api/campaign/singleBannerAds?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}';
    print("url of banner ad=${url}");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    if (response.data['success'] == 1)
      setState(() {
        isBannerLoaded = true;
        banneradImage = response.data['data']['image'];
        banneradButton = response.data['data']['category_val'];
        banneradUrl = response.data['data']['url'];
        banneradContent = response.data['data']['post_content'];
        bannerid = response.data['data']['blog_id'];
      });
    print("response banner=${response.data}");
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
          if (e.categoryName.toString().toLowerCase() == "recipe" ||
              e.categoryName.toString().toLowerCase() == "ricette") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecipeCategoryPage()));
          } else {
            print(widget.blog!.category);
            print('cat val ${widget.blog!.categoryVal}');

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlogBuzzCountryPage(
                          category: e.categoryVal,
                          setNavBar: widget.setNavBar,
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
              e.categoryName.toUpperCase(),
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
    getAdBanner();
    super.initState();
    if (widget.index == 1) {
      print("i am here with 0");
      WidgetsBinding.instance.addPostFrameCallback((_) => calculateHeight());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.firstIndex=${widget.firstIndex}");
    return GestureDetector(
      onTap: () {
        print("maa bia re click");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => BlogBuzzCategoryMainPage(
        //               country: CurrentUser().currentUser.country,
        //               language: "",
        //               refreshFromShortbuz: widget.refreshFromShortbuz,
        //               refresh: widget.refresh,
        //               refreshFromMultipleStories:
        //                   widget.refreshFromMultipleStories,
        //               setNavBar: widget.setNavBar,
        //               isChannelOpen: widget.isChannelOpen,
        //               changeColor: widget.changeColor,
        //               category: widget.blog.categoryVal,
        //             )));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpandedBlogPage(
                      refreshFromShortbuz: widget.refreshFromShortbuz!,
                      refresh: widget.refresh!,
                      refreshFromMultipleStories:
                          widget.refreshFromMultipleStories!,
                      setNavBar: widget.setNavBar!,
                      isChannelOpen: widget.isChannelOpen!,
                      changeColor: widget.changeColor!,
                      blogID: widget.blog!.blogId,
                    )));
      },
      child: Container(
          child: widget.index == 1
              ? Container(
                  child: Column(
                    children: [
                      widget.firstIndex == 0 ? _title() : Container(),
                      widget.firstIndex == 0 ? _categoryList() : Container(),
                      // isBannerLoaded
                      //     ? Banner(
                      //         message: 'Ad',
                      //         location: BannerLocation.topStart,
                      //         child: Container(
                      //           child: Column(
                      //             children: [
                      //               Stack(
                      //                 children: [
                      //                   Image(
                      //                     image: CachedNetworkImageProvider(
                      //                         banneradImage),
                      //                     fit: BoxFit.cover,
                      //                     width: 100.0.w,
                      //                   ),
                      //                   Positioned.fill(
                      //                     bottom: 2.0.h,
                      //                     child: Align(
                      //                       alignment: Alignment.bottomCenter,
                      //                       child: Container(
                      //                         width: 80.0.w,
                      //                         child: Column(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.center,
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.end,
                      //                           children: [
                      //                             Text(
                      //                               banneradContent,
                      //                               style: whiteNormal.copyWith(
                      //                                   fontSize: 20,
                      //                                   fontWeight:
                      //                                       FontWeight.bold,
                      //                                   fontFamily: 'Georgie'),
                      //                               textAlign: TextAlign.center,
                      //                             ),
                      //                             TextButton.icon(
                      //                                 icon: Icon(Icons
                      //                                     .arrow_circle_right),
                      //                                 label: Text(
                      //                                   banneradButton,
                      //                                   style: whiteNormal
                      //                                       .copyWith(
                      //                                           fontSize: 20,
                      //                                           color: Colors
                      //                                               .black,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .bold,
                      //                                           fontFamily:
                      //                                               'Georgie'),
                      //                                   textAlign:
                      //                                       TextAlign.center,
                      //                                 ),
                      //                                 style: ButtonStyle(
                      //                                     padding: MaterialStateProperty.all<EdgeInsets>(
                      //                                         EdgeInsets.all(
                      //                                             15)),
                      //                                     backgroundColor:
                      //                                         MaterialStateProperty.all<Color>(
                      //                                             Colors.amber),
                      //                                     foregroundColor:
                      //                                         MaterialStateProperty.all<Color>(
                      //                                             Colors.black),
                      //                                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      //                                         borderRadius: BorderRadius.circular(18.0),
                      //                                         side: BorderSide(color: Colors.amber)))),
                      //                                 onPressed: () {
                      //                                   // print(
                      //                                   //     "urll of ad=${blogList.blogs[index].url}");
                      //                                   Navigator.of(context).push(
                      //                                       MaterialPageRoute(
                      //                                           builder: (context) =>
                      //                                               SimpleWebView(
                      //                                                   url:
                      //                                                       banneradUrl,
                      //                                                   heading:
                      //                                                       "")));
                      //                                 }),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     : Container(),
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
                            image: CachedNetworkImageProvider(
                                widget.blog!.image!!),
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
              : (widget.category == 'banner')
                  ? Container(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Image(
                                image: CachedNetworkImageProvider(
                                    widget.blog!.image!),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                        print("bhauni bia re clicked");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExpandedBlogPage(
                                      refreshFromShortbuz:
                                          widget.refreshFromShortbuz!,
                                      refresh: widget.refresh!,
                                      refreshFromMultipleStories:
                                          widget.refreshFromMultipleStories!,
                                      setNavBar: widget.setNavBar!,
                                      isChannelOpen: widget.isChannelOpen!,
                                      changeColor: widget.changeColor!,
                                      blogID: widget.blog!.blogId,
                                    )));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => BlogBuzzCategoryMainPage(
                        //               country: CurrentUser().currentUser.country,
                        //               language: "",
                        //               setNavBar: widget.setNavBar,
                        //               isChannelOpen: widget.isChannelOpen,
                        //               category: widget.blog.categoryVal,
                        //             )));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5.h, vertical: 2.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: CachedNetworkImageProvider(
                                  widget.blog!.image!),
                              fit: BoxFit.cover,
                              width: 35.0.w,
                              height: 50.0.w,
                            ),
                            Container(
                              width: 55.0.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 1.5.h),
                                    child: Text(
                                      widget.blog!.postContent!,
                                      style: TextStyle(
                                          fontSize: 18, fontFamily: 'Georgie'),
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.0.h),
                                        child: Text(
                                          AppLocalizations.of("BY ") +
                                              widget.blog!.userName!
                                                  .toUpperCase(),
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontFamily: 'Arial'),
                                        ),
                                      ),
                                      // IconButton(
                                      //   icon: Icon(Icons.bookmark_border_outlined,
                                      //       color: Colors.black),
                                      //   onPressed: () {},
                                      // )
                                    ],
                                  ),
                                  Container(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        splashRadius: 20,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          CustomIcons.bookmark_thin,
                                        ),
                                        onPressed: () {
                                          // print(widget.feed.postImgData);
                                          Get.bottomSheet(
                                              SaveToBoardSheet(
                                                postID: widget.blog!.blogId,
                                                image: widget.blog!.blogId,
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                                  .circular(
                                                              20.0))));
                                        },
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                      ))
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
