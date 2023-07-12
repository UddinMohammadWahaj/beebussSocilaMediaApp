import 'package:bizbultest/models/shortbuz_suggestions_model.dart';
import 'package:bizbultest/view/shortbuz_main_page.dart';
import 'package:bizbultest/widgets/discover_video_player.dart';
import 'package:bizbultest/widgets/discover_video_player_shortbuz.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SuggestedShortBuzzCard extends StatelessWidget {
  final ShorbuzSuggestionsModel? video;
  final VoidCallback? onTap;

  SuggestedShortBuzzCard({Key? key, this.video, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 1.0.w, bottom: 2.5.h, right: 1.0.w, top: 1.0.w),
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: Stack(
            children: [
              Container(
                width: 35.0.w,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: DiscoverVideoPlayerShortBuz(
                        image: video!.postImgData,
                        url: video!.video,
                        title: video!.postId,
                      )

                    // Image(image: CachedNetworkImageProvider(video.postImgData), fit: BoxFit.cover, height: 30.0.h)

                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w, vertical: 1.5.h),
                    child: Wrap(
                      children: [
                        // Text(video.postId.toString(),style: TextStyle(color: Colors.white),),
                        Padding(
                          padding: EdgeInsets.only(left: 1.0.w),
                          child: Text(
                            video!.postShortcode!.length > 13
                                ? video!.postShortcode!.substring(0, 13) + "..."
                                : video!.postShortcode! + "...",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 10.0.sp),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CupertinoButton(
                              minSize: double.minPositive,
                              padding: EdgeInsets.zero,
                              child: Icon(Icons.play_arrow_outlined,
                                  color: Colors.white, size: 5.0.w),
                              onPressed: () {},
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1.0.w),
                              child: Text(video!.postNumViews!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10.0.sp)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
