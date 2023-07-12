import 'dart:convert';
import 'dart:math';

import 'package:bizbultest/Language/languageData.dart';
import 'package:bizbultest/Language/selectLanguage.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/providers/discover/discover_tags_provider.dart';
import 'package:bizbultest/providers/feeds/popular_videos_provider.dart';
import 'package:bizbultest/providers/feeds/trending_topics_provider.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:bizbultest/utilities/route_genrator.dart';
import 'package:bizbultest/view/Chat/account_two_step_settings_screen.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:bizbultest/view/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'models/user_story_list_model.dart';
import 'package:bizbultest/constance/constance.dart' as constance;

// void callbackDispatcher() async {
//   FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();

//   // app_icon needs to be a added as a drawable
//   // resource to the Android head project.
//   var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//   var IOS = new IOSInitializationSettings();

//   // initialise settings for both Android and iOS device.
//   var settings = new InitializationSettings(android: android, iOS: IOS);
//   flip.initialize(settings);s
//   _showNotificationWithDefaultSound(flip);
//   // Workmanager.cancelByUniqueName("1");
// }

// Future<void> _showNotificationWithDefaultSound(flip) async {
//   // Show a notification after every 15 minute with the first
//   // appearance happening a minute after invoking the method
//   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//       Random().nextInt(2147483647).toString(), 'basic_channel',
//       channelDescription: 'your channel description',
//       playSound: true,
//       importance: Importance.max,
//       priority: Priority.high,
//       fullScreenIntent: true);
//   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

//   // initialise channel platform for both Android and iOS device.
//   var platformChannelSpecifics = new NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);
//   await flip.show(
//     Random().nextInt(2147483647),
//     'basic_channel',
//     'Channel with call ringtone',
//     platformChannelSpecifics,
//     payload: 'Default_Sound',
//   );
// }

class MyApp extends StatefulWidget {
  final SharedPreferences pref;
  MyApp({required this.pref});

  static setCustomeLanguage(BuildContext context, String languageCode) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late String loginCheck;
  late String memberID;
  String loginSuccess = "load";
  bool loginBar = false;

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // AndroidNotificationChannel channel;

  var entry;

  String locale = "en";

  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  @override
  void initState() {
    // callbackDispatcher();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.s

    WidgetsBinding.instance.addObserver(this);

    checkMemberID();

    setState(() {
      CurrentUser().currentUser.shortbuzIsMuted = true;
      CurrentUser().currentUser.isPlaying = true;
    });
    myContext = context;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    _loadLanguage();
    checkLanguage();
    print("enterd the app state");
    super.initState();
  }

  late BuildContext myContext;

