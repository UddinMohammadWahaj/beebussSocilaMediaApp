import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/expanded_video_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class VideoBottomTile extends StatelessWidget {
  final VideoListModelData? video;
  final int? index;
  final VoidCallback? onPress;

  VideoBottomTile({Key? key, this.video, this.index, this.onPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Logger().e("video list model data error");

    return Container(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 3.0.w,
              bottom: 2.5.h,
              right: 3.0.w,
              top: 2.5.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 25.0.w,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        video!.image!,
                        height: 20.0.h,
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  height: 20.0.h,
                  width: 55.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.0.h),
                        child: Text(
                          video!.name!,
                          style: whiteBold.copyWith(fontSize: 18.0.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.0.h),
                        child: Row(
                          children: [
                            Text(
                              video!.numViews!,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.0.w),
                              child: Text(
                                video!.timeStamp!,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        video!.postContent!,
                        style: whiteNormal.copyWith(fontSize: 13.0.sp),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                      foregroundColor: Colors.grey.withOpacity(0.5),
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: onPress ?? () {},
            child: Padding(
              padding:
                  EdgeInsets.only(left: 3.0.w, right: 3.0.w, bottom: 3.0.h),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.0.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            size: 3.5.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.0.w),
                            child: Text(
                              AppLocalizations.of(
                                "Play",
                              ),
                              style: blackBold.copyWith(fontSize: 13.0.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
