import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OtherUserProfileMenu extends StatefulWidget {
  final VoidCallback? copyLink;
  final VoidCallback? shareTo;

  const OtherUserProfileMenu({Key? key, this.copyLink, this.shareTo})
      : super(key: key);
  @override
  _OtherUserProfileMenuState createState() => _OtherUserProfileMenuState();
}

class _OtherUserProfileMenuState extends State<OtherUserProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            onTap: widget.copyLink ?? () {},
            title: Text(
              AppLocalizations.of(
                "Copy Link",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: widget.shareTo ?? () {},
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
    ;
  }
}
