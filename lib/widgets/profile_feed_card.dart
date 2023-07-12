import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/profile_feed_model.dart';

import 'package:bizbultest/view/discover_expanded_feed.dart';
import 'package:bizbultest/widgets/profile_feed_header.dart';
import 'package:bizbultest/widgets/profile_feed_image_card.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:html/parser.dart';
import 'package:sizer/sizer.dart';

class ProfileFeedCard extends StatefulWidget {
  final ProfileFeedModel feed;
  final String memberID;
  final String memberImage;
  final String logo;
  final Function onPressMatchText;
  final VoidCallback onPress;

  final String country;

  final GlobalKey<ScaffoldState> sKey;

  ProfileFeedCard(
      {Key? key,
      required this.feed,
      required this.memberID,
      required this.memberImage,
      required this.sKey,
      required this.logo,
      required this.country,
      required this.onPressMatchText,
      required this.onPress})
      : super(key: key);

  @override
  _ProfileFeedCardState createState() => _ProfileFeedCardState();
}

class _ProfileFeedCardState extends State<ProfileFeedCard> {
  String emoji1 = "😥";
  String emoji2 = "😂";
  String emoji3 = "🔥";
  String emoji4 = "❤";
  String emoji5 = "🙌";
  String emoji6 = "👏";
  String emoji7 = "😍";
  String emoji8 = "😮";
  bool showEmoji = false;

  String hintText = " Add a comment...";
  late bool showMore;
  late bool showMoreRebuzz;

  @override
  void initState() {
    showMore = (widget.feed.postContent!.length > 80 ? false : null)!;
    showMoreRebuzz = (widget.feed.postContent!.length > 80 ? false : null)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.0.h),
      child: Container(
        child: Column(
          children: [
            ProfileFeedHeader(
              feed: widget.feed,
              country: widget.country,
              logo: widget.logo,
              memberImage: widget.memberImage,
              memberID: widget.memberID,
              onPress: widget.onPress,
            ),
            ProfileFeedsImageCard(
              feed: widget.feed,
              country: widget.country,
              logo: widget.logo,
              memberImage: widget.memberImage,
              memberID: widget.memberID,
              sKey: widget.sKey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.feed.postRebuzData != ""
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
                                  text: widget.feed.postShortcode! +
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
                                        text: showMoreRebuzz == null
                                            ? parse(widget.feed.postContent)
                                                .documentElement!
                                                .text
                                            : showMoreRebuzz == true
                                                ? parse(widget.feed.postContent)
                                                    .documentElement!
                                                    .text
                                                : parse(widget.feed.postContent)
                                                        .documentElement!
                                                        .text
                                                        .characters
                                                        .skipLast(widget
                                                                .feed
                                                                .postContent!
                                                                .length -
                                                            80)
                                                        .toString() +
                                                    " ...",
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
                                widget.feed.postContent!.length > 80
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showMoreRebuzz = !showMoreRebuzz;
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              showMoreRebuzz == null
                                                  ? ""
                                                  : showMoreRebuzz == true
                                                      ? AppLocalizations.of(
                                                          'less')
                                                      : AppLocalizations.of(
                                                          'More'),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
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
                                      ? parse(widget.feed.postShortcode)
                                              .documentElement!
                                              .text +
                                          "  " +
                                          parse(widget.feed.postContent)
                                              .documentElement!
                                              .text
                                      : showMore == true
                                          ? parse(widget.feed.postShortcode)
                                                  .documentElement!
                                                  .text +
                                              "  " +
                                              parse(widget.feed.postContent)
                                                  .documentElement!
                                                  .text
                                          : parse(widget.feed.postShortcode)
                                                  .documentElement!
                                                  .text +
                                              "  " +
                                              parse(widget.feed.postContent)
                                                  .documentElement!
                                                  .text
                                                  .characters
                                                  .skipLast(widget.feed
                                                          .postContent!.length -
                                                      80)
                                                  .toString() +
                                              " ...",
                                  parse: <MatchText>[
                                    MatchText(
                                        onTap: widget.onPressMatchText() ??
                                            (value) {},
                                        pattern: "\A*(?= )",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                    MatchText(
                                        onTap: widget.onPressMatchText() ??
                                            (value) {},
                                        pattern: "(@+[a-zA-Z0-9(_)]{1,})",
                                        style: TextStyle(
                                            color: feedColor,
                                            fontWeight: FontWeight.normal)),
                                    MatchText(
                                        onTap: widget.onPressMatchText() ??
                                            (value) {},
                                        pattern: "(#+[a-zA-Z0-9(_)]{1,})",
                                        style: TextStyle(
                                            color: feedColor,
                                            fontWeight: FontWeight.normal))
                                  ],
                                ),
                                widget.feed.postContent!.length > 80
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
                                                          'More'),
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
            int.parse(widget.feed.postTotalComment!) > 0
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiscoverExpandedFeed(
                                    //feed: widget.feed,
                                    logo: widget.logo,
                                    country: widget.country,
                                    memberID: widget.memberID,
                                  )));
                    },
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
                    (widget.feed.timeStamp!),
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