  _loadLanguage() async {
    if (!mounted) return;
    try {
      if (constance.allTextData == null) {
        constance.allTextData = AllTextData.fromJson(
          json.decode(
            await DefaultAssetBundle.of(myContext)
                .loadString("jsonFile/languagetext.json"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  List<RadioModel> sampleData = [];

  checkLanguage() async {
    sampleData.add(RadioModel(false, 'English', "en", "English"));
    sampleData.add(RadioModel(false, 'English (UK)', "en", "English (UK)"));
    sampleData.add(RadioModel(false, 'Indonesian', "id", "Bahasa Indonesia"));
    sampleData.add(RadioModel(false, 'Pilipino', "fil", "Filipino"));
    sampleData.add(RadioModel(false, 'Hrvatski', "hr", "Croatian"));
    sampleData.add(RadioModel(false, 'Magyar', "hu", "Hungarian"));
    sampleData.add(RadioModel(false, 'Malay', "ms", "Bahasa Melayu"));
    sampleData.add(RadioModel(false, 'فارسی', "fa", "Persian"));
    sampleData
        .add(RadioModel(false, 'Français (Canada)', "fr", "French (Canada)"));
    sampleData
        .add(RadioModel(false, 'Français (France)', "fr", "French (France)"));
    sampleData.add(RadioModel(false, 'Deutsch', "de", "German"));
    sampleData
        .add(RadioModel(false, 'Española (españa)', "es", "Spanish (Spain)"));
    sampleData
        .add(RadioModel(false, 'Español', "es", "Spanish (Latin America)"));
    sampleData.add(RadioModel(false, 'Italiano', "it", "Italian"));
    sampleData.add(
        RadioModel(false, 'Portuguese (Brasil)', "pt", "Portugues (Brasil)"));
    sampleData.add(RadioModel(
        false, 'Portuguese (Portugal)', "pt", "Portugues (Portugal)"));
    sampleData.add(RadioModel(false, 'Africa', "af", "Afrikaans"));
    sampleData.add(RadioModel(false, 'عربي', "ar", "Arabic"));
    sampleData.add(RadioModel(false, 'български', "bg", "Bulgarian"));
    sampleData.add(RadioModel(false, 'čeština', "cs", "Czech"));
    sampleData.add(RadioModel(false, 'Dansk', "da", "Danish"));
    sampleData.add(RadioModel(false, 'Ελληνικά', "el", "Greek"));
    sampleData.add(RadioModel(false, 'Dutch', "nl", "NederLands"));
    sampleData
        .add(RadioModel(false, 'Norwegian (bokmal)', "no", "Norsk (bokmal)"));
    sampleData.add(RadioModel(false, 'Polish', "pl", "Polaski"));
    sampleData.add(RadioModel(false, 'Romena', "ro", "Romanian"));
    sampleData.add(RadioModel(false, 'Slovenský', "sk", "Slovak"));
    sampleData.add(RadioModel(false, 'Suomi', "fi", "Finnish"));
    sampleData.add(RadioModel(false, 'Svenska', "sv", "Swedish"));
    sampleData.add(RadioModel(false, 'Tiếng Việt', "vi", "Vietnamese"));
    sampleData.add(RadioModel(false, 'Türk', "tr", "Turkish"));
    sampleData.add(RadioModel(false, 'русский', "ru", "Russian"));
    sampleData.add(RadioModel(false, 'Yкраїнська', "uk", "Ukrainian"));
    sampleData.add(RadioModel(false, 'Српски', "sr", "Serbian"));
    sampleData.add(RadioModel(false, 'עִברִית', "he", "Hebrew"));
    sampleData.add(RadioModel(false, 'हिंदी', "hi", "Hindi"));
    sampleData.add(RadioModel(false, 'ไทย', "th", "Thai"));
    sampleData.add(RadioModel(false, '中国人 （簡化）', "zh", "Chinese (Simplified)"));
    sampleData.add(RadioModel(
        false, '中國人 (繁體, 台灣)', "zh", "Chinese (Traditional, Taiwan)"));
    sampleData.add(RadioModel(
        false, '中文（繁體，香港', "zh", "Chinese (Traditional, Hong kong)"));
    sampleData.add(RadioModel(false, '日本', "ja", "Japanese"));
    sampleData.add(RadioModel(false, '한국인', "ko", "Korean"));

    String? name = await MySharedPreferences().getSelectedLanguage();
    if (name != null && name != "") {
      for (var i = 0; i < sampleData.length; i++) {
        if (sampleData[i].lngName == name) {
          constance.locale = sampleData[i].lngCode;
          locale = constance.locale;
          selectLanguage(constance.locale);
          return;
        }
      }
    }
  }

  selectLanguage(String languageCode) {
    MyApp.setCustomeLanguage(context, languageCode);
  }

  // getPermission(String userId) async {
  //   bool locationResult = await Permissions().getCameraPermission();
  //   if (locationResult) {
  //     setState(() {
  //       oppositeUserId = userId;
  //     });
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => JoinChannelVideo(
  //           oppositeMemberId: oppositeUserId,
  //           isFromHome: true,
  //         ),
  //       ),
  //     );
  //   } else {
  //     getPermission(userId);
  //   }
  // }

  bool isLogoLoaded = false;
  var logo;
  var countryName;
  bool isMemberLoaded = false;
  var currentMemberName;
  var currentMemberImage;
  var currentMemberShortcode;
  bool? hasMemberID = false;

  String oppositeUserId = "";

  Future<String> getCurrentMember(String memberID) async {
    var url =
        "https://www.bebuzee.com/api/user/userDetails?action=member_details_data&user_id=${memberID}";
    var response = await ApiProvider().fireApiWithParamsPostToken(url);

    // var response = await http.get(url);
    print("gegte currentMember=${response.data}");
    if (response.statusCode == 200) {
      setState(() {
        isMemberLoaded = true;
      });
    }
    setState(() {
      // var convertJson = json.decode(response.body);
      currentMemberName = response.data['name'];

      currentMemberImage = response.data['image'];
      currentMemberShortcode = response.data['shortcode'];
    });
    return "success";
  }

  Future<String> getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    if (this.mounted) {
      setState(() {
        countryName = locationX["country"];
      });
    }
    return 'success';
  }

  Future<String> getCountryName() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=fetch_location_logo&country=${countryName.toString()}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          isLogoLoaded = true;
        });
      }
    }

    if (this.mounted) {
      setState(() {
        var convertJson = json.decode(response.body);
        logo = convertJson['image_url'];
      });
    }

    return "success";
  }

  Future<String> checkMemberID() async {
    print("im at object pointt");
    SharedPreferences sp = await SharedPreferences.getInstance();

    String? memberID = sp.getString("memberID");
    String? image = sp.getString("image");
    String? shortcode = sp.getString("shortcode");
    String? name = sp.getString("name");
    String? country = sp.getString("country");
    String? logo = sp.getString("logo");
    String? email = sp.getString("email");
    await getCurrentMember(memberID ?? "");
    print("check memberid called current coountryid=${CurrentUser().currentUser.code}");
    setState(() {
      CurrentUser().currentUser.memberID = memberID;
      CurrentUser().currentUser.image = image;
      CurrentUser().currentUser.shortcode = shortcode ?? '';
      CurrentUser().currentUser.fullName = name!;
      CurrentUser().currentUser.country = country!;
      CurrentUser().currentUser.logo = logo ?? '';
      CurrentUser().currentUser.email = email!;
    });

    // if (memberID == null || image == null || shortcode == null || name == null || country == null || logo == null)
    // {
    //   if (mounted) {
    //     setState(() {
    //       hasMemberID = false;
    //     });
    //   }
    // }

    print(memberID.toString()+" this is how to email workkk");
    if(memberID == null){
      if (mounted) {
        setState(() {
          hasMemberID = false;
        });
      }
    }
    else if (memberID != null ||
        image != null ||
        shortcode != null ||
        name != null ||
        country != null ||
        logo != null) {
      if (mounted) {
        setState(() {
          hasMemberID = true;
        });
      }
    }

    return "Success";
  }

  GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

  late UserStoryList userStoryList;
  bool areUsersLoaded = false;

  Future<String> getStoryUserList(String memberID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_story_data.php?action=story_data_member_only&user_id=$memberID&country=${CurrentUser().currentUser.country}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      UserStoryList userData =
          UserStoryList.fromJson(jsonDecode(response.body));
      if (mounted) {
        setState(() {
          userStoryList = userData;
          areUsersLoaded = true;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areUsersLoaded = false;
        });
      }
    }

    return "success";
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.toString() == "AppLifecycleState.resumed") {
      //  initDynamicLinks();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("appband");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    constance.locale = locale;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PopularVideosProvider()),
        ChangeNotifierProvider(create: (_) => TrendingTopicsProvider()),
        ChangeNotifierProvider(create: (_) => DiscoverTagsProvider()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OverlaySupport.global(
            child: OrientationBuilder(
              builder: (context, orientation) {
                // SizerUtil().init(constraints, orientation);
                SizerUtil.setScreenSize(constraints, orientation);
                return GetMaterialApp(
                  navigatorKey: mainNavigatorKey,
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  //initialRoute: SignUpPage1.routeName,
                  home: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: hasMemberID == null
                        ? Container()
                        : hasMemberID == false
                            ? LoginPage()
                            : HomePage(
                                pref: widget.pref,
                                memberID: CurrentUser().currentUser.memberID,
                                logo: CurrentUser().currentUser.logo,
                                country: CurrentUser().currentUser.country,
                                currentMemberImage:
                                    CurrentUser().currentUser.image,
                              ),
                  ),
                  title: 'Bebuzee',
                  theme: ThemeData.light(),
                  // routes: routes,
                );
              },
            ),
          );
        },
      ),
    );
  }

}


