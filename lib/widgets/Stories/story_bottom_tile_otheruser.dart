import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StoryBottomTileOtherUser extends StatelessWidget {
  final VoidCallback? copyLink;
  final VoidCallback? shareTo;

  StoryBottomTileOtherUser({Key? key, this.copyLink, this.shareTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
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
