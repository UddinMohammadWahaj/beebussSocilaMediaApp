import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class ProfileDisplayCard extends StatefulWidget {
  final bool? showCategory;
  final bool? showContact;
  final String? category;

  const ProfileDisplayCard(
      {Key? key, this.showCategory, this.showContact, this.category})
      : super(key: key);

  @override
  _ProfileDisplayCardState createState() => _ProfileDisplayCardState();
}

class _ProfileDisplayCardState extends State<ProfileDisplayCard> {
  bool showCategory = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 1.0.h),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Column(
                      children: [],
                    ),
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        CurrentUser()
                            .currentUser
                            .posts
                            .toString()
                            .split(" ")[0],
                        style: blackBold.copyWith(fontSize: 14.0.sp),
                      ),
                      Text(
                        AppLocalizations.of(
                          "Posts",
                        ),
                        style: TextStyle(fontSize: 11.0.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 4.0.h,
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        CurrentUser()
                            .currentUser
                            .followers
                            .toString()
                            .split(" ")[0],
                        style: blackBold.copyWith(fontSize: 14.0.sp),
                      ),
                      Text(
                        AppLocalizations.of(
                          "Followers",
                        ),
                        style: TextStyle(fontSize: 11.0.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 4.0.h,
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        CurrentUser()
                            .currentUser
                            .following
                            .toString()
                            .split(" ")[0],
                        style: blackBold.copyWith(fontSize: 14.0.sp),
                      ),
                      Text(
                        AppLocalizations.of(
                          "Following",
                        ),
                        style: TextStyle(fontSize: 11.0.sp),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.0.h),
            child: Opacity(
              opacity: 0.3,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: new BoxDecoration(
                    color: primaryBlueColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    shape: BoxShape.rectangle,
                  ),
                  width: 60.0.w,
                  child: Padding(
                    padding: EdgeInsets.all(1.0.w),
                    child: Text(
                      AppLocalizations.of(
                        "Follow",
                      ),
                      style: whiteBold.copyWith(fontSize: 10.0.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(top: 2.5.h),
                child: Text(
                  CurrentUser().currentUser.fullName!,
                  style: blackBold.copyWith(fontSize: 10.0.sp),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
          widget.showCategory == true
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.0.w),
                      child: Text(
                        widget.category == null ? "" : widget.category!,
                        style: greyNormal.copyWith(fontSize: 10.0.sp),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                )
              : Container(),
          widget.showContact == true
              ? Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Container(
                          color: Colors.grey,
                          height: 0.5,
                          width: 100.0.w,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Text(
                          AppLocalizations.of(
                            'Email',
                          ),
                          style: blackBold.copyWith(color: primaryBlueColor),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
