import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HighlightsBottomTile extends StatelessWidget {
  final VoidCallback? remove;
  final VoidCallback? edit;
  final VoidCallback? copyLink;
  final VoidCallback? shareTo;

  HighlightsBottomTile(
      {Key? key, this.remove, this.edit, this.copyLink, this.shareTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            onTap: edit ?? () {},
            title: Text(
              AppLocalizations.of(
                "Edit Highlight",
              ),
              style: TextStyle(color: Colors.red, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: remove ?? () {},
            title: Text(
              AppLocalizations.of(
                "Remove from Highlight",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                "Send to",
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
