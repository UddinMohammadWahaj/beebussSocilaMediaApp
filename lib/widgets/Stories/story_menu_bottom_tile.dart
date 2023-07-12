import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/AgoraCallDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StoryBottomTileCurrentUser extends StatelessWidget {
  final VoidCallback? savePhoto;
  final VoidCallback? delete;
  final VoidCallback? shareAsPost;
  final VoidCallback? shareTo;
  final VoidCallback? copyLink;

  StoryBottomTileCurrentUser(
      {Key? key,
      this.savePhoto,
      this.delete,
      this.shareAsPost,
      this.shareTo,
      this.copyLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            onTap: delete ?? () {},
            title: Text(
              AppLocalizations.of(
                "Delete",
              ),
              style: TextStyle(color: Colors.red, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: savePhoto ?? () {},
            title: Text(
              AppLocalizations.of(
                "Save To Gallery",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: shareAsPost ?? () {},
            title: Text(
              AppLocalizations.of(
                "Share as post",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: copyLink ?? () {},
            title: Text(
              AppLocalizations.of(
                "Copy Link",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: shareTo ?? () {},
            title: Text(
              AppLocalizations.of(
                "Share to",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
            ),
          ),
        ],
      ),
    );
  }
}
