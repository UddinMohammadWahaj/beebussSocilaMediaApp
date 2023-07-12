import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'Chat/colors.dart';

Widget loadingAnimation() {
  return Image.asset(
    "assets/images/new_loading_black.gif",
    height: 3.0.h,
  );
}

Widget loadingAnimationBlackBackground() {
  return Image.asset(
    "assets/images/new_loading_white.gif",
    height: 3.0.h,
  );
}

Widget customCircularIndicator(double width, Color color) {
  return CircularProgressIndicator(
      strokeWidth: width, valueColor: AlwaysStoppedAnimation<Color>(color));
}

Widget downloadIndicator(double value) {
  return CircularProgressIndicator(
      value: value,
      backgroundColor: Colors.grey.shade300,
      color: Colors.white,
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation<Color>(darkColor));
}

Widget hashtagPlaceholder() {
  return Container(
    height: 40,
    child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(2),
            child: SkeletonAnimation(
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Container(
                      width: 35,
                    )),
              ),
            ),
          );
        }),
  );
}
