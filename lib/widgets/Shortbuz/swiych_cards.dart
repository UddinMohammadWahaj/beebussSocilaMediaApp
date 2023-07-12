import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AllowComments extends StatelessWidget {
  final bool? allowComments;
  final ValueChanged<bool?>? onChanged;

  AllowComments({Key? key, this.allowComments, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h, left: 3.0.w, right: 3.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.comment_outlined,
                color: Colors.grey,
                size: 3.0.h,
              ),
              SizedBox(
                width: 3.0.w,
              ),
              Text(
                AppLocalizations.of(
                  "Allow comments",
                ),
                style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
              ),
            ],
          ),
          Row(
            children: [
              Switch(
                value: allowComments!,
                onChanged: onChanged ?? (val) {},
                activeTrackColor: primaryBlueColor.withOpacity(0.4),
                activeColor: primaryBlueColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SaveToDevice extends StatelessWidget {
  final bool? save;
  final ValueChanged<bool?>? onChanged;

  SaveToDevice({Key? key, this.save, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.save_outlined,
                color: Colors.grey,
                size: 3.0.h,
              ),
              SizedBox(
                width: 3.0.w,
              ),
              Text(
                AppLocalizations.of(
                  "Save to device",
                ),
                style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
              ),
            ],
          ),
          Row(
            children: [
              Switch(
                value: save!,
                onChanged: onChanged ?? (val) {},
                activeTrackColor: primaryBlueColor.withOpacity(0.4),
                activeColor: primaryBlueColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
