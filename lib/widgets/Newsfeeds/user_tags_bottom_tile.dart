import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/expanded_user_tags_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class TaggedUsersBottomTile extends StatelessWidget {
  final int? index;
  final TaggedUsersModel? user;
  final VoidCallback? onTap;
  final VoidCallback? goToProfile;
  final String? type;

  const TaggedUsersBottomTile(
      {Key? key,
      this.index,
      this.user,
      this.onTap,
      this.goToProfile,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 4.0.w, right: 4.0.h, top: 1.0.h, bottom: 2.0.h),
      child: Column(
        children: [
          index == 0
              ? Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.0.h, bottom: 1.0.h),
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          height: 0.6.h,
                          width: 8.0.w,
                        ),
                      ),
                      Text(
                        type == "image"
                            ? AppLocalizations.of(
                                "In This Photo",
                              )
                            : AppLocalizations.of(
                                "In This Video",
                              ),
                        style: TextStyle(
                            fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
            child: InkWell(
              onTap: goToProfile ?? () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 3.0.h,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(user!.imageUser!),
                        ),
                      ),
                      SizedBox(
                        width: 3.0.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user!.shortcode!,
                            style: TextStyle(fontSize: 10.0.sp),
                          ),
                          Text(
                            user!.name!,
                            style: TextStyle(fontSize: 10.0.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      user!.memberId != CurrentUser().currentUser.memberID
                          ? InkWell(
                              splashColor: Colors.grey.withOpacity(0.3),
                              onTap: onTap ?? () {},
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: primaryBlueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.0.w, vertical: 0.8.h),
                                  child: Text(
                                    user!.followData!,
                                    style:
                                        whiteBold.copyWith(fontSize: 10.0.sp),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
