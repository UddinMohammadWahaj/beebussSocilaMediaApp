import 'dart:convert';

import 'package:bizbultest/models/current_user_followers_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_likes_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class FollowerFollowingCard extends StatefulWidget {
  final UserFollowersFollowingModel user;
  final VoidCallback onTap;

  const FollowerFollowingCard(
      {Key? key, required this.user, required this.onTap})
      : super(key: key);

  @override
  _FollowerFollowingCardState createState() => _FollowerFollowingCardState();
}

class _FollowerFollowingCardState extends State<FollowerFollowingCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      visualDensity: VisualDensity(horizontal: 0, vertical: -1),
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(widget.user.userImage!),
        ),
      ),
      title: Text(
        widget.user.shortcode!,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 15),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.user.memberFirstname!,
        style: TextStyle(fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: widget.user.memberId != CurrentUser().currentUser.memberID
          ? GestureDetector(
              onTap: () {
                if (widget.user.followText == "Follow") {
                  setState(() {
                    widget.user.followText = "Following";
                  });
                  FeedLikeApiCalls.followUser(widget.user.memberId!, 0);
                } else if (widget.user.followText == "Requested") {
                  setState(() {
                    widget.user.followText = "Follow";
                  });
                  FeedLikeApiCalls.cancelRequest(widget.user.memberId!, 0);
                } else {
                  FeedLikeApiCalls.unfollow(widget.user.memberId!, 01);
                  setState(() {
                    widget.user.followText = "Follow";
                  });
                }
              },
              child: Container(
                  height: 30,
                  width: 80,
                  decoration: new BoxDecoration(
                    color: widget.user.followText == "Follow"
                        ? primaryBlueColor
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: Colors.black54,
                      width: widget.user.followText == "Follow" ? 0 : 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.user.followText,
                      style: TextStyle(
                          fontSize: 14,
                          color: widget.user.followText == "Follow"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
            )
          : Container(
              height: 0,
              width: 0,
            ),
    );
  }
}
