import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PostReportOtherPopup extends StatefulWidget {
  final String? shortcode;
  final VoidCallback? violence;
  final VoidCallback? sale;
  final VoidCallback? harassment;
  final VoidCallback? intellectual;
  final VoidCallback? injury;

  PostReportOtherPopup(
      {Key? key,
      this.shortcode,
      this.violence,
      this.sale,
      this.harassment,
      this.intellectual,
      this.injury})
      : super(key: key);

  @override
  _PostReportOtherPopupState createState() => _PostReportOtherPopupState();
}

class _PostReportOtherPopupState extends State<PostReportOtherPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.h),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Violence or threat of violence',
              ),
            ),
            onTap: widget.violence ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Report as sale or promotion of drugs ?',
              ),
            ),
            onTap: widget.sale ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Harassment or bullying',
              ),
            ),
            onTap: widget.harassment ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Intellectual property violation',
              ),
            ),
            onTap: widget.intellectual ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Self injury',
              ),
            ),
            onTap: widget.injury ?? () async {},
          ),
        ],
      ),
    );
  }
}
