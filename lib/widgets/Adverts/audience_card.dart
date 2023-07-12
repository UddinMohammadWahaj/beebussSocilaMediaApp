import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'edit_audience_advert.dart';

class AudienceCard extends StatelessWidget {
  final int? index;
  final int? value;
  final AudienceModel? audience;
  final Function? onTap;
  final Function? onChanged;

  const AudienceCard(
      {Key? key,
      this.index,
      this.value,
      this.audience,
      this.onTap,
      this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 85.0.w,
          child: RadioListTile<dynamic>(
            dense: true,
            activeColor: primaryBlueColor,
            value: index,
            groupValue: value,
            onChanged: (ind) {
              onChanged!(ind);
            },
            title: Text(audience!.audienceName!),
            subtitle: Container(
              width: 85.0.w,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: audience!.audienceAgeData,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                //isScrollControlled:true,
                context: context,
                builder: (BuildContext bc) {
                  return EditAudienceAdvert(
                    refresh: onTap!,

                    audienceId: audience!.audienceId,
                    memberName: CurrentUser().currentUser.fullName,
                    memberImage: CurrentUser().currentUser.image,
                    //  feed: widget.feed,
                    logo: CurrentUser().currentUser.logo,
                    country: CurrentUser().currentUser.country,
                    memberID: CurrentUser().currentUser.memberID,
                  );
                });
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(left: 2.0.w),
              child: Text(
                AppLocalizations.of(
                  "Edit",
                ),
                style: TextStyle(color: primaryBlueColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
