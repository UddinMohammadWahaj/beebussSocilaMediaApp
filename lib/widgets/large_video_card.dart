import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_search_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/expanded_video_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class LargeVideoCard extends StatefulWidget {
  final VideoListModelData? video;
  final VoidCallback? play;
  final int? index;
  final VoidCallback? hide;

  LargeVideoCard({Key? key, this.video, this.play, this.index, this.hide})
      : super(key: key);

  @override
  _LargeVideoCardState createState() => _LargeVideoCardState();
}

class _LargeVideoCardState extends State<LargeVideoCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.index == 0
            ? Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 3.0.w),
                      child: Text(
                        AppLocalizations.of(
                          "Search Results",
                        ),
                        style: whiteNormal.copyWith(fontSize: 14.0.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0.w),
                      child: FloatingActionButton(
                          splashColor: Colors.grey.withOpacity(0.3),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          elevation: 0,
                          onPressed: widget.hide ?? () {},
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.0.w),
                            child: Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 4.0.h,
                            ),
                          )),
                    )
                  ],
                ),
              )
            : Container(),
        InkWell(
          splashColor: Colors.grey.withOpacity(0.3),
          onTap: widget.play ?? () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        child: Image.network(
                          widget.video!.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.5.h),
                    child: Text(
                      widget.video!.postContent!,
                      style: whiteBold.copyWith(fontSize: 12.0.sp),
                    ),
                  ),
                  Text(
                    widget.video!.name!,
                    style: whiteNormal.copyWith(fontSize: 10.0.sp),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.video!.numViews!,
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w),
                        child: Text(
                          widget.video!.timeStamp!,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
