import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VideoCommentMenu extends StatefulWidget {
  final String? userID;
  final VoidCallback? delete;
  final VoidCallback? reportSpam;
  final VoidCallback? reportAbusive;

  VideoCommentMenu(
      {Key? key, this.userID, this.delete, this.reportSpam, this.reportAbusive})
      : super(key: key);

  @override
  _VideoCommentMenuState createState() => _VideoCommentMenuState();
}

class _VideoCommentMenuState extends State<VideoCommentMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.userID == CurrentUser().currentUser.memberID
          ? ListTile(
              onTap: widget.delete ?? () {},
              title: Text(
                  AppLocalizations.of(
                    "Delete",
                  ),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp)),
            )
          : ListTile(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    backgroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    //isScrollControlled:true,
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        child: Wrap(
                          children: [
                            ListTile(
                              onTap: widget.reportSpam ?? () {},
                              title: Text(
                                  AppLocalizations.of(
                                    "Spam or Scam",
                                  ),
                                  style:
                                      whiteNormal.copyWith(fontSize: 12.0.sp)),
                            ),
                            ListTile(
                              onTap: widget.reportAbusive ?? () {},
                              title: Text(
                                  AppLocalizations.of(
                                    "Abusive Content",
                                  ),
                                  style:
                                      whiteNormal.copyWith(fontSize: 12.0.sp)),
                            ),
                          ],
                        ),
                      );
                    });
              },
              title: Text(AppLocalizations.of("Report"),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp)),
            ),
    );
  }
}
