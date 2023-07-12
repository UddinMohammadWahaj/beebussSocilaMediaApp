import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:html/parser.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import 'discover_feed_first_card.dart';
import 'discover_feeds_first_header.dart';

class DiscoverFeedFirstCard extends StatefulWidget {
  final DiscoverPostsModel? feed;
  final String? memberID;
  final String? memberImage;
  final String? logo;
  final ValueChanged<String?>? onPressMatchText;
  final VoidCallback? onPress;
  final int? index;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  final String? country;

  final GlobalKey<ScaffoldState>? sKey;

  DiscoverFeedFirstCard(
      {Key? key,
      this.feed,
      this.memberID,
      this.memberImage,
      this.sKey,
      this.logo,
      this.country,
      this.onPressMatchText,
      this.onPress,
      this.index,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  _DiscoverFeedFirstCardState createState() => _DiscoverFeedFirstCardState();
}

class _DiscoverFeedFirstCardState extends State<DiscoverFeedFirstCard> {
  String emoji1 = "😥";
  String emoji2 = "😂";
  String emoji3 = "🔥";
  String emoji4 = "❤";
  String emoji5 = "🙌";
  String emoji6 = "👏";
  String emoji7 = "😍";
  String emoji8 = "😮";
  bool? showEmoji = false;

  String hintText = " Add a comment...";
  late bool showMore;

  @override
  void initState() {
    showMore = (widget.feed!.postContent!.length > 80 ? false : null)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.0.h),
      child: Container(
        child: Column(
          children: [
            widget.index == 0
                ? GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0.w, vertical: 1.5.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.keyboard_backspace_rounded,
                            size: 4.0.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.w),
                            child: Text(
                              AppLocalizations.of('Explore'),
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            DiscoverFeedsFirstHeader(
              setNavBar: widget.setNavBar,
              isChannelOpen: widget.isChannelOpen,
              changeColor: widget.changeColor,
              feed: widget.feed,
              country: widget.country,
              logo: widget.logo,
              memberImage: widget.memberImage,
              memberID: widget.memberID,
              onPress: widget.onPress,
            ),
            DiscoverFeedsFirstImageCard(
              post: widget.feed!,
              country: widget.country!,
              logo: widget.logo!,
              memberImage: widget.memberImage!,
              memberID: widget.memberID!,
              sKey: widget.sKey!,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.feed!.postRebuzData != ""
                        ? Container(
                            width: 90.0.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ParsedText(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  text: widget.feed!.postShortcode! +
                                      "  " +
                                      widget.feed!.postRebuzData!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  parse: <MatchText>[
                                    MatchText(
                                        onTap: (value) {},
                                        pattern: "\w*(?= )",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                    MatchText(
                                        onTap: (value) {},
                                        pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                                        style: TextStyle(
                                            color: feedColor,
                                            fontWeight: FontWeight.normal)),
                                    MatchText(
                                        onTap: (value) {},
                                        pattern: "(#+[a-zA-Z0-9(_)]{1,})",
                                        style: TextStyle(
                                            color: feedColor,
                                            fontWeight: FontWeight.normal))
                                  ],
                                ),
                                Container(
                                  width: 90.0.w,
                                  // height: _currentScreenSize.height * 0.06,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      ParsedText(
                                        style: TextStyle(color: Colors.black),
                                        text: parse(widget.feed!.postContent)
                                            .documentElement!
                                            .text,
                                        parse: <MatchText>[
                                          MatchText(
                                              onTap: (value) {},
                                              pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                                              style: TextStyle(
                                                  color: feedColor,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          MatchText(
                                              onTap: (value) {},
                                              pattern: "(#+[a-zA-Z0-9(_)]{1,})",
                                              style: TextStyle(
                                                  color: feedColor,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 90.0.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                ParsedText(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  text: showMore == null
                                      ? parse(widget.feed!.postShortcode)
                                              .documentElement!
                                              .text +
                                          "  " +
                                          parse(widget.feed!.postContent)
                                              .documentElement!
                                              .text
                                      : showMore == true
                                          ? parse(widget.feed!.postShortcode)
                                                  .documentElement!
                                                  .text +
                                              "  " +
                                              parse(widget.feed!.postContent)
                                                  .documentElement!
                                                  .text
                                          : parse(widget.feed!.postShortcode)
                                                  .documentElement!
                                                  .text +
                                              "  " +
                                              parse(widget.feed!.postContent)
                                                  .documentElement!
                                                  .text
                                                  .characters
                                                  .skipLast(widget.feed!
                                                          .postContent!.length -
                                                      80)
                                                  .toString() +
                                              " ...",
                                  parse: <MatchText>[
                                    MatchText(
                                        onTap: widget.onPressMatchText ??
                                            (value) {},
                                        pattern: "\A*(?= )",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                    MatchText(
                                        onTap: widget.onPressMatchText ??
                                            (value) {},
                                        pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                                        style: TextStyle(
                                            color: feedColor,
                                            fontWeight: FontWeight.normal)),
                                    MatchText(
                                        onTap: widget.onPressMatchText ??
                                            (value) {},
                                        pattern: "(#+[a-zA-Z0-9(_)]{1,})",
                                        style: TextStyle(
                                            color: feedColor,
                                            fontWeight: FontWeight.normal))
                                  ],
                                ),
                                widget.feed!.postContent!.length > 80
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showMore = !showMore;
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              showMore == null
                                                  ? ""
                                                  : showMore == true
                                                      ? AppLocalizations.of(
                                                          'less')
                                                      : AppLocalizations.of(
                                                          'more'),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                  ]),
            ),
            int.parse(widget.feed!.postTotalComment!) > 0
                ? GestureDetector(
                    /* onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiscoverExpandedFeed(
                          feed: widget.feed,
                          logo: widget.logo,
                          country: widget.country,
                          memberID: widget.memberID,
                        )));
              },*/
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 6),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of("View all comments"),
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.start,
                            )),
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.feed!.timeStamp!),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
