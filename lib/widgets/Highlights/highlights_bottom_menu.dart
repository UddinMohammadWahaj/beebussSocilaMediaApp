import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Stories/story_menu_bottom_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HighlightBottomMenu extends StatefulWidget {
  final String? storyImage;
  final VoidCallback? highlightTap;
  final VoidCallback? savePhoto;
  final VoidCallback? openMore;
  final VoidCallback? share;

  HighlightBottomMenu(
      {Key? key,
      this.storyImage,
      this.highlightTap,
      this.savePhoto,
      this.openMore,
      this.share})
      : super(key: key);

  @override
  _HighlightBottomMenuState createState() => _HighlightBottomMenuState();
}

class _HighlightBottomMenuState extends State<HighlightBottomMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.only(bottom: 0.2.h),
              constraints: BoxConstraints(),
              onPressed: widget.share ?? () {},
              icon: Icon(
                Icons.share,
                color: Colors.white,
                size: 3.0.h,
              ),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Text(
              AppLocalizations.of(
                "Share",
              ),
              style: whiteBold.copyWith(fontSize: 8.0.sp),
            )
          ],
        ),
        SizedBox(
          width: 4.0.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.only(bottom: 0.2.h),
              constraints: BoxConstraints(),
              onPressed: widget.openMore ?? () {},
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 3.0.h,
              ),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Text(
              AppLocalizations.of('More'),
              style: whiteBold.copyWith(fontSize: 8.0.sp),
            )
          ],
        ),
      ],
    );
  }
}
