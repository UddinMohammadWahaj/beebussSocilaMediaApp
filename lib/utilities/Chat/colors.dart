import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

/// WhatsApp's signature green color.
final Color darkColor = const Color(0xff91596F);
final Color primaryColor = const Color(0xff91596F);

/// Secondary green color.
final Color secondaryColor = const Color(0xff91596F);
final Color highlightColor = const Color(0xffB46A4D);

/// White-ish background color.
final Color scaffoldBgColor = const Color(0xfffafafa);

/// FloatingActionButton's background color
final Color fabBgColor = Color(0xffA6635B); //const Color(0xff20c659);
final Color fabBgSecondaryColor = const Color(0xff507578);

final Color lightGrey = const Color(0xffe2e8ea);

final Color profileDialogBgColor = const Color(0xff73bfb8);
final Color profileDialogIconColor = const Color(0xff8ac9c3);

final Color chatDetailScaffoldBgColor = const Color(0xffe7e2db);
final Color directAppBarIconColor = darkColor.withOpacity(0.8);

final Color iconColor = const Color(0xff858b90);
final Color textFieldHintColor = const Color(0xffcdcdcd);

final Color messageBubbleColor = const Color(0xffe1ffc7);
final Color blueCheckColor = const Color(0xff3fbbec);

final Color statusThumbnailBorderColor = const Color(0xffF18910);
final Color directChatThumbnailBorderColor = const Color(0xffF18910);

final Color notificationBadgeColor =
    Color(0xffA6635B); //const Color(0xff08d160);

Widget gradientContainer(Widget? child) {
  return new Container(
    decoration: new BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          const Color(0xff2B25CC),
          const Color(0xffA6635B),
          const Color(0xff91596F),
          const Color(0xffB46A4D),
          const Color(0xffF18910),
          const Color(0xffA6635B),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: child,
  );
}

Widget gradientContainerForButton(Widget child) {
  return new Container(
    decoration: new BoxDecoration(
      shape: BoxShape.circle,
      gradient: new LinearGradient(
        colors: [
          const Color(0xff2B25CC),
          const Color(0xffA6635B),
          const Color(0xff91596F),
          const Color(0xffB46A4D),
          const Color(0xffF18910),
          const Color(0xffA6635B),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(child: child),
  );
}
