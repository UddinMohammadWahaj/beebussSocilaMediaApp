import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class VideoReportMenu extends StatefulWidget {
  final String? shortcode;
  final VoidCallback? dontLikeIt;
  final VoidCallback? spam;
  final VoidCallback? nudity;
  final VoidCallback? hateSpeech;
  final VoidCallback? other;
  final String? followStatus;

  VideoReportMenu(
      {Key? key,
      this.shortcode,
      this.dontLikeIt,
      this.spam,
      this.nudity,
      this.hateSpeech,
      this.other,
      this.followStatus})
      : super(key: key);

  @override
  _VideoReportMenuState createState() => _VideoReportMenuState();
}

class _VideoReportMenuState extends State<VideoReportMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 5,
              width: 10.0.w,
            ),
          )),
          Center(
            child: Text(
              AppLocalizations.of(
                "Report",
              ),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.5.h),
            child: Container(
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(
                            "Choose a reason for reporting this post. We won't tell") +
                        " ",
                  ),
                  TextSpan(
                      text: widget.shortcode,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  TextSpan(text: " " + AppLocalizations.of("who reported them"))
                ]))),
          ),
          widget.followStatus != "Follow"
              ? ListTile(
                  title: Text(
                    AppLocalizations.of(
                      "I just don't like it",
                    ),
                    style: whiteNormal.copyWith(fontSize: 12.0.sp),
                  ),
                  onTap: widget.dontLikeIt ?? () async {},
                )
              : Container(),
          ListTile(
            title: Text(
              AppLocalizations.of(
                "It's spam",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            onTap: widget.spam ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Nudity or pornography',
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            onTap: widget.nudity ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Hate speech or symbols',
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            onTap: widget.hateSpeech ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Other',
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            onTap: widget.other ?? () async {},
          ),
        ],
      ),
    );
  }
}

class DontLikeVideoReport extends StatefulWidget {
  final VoidCallback? unfollow;
  final String? followStatus;
  final String? shortcode;

  DontLikeVideoReport(
      {Key? key, this.unfollow, this.followStatus, this.shortcode})
      : super(key: key);

  @override
  _DontLikeVideoReportState createState() => _DontLikeVideoReportState();
}

class _DontLikeVideoReportState extends State<DontLikeVideoReport> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.h),
      child: Container(
        child: Wrap(
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 5,
                width: 10.0.w,
              ),
            )),
            Center(
              child: Text(
                AppLocalizations.of(
                  "Report",
                ),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(
                    "Don't like this profile ?",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.0.h),
              child: Text(
                  AppLocalizations.of(
                        "Unfollow",
                      ) +
                      " "
                          " ${widget.shortcode}" +
                      AppLocalizations.of(
                        "so you won't see any of their photos, videos or story in your feed.",
                      ),
                  style: greyNormal),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 2.5.h),
                width: 175,
                child: ElevatedButton(
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5)),
                    onPressed: widget.unfollow ?? () {},
                    // color: primaryBlueColor,
                    // disabledColor: primaryBlueColor,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryBlueColor),
                        // disabledColor: primaryBlueColor,
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Text(
                      widget.followStatus!,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
