import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HighlightsProfileMenu extends StatelessWidget {
  final VoidCallback? edit;
  final VoidCallback? delete;
  final VoidCallback? copyLink;
  final VoidCallback? shareTo;

  HighlightsProfileMenu(
      {Key? key, this.edit, this.delete, this.copyLink, this.shareTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                height: 4,
                width: 40,
                decoration: new BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
          ),
          ListTile(
            onTap: edit ?? () {},
            title: Text(
              AppLocalizations.of(
                "Edit Highlight",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
            ),
          ),
          ListTile(
            onTap: delete ?? () {},
            title: Text(
              AppLocalizations.of(
                "Delete Highlight",
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
