import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/suggested_users_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_likes_api_calls.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionsPopup extends StatefulWidget {
  final VoidCallback? onPressed;
  final SuggestedUsers? user;

  SuggestionsPopup({Key? key, this.onPressed, this.user}) : super(key: key);

  @override
  _SuggestionsPopupState createState() => _SuggestionsPopupState();
}

class _SuggestionsPopupState extends State<SuggestionsPopup> {
  SuggestedUsers? user;

  Widget _title() {
    return Text(
      user!.shortcode!,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _subtitle() {
    return Text(
      user!.name!,
      style: TextStyle(color: Colors.black54, fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _profileImage() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(user!.image!),
    );
  }

  Widget _followButton() {
    return Container(
      height: 30,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryBlueColor),
              // disabledColor: primaryBlueColor,
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () async {
            // if (user.followStatus == 0) {
            //   setState(() {
            //     user.followStatus = "Following";
            //   });
            //   // FeedLikeApiCalls.followUser(user.memberId, 0);
            //   FeedLikeApiCalls.memberfollowunfollow(
            //       user.memberId, user.followStatus);
            // } else {
            //   setState(() {
            //     user.followStatus = "Follow";
            //   });

            var status = await FeedLikeApiCalls.memberfollowunfollow(
                user!.memberId!, user!.followStatus);
            setState(() {
              user!.followStatus = status;
            });
            // FeedLikeApiCalls.unfollow(user.memberId, 0);
            // }
          },
          // color: primaryBlueColor,
          // disabledColor: primaryBlueColor,
          child: Text(
            user!.followStatus == 1
                ? "Following"
                : user!.followStatus == 0
                    ? "Follow"
                    : user!.followStatus == 4
                        ? "Follow Back"
                        : "Requested",
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }

  @override
  void initState() {
    user = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      onTap: widget.onPressed,
      dense: false,
      leading: _profileImage(),
      title: _title(),
      subtitle: _subtitle(),
      trailing: _followButton(),
    ));
  }
}
