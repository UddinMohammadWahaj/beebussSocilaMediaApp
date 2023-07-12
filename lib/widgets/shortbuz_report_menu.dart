import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'Bookmark/save_to_board_sheet.dart';

class ShortbuzReportMenu extends StatefulWidget {
  final VoidCallback? report;
  final VoidCallback? notInterested;
  final VoidCallback? saveVideo;
  final VoidCallback? copyLink;
  final String? image;
  final String? postID;

  const ShortbuzReportMenu(
      {Key? key,
      this.report,
      this.notInterested,
      this.saveVideo,
      this.copyLink,
      this.image,
      this.postID})
      : super(key: key);

  @override
  _ShortbuzReportMenuState createState() => _ShortbuzReportMenuState();
}

class _ShortbuzReportMenuState extends State<ShortbuzReportMenu> {
  Widget _iconButton(VoidCallback onPressed, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
            child: IconButton(
              splashRadius: 20,
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _iconButton(
              widget.report!,
              CustomIcons.flag,
              AppLocalizations.of(
                "Report",
              ),
            ),
            _iconButton(
              widget.notInterested!,
              CustomIcons.forbidden,
              AppLocalizations.of(
                "Not interested",
              ),
            ),
            _iconButton(
              widget.saveVideo!,
              CustomIcons.download,
              AppLocalizations.of(
                "Save video",
              ),
            ),
            _iconButton(
              widget.copyLink!,
              Icons.copy,
              AppLocalizations.of(
                "Copy Link",
              ),
            ),
            _iconButton(
              () {
                Navigator.pop(context);
                Get.bottomSheet(
                    SaveToBoardSheet(
                      image: widget.image!,
                      postID: widget.postID!,
                    ),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))));
              },
              CustomIcons.bookmark_thin,
              AppLocalizations.of("Save to board"),
            ),
          ],
        ),
      ),
    );
  }
}
