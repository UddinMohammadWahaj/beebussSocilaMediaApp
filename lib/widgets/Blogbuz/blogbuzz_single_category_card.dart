import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/blogbuzz_category_model.dart';
import 'package:bizbultest/models/blogbuzz_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/expanded_blog_page.dart';
import 'package:bizbultest/widgets/Bookmark/save_to_board_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class BlogBuzzSingleCategoryCard extends StatefulWidget {
  final BlogBuzzCategoryModel? blog;
  final int? index;
  final int? lastIndex;
  final Function? refresh;
  final Function? refreshFromShortbuz;
  final Function? refreshFromMultipleStories;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  BlogBuzzSingleCategoryCard(
      {Key? key,
      this.index,
      this.lastIndex,
      this.blog,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.refresh,
      this.refreshFromShortbuz,
      this.refreshFromMultipleStories})
      : super(key: key);

  @override
  _BlogBuzzSingleCategoryCardState createState() =>
      _BlogBuzzSingleCategoryCardState();
}

class _BlogBuzzSingleCategoryCardState extends State<BlogBuzzSingleCategoryCard>
    with AutomaticKeepAliveClientMixin {
  var indexList = [0, 1, 7, 8, 14, 15, 21, 22, 28];

  late Categories categoryList;
  late bool areCategoriesLoaded;

  Future<void> getCategoryList() async {
    print("inner get category list called ");
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blog_buz_feed_category_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog/blogCategory?action=blog_buz_feed_category_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}');

    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    return await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      if (value.statusCode == 200) {
        print('category list bia =${value.data}');
        Categories categoryData = Categories.fromJson(value.data['category']);
        if (mounted) {
          setState(() {
            categoryList = categoryData;

            areCategoriesLoaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            areCategoriesLoaded = false;
          });
        }
      }
    });

    // var response = await http.get(url);

    // if (response.statusCode == 200) {
    //   Categories categoryData = Categories.fromJson(jsonDecode(response.body));
    //   if (mounted) {
    //     setState(() {
    //       categoryList = categoryData;
    //       areCategoriesLoaded = true;
    //     });
    //   }
    // }
    // if (response.body == null || response.statusCode != 200) {
    //   if (mounted) {
    //     setState(() {
    //       areCategoriesLoaded = false;
    //     });
    //   }
    // }
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
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
        padding: EdgeInsets.only(bottom: 2.0.h),
        child: indexList.contains(widget.index)
            ? Column(
                children: [
                  widget.index == 0
                      ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10, bottom: 25),
                              child: Container(
                                child: Text(
                                  widget.blog!.blogCategory!!,
                                  style: blackBold.copyWith(
                                      fontSize: 30.0.sp, fontFamily: "Georgie"),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0.h),
                        child: Container(
                          width: 100.0.w,
                          height: 60.0.h,
                          child: Image.network(
                            widget.blog!.blogImage!,
                            fit: BoxFit.cover,

                            // errorWidget: (context, url, error) => new Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 3.0.h,
                            ),
                            child: Container(
                              width: 97.0.w,
                              color: Colors.white,
                              // height: 15.0.h,
                              child: Padding(
                                padding: EdgeInsets.all(3.0.h),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.blog!.blogCategory!.toUpperCase(),
                                      style: TextStyle(fontSize: 8.0.sp),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.5.h),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            width: 80.0.w,
                                            child: Text(
                                              parse(widget.blog!.blogContent)
                                                  .documentElement!
                                                  .text,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Georgie'),
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.0.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "BY " +
                                                    widget.blog!.blogUserName!
                                                        .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontFamily: 'Arial',
                                                    fontSize: 8.0.sp),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2.5.w),
                                                child: Text(
                                                    widget.blog!.blogTimeStamp!
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 8.0.sp)),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            splashRadius: 20,
                                            constraints: BoxConstraints(),
                                            icon: Icon(
                                              CustomIcons.bookmark_thin,
                                            ),
                                            onPressed: () {
                                              Get.bottomSheet(
                                                  SaveToBoardSheet(
                                                    postID: widget.blog!.postID,
                                                    image:
                                                        widget.blog!.blogImage,
                                                  ),
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                                  .circular(
                                                              20.0))));
                                            },
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            : Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 2.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      widget.blog!.blogImage!,
                      width: 35.0.w,
                      height: 50.0.w,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: 55.0.w,
                      height: 50.0.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parse(widget.blog!.blogContent)
                                    .documentElement!
                                    .text,
                                style: TextStyle(
                                    fontSize: 18, fontFamily: "Georgie"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.5.h),
                                child: Text(
                                  AppLocalizations.of("BY") +
                                      " " +
                                      widget.blog!.blogUserName!.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontFamily: 'Arial'),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: new BoxDecoration(
                                border: Border(
                              top: BorderSide(
                                  color: Colors.grey.shade500, width: 0.2),
                              bottom: BorderSide(
                                  color: Colors.grey.shade500, width: 0.2),
                            )),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              onTap: () {
                                Get.bottomSheet(
                                    SaveToBoardSheet(
                                        postID: widget.blog!.postID,
                                        image: widget.blog!.blogImage),
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0))));
                              },
                              title: Text(
                                AppLocalizations.of("Save to board"),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              trailing: Icon(
                                CustomIcons.bookmark_thin,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
