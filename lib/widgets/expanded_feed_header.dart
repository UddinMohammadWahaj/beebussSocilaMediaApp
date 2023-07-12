import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:html/parser.dart';
import 'package:sizer/sizer.dart';

class ExpandedFeedHeader extends StatefulWidget {
  final VoidCallback? onPressedLikeButton;
  final VoidCallback? onPressedCommentButton;
  final String? postLikeIcon;
  final String? postUserPicture;
  final int? postTotalLikes;
  final String? postRebuzData;
  final String? postShortcode;
  final ValueChanged<String?>? onPressMatchText;
  final String? postContent;
  final String? timeStamp;
  final String? postHeaderLocation;
  final String? currentMemberImage;
  final String? currentMemberShortcode;
  final String? test;

  ExpandedFeedHeader(
      {Key? key,
      this.onPressedLikeButton,
      this.onPressedCommentButton,
      this.postLikeIcon,
      this.postTotalLikes,
      this.postRebuzData,
      this.postShortcode,
      this.onPressMatchText,
      this.postContent,
      this.timeStamp,
      this.postUserPicture,
      this.postHeaderLocation,
      this.currentMemberImage,
      this.currentMemberShortcode,
      this.test})
      : super(key: key);

  @override
  _ExpandedFeedHeaderState createState() => _ExpandedFeedHeaderState();
}

class _ExpandedFeedHeaderState extends State<ExpandedFeedHeader> {
  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 3.0.h),
      child: Column(
        children: [
          Container(
            width: 95.0.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(widget.postUserPicture!),
                      ),
                    ),
                    SizedBox(
                      width: 3.0.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5),
                          child: Row(
                            children: [
                              widget.postRebuzData != ""
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 72.0.w,
                                          child: ParsedText(
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            text: widget.postShortcode! +
                                                "  " +
                                                widget.postRebuzData!,
                                            parse: <MatchText>[
                                              MatchText(
                                                  onTap: widget
                                                          .onPressMatchText! ??
                                                      (value) {},
                                                  /*print(value);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => HashtagPage(
                                                          hashtag: value.toString().substring(1),
                                                        memberID: widget.memberID,
                                                        country: widget.country,
                                                        logo: widget.logo,
                                                      )));*/

                                                  pattern: "\A*(?= )",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              MatchText(
                                                  onTap:
                                                      widget.onPressMatchText ??
                                                          (value) {},
                                                  /*  print(value);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => HashtagPage(
                                                        hashtag: value.toString().substring(1),
                                                        memberID: widget.memberID,
                                                        country: widget.country,
                                                        logo: widget.logo,
                                                      )));*/

                                                  pattern:
                                                      "(@+[a-zA-Z0-9(_)]{1,})",
                                                  style: TextStyle(
                                                      color: feedColor,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              MatchText(
                                                  onTap:
                                                      widget.onPressMatchText ??
                                                          (value) {},
                                                  /* print(value);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => HashtagPage(
                                                        hashtag: value.toString().substring(1),
                                                        memberID: widget.memberID,
                                                        country: widget.country,
                                                        logo: widget.logo,
                                                      )));*/

                                                  pattern:
                                                      "(#+[a-zA-Z0-9(_)]{1,})",
                                                  style: TextStyle(
                                                      color: feedColor,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            width: 72.0.w,
                                            child: ParsedText(
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              text: widget.postContent!,
                                              parse: <MatchText>[
                                                MatchText(
                                                    onTap: widget
                                                            .onPressMatchText ??
                                                        (value) {},
                                                    /*  print(value);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => HashtagPage(
                                                          hashtag: value.toString().substring(1),
                                                          memberID: widget.memberID,
                                                          country: widget.country,
                                                          logo: widget.logo,
                                                        )));*/

                                                    pattern:
                                                        "(@+[a-zA-Z0-9(_)]{1,})",
                                                    style: TextStyle(
                                                        color: feedColor,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                MatchText(
                                                    onTap: widget
                                                            .onPressMatchText ??
                                                        (value) {},
                                                    /*  print(value);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => HashtagPage(
                                                          hashtag: value.toString().substring(1),
                                                          memberID: widget.memberID,
                                                          country: widget.country,
                                                          logo: widget.logo,
                                                        )));*/

                                                    pattern:
                                                        "(#+[a-zA-Z0-9(_)]{1,})",
                                                    style: TextStyle(
                                                        color: feedColor,
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      width: 72.0.w,
                                      child: Wrap(
                                        children: [
                                          FittedBox(
                                            child: Text(
                                              widget.postShortcode!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ParsedText(
                                            alignment: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                            softWrap: true,
                                            text: parse(widget.postContent)
                                                .documentElement!
                                                .text,
                                            parse: <MatchText>[
                                              MatchText(
                                                  onTap:
                                                      widget.onPressMatchText ??
                                                          (value) {},
                                                  /* print(value);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HashtagPage(
                                                    hashtag: value.toString().substring(1),
                                                    memberID: widget.memberID,
                                                    country: widget.country,
                                                    logo: widget.logo,
                                                  )));*/

                                                  pattern: "\A*(?= )",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              MatchText(
                                                  onTap:
                                                      widget.onPressMatchText ??
                                                          (value) {},
                                                  /*print(value);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HashtagPage(
                                                    hashtag: value.toString().substring(1),
                                                    memberID: widget.memberID,
                                                    country: widget.country,
                                                    logo: widget.logo,
                                                  )));*/

                                                  pattern:
                                                      "(@+[a-zA-Z0-9(_)]{1,})",
                                                  style: TextStyle(
                                                      color: feedColor,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              MatchText(
                                                  onTap:
                                                      widget.onPressMatchText ??
                                                          (value) {},
                                                  /* print(value);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HashtagPage(
                                                    hashtag: value.toString().substring(1),
                                                    memberID: widget.memberID,
                                                    country: widget.country,
                                                    logo: widget.logo,
                                                  )));*/

                                                  pattern:
                                                      "(#+[a-zA-Z0-9(_)]{1,})",
                                                  style: TextStyle(
                                                      color: feedColor,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                        ],
                                      )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 4),
                          child: Container(
                              width: 175,
                              child: Text(
                                widget.postHeaderLocation! != ""
                                    ? widget.postHeaderLocation!
                                    : "",
                                style: TextStyle(color: Colors.grey[600]),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                // GestureDetector(child: Icon(Icons.more_horiz_outlined),onTap: (){

                // },)
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(widget.test!),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 1.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.timeStamp!,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
