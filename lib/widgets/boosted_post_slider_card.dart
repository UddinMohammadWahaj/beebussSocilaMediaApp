import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/boost_post_slider_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/view_boost_results.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BoostedPostCards extends StatefulWidget {
  final BoostPostSliderModel? boost;
  final NewsFeedModel? feed;
  final String? memberID;
  final String? country;
  final String? memberImage;
  final String? memberName;

  BoostedPostCards(
      {Key? key,
      this.boost,
      this.memberID,
      this.country,
      this.memberImage,
      this.memberName,
      this.feed})
      : super(key: key);

  @override
  _BoostedPostCardsState createState() => _BoostedPostCardsState();
}

class _BoostedPostCardsState extends State<BoostedPostCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0.w),
      child: Container(
        width: 95.0.w,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(1.0.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.boost!.boostDate!, style: blackBold),
                          Text(
                            widget.boost!.boostedBy!,
                            style: blackBold,
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.boost!.boostStatus!,
                        style: blackBold,
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.grey.withOpacity(0.3),
                      width: 45.0.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0.h, horizontal: 1.5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "People Reached",
                              ),
                              style: blackBold,
                            ),
                            Text(
                              widget.boost!.peopleReached.toString(),
                              style: blackBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 45.0.w,
                      color: Colors.grey.withOpacity(0.3),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0.h, horizontal: 1.5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Link Clicks",
                              ),
                              style: blackBold,
                            ),
                            Text(
                              widget.boost!.linksClicks.toString(),
                              style: blackBold,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // print(widget.feed.postId);
                      print(widget.boost!.postId);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BoostResults(
                                    feed: widget.feed!,
                                    memberImage: widget.memberImage!,
                                    memberName: widget.memberName!,
                                    postID: widget.boost!.postId,
                                    postType: widget.boost!.postType,
                                    memberID: widget.memberID!,
                                    boostID: widget.boost!.boostId,
                                    country: widget.country!,
                                  )));
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(1.5.h),
                          child: Text(
                            AppLocalizations.of(
                              "View Results",
                            ),
                            style: blackBold.copyWith(color: primaryBlueColor),
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
