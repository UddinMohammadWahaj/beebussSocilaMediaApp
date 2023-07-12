import 'package:bizbultest/models/discover_feed_model.dart';
import 'package:bizbultest/models/discover_posts_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/locations_page.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../test.dart';

class DiscoverFeedsFirstHeader extends StatefulWidget {
  final DiscoverPostsModel? feed;
  final String? memberID;
  final String? memberImage;
  final String? logo;
  final String? country;
  final VoidCallback? onPress;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  DiscoverFeedsFirstHeader(
      {Key? key,
      this.feed,
      this.memberID,
      this.memberImage,
      this.logo,
      this.country,
      this.onPress,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  _DiscoverFeedsFirstHeaderState createState() =>
      _DiscoverFeedsFirstHeaderState();
}

class _DiscoverFeedsFirstHeaderState extends State<DiscoverFeedsFirstHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                OtherUser().otherUser.memberID = widget.feed!.postMemberId;
                OtherUser().otherUser.shortcode = widget.feed!.postShortcode;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePageMain(
                            setNavBar: widget.setNavBar!,
                            isChannelOpen: widget.isChannelOpen!,
                            changeColor: widget.changeColor!,
                            otherMemberID: widget.feed!.postMemberId!,
                          )));
            },
            child: Row(
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
                    backgroundImage:
                        NetworkImage(widget.feed!.postUserPicture!),
                  ),
                ),
                SizedBox(
                  width: 4.0.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.feed!.postShortcode!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Helvetica Neue"),
                    ),
                    widget.feed!.postHeaderLocation != ""
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocationPage(
                                            latitude: widget.feed!.postDataLat,
                                            longitude:
                                                widget.feed!.postDataLong,
                                            logo: widget.logo!,
                                            country: widget.country!,
                                            memberID: widget.memberID!,
                                            locationName:
                                                widget.feed!.postHeaderLocation,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Container(
                                  width: 175,
                                  child: Text(
                                    widget.feed!.postHeaderLocation != "" &&
                                            widget.feed!.postHeaderLocation !=
                                                null
                                        ? widget.feed!.postHeaderLocation
                                        : "",
                                    style: TextStyle(color: Colors.grey[600]),
                                  )),
                            ),
                          )
                        : Container(),
                    /*    widget.feed.postMemberId != CurrentUser().currentUser.memberID && widget.feed.boostData > 0
                        ? Container(
                      child: Row(
                        children: [
                          Text("Sponsored"),
                          SizedBox(
                            width: 0.5.w,
                          ),
                          Icon(
                            Icons.public,
                            size: 15,
                          )
                        ],
                      ),
                    )
                        : Container()*/
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
              onTap: widget.onPress ?? () {},
              child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.more_horiz),
                  )))
        ],
      ),
    );
  }
}
