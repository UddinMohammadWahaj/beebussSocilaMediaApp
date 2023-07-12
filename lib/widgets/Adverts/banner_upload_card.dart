import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../utilities/colors.dart';

class UploadBannerCard extends StatelessWidget {
  final int? uploadProgress;
  final VoidCallback? onTap;
  final String? text;
  final String? image;
  final bool? correctDimension;
  final String? errorText;

  const UploadBannerCard(
      {Key? key,
      this.uploadProgress,
      this.onTap,
      this.text,
      this.image,
      this.correctDimension,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("current banner image=$image");
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: Center(
          child: InkWell(
        onTap: onTap ?? () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    text!,
                    style: TextStyle(
                        fontSize: 9.5.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 1.5.w,
                  ),
                  image != ""
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 2.75.h,
                        )
                      : Container()
                ],
              ),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            uploadProgress == 0 && image == ""
                ? Center(
                    child: Container(
                      width: 90.0.w,
                      height: 25.0.h,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        shape: BoxShape.rectangle,
                        border: new Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.cloud_upload_outlined,
                          size: 12.0.h,
                        ),
                      ),
                    ),
                  )
                : uploadProgress! <= 100 && !image!.contains('https')
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.0.w, vertical: 2.0.h),
                              child: Text(
                                uploadProgress! < 100
                                    ? AppLocalizations.of("Processing")
                                    : AppLocalizations.of(
                                        "Processing Done!",
                                      ),
                                style: TextStyle(
                                    fontSize: 12.0.sp, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0.h,
                                  left: 1.0.w,
                                  right: 1.0.w,
                                  bottom: 2.0.h),
                              child: new LinearPercentIndicator(
                                backgroundColor:
                                    primaryBlueColor.withOpacity(0.3),
                                //width: 90.0.w,
                                animation: false,
                                lineHeight: 2.5.h,
                                animationDuration: 2500,
                                percent: uploadProgress! / 100,
                                center: Text(
                                  uploadProgress.toString() + "%",
                                  style: TextStyle(
                                      fontSize: 12.0.sp, color: Colors.white),
                                ),
                                linearStrokeCap: LinearStrokeCap.butt,
                                progressColor: primaryBlueColor,
                              ),
                            )
                          ])
                    : Container(
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: image!,
                              progressIndicatorBuilder: (_, __, ___) =>
                                  Center(child: loadingAnimation()),
                            )

                            // Image.network(
                            //   image,
                            //   fit: BoxFit.cover,
                            // ),
                            ),
                      ),
            !correctDimension!
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0.w, vertical: 1.0.h),
                    child: Container(
                      child: Text(
                        errorText!,
                        style: TextStyle(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      )),
    ));
  }
}
