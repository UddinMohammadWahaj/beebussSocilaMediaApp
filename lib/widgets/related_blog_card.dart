import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/related_blog_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/expanded_blog_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:html/parser.dart';
import 'package:bizbultest/utilities/colors.dart';

import '../api/api.dart';
import '../services/current_user.dart';
import '../utilities/simple_web_view.dart';

class RelatedBlogCard extends StatefulWidget {
  final RelatedBlogModel blog;
  final int index;

  RelatedBlogCard({Key? key, required this.blog, required this.index})
      : super(key: key);

  @override
  _RelatedBlogCardState createState() => _RelatedBlogCardState();
}

class _RelatedBlogCardState extends State<RelatedBlogCard> {
  @override
  void initState() {
    print("index is " + widget.index.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.blog.category == 'banner') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  SimpleWebView(url: widget.blog.url!, heading: "")));
        } else
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExpandedBlogPage(
                        blogID: widget.blog.blogId!,
                      )));
      },
      child: Container(
        child: Column(
          children: [
            widget.index == 0
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.black,
                          height: 0.5.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: Container(
                            color: Colors.black,
                            height: 1.5.w,
                            width: 30.0.w,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.w, top: 1.5.w),
                          child: Container(
                            child: Text(
                              AppLocalizations.of(
                                "Related Blogs",
                              ),
                              style: TextStyle(
                                  fontSize: 14.0.sp, fontFamily: 'Georgia'),
                            ),
                            //height: 2.2.w,
                            //width: 10.0.w,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            widget.blog.category == 'banner'
                ? Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0.h),
                        child: Container(
                          width: 100.0.w,
                          height: 60.0.h,
                          child: Image.network(
                            widget.blog.image!,
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
                                      'Sponsored',
                                      style: TextStyle(fontSize: 10.0.sp),
                                    ),

                                    SizedBox(
                                      width: 1.0.w,
                                    ),

                                    FittedBox(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: 1.5.h),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                  width: 80.0.w,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      parse(widget
                                                              .blog.blogTitle)
                                                          .documentElement!
                                                          .text,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'Georgie'),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          TextButton(
                                              autofocus: true,
                                              child: Text(
                                                widget.blog.userUrl!
                                                    .toUpperCase(),
                                                style: whiteNormal.copyWith(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Georgie'),
                                                textAlign: TextAlign.center,
                                              ),
                                              style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all<EdgeInsets>(
                                                          EdgeInsets.all(18)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<Color>(
                                                          HexColor('#0110FF')),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<Color>(
                                                          Colors.black),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          side: BorderSide(color: Colors.white)))),
                                              onPressed: () async {
                                                // print(
                                                //     "urll of ad=${blogList.blogs[index].url}");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SimpleWebView(
                                                                url: widget
                                                                    .blog.url!,
                                                                heading: "")));
                                                await ApiProvider()
                                                    .fireApiWithParams(
                                                        'https://www.bebuzee.com/api/click_ads.php',
                                                        params: {
                                                      "data_id":
                                                          widget.blog.blogId,
                                                      "ad_type": 'sponsor',
                                                      "user_id": CurrentUser()
                                                          .currentUser
                                                          .memberID
                                                    });
                                              }),
                                        ],
                                      ),
                                    )

                                    // Padding(
                                    //   padding: EdgeInsets.only(top: 2.0.h),
                                    //   child: Row(
                                    //     children: [
                                    //       Text(
                                    //         "BY " +
                                    //             widget.blog.user
                                    //                 .toUpperCase(),
                                    //         style: TextStyle(
                                    //             color: Colors.black
                                    //                 .withOpacity(0.6),
                                    //             fontFamily: 'Arial',
                                    //             fontSize: 8.0.sp),
                                    //       ),
                                    //       Padding(
                                    //         padding:
                                    //             EdgeInsets.only(left: 2.5.w),
                                    //         child: Text(
                                    //             widget.blog.dateDt
                                    //                 .toUpperCase(),
                                    //             style: TextStyle(
                                    //                 color: Colors.black
                                    //                     .withOpacity(0.6),
                                    //                 fontSize: 8.0.sp)),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0.h),
                        child: Container(
                          width: 100.0.w,
                          height: 60.0.h,
                          child: Image.network(
                            widget.blog.image!,
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
                                      widget.blog.category!.toUpperCase(),
                                      style: TextStyle(fontSize: 8.0.sp),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.5.h),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            width: 80.0.w,
                                            child: Text(
                                              parse(widget.blog.blogTitle)
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
                                        children: [
                                          Text(
                                            "BY " +
                                                widget.blog.user!.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontFamily: 'Arial',
                                                fontSize: 8.0.sp),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 2.5.w),
                                            child: Text(
                                                widget.blog.dateDt!
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 8.0.sp)),
                                          ),
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
        ),
      ),
    );
  }
}
