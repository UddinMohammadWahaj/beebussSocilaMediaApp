import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

// import 'package:awesome_notifications/android_foreground_service.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

class NotificationUtils {
  static Future<bool> requestBasicPermissionToSendNotifications(
      BuildContext context) async {
    //NPcom

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Color(0xfffbfbfb),
                title: Text('Get Notified!',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.fitWidth,
                    ),
                    Text(
                      'Allow Awesome Notifications to send you beautiful notifications!',
                      maxLines: 4,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Later',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )),
                  TextButton(
                    onPressed: () async {
                      //NPcom
                      isAllowed = await AwesomeNotifications()
                          .requestPermissionToSendNotifications();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Allow',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ));
    }
    return isAllowed;
  }

  static Future<void> showCallNotification(int id) async {
    // String platformVersion = await getPlatformVersion();
    // AndroidForegroundService.startForeground(

//NPcom
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Incoming Call',
          body: 'from Kishan',
          category: NotificationCategory.Call,
          largeIcon: 'asset://assets/images/album.png',
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          // backgroundColor: (platformVersion == 'Android-31')
          //     ? Color(0x00796a)
          //     : Colors.white,
          payload: {'username': 'Kishan'},
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'ACCEPT',
              label: 'Accept Call',
              color: Colors.green,
              autoDismissible: true),
          NotificationActionButton(
            key: 'REJECT',
            label: 'Reject',
            isDangerousOption: true,
            autoDismissible: true,
          ),
        ]);
  }

//   static Future<void> showNotificationWithIconsAndActionButtons(int id) async {
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: id,
//             channelKey: 'call_channel',
//             title: 'Anonymous says:',
//             body: 'Hi there!',
//             payload: {'uuid': 'user-profile-uuid'}),
//         actionButtons: [
//           NotificationActionButton(
//             key: 'READ',
//             label: 'Mark as read',
//             autoDismissible: true,
//           ),
//           NotificationActionButton(
//               key: 'PROFILE',
//               label: 'Profile',
//               autoDismissible: true,
//               color: Colors.green),
//           NotificationActionButton(
//               key: 'DISMISS',
//               label: 'Dismiss',
//               autoDismissible: true,
//               buttonType: ActionButtonType.DisabledAction,
//               isDangerousOption: true)
//         ]);
//   }
}

Future<String> getPlatformVersion() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    return 'Android-$sdkInt';
  }

  if (Platform.isIOS) {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    var systemName = iosInfo.systemName;
    var version = iosInfo.systemVersion;
    return '$systemName-$version';
  }

  return 'unknow';
}
