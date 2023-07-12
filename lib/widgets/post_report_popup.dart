import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class PostReportPopup extends StatefulWidget {
  final String ?shortcode;
  final VoidCallback? dontLikeIt;
  final VoidCallback? spam;
  final VoidCallback? nudity;
  final VoidCallback? hateSpeech;
  final VoidCallback ?other;

  PostReportPopup({Key? key, this.shortcode, this.dontLikeIt, this.spam, this.nudity, this.hateSpeech, this.other}) : super(key: key);

  @override
  _PostReportPopupState createState() => _PostReportPopupState();
}

class _PostReportPopupState extends State<PostReportPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 5,
              width: 10.0.w,
            ),
          )),
          Center(
            child: Text(
              AppLocalizations.of('Report'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.5.h),
            child: Container(
                child: RichText(
                    text: TextSpan(style: TextStyle(color: Colors.grey), children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(
                        "Choose a reason for reporting this post. We wont tell",
                      ) +
                      " "),
              TextSpan(text: widget.shortcode, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: " " +
                      AppLocalizations.of(
                        "who reported them",
                      ))
            ]))),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                "I just don't like it",
              ),
            ),
            onTap: widget.dontLikeIt ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                "It's spam",
              ),
            ),
            onTap: widget.spam ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Nudity or pornography',
              ),
            ),
            onTap: widget.nudity ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Hate speech or symbols',
              ),
            ),
            onTap: widget.hateSpeech ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Other',
              ),
            ),
            onTap: widget.other ?? () async {},
          ),
        ],
      ),
    );
  }
}
