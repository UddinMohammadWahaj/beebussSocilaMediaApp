import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
// import 'package:charts_flutter/flutter.dart' as f;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShortbuzReportMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 2.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Icon(
                    CustomIcons.flag,
                    color: Colors.black,
                    size: 3.5.h,
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                AppLocalizations.of("Report"),
                style: TextStyle(fontSize: 8.0.sp),
              )
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Icon(
                    CustomIcons.forbidden,
                    color: Colors.black,
                    size: 3.5.h,
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                AppLocalizations.of("Not Interested"),
                style: TextStyle(fontSize: 8.0.sp),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Icon(
                    CustomIcons.download,
                    color: Colors.black,
                    size: 3.5.h,
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                AppLocalizations.of(
                  "Save video",
                ),
                style: TextStyle(fontSize: 8.0.sp),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Icon(
                    CustomIcons.duet,
                    color: Colors.black,
                    size: 3.5.h,
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                AppLocalizations.of(
                  "Duet",
                ),
                style: TextStyle(fontSize: 8.0.sp),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Icon(
                    CustomIcons.stich,
                    color: Colors.black,
                    size: 3.5.h,
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                AppLocalizations.of(
                  "Stich",
                ),
                style: TextStyle(fontSize: 8.0.sp),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      ),
    );
  }
}
