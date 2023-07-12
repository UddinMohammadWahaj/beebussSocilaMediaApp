
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SingleCategoryExpandedVideoCard extends StatefulWidget {
  final VideoListModelData video;
  final int index;
  final VoidCallback hide;
  final VoidCallback playVideo;

  SingleCategoryExpandedVideoCard(
      {Key? key,
      required this.video,
      required this.index,
      required this.hide,
      required this.playVideo})
      : super(key: key);

  @override
  _SingleCategoryExpandedVideoCardState createState() =>
      _SingleCategoryExpandedVideoCardState();
}

class _SingleCategoryExpandedVideoCardState
    extends State<SingleCategoryExpandedVideoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey.withOpacity(0.3),
      onTap: widget.playVideo ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 3.0.h),
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.index == 0
                  ? InkWell(
                      splashColor: Colors.grey.withOpacity(0.3),
                      onTap: widget.hide ?? () {

                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(bottom: 3.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   widget.video.categoryIt,
                            //   style: whiteBold.copyWith(fontSize: 15.0.sp),
                            // ),
                            Text(
                              CurrentUser()
                                          .currentUser
                                          .country!
                                          .toLowerCase() ==
                                      "italy"
                                  ? widget.video.categoryIt!
                                  : widget.video.category!,
                              // widget.video.categoryIt == "Art and Design"
                              //     ? AppLocalizations.of(
                              //         "Art and Design",
                              //       )
                              //     : widget.video.categoryIt ==
                              //             "Autos and Vehicles"
                              //         ? AppLocalizations.of(
                              //             "Autos and Vehicles",
                              //           )
                              //         : widget.video.categoryIt == "Beauty"
                              //             ? AppLocalizations.of(
                              //                 "Beauty",
                              //               )
                              //             : widget.video.categoryIt ==
                              //                     "Business"
                              //                 ? AppLocalizations.of(
                              //                     "Business",
                              //                   )
                              //                 : widget.video.categoryIt ==
                              //                         "Children and family films"
                              //                     ? AppLocalizations.of(
                              //                         "Children and family films",
                              //                       )
                              //                     : widget.video.categoryIt ==
                              //                             "Comedy"
                              //                         ? AppLocalizations.of(
                              //                             "Comedy",
                              //                           )
                              //                         : widget.video
                              //                                     .categoryIt ==
                              //                                 "Crypto"
                              //                             ? AppLocalizations.of(
                              //                                 "Crypto",
                              //                               )
                              //                             : widget.video
                              //                                         .categoryIt ==
                              //                                     "Documentaries"
                              //                                 ? AppLocalizations
                              //                                     .of(
                              //                                     "Documentaries",
                              //                                   )
                              //                                 : widget.video
                              //                                             .categoryIt ==
                              //                                         "Education"
                              //                                     ? AppLocalizations
                              //                                         .of(
                              //                                         "Education",
                              //                                       )
                              //                                     : widget.video
                              //                                                 .categoryIt ==
                              //                                             "Entertainment"
                              //                                         ? AppLocalizations
                              //                                             .of(
                              //                                             "Entertainment",
                              //                                           )
                              //                                         : widget.video.categoryIt ==
                              //                                                 "Events"
                              //                                             ? AppLocalizations
                              //                                                 .of(
                              //                                                 "Events",
                              //                                               )
                              //                                             : widget.video.categoryIt == "Fashion"
                              //                                                 ? AppLocalizations.of(
                              //                                                     "Fashion",
                              //                                                   )
                              //                                                 : widget.video.categoryIt == "Films"
                              //                                                     ? AppLocalizations.of(
                              //                                                         "Films",
                              //                                                       )
                              //                                                     : widget.video.categoryIt == "Food"
                              //                                                         ? AppLocalizations.of(
                              //                                                             "Food",
                              //                                                           )
                              //                                                         : widget.video.categoryIt == "Funny"
                              //                                                             ? AppLocalizations.of(
                              //                                                                 "Funny",
                              //                                                               )
                              //                                                             : widget.video.categoryIt == "Gaming"
                              //                                                                 ? AppLocalizations.of(
                              //                                                                     "Gaming",
                              //                                                                   )
                              //                                                                 : widget.video.categoryIt == "Home"
                              //                                                                     ? AppLocalizations.of(
                              //                                                                         "Home",
                              //                                                                       )
                              //                                                                     : widget.video.categoryIt == "Lifestyle"
                              //                                                                         ? AppLocalizations.of(
                              //                                                                             "Lifestyle",
                              //                                                                           )
                              //                                                                         : widget.video.categoryIt == "Music"
                              //                                                                             ? AppLocalizations.of(
                              //                                                                                 "Music",
                              //                                                                               )
                              //                                                                             : widget.video.categoryIt == "Nature"
                              //                                                                                 ? AppLocalizations.of(
                              //                                                                                     "Nature",
                              //                                                                                   )
                              //                                                                                 : widget.video.categoryIt == "News"
                              //                                                                                     ? AppLocalizations.of(
                              //                                                                                         "News",
                              //                                                                                       )
                              //                                                                                     : widget.video.categoryIt == "Nonprofit and Activism"
                              //                                                                                         ? AppLocalizations.of("Nonprofit and Activism")
                              //                                                                                         : widget.video.categoryIt == "OutdoorsPeople and Blogs"
                              //                                                                                             ? AppLocalizations.of("OutdoorsPeople and Blogs")
                              //                                                                                             : widget.video.categoryIt == "Pets and Animals"
                              //                                                                                                 ? AppLocalizations.of("Pets and Animals")
                              //                                                                                                 : widget.video.categoryIt == "Photography"
                              //                                                                                                     ? AppLocalizations.of("Photography")
                              //                                                                                                     : widget.video.categoryIt.toString() == "politics"
                              //                                                                                                         ? AppLocalizations.of("politics")
                              //                                                                                                         : widget.video.categoryIt == "Real estate"
                              //                                                                                                             ? AppLocalizations.of("Real estate")
                              //                                                                                                             : widget.video.categoryIt == "Recipe"
                              //                                                                                                                 ? AppLocalizations.of("Recipe")
                              //                                                                                                                 : widget.video.categoryIt == "Romance"
                              //                                                                                                                     ? AppLocalizations.of("Romance")
                              //                                                                                                                     : widget.video.categoryIt == "Satire"
                              //                                                                                                                         ? AppLocalizations.of("Satire")
                              //                                                                                                                         : widget.video.categoryIt == "Science"
                              //                                                                                                                             ? AppLocalizations.of("Science")
                              //                                                                                                                             : widget.video.categoryIt == "Series"
                              //                                                                                                                                 ? AppLocalizations.of("Series")
                              //                                                                                                                                 : widget.video.categoryIt == "Social media"
                              //                                                                                                                                     ? AppLocalizations.of("Social media")
                              //                                                                                                                                     : widget.video.categoryIt == "Sport"
                              //                                                                                                                                         ? AppLocalizations.of("Sport")
                              //                                                                                                                                         : widget.video.categoryIt == "Tech"
                              //                                                                                                                                             ? AppLocalizations.of("Tech")
                              //                                                                                                                                             : widget.video.categoryIt == "Travel"
                              //                                                                                                                                                 ? AppLocalizations.of("Travel")
                              //                                                                                                                                                 : widget.video.categoryIt == "Tutorials"
                              //                                                                                                                                                     ? AppLocalizations.of("Tutorials")
                              //                                                                                                                                                     : widget.video.categoryIt == "TV"
                              //                                                                                                                                                         ? AppLocalizations.of("TV")
                              //                                                                                                                                                         : AppLocalizations.of("TV"),
                              style: whiteBold.copyWith(fontSize: 15.0.sp),
                            ),

                            Container(
                              child: Icon(
                                Icons.cancel,
                                size: 3.5.h,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                      child: Image(
                    image: CachedNetworkImageProvider(widget.video.image!),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.5.h),
                child: Text(
                  widget.video.postContent!,
                  style: whiteBold.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Text(
                widget.video.shortcode!,
                style: whiteNormal.copyWith(fontSize: 10.0.sp),
              ),
              Row(
                children: [
                  Text(
                    widget.video.numViews!,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.0.w),
                    child: Text(
                      widget.video.timeStamp!,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
