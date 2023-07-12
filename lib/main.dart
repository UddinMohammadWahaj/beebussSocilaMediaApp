// Member id - 1791943
//
// M member id - 1797121

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/app.dart';

import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

/*
AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationDetails androidPlatformChannelSpecifics;
NotificationDetails platformChannelSpecifics;

*/
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}




late String selectedNotificationPayload;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferencesAndroid.registerWith();
  // await Firebase.initializeApp();

  if (!kIsWeb) {
    // channel = const AndroidNotificationChannel(
    //     'high_importance_channel', // id
    //     'High Importance Notifications', // title
    //     'This channel is used for important notifications.', // description
    //     importance: Importance.high,
    //     playSound: true);

    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

  var pref;
  try {
    pref = await SharedPreferences.getInstance();
  } catch (e) {
    print("shared pref error=${e}");
  }

  AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelGroupKey: 'category_tests',
          channelKey: 'call_channel',
          channelName: 'Calls Channel',
          channelDescription: 'Channel with call ringtone',
          defaultColor: Color(0xFF9D50DD),
          importance: NotificationImportance.Max,
          ledColor: Colors.white,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'category_tests',
            channelGroupName: 'Category tests')
      ],
      debug: true);
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);



  runApp(
    Phoenix(
      child: MyApp(
        pref: pref,
      ),
    ),
  );
}
