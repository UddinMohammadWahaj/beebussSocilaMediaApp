import 'package:bizbultest/models/personal_blog_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/blogbuzz_single_category_page.dart';
import 'package:bizbultest/view/expanded_blog_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class PersonalBlogCard extends StatefulWidget {
  final PersonalBlogModel? blog;
  final int? index;
  final int? lastIndex;

  PersonalBlogCard({Key? key, this.blog, this.index, this.lastIndex})
      : super(key: key);

  @override
  _PersonalBlogCardState createState() => _PersonalBlogCardState();
}

class _PersonalBlogCardState extends State<PersonalBlogCard> {
  var indexList = [0, 1, 7, 8, 14, 15, 21, 22, 28];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpandedBlogPage(
                      from: "personal",
                      personalblog: widget.blog!,
                      blogID: widget.blog!.blogId,
                    )));
      },
      child: Container(
        child: indexList.contains(widget.index)
            ? Column(
                children: [
                  widget.index == 0
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 4.0.h, bottom: 4.0.h),
                              child: Container(
                                child: Text(
                                  widget.blog!.userName! + " - Blog",
                                  style: blackBold.copyWith(
                                      fontSize: 16.0.sp, fontFamily: "Georgie"),
                                  textAlign: TextAlign.center,
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
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.blog!.image!,

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
                                      widget.blog!.category!.toUpperCase(),
                                      style: TextStyle(fontSize: 8.0.sp),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.5.h),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            width: 80.0.w,
                                            child: Text(
                                              parse(widget.blog!.content)
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
                                                widget.blog!.userName!
                                                    .toUpperCase(),
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
                                                widget.blog!.timeStamp
                                                        ?.toUpperCase() ??
                                                    "",
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
              )
            : Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 2.0.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImage(
                          width: 35.0.w,
                          height: 50.0.w,
                          fit: BoxFit.cover,
                          imageUrl: widget.blog!.image!,

                          // errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
                        Container(
                          height: 25.h,
                          width: 55.0.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.blog!.category!.toUpperCase(),
                                style: TextStyle(fontSize: 8.0.sp),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Text(
                                    parse(widget.blog!.content)
                                        .documentElement!
                                        .text,
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: "Georgie"),
                                    maxLines: 2),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.2.h),
                                child: Text(
                                  "BY " + widget.blog!.userName!.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontFamily: 'Arial'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1.8.h),
                                child: Text(
                                    widget.blog!.timeStamp?.toUpperCase() ?? "",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 8.0.sp)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Divider(
                        height: 5,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
