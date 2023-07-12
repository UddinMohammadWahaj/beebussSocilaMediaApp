import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bizbultest/api/ApiRepo.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/basic/homeVcScreen.dart';
import 'package:bizbultest/basic/newVcScreen.dart';
import 'package:bizbultest/config/agora.config.dart' as config;
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/permission/permissions.dart';
import 'package:bizbultest/playground/PlayVideoCallScreen.dart';
import 'package:bizbultest/playground/controller/callpagecontroller.dart';
import 'package:bizbultest/playground/src/pages/callpage.dart';
import 'package:bizbultest/playground/utils/enumcall.dart';
import 'package:bizbultest/playground/utils/settings.dart';
import 'package:bizbultest/push/media_player_central.dart';
import 'package:bizbultest/push/notification_utils.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/Properbuz/api/properbuz_feeds_api.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeed_logo_icons.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedview.dart';
import 'package:bizbultest/view/discover_people_main.dart';
import 'package:bizbultest/view/feeds_page.dart';
import 'package:bizbultest/view/my_flutter_app_icons.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/view/shortbuz_main_page.dart';
import 'package:bizbultest/view/shortbuzsearch.dart';
import 'package:bizbultest/view/video_page_main.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:bizbultest/widgets/Newsfeeds/single_feed_post.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:vibration/vibration.dart';
import 'package:zefyrka/zefyrka.dart';

import '../services/BuzzfeedControllers/buzzfeedcontroller.dart';
import '../services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'Chat/chat_home.dart';
import 'Properbuz/detailed_feed_view.dart';
import 'channel_page_main.dart';
import 'channel_page_other_user.dart';
import 'expanded_blog_page.dart';

class HomePage extends StatefulWidget {
  final String? logo;
  final String? memberID;
  final String? country;
  final String? currentMemberImage;
  final bool? hasMemberLoaded;
  static String? tag = 'home-page';
  final bool? hideNavBar;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final SharedPreferences? pref;
  var from = '';
  // final NotificationAppLaunchDetails notificationAppLaunchDetails;
  HomePage(
      {Key? key,
      this.pref,
      this.from = '',
      // this.notificationAppLaunchDetails,
      this.logo,
      this.memberID,
      this.country,
      this.currentMemberImage,
      this.hasMemberLoaded,
      this.hideNavBar,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  // bool get didNotificationLaunchApp =>
  //     notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomePage createState() {
    return new _HomePage();
  }
}

class Call {
  Call(this.number);

  String number;
  bool held = false;
  bool muted = false;
}

final CallPageController controller = Get.put(CallPageController());
var listenFirst = true;

class _HomePage extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // FlutterLocalNotificationsPlugin
  //
  //
  // ;
  _HomePage();

  // NotificationAppLaunchDetails notificationAppLaunchDetails;

  // bool get didNotificationLaunchApp =>
  //     notificationAppLaunchDetails.didNotificationLaunchApp ?? false;

  int c = 6;
  int selectedIndex = 0;
  bool isChannelOpen1 = false;
  bool isChannelOpen2 = false;
  bool isChannelOpen3 = false;
  bool isChannelOpen4 = false;
  late bool isMemberLoaded;
  bool isProfileOpen = false;
  bool jumpToFeeds = false;
  bool uploadBuz = false;
  var currentMemberName;
  var currentMemberImage;
  var currentMemberShortcode;
  bool channelColor = false;
  late String channelName;
  bool isClickAnswer = false;
  DirectRefresh refreshChat = DirectRefresh();

  ScrollController feedController = ScrollController();
  ScrollController searchController = ScrollController();
  ScrollController blogController = ScrollController();
  ScrollController profileController = ScrollController();
  ScrollController videoController = ScrollController();

  var timezone;

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  Future<String> getTimezone() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    if (mounted) {
      setState(() {
        timezone = locationX["timezone"];
        CurrentUser().currentUser.timeZone = locationX["timezone"];
      });
    }

    return "Success";
  }

  Future<String> getCurrentMember() async {
    var url =
        "https://www.bebuzee.com/api/user/userDetails?action=member_details_data&user_id=${widget.memberID}";
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

  String otherMemberID = "";
  String purpose = "";
  String shortcode = "";
  String postID = "";
  late VideoListModel videoList;
  bool areVideosLoaded = false;
  String index = "";
  String token = '';

  Future<void> getSingleVideo(String postID) async {
    print("get single video called");
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=popular_video_data_new_feed_single_post&post_id=$postID");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      VideoListModel videoData =
          VideoListModel.fromJson(jsonDecode(response.body));
      //await Future.wait(videoData.videos.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        setState(() {
          videoList = videoData;
          areVideosLoaded = true;
        });
      }
      Get.to(() => MainVideoPage(
                changeColor: (val) {
                  setState(() {
                    channelColor = val;
                  });
                },
                video: videoList.data![0],
                from: "Feeds",
                scrollController: videoController,
                setNavBar: (val) {
                  setState(() {
                    hideNavBar = val;
                  });
                },
              ))!
          .then((value) {
        setState(() {
          purpose = "";
        });
      });
    }
  }

  void initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      setState(() {
        otherMemberID = deepLink.toString().split("/")[4];
        purpose = deepLink.toString().split("/")[3];
        shortcode = deepLink.toString().split("/")[5];
        postID = deepLink.toString().split("/")[6];
      });
    }

    FirebaseDynamicLinks.instance.onLink;
    if (purpose == "story") {
      print("final purpose is " + purpose);
      setState(() {
        OtherUser().otherUser.memberID = otherMemberID;
        OtherUser().otherUser.shortcode = shortcode;
      });
      Get.to(() => ProfilePageMain(
                from: "home",
                jumpToProfile: (val) {
                  setState(() {
                    jumpToFeeds = val;
                  });
                },
                setNavBar: (val) {
                  setState(() {
                    hideNavBar = val;
                  });
                },
                changeColor: (val) {
                  setState(() {
                    channelColor = val;
                  });
                },
                isChannelOpen: (val) {
                  setState(() {
                    isChannelOpen3 = val;
                  });
                },
                otherMemberID: otherMemberID,
              ))!
          .then((value) {
        setState(() {
          purpose = "";
        });
      });
    } else if (purpose == "profile") {
      print("final purpose is " + purpose);
      setState(() {
        OtherUser().otherUser.memberID = otherMemberID;
        OtherUser().otherUser.shortcode = shortcode;
      });
      Get.to(() => ProfilePageMain(
                from: "profile",
                jumpToProfile: (val) {
                  setState(() {
                    jumpToFeeds = val;
                  });
                },
                setNavBar: (val) {
                  setState(() {
                    hideNavBar = val;
                  });
                },
                changeColor: (val) {
                  setState(() {
                    channelColor = val;
                  });
                },
                isChannelOpen: (val) {
                  setState(() {
                    isChannelOpen3 = val;
                  });
                },
                otherMemberID: otherMemberID,
              ))!
          .then((value) {
        setState(() {
          purpose = "";
        });
      });
    } else if (purpose == "post") {
      print("final purpose is " + purpose);
      Get.to(() => SingleFeedPost(
                memberID: otherMemberID,
                postID: postID,
                profileOpen: (val) {
                  setState(() {
                    isProfileOpen = val;
                  });
                },
                setNavBar: (val) {
                  setState(() {
                    hideNavBar = val;
                  });
                },
                changeColor: (val) {
                  setState(() {
                    channelColor = val;
                  });
                },
                isChannelOpen: (val) {
                  setState(() {
                    isChannelOpen3 = val;
                  });
                },
              ))!
          .then((value) {
        setState(() {
          purpose = "";
        });
      });
    } else if (purpose == "shortbuz") {
      print("final purpose is " + purpose);
      Get.to(() => ShortbuzMainPage(
                from: "discover",
                profileOpen: (val) {
                  setState(() {
                    isProfileOpen = val;
                  });
                },
                setNavBar: (val) {
                  setState(() {
                    hideNavBar = val;
                  });
                },
                changeColor: (val) {
                  setState(() {
                    channelColor = val;
                  });
                },
                isChannelOpen: (val) {
                  setState(() {
                    isChannelOpen3 = val;
                  });
                },
                postID: postID,
              ))!
          .then((value) {
        setState(() {
          purpose = "";
        });
      });
    } else if (purpose == "video") {
      print("final purpose is " + purpose);
      getSingleVideo(postID);
      setState(() {
        purpose = "";
      });
    } else if (purpose == "highlight") {
      print("final purpose is " + purpose);
      setState(() {
        index = deepLink.toString().split("/")[7];
        OtherUser().otherUser.index = index;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePageMain(
                    from: "highlight",
                    jumpToProfile: (val) {
                      setState(() {
                        jumpToFeeds = val;
                      });
                    },
                    setNavBar: (val) {
                      setState(() {
                        hideNavBar = val;
                      });
                    },
                    changeColor: (val) {
                      setState(() {
                        channelColor = val;
                      });
                    },
                    isChannelOpen: (val) {
                      setState(() {
                        isChannelOpen3 = val;
                      });
                    },
                    otherMemberID: otherMemberID,
                  )));
      setState(() {
        purpose = "";
      });
    } else if (purpose == "blog") {
      print("final purpose is " + purpose);
      Get.to(() => ExpandedBlogPage(
            setNavBar: (val) {
              setState(() {
                hideNavBar = val;
              });
            },
            changeColor: (val) {
              setState(() {
                channelColor = val;
              });
            },
            isChannelOpen: (val) {
              setState(() {
                isChannelOpen3 = val;
              });
            },
            blogID: postID,
          ));

      setState(() {
        purpose = "";
      });
    } else if (purpose == "channel") {
      print("final purpose is " + purpose);

      if (otherMemberID == CurrentUser().currentUser.memberID) {
        Get.to(() => ChannelPageMain(
              otherMemberID: otherMemberID,
              setNavBar: (val) {
                setState(() {
                  hideNavBar = val;
                });
              },
              changeColor: (val) {
                setState(() {
                  channelColor = val;
                });
              },
              isChannelOpen: (val) {
                setState(() {
                  isChannelOpen3 = val;
                });
              },
            ));
      } else {
        Get.to(() => ChannelPageMainOtherUser(
              otherMemberID: otherMemberID,
              setNavBar: (val) {
                setState(() {
                  hideNavBar = val;
                });
              },
              changeColor: (val) {
                setState(() {
                  channelColor = val;
                });
              },
              isChannelOpen: (val) {
                setState(() {
                  isChannelOpen3 = val;
                });
              },
            ));
      }
      setState(() {
        purpose = "";
      });
    } else if (purpose == "properbuz_feed") {
      ProperbuzFeedController controller = Get.put(ProperbuzFeedController());
      var posts = await ProperbuzFeedsAPI.getSinglePost(postID);
      controller.singlePostList.assignAll(posts);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedFeedView(
                    feedIndex: 0,
                    val: 5,
                  )));
    } else {}
  }

  void _onTapFeed() {
    feedController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onTapSearch() {
    searchController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onTapVideo() {
    videoController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  HomepageRefreshState refresh = new HomepageRefreshState();

  late TabController tabController;
  bool hideNavBar = false;
  String _currentPage = "Feeds";
  int _selectedIndex = 0;
  List<String> pageKeys = [
    "Feeds",
    "Discover",
    "Videos",
    "Blogs",
    'Buzzfeed',
    "Profile",
  ];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Feeds": GlobalKey<NavigatorState>(),
    "Discover": GlobalKey<NavigatorState>(),
    "Videos": GlobalKey<NavigatorState>(),
    "Blogs": GlobalKey<NavigatorState>(),
    "Profile": GlobalKey<NavigatorState>(),
    "Buzzfeed": GlobalKey<NavigatorState>(),
  };

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(String tabItem) {

    Widget? child;
    if (tabItem == "Feeds")
      child = FeedsPage(
        profileOpen: (val) {
          setState(() {
            isProfileOpen = val;
          });
        },
        setNavBar: (val) {
          setState(() {
            hideNavBar = val;
          });
        },
        changeColor: (val) {
          setState(() {
            channelColor = val;
          });
        },
        isChannelOpen: (val) {
          setState(() {
            isChannelOpen1 = val;
          });
        },
        memberID: widget.memberID!,
        logo: widget.logo ?? "",
        country: widget.country ?? "",
        scrollController: feedController,
      );

    else if (tabItem == 'Buzzfeed') {
      print("entered buzz feed view");
      child = BuzzfeedView(
        key: Key(CurrentUser().currentUser.memberID!),
      );
    } else if (tabItem == "Discover")
      // child = Container();

      child = DiscoverPage(
        profileOpen: (val) {
          setState(() {
            isProfileOpen = val;
          });
        },
        setNavBar: (val) {
          setState(() {
            hideNavBar = val;
          });
        },
        changeColor: (val) {
          setState(() {
            channelColor = val;
          });
        },
        isChannelOpen: (val) {
          setState(() {
            isChannelOpen2 = val;
          });
        },
        scrollController: searchController,
      );
    else if (tabItem == "Videos")
      // child = Container();

      child = MainVideoPage(
        scrollController: videoController,
        setNavBar: (val) {
          print("this is video page");
          setState(() {
            hideNavBar = val;
          });
        },
      );
    else if (tabItem == "Blogs")
      // child = ShortbuzSearchView();
      child = ShortbuzMainPage(
        profileOpen: (val) {
          setState(() {
            isProfileOpen = val;
          });
        },
        setNavBar: (val) {
          setState(() {
            hideNavBar = val;
          });
        },
        changeColor: (val) {
          print("changeeeeeeeeee");
          setState(() {
            channelColor = val;
          });
        },
        isChannelOpen: (val) {
          setState(() {
            isChannelOpen4 = val;
          });
        },
        jumpToFeeds: (val) {
          setState(() {
            uploadBuz = val;
          });
          if (uploadBuz) {
            refresh.updateRefresh(true);
            setState(() {
              uploadBuz = false;
            });
          }
        },
      );
    else if (tabItem == "Profile") child = Container();

    // child = ChatHome(
    //   setNavbar: (val) {
    //     setState(() {
    //       hideNavBar = val;
    //     });
    //   },
    // );
    return Offstage(
      offstage: _currentPage != tabItem,
      child: Navigator(
        key: _navigatorKeys[tabItem]!,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => child!);
        },
      ),


    );
  }

  BottomNavigationBarItem _bottomButtons(IconData iconData, double size) {
    return iconData == BuzzfeedLogo.buzzfeedlogo
        ? BottomNavigationBarItem(
            icon: Icon(
              iconData,
              size: 10.0.w,
            ),
            label: '',
            // title: Container(
            //   height: 0,
            // ),
          )
        : BottomNavigationBarItem(
            icon: Icon(
              iconData,
              size: size,
            ),
            label: '',
            // title: Container(
            //   height: 0,
            // ),
          );
  }

  BottomNavigationBarItem _buzzfeed(double size) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        'assets/images/buzzfeed.png',
        fit: BoxFit.contain,
        height: size,
      ),
      // title: Container(
      //   height: 0,
      // ),
    );
  }

  void _openDynamicLink() {
    Get.dialog(ProcessingDialog(
      title: "Loading",
      heading: "",
    ));
    Timer(Duration(seconds: 1), () {
      Get.back();
      initDynamicLinks(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state.toString() == "AppLifecycleState.resumed") {
      // initDynamicLinks(context);
      print("bhen resume hua re -- ");
      // LoginApiCalls.getCountry().then((value) async {
      //   print("bhen resume hua country=${value}");
      //   LoginApiCalls.getCountryLogo(value);
      // });

      // if (NOTSTARTED ) {
      //   NOTSTARTED = false;
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => FunnyPage(),
      //   ));
      // }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      var msg = prefs.getString('payload');
      if (msg != null) {
        print("bhen resume -----msg $msg");

        String payloadstring = msg;

        await prefs.remove('payload');

        String oppid;
        CallType typecall =
            (payloadstring.contains('audio')) ? CallType.audio : CallType.video;
        if (payloadstring.contains('audio'))
          oppid = payloadstring.split('+audio')[0];
        else
          oppid = payloadstring.split('+video')[0];
        UserDetailModel objUserDetailModel =
            await ApiProvider().getUserDetail(oppid);
        List<String> channelName = payloadstring.split('+channelName=');
        List<String> splittextreal = payloadstring.split('+token=');
        List<String> splittext = splittextreal[0].split('+');
        // List<String> splittext = notification.body.split('+');
        String uid = splittext[0] ?? "";
        String callType = splittext[1] ?? "";
        List<String> splittextreal2 = splittextreal[1].split('+channelName=');
        String calltoken = splittextreal2[0];
        String callchannel = splittextreal2[1];
        PAYLOADSTRING = '';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            callFromButton: false,
            callType: typecall,
            channelName: channelName[1],
            isFromHome: true,
            oppositeMemberId: oppid,
            userImage: objUserDetailModel.image,
            name: objUserDetailModel.memberName,
            token: calltoken,
          ),
        ));
        // await flutterLocalNotificationsPlugin.cancelAll();
      }
      if (NOTSTARTED) {
        NOTSTARTED = false;
        String payloadstring = PAYLOADSTRING;
        // flutterLocalNotificationsPlugin.cancelAll();

        String oppid;
        CallType typecall =
            (payloadstring.contains('audio')) ? CallType.audio : CallType.video;
        if (payloadstring.contains('audio'))
          oppid = payloadstring.split('+audio')[0];
        else
          oppid = payloadstring.split('+video')[0];
        UserDetailModel objUserDetailModel =
            await ApiProvider().getUserDetail(oppid);
        List<String> channelName = payloadstring.split('+channelName=');
        List<String> splittextreal = payloadstring.split('+token=');
        List<String> splittext = splittextreal[0].split('+');
        // List<String> splittext = notification.body.split('+');
        String uid = splittext[0] ?? "";
        String callType = splittext[1] ?? "";
        List<String> splittextreal2 = splittextreal[1].split('+channelName=');
        String calltoken = splittextreal2[0];
        String callchannel = splittextreal2[1];
        PAYLOADSTRING = '';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            callFromButton: false,
            callType: typecall,
            channelName: channelName[1],
            isFromHome: true,
            oppositeMemberId: oppid,
            userImage: objUserDetailModel.image,
            name: objUserDetailModel.memberName,
            token: calltoken,
          ),
        ));
      }

      // await confignoty("resume");

      if (listenFirst) {}
      // AwesomeNotifications().actionStream.listen((event) {
      //   if (event.buttonKeyInput == 'accept') {
      //     print("accepthuaa re");
      //   }
      //   print("accepthua re bia");
      //   // Navigator.of(context).push(MaterialPageRoute(
      //   //   builder: (context) => FunnyPage(),
      //   // ));
      // });

      // print("bhen resume hua ${widget.didNotificationLaunchApp}");

      ///////////////////////////
      // String pref = await SharedPreferences.getInstance()
      //     .then((value) => value.getString('notification'));
      // if (pref != null) {
      //   String oppid;
      //   if (pref.contains('audio'))
      //     oppid = pref.split('+audio')[0];
      //   else
      //     oppid = pref.split('+video')[0];
      //   List<String> channelName = pref.split('+channelName=');
      //   List<String> splittextreal = pref.split('+token=');
      //   List<String> splittext = splittextreal[0].split('+');
      //   List<String> splittextreal2 = splittextreal[1].split('+channelName=');
      //   String calltoken = splittextreal2[0];
      //   await SharedPreferences.getInstance()
      //       .then((value) async => await value.remove('notification'));
      //   await sendPushMessage(
      //       channelName: channelName[1],
      //       isVideo: pref.contains('audio') ? false : true,
      //       oppid: oppid,
      //       token: calltoken);
      //   await flutterLocalNotificationsPlugin.cancelAll();
      // } else {
      //   print("bhen pref null");
      // }

      // didReceiveLocalNotificationSubject.stream
      //     .listen((ReceivedNotification receivedNotification) async {
      //   print("bhen resume huaa ${receivedNotification.payload}");
      // });

      // await flutterLocalNotificationsPlugin
      //     .getNotificationAppLaunchDetails()
      //     .then((value) {
      //   if (value.didNotificationLaunchApp) {
      //     print('didnotylauch  ${value.didNotificationLaunchApp}');
      //   }
      // });
      //////////////////////////////////////////////////////////////////
    }
    if (state.toString() == 'AppLifeCycleState.paused')
      print(' bhen pause hua');
    if (state.toString() == 'AppLifeCycleState.inactive')
      print(' bhen inactive hua');
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool starting = true;
  bool isVCallPick = false;
  bool isACallPick = false;

  UserDetailModel objUserDetailModel = new UserDetailModel();

  // ignore: unused_element
  void _setStarting() {
    Timer(Duration(seconds: 4), () {
      setState(() {
        starting = false;
      });
    });
  }

  bool delayLEDTests = false;
  double _secondsToWakeUp = 5;
  double _secondsToCallCategory = 5;

  bool globalNotificationsAllowed = false;
  bool schedulesFullControl = false;
  bool isCriticalAlertsEnabled = false;
  bool isPreciseAlarmEnabled = false;
  bool isOverrideDnDEnabled = false;

  Map<NotificationPermission, bool> scheduleChannelPermissions = {};
  Map<NotificationPermission, bool> dangerousPermissionsStatus = {};

  List<NotificationPermission> channelPermissions = [
    NotificationPermission.Alert,
    NotificationPermission.Sound,
    NotificationPermission.Badge,
    NotificationPermission.Light,
    NotificationPermission.Vibration,
    NotificationPermission.CriticalAlert,
    NotificationPermission.FullScreenIntent
  ];

  List<NotificationPermission> dangerousPermissions = [
    NotificationPermission.CriticalAlert,
    NotificationPermission.OverrideDnD,
    NotificationPermission.PreciseAlarms,
  ];

  @override
  void initState() {
    initializeFirebaseService();
    Timer(Duration(seconds: 1), () {
      // initDynamicLinks(context);
    });
    // _checkInternet();
    // _connectivity();
    getTimezone();
    tabController = new TabController(length: 5, vsync: this);
    // getCurrentMember();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // FirebaseMessaging.instance.getToken().then((value) async {
    //   print(value);
    //   config.firebaseToken = value!;
    //   String uid = CurrentUser().currentUser.memberID!;

    //   bool isAddToken = await ApiProvider().isAddToken(uid, value);
    //   if (isAddToken) {
    //     print("token set");
    //   }
    //   setState(() {});
    // });

    for (NotificationPermission permission in channelPermissions) {
      scheduleChannelPermissions[permission] = false;
    }

    for (NotificationPermission permission in dangerousPermissions) {
      dangerousPermissionsStatus[permission] = false;
    }

    // Uncomment those lines after activate google services inside example/android/build.gradle
    // initializeFirebaseService();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //
    //   String notification = message.data['body'].toString();
    //   print("Home Agora $notification");
    //   print("maer gud");
    //   if (notification.isNotEmpty) {
    //     try {
    //       print("onMessage has arrived ${message.data['body']}");
    //
    //       if (/* uid.toLowerCase() == "cut"*/ notification.contains('cut')) {
    //         await FlutterRingtonePlayer.stop();
    //         await Vibration.cancel();
    //         print("notification count ${notification.contains('count')}");
    //         List<String> endCallData = notification.split('+id=');
    //         UserDetailModel objUserDetailModel =
    //         await ApiProvider().getUserDetail(endCallData[1]);
    //
    //         if (/*callType == "video"*/ notification.contains('video')) {
    //           isVCallPick = false;
    //
    //           print(
    //               "maergud myid=${CurrentUser().currentUser
    //                   .memberID} oppid=${endCallData[1]}");
    //           if (int.parse(CurrentUser().currentUser.memberID.toString()) !=
    //               int.parse(endCallData[1])) {
    //             print(
    //                 "maergud myid=${CurrentUser().currentUser
    //                     .memberID}===== oppid=${endCallData[1]}");
    //
    //             //   Navigator.pushAndRemoveUntil(
    //             //       context,
    //             //       MaterialPageRoute(
    //             //         builder: (context) => HomePage(
    //             //           changeColor: widget.changeColor,
    //             //           country: widget.country,
    //             //           currentMemberImage: widget.currentMemberImage,
    //             //           hasMemberLoaded: widget.hasMemberLoaded,
    //             //           hideNavBar: widget.hideNavBar,
    //             //           isChannelOpen: widget.isChannelOpen,
    //             //           logo: widget.logo,
    //             //           memberID: widget.memberID,
    //             //           setNavBar: widget.setNavBar,
    //             //         ),
    //             //       ),
    //             //       ModalRoute.withName("/Home"));
    //             }
    //           } else {
    //             if (CurrentUser()
    //                 .currentUser
    //                 .memberID
    //                 .toString()
    //                 .trim()
    //                   .compareTo(endCallData[1].trim()) !=
    //                 0) {
    //               print(
    //                   "maergud myid=${CurrentUser().currentUser
    //                       .memberID}===== oppid=${endCallData[1]}");
    //               // Navigator.pushAndRemoveUntil(
    //               //     context,
    //               //     MaterialPageRoute(
    //               //       builder: (context) => HomePage(
    //               //         changeColor: widget.changeColor,
    //               //         country: widget.country,
    //               //         currentMemberImage: widget.currentMemberImage,
    //               //         hasMemberLoaded: widget.hasMemberLoaded,
    //               //         hideNavBar: widget.hideNavBar,
    //               //         isChannelOpen: widget.isChannelOpen,
    //               //         logo: widget.logo,
    //               //         memberID: widget.memberID,
    //               //         setNavBar: widget.setNavBar,
    //               //       ),
    //               //     ),
    //               //     ModalRoute.withName("/Home"));
    //             }
    //             isACallPick = false;
    //           }
    //         } else {
    //           List<String> splittextreal = notification.split('+token=');
    //           List<String> splittext = splittextreal[0].split('+');
    //
    //           String uid = splittext[0] ?? "";
    //           String callType = splittext[1] ?? "";
    //           List<String> splittextreal2 =
    //           splittextreal[1].split('+channelName=');
    //           String calltoken = splittextreal2[0];
    //           String callchannel = splittextreal2[1];
    //           print('dudhara callchannel=$callchannel');
    //           print("dudhara calltype=$callType");
    //           print("dudhara token $calltoken");
    //
    //           objUserDetailModel = await ApiProvider().getUserDetail(uid);
    //           if (objUserDetailModel != null &&
    //               objUserDetailModel.memberId != null &&
    //               objUserDetailModel.memberId != "") {
    //             // await FlutterRingtonePlayer.playRingtone();
    //
    //             // await getPermission();
    //             // setState(() {
    //             //   if (callType == "video") {
    //             //     print("biavcallpickktrue");
    //             //     isVCallPick = true;
    //             //     token = calltoken;
    //             //     channelName = callchannel;
    //             //     print("dudhara token her $token");
    //             //   } else {
    //             //     isACallPick = true;
    //             //     token = calltoken;
    //             //     channelName = callchannel;
    //             //   }
    //             // });
    //             // if (callType == "video") {
    //             //   print("biavcallpickktrue");
    //             //   isVCallPick = true;
    //             //   token = calltoken;
    //             //   channelName = callchannel;
    //             //   print("dudhara token her $token");
    //             // } else {
    //             //   isACallPick = true;
    //             //   token = calltoken;
    //             //   channelName = callchannel;
    //             // }
    //             showCallNotification(
    //                 objUserDetailModel.memberName, objUserDetailModel.image);
    //           }
    //         }
    //       } catch (e) {
    //       print(e);
    //     } finally {}
    //   }
    //
    //   // if (
    //   // // This step (if condition) is only necessary if you pretend to use the
    //   // // test page inside console.firebase.google.com
    //   // !AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
    //   //     considerWhiteSpaceAsEmpty: true) ||
    //   //     !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
    //   //         considerWhiteSpaceAsEmpty: true)) {
    //   //   print('Message also contained a notification: ${message.notification}');
    //   //
    //   //   String imageUrl;
    //   //   imageUrl ??= message.notification.android?.imageUrl;
    //   //   imageUrl ??= message.notification.apple?.imageUrl;
    //   //
    //   //   // https://pub.dev/packages/awesome_notifications#notification-types-values-and-defaults
    //   //   Map<String, dynamic> notificationAdapter = {
    //   //     NOTIFICATION_CONTENT: {
    //   //       NOTIFICATION_ID: Random().nextInt(2147483647),
    //   //       NOTIFICATION_CHANNEL_KEY: 'call_channel',
    //   //       NOTIFICATION_TITLE: message.notification.title,
    //   //       NOTIFICATION_BODY: message.notification.body,
    //   //       NOTIFICATION_LAYOUT:
    //   //       AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
    //   //       NOTIFICATION_BIG_PICTURE: imageUrl
    //   //     }
    //   //   };
    //   //
    //   //   AwesomeNotifications()
    //   //       .createNotificationFromJsonData(notificationAdapter);
    //   // } else {
    //   //   AwesomeNotifications().createNotificationFromJsonData(message.data);
    //   // }
    // });

    // If you pretend to use the firebase service, you need to initialize it
    // getting a valid token
    // initializeFirebaseService();

    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //   if (message.data["type"] != "online") {
    //     print('Message data: ${message.data}');
    //   }

    //   String notification = message.data['body'].toString();
    //   if (notification.isNotEmpty) {
    //     try {
    //       print("onMessage has arrived ${message.data['body']}");

    //       if (/* uid.toLowerCase() == "cut"*/ notification.contains('cut')) {
    //         await FlutterRingtonePlayer.stop();
    //         await Vibration.cancel();
    //         AwesomeNotifications().cancelAll();
    //         // AwesomeNotifications().removeChannel("call_channel");
    //         List<String> endCallData = notification.split('+id=');
    //         UserDetailModel objUserDetailModel =
    //             await ApiProvider().getUserDetail(endCallData[1]);
    //         if (isClickAnswer) {
    //           setState(() {
    //             if (/*callType == "video"*/ notification.contains('video')) {
    //               isVCallPick = false;

    //               // print(
    //               //     "maergud myid=${CurrentUser().currentUser.memberID} oppid=${endCallData[1]}");
    //               if (int.parse(
    //                       CurrentUser().currentUser.memberID.toString()) !=
    //                   int.parse(endCallData[1])) {
    //                 // print(
    //                 //     "maergud myid=${CurrentUser().currentUser.memberID}===== oppid=${endCallData[1]}");

    //                 Navigator.pushAndRemoveUntil(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => HomePage(
    //                         changeColor: widget.changeColor,
    //                         country: widget.country,
    //                         currentMemberImage: widget.currentMemberImage,
    //                         hasMemberLoaded: widget.hasMemberLoaded,
    //                         hideNavBar: widget.hideNavBar,
    //                         isChannelOpen: widget.isChannelOpen,
    //                         logo: widget.logo,
    //                         memberID: widget.memberID,
    //                         setNavBar: widget.setNavBar,
    //                       ),
    //                     ),
    //                     ModalRoute.withName("/HomePage"));
    //               }
    //             } else {
    //               if (CurrentUser()
    //                       .currentUser
    //                       .memberID
    //                       .toString()
    //                       .trim()
    //                       .compareTo(endCallData[1].trim()) !=
    //                   0) {
    //                 print(
    //                     "maergud myid=${CurrentUser().currentUser.memberID}===== oppid=${endCallData[1]}");
    //                 Navigator.pushAndRemoveUntil(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => HomePage(
    //                         changeColor: widget.changeColor,
    //                         country: widget.country,
    //                         currentMemberImage: widget.currentMemberImage,
    //                         hasMemberLoaded: widget.hasMemberLoaded,
    //                         hideNavBar: widget.hideNavBar,
    //                         isChannelOpen: widget.isChannelOpen,
    //                         logo: widget.logo,
    //                         memberID: widget.memberID,
    //                         setNavBar: widget.setNavBar,
    //                       ),
    //                     ),
    //                     ModalRoute.withName("/Home"));
    //               }
    //               isACallPick = false;
    //             }
    //           });
    //         } else {
    //           isACallPick = false;
    //           isVCallPick = false;
    //         }
    //       } else {
    //         List<String> splittextreal = notification.split('+token=');
    //         List<String> splittext = splittextreal[0].split('+');

    //         String uid = splittext[0] ?? "";
    //         String callType = splittext[1] ?? "";
    //         List<String> splittextreal2 =
    //             splittextreal[1].split('+channelName=');
    //         String calltoken = splittextreal2[0];
    //         String callchannel = splittextreal2[1];
    //         print('dudhara callchannel=$callchannel');
    //         print("dudhara calltype=$callType");
    //         print("dudhara token $calltoken");

    //         objUserDetailModel = await ApiProvider().getUserDetail(uid);
    //         if (objUserDetailModel != null &&
    //             objUserDetailModel.memberId != null &&
    //             objUserDetailModel.memberId != "") {
    //           await FlutterRingtonePlayer.playRingtone();

    //           // await getPermission();
    //           // setState(() {
    //           //   if (callType == "video") {
    //           //     print("biavcallpickktrue");
    //           //     isVCallPick = true;
    //           //     token = calltoken;
    //           //     channelName = callchannel;
    //           //     print("dudhara token her $token");
    //           //   } else {
    //           //     isACallPick = true;
    //           //     token = calltoken;
    //           //     channelName = callchannel;
    //           //   }
    //           // });
    //           if (callType == "video") {
    //             print("biavcallpickktrue");
    //             isVCallPick = true;
    //             token = calltoken;
    //             channelName = callchannel;
    //             print("dudhara token her $token");
    //           } else {
    //             isACallPick = true;
    //             token = calltoken;
    //             channelName = callchannel;
    //           }
    //           showCallNotification(
    //               objUserDetailModel.memberId,
    //               objUserDetailModel.memberName,
    //               objUserDetailModel.image,
    //               callType,
    //               calltoken,
    //               callchannel);
    //         }
    //       }
    //     } catch (e) {
    //       print(e);
    //     } finally {}
    //   }
    // });

    if (listenFirst) {
      listenFirst = false;
      // FirebaseMessaging.instance
      //     .getInitialMessage()
      //     .then((RemoteMessage? message) async {
      //   // if (message != null) {
      //   //   String notification = message.data['body'].toString();
      //   //   if (notification.isNotEmpty) {
      //   //     try {
      //   //       print("onMessage has arrived ${message.data['body']}");

      //   //       if (notification.contains('cut')) {
      //   //       } else {
      //   //         List<String> splittextreal = notification.split('+token=');
      //   //         List<String> splittext = splittextreal[0].split('+');

      //   //         String uid = splittext[0] ?? "";
      //   //         String callType = splittext[1] ?? "";
      //   //         List<String> splittextreal2 =
      //   //             splittextreal[1].split('+channelName=');
      //   //         String calltoken = splittextreal2[0];
      //   //         String callchannel = splittextreal2[1];
      //   //         print('dudhara callchannel=$callchannel');
      //   //         print("dudhara calltype=$callType");
      //   //         print("dudhara token $calltoken");

      //   //         objUserDetailModel = await ApiProvider().getUserDetail(uid);
      //   //         if (objUserDetailModel != null &&
      //   //             objUserDetailModel.memberId != null &&
      //   //             objUserDetailModel.memberId != "") {
      //   //           // await FlutterRingtonePlayer.playRingtone();

      //   //           // await getPermission();
      //   //           // setState(() {
      //   //           //   if (callType == "video") {
      //   //           //     print("biavcallpickktrue");
      //   //           //     isVCallPick = true;
      //   //           //     token = calltoken;
      //   //           //     channelName = callchannel;
      //   //           //     print("dudhara token her $token");
      //   //           //   } else {
      //   //           //     isACallPick = true;
      //   //           //     token = calltoken;
      //   //           //     channelName = callchannel;
      //   //           //   }
      //   //           // });
      //   //           if (callType == "video") {
      //   //             print("biavcallpickktrue");
      //   //             isVCallPick = true;
      //   //             token = calltoken;
      //   //             channelName = callchannel;
      //   //             print("dudhara token her $token");
      //   //           } else {
      //   //             isACallPick = true;
      //   //             token = calltoken;
      //   //             channelName = callchannel;
      //   //           }
      //   //           showCallNotification(
      //   //               objUserDetailModel.memberId,
      //   //               objUserDetailModel.memberName,
      //   //               objUserDetailModel.image,
      //   //               callType,
      //   //               calltoken,
      //   //               callchannel);
      //   //         }
      //   //       }
      //   //     } catch (e) {
      //   //       print(e);
      //   //     } finally {}
      //   //   }
      //   // }
      // });

      // AwesomeNotifications().createdStream.listen((receivedNotification) {
      //   String createdSourceText = AwesomeAssertUtils.toSimpleEnumString(
      //       receivedNotification.createdSource);
      // });

      // AwesomeNotifications().displayedStream.listen((receivedNotification) {
      //   String createdSourceText = AwesomeAssertUtils.toSimpleEnumString(
      //       receivedNotification.createdSource);
      // });

      // AwesomeNotifications().dismissedStream.listen((receivedAction) {
      //   String dismissedSourceText = AwesomeAssertUtils.toSimpleEnumString(
      //       receivedAction.dismissedLifeCycle);
      // });

      // AwesomeNotifications().actionStream.listen((receivedAction) async {
      //   if (receivedAction.channelKey == 'call_channel') {
      //     switch (receivedAction.buttonKeyPressed) {
      //       case 'REJECT':
      //         await FlutterRingtonePlayer.stop();
      //         await Vibration.cancel();
      //         String _oppositeMemberId =
      //             receivedAction.payload["OPPOSITEMEMBERID"];
      //         isClickAnswer = false;
      //         isACallPick = false;

      //         sendPushMessage(_oppositeMemberId);

      //         break;

      //       case 'ACCEPT':
      //         await FlutterRingtonePlayer.stop();
      //         await Vibration.cancel();
      //         String _channelName = receivedAction.payload["CALLCHANNEL"];
      //         String _oppositeMemberId =
      //             receivedAction.payload["OPPOSITEMEMBERID"];
      //         String _name = receivedAction.payload["USERNAME"];
      //         String _token = receivedAction.payload["CALLTOKEN"];
      //         String _userImage = receivedAction.payload["USERIMAGE"] ??
      //             objUserDetailModel.image;
      //         String _callType = receivedAction.payload["CALLTYPE"];
      //         CallType _typecall = (_callType.contains('audio'))
      //             ? CallType.audio
      //             : CallType.video;
      //         bool locationResult = await Permissions().getCameraPermission();
      //         if (locationResult) {
      //           setState(() {
      //             if (_callType == "video") {
      //               isClickAnswer = true;
      //               isVCallPick = true;
      //               token = _token;
      //               channelName = _channelName;
      //               objUserDetailModel.memberId = _oppositeMemberId;
      //               objUserDetailModel.memberName = _name;
      //               objUserDetailModel.image = _userImage;
      //             } else {
      //               isClickAnswer = true;
      //               isACallPick = true;
      //               token = _token;
      //               channelName = _channelName;
      //               objUserDetailModel.memberId = _oppositeMemberId;
      //               objUserDetailModel.memberName = _name;
      //               objUserDetailModel.image = _userImage;
      //             }
      //           });
      //         } else {}

      //         // Navigator.pushAndRemoveUntil(
      //         //     context,
      //         //     MaterialPageRoute(
      //         //       builder: (context) => CallPage(
      //         //           channelName: channelName,
      //         //           role: ClientRole.Audience,
      //         //           oppositeMemberId: oppositeMemberId,
      //         //           isFromHome: true,
      //         //           callFromButton: false,
      //         //           callType: typecall,
      //         //           name: name ?? "",
      //         //           token: token,
      //         //           userImage: userImage ?? "",
      //         //           appID: APP_ID),
      //         //     ),
      //         //     ModalRoute.withName("/CallPage"));

      //         break;

      //       default:
      //         // loadSingletonPage(targetPage: PAGE_PHONE_CALL, receivedAction: receivedAction);
      //         break;
      //     }
      //     return;
      //   }

      //   if (!AwesomeStringUtils.isNullOrEmpty(receivedAction.buttonKeyInput)) {
      //     processInputTextReceived(receivedAction);
      //   } else if (!AwesomeStringUtils.isNullOrEmpty(
      //           receivedAction.buttonKeyPressed) &&
      //       receivedAction.buttonKeyPressed.startsWith('MEDIA_')) {
      //     processMediaControls(receivedAction);
      //   } else {
      //     processDefaultActionReceived(receivedAction);
      //   }
      // });
    }

    refreshPermissionsIcons().then((_) =>
        NotificationUtils.requestBasicPermissionToSendNotifications(context)
            .then((allowed) {
          if (allowed != globalNotificationsAllowed) refreshPermissionsIcons();
        }));

    // FirebaseMessaging.onMessage.listen(
    //   (RemoteMessage message) async {
    //     String notification = message.data['body'].toString();
    //     print("Home Agora $notification");
    //     print("maer gud");
    //     if (notification.isNotEmpty) {
    //       try {
    //         print("onMessage has arrived ${message.data['body']}");
    //
    //         if (/* uid.toLowerCase() == "cut"*/  notification.contains('cut')) {
    //           await FlutterRingtonePlayer.stop();
    //           await Vibration.cancel();
    //           print("notification count ${notification.contains('count')}");
    //           List<String> endCallData = notification.split('+id=');
    //           UserDetailModel objUserDetailModel =
    //               await ApiProvider().getUserDetail(endCallData[1]);
    //
    //           setState(() {
    //             if ( /*callType == "video"*/  notification.contains('video')) {
    //               isVCallPick = false;
    //
    //               print(
    //                   "maergud myid=${CurrentUser().currentUser.memberID} oppid=${endCallData[1]}");
    //               if (int.parse(
    //                       CurrentUser().currentUser.memberID.toString()) !=
    //                   int.parse(endCallData[1])) {
    //                 print(
    //                     "maergud myid=${CurrentUser().currentUser.memberID}===== oppid=${endCallData[1]}");
    //                  // Add Kishan for unnecessary chat screen close and move Homepage
    //
    //                 // Navigator.push(
    //                 //     context,
    //                 //     MaterialPageRoute(
    //                 //         builder: (context) => DetailedChatScreen(
    //                 //               token: objUserDetailModel.firebaseToken,
    //                 //               name: objUserDetailModel.memberName,
    //                 //               image: objUserDetailModel.image,
    //                 //               memberID: endCallData[1],
    //                 //            )));
    //
    //                 Navigator.pushAndRemoveUntil(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => HomePage(
    //                         changeColor: widget.changeColor,
    //                         country: widget.country,
    //                         currentMemberImage: widget.currentMemberImage,
    //                         hasMemberLoaded: widget.hasMemberLoaded,
    //                         hideNavBar: widget.hideNavBar,
    //                         isChannelOpen: widget.isChannelOpen,
    //                         logo: widget.logo,
    //                         memberID: widget.memberID,
    //                         setNavBar: widget.setNavBar,
    //                       ),
    //                     ),
    //                     ModalRoute.withName("/Home"));
    //               }
    //             } else {
    //               if (CurrentUser()
    //                       .currentUser
    //                       .memberID
    //                       .toString()
    //                       .trim()
    //                       .compareTo(endCallData[1].trim()) !=
    //                   0) {
    //                 print(
    //                     "maergud myid=${CurrentUser().currentUser.memberID}===== oppid=${endCallData[1]}");
    //                  // Add Kishan for unnecessary chat screen close and move Homepageen
    //                 // Navigator.push(
    //                 //     context,
    //                 //     MaterialPageRoute(
    //                 //         builder: (context) => DetailedChatScreen(
    //                 //               token: objUserDetailModel.firebaseToken,
    //                 //               name: objUserDetailModel.memberName,
    //                 //               image: objUserDetailModel.image,
    //                 //               memberID: endCallData[1],
    //                 //             )));
    //
    //                 Navigator.pushAndRemoveUntil(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => HomePage(
    //                         changeColor: widget.changeColor,
    //                         country: widget.country,
    //                         currentMemberImage: widget.currentMemberImage,
    //                         hasMemberLoaded: widget.hasMemberLoaded,
    //                         hideNavBar: widget.hideNavBar,
    //                         isChannelOpen: widget.isChannelOpen,
    //                         logo: widget.logo,
    //                         memberID: widget.memberID,
    //                         setNavBar: widget.setNavBar,
    //                       ),
    //                     ),
    //                     ModalRoute.withName("/Home"));
    //               }
    //               isACallPick = false;
    //             }
    //           });
    //         } else {
    //           List<String> splittextreal = notification.split('+token=');
    //           List<String> splittext = splittextreal[0].split('+');
    //           // List<String> splittext = notification.body.split('+');
    //           String uid = splittext[0] ?? "";
    //           String callType = splittext[1] ?? "";
    //           List<String> splittextreal2 =
    //               splittextreal[1].split('+channelName=');
    //           String calltoken = splittextreal2[0];
    //           String callchannel = splittextreal2[1];
    //           print('dudhara callchannel=$callchannel');
    //           print("dudhara calltype=$callType");
    //           print("dudhara token $calltoken");
    //           // List<String> splittext = notification.split('+');
    //           // String uid = splittext[0];
    //           // String callType = splittext[1] ?? "";
    //
    //           objUserDetailModel = await ApiProvider().getUserDetail(uid);
    //           if (objUserDetailModel != null &&
    //               objUserDetailModel.memberId != null &&
    //               objUserDetailModel.memberId != "") {
    //             await FlutterRingtonePlayer.playRingtone();
    //
    //             await getPermission();
    //             setState(() {
    //               if (callType == "video") {
    //                 print("biavcallpickktrue");
    //                 isVCallPick = true;
    //                 token = calltoken;
    //                 channelName = callchannel;
    //                 print("dudhara token her $token");
    //               } else {
    //                 isACallPick = true;
    //                 token = calltoken;
    //                 channelName = callchannel;
    //               }
    //             });
    //           }
    //         }
    //       } catch (e) {
    //         print(e);
    //       } finally {}
    //     }
    //   },
    // );

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print("boner gud called");
    //   await FlutterRingtonePlayer.stop();
    //
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //
    //   if (notification != null && android != null) {
    //     try {
    //       print("onMessage has arrived ${message.data['body']}");
    //       List<String> splittextreal =
    //           message.data['body'].toString().split('+token=');
    //       List<String> splittext = splittextreal[0].split('+');
    //       // List<String> splittext = notification.body.split('+');
    //       String uid = splittext[0] ?? "";
    //       String callType = splittext[1] ?? "";
    //       List<String> splittextreal2 = splittextreal[1].split('+channelName=');
    //       String calltoken = splittextreal2[0];
    //       String callchannel = splittextreal2[1];
    //       print('dudhara callchannel=$callchannel');
    //       print("dudhara calltype=$callType");
    //       print("dudhara token $calltoken");
    //       if (uid.toLowerCase() == "cut") {
    //         await FlutterRingtonePlayer.stop();
    //         await Vibration.cancel();
    //
    //         setState(() {
    //           if (callType == "video") {
    //             isVCallPick = false;
    //           } else {
    //             isACallPick = false;
    //           }
    //         });
    //       } else {
    //         List<String> splittext = message.data['body'].toString().split('+');
    //         String uid = splittext[0];
    //         String callType = splittext[1] ?? "";
    //
    //         objUserDetailModel = await ApiProvider().getUserDetail(uid);
    //         if (objUserDetailModel != null &&
    //             objUserDetailModel.memberId != null &&
    //             objUserDetailModel.memberId != "") {
    //           await FlutterRingtonePlayer.playRingtone();
    //           await getPermission();
    //           setState(() {
    //             if (callType == "video") {
    //               print("biavcallpickktrue");
    //               isVCallPick = true;
    //               token = calltoken;
    //               channelName = callchannel;
    //               print("dudhara token her $token");
    //             } else {
    //               isACallPick = true;
    //               token = calltoken;
    //               channelName = callchannel;
    //             }
    //           });
    //         }
    //       }
    //     } catch (e) {
    //       print(e);
    //     } finally {}
    //   }
    //   print(
    //       'A new onMessageOpenedApp event was published! bia ${message.data}');
    // });
  }

  Future<void> initializeFirebaseService() async {
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   String notification = message.data['body'].toString();
    //   if (notification.isNotEmpty) {
    //     try {
    //       print("onMessage has arrived ${message.data['body']}");

    //       if (/* uid.toLowerCase() == "cut"*/ notification.contains('cut')) {
    //         await FlutterRingtonePlayer.stop();
    //         await Vibration.cancel();
    //         print("notification count ${notification.contains('count')}");
    //         List<String> endCallData = notification.split('+id=');

    //         if (mounted && isClickAnswer) {
    //           setState(() {
    //             if (/*callType == "video"*/ notification.contains('video')) {
    //               isVCallPick = false;

    //               print(
    //                   "maergud myid=${CurrentUser().currentUser.memberID} oppid=${endCallData[1]}");
    //               if (int.parse(
    //                       CurrentUser().currentUser.memberID.toString()) !=
    //                   int.parse(endCallData[1])) {
    //                 print(
    //                     "maergud myid=${CurrentUser().currentUser.memberID}===== oppid=${endCallData[1]}");

    //                 Navigator.pushAndRemoveUntil(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => HomePage(
    //                         changeColor: widget.changeColor,
    //                         country: widget.country,
    //                         currentMemberImage: widget.currentMemberImage,
    //                         hasMemberLoaded: widget.hasMemberLoaded,
    //                         hideNavBar: widget.hideNavBar,
    //                         isChannelOpen: widget.isChannelOpen,
    //                         logo: widget.logo,
    //                         memberID: widget.memberID,
    //                         setNavBar: widget.setNavBar,
    //                       ),
    //                     ),
    //                     ModalRoute.withName("/HomePage"));
    //               }
    //             } else {
    //               if (CurrentUser()
    //                       .currentUser
    //                       .memberID
    //                       .toString()
    //                       .trim()
    //                       .compareTo(endCallData[1].trim()) !=
    //                   0) {
    //                 print(
    //                     "maergud myid=${CurrentUser().currentUser.memberID}===== oppid=${endCallData[1]}");
    //                 Navigator.pushAndRemoveUntil(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => HomePage(
    //                         changeColor: widget.changeColor,
    //                         country: widget.country,
    //                         currentMemberImage: widget.currentMemberImage,
    //                         hasMemberLoaded: widget.hasMemberLoaded,
    //                         hideNavBar: widget.hideNavBar,
    //                         isChannelOpen: widget.isChannelOpen,
    //                         logo: widget.logo,
    //                         memberID: widget.memberID,
    //                         setNavBar: widget.setNavBar,
    //                       ),
    //                     ),
    //                     ModalRoute.withName("/Home"));
    //               }
    //               isACallPick = false;
    //             }
    //           });
    //         } else {
    //           setState(() {
    //             isACallPick = false;
    //             isVCallPick = false;
    //           });
    //         }
    //       } else {
    //         List<String> splittextreal = notification.split('+token=');
    //         List<String> splittext = splittextreal[0].split('+');
    //         String uid = splittext[0] ?? "";
    //         String callType = splittext[1] ?? "";
    //         List<String> splittextreal2 =
    //             splittextreal[1].split('+channelName=');
    //         String calltoken = splittextreal2[0];
    //         String callchannel = splittextreal2[1];
    //         print('dudhara callchannel=$callchannel');
    //         print("dudhara calltype=$callType");
    //         print("dudhara token $calltoken");
    //         //first time

    //         objUserDetailModel = await ApiProvider().getUserDetail(uid);
    //         print(objUserDetailModel);
    //         if (objUserDetailModel != null &&
    //             objUserDetailModel.memberId != null &&
    //             objUserDetailModel.memberId != "") {
    //           // await FlutterRingtonePlayer.playRingtone();

    //           // await getPermission();
    //           // setState(() {
    //           //   if (callType == "video") {
    //           //     print("biavcallpickktrue");
    //           //     isVCallPick = true;
    //           //     token = calltoken;
    //           //     channelName = callchannel;
    //           //     print("dudhara token her $token");
    //           //   } else {
    //           //     isACallPick = true;
    //           //     token = calltoken;
    //           //     channelName = callchannel;
    //           //   }
    //           // });

    //           if (callType == "video") {
    //             print("biavcallpickktrue");
    //             isVCallPick = true;
    //             token = calltoken;
    //             channelName = callchannel;
    //             print("dudhara token her $token");
    //           } else {
    //             isACallPick = true;
    //             token = calltoken;
    //             channelName = callchannel;
    //           }

    //           showCallNotification(
    //               objUserDetailModel.memberId!,
    //               objUserDetailModel.memberName!,
    //               objUserDetailModel.image!,
    //               callType,
    //               calltoken,
    //               callchannel);
    //         }
    //       }
    //     } catch (e) {
    //       print(e);
    //     } finally {}
    //   } else {}
    // });
  }

  static Future<void> showCallNotification(
      String oppositeId,
      String name,
      String image,
      String callType,
      String calltoken,
      String callchannel) async {
    String platformVersion = await getPlatformVersion();
    // AndroidForegroundService.startForeground(
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: Random().nextInt(2147483647),
            channelKey: 'call_channel',
            title: 'Incoming Call',
            body: 'from $name',
            category: NotificationCategory.Call,
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false,
            // backgroundColor: (platformVersion == 'Android-31')
            //     ? Color(0x00796a)
            //     : Colors.white,
            payload: {
              'USERNAME': name,
              'CALLTYPE': callType,
              'CALLTOKEN': calltoken,
              'CALLCHANNEL': callchannel,
              'OPPOSITEMEMBERID': oppositeId,
            }),
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
              autoDismissible: true),
        ]);
  }

  void loadSingletonPage({String? targetPage, ReceivedAction? receivedAction}) {
    // Avoid to open the notification details page over another details page already opened
    Navigator.pushNamedAndRemoveUntil(context, targetPage!,
        (route) => (route.settings.name != targetPage) || route.isFirst,
        arguments: receivedAction);
  }

  Future<void> refreshPermissionsIcons() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      setState(() {
        globalNotificationsAllowed = isAllowed;
      });
    });
    refreshScheduleChannelPermissions();
    refreshDangerousChannelPermissions();
  }

  void refreshScheduleChannelPermissions() {
    AwesomeNotifications()
        .checkPermissionList(
            channelKey: 'scheduled', permissions: channelPermissions)
        .then((List<NotificationPermission> permissionsAllowed) => setState(() {
              schedulesFullControl = true;
              for (NotificationPermission permission in channelPermissions) {
                scheduleChannelPermissions[permission] =
                    permissionsAllowed.contains(permission);
                schedulesFullControl = schedulesFullControl &&
                    scheduleChannelPermissions[permission]!;
              }
            }));
  }

  void refreshDangerousChannelPermissions() {
    AwesomeNotifications()
        .checkPermissionList(permissions: dangerousPermissions)
        .then((List<NotificationPermission> permissionsAllowed) => setState(() {
              for (NotificationPermission permission in dangerousPermissions) {
                dangerousPermissionsStatus[permission] =
                    permissionsAllowed.contains(permission);
              }
              isCriticalAlertsEnabled = dangerousPermissionsStatus[
                  NotificationPermission.CriticalAlert]!;
              isPreciseAlarmEnabled = dangerousPermissionsStatus[
                  NotificationPermission.PreciseAlarms]!;
              isOverrideDnDEnabled = dangerousPermissionsStatus[
                  NotificationPermission.OverrideDnD]!;
            }));
  }

  void processDefaultActionReceived(ReceivedAction receivedAction) {
    // Fluttertoast.showToast(msg: 'Action received');

    String? targetPage;

    // Avoid to reopen the media page if is already opened
    /*if (receivedAction.channelKey == 'media_player') {
      targetPage = PAGE_MEDIA_DETAILS;
      if (Navigator.of(context).isCurrent(PAGE_MEDIA_DETAILS)) return;
    } else {
      targetPage = PAGE_NOTIFICATION_DETAILS;
    }*/

    loadSingletonPage(targetPage: targetPage, receivedAction: receivedAction);
  }

  void processInputTextReceived(ReceivedAction receivedAction) {
    // if(receivedAction.channelKey == 'chats')
    //   NotificationUtils.simulateSendResponseChatConversation(
    //       msg: receivedAction.buttonKeyInput,
    //       groupKey: 'jhonny_group'
    //   );
    //
    // sleep(Duration(seconds: 2)); // To give time to show
    // Fluttertoast.showToast(
    //     msg: 'Msg: ' + receivedAction.buttonKeyInput,
    //     backgroundColor: App.mainColor,
    //     textColor: Colors.white);
  }

  void processMediaControls(actionReceived) {
    switch (actionReceived.buttonKeyPressed) {
      case 'MEDIA_CLOSE':
        MediaPlayerCentral.stop();
        break;

      case 'MEDIA_PLAY':
      case 'MEDIA_PAUSE':
        MediaPlayerCentral.playPause();
        break;

      case 'MEDIA_PREV':
        MediaPlayerCentral.previousMedia();
        break;

      case 'MEDIA_NEXT':
        MediaPlayerCentral.nextMedia();
        break;

      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // AwesomeNotifications().createdSink.close();
    // AwesomeNotifications().displayedSink.close();
    // AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  getPermission() async {
    bool locationResult = await Permissions().getCameraPermission();
    if (locationResult) {
    } else {
      getPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(config.firebaseToken);
    if (jumpToFeeds) {
      _selectTab("Feeds", 0);
      refresh.updateRefresh(true);
      setState(() {
        jumpToFeeds = false;
        hideNavBar = false;
        CurrentUser().currentUser.refreshStory = true;
      });
    }
    print("bou dAana built");
    return Scaffold(
      body: isACallPick
          ? /*CallPage(
                channelName: channelName,
                role: ClientRole.Audience,
                oppositeMemberId: objUserDetailModel.memberId,
                isFromHome: true,
                callFromButton: false,
                callType: CallType.audio,
                name: objUserDetailModel.memberName ?? "",
                token: token,
                userImage: objUserDetailModel.image ?? "",
                appID: APP_ID)*/
          HomeVideoCallScreen(
              channelName: channelName,
              isFromHome: true,
              callFromButton: false,
              oppositeMemberId: objUserDetailModel.memberId!,
              name: objUserDetailModel.memberName ?? "",
              token: token,
              userImage: objUserDetailModel.image ?? "",
              callType: CallType.audio,
            )

          // JoinChannelAudio(
          //     img: objUserDetailModel.image,
          //     isFromHome: true,
          //     name: objUserDetailModel.memberName ?? "",
          //     token: "",
          //   )
          : !isVCallPick
              ? WillPopScope(
        onWillPop: () async {
          if (_currentPage == "Discover") {
            setState(() {
              hideNavBar = false;
            });
          }
          final isFirstRouteInCurrentTab =
          !await _navigatorKeys[_currentPage]!
              .currentState!
              .maybePop();
          if (isFirstRouteInCurrentTab) {
            if (_currentPage != "Feeds") {
              _selectTab("Feeds", 0);

              return false;
            }
          }
          return isFirstRouteInCurrentTab;
        },
        child: StreamBuilder(
            initialData: refresh.currentNavbarState,
            stream: refresh.observableCart,
            builder: (context, snapshot) {
              return Scaffold(
                key: _scaffoldKey,
                bottomNavigationBar: Container(
                  height: hideNavBar == true ||
                      refresh.currentNavbarState == true
                      ? 0
                      : 9.0.h,
                  child: hideNavBar == true ||
                      refresh.currentNavbarState == true
                      ? Container()
                      : BottomNavigationBar(
                    onTap: (int index) {
                      setState(() {
                        channelColor = false;
                      });

                      if (_currentPage != "Feeds" &&
                          pageKeys[index] == "Feeds") {
                        if (isChannelOpen1) {
                          setState(() {
                            channelColor = true;
                          });
                        }
                      }
                      if (_currentPage != "Discover" &&
                          pageKeys[index] == "Discover") {
                        if (isChannelOpen2) {
                          setState(() {
                            channelColor = true;
                          });
                        }
                      }
                      if (_currentPage != "Profile" &&
                          pageKeys[index] == "Profile") {
                        print("cool");
                        // refreshChat.updateRefresh(true);
                        setState(() {
                          hideNavBar = true;
                        });
                        if (isChannelOpen3) {
                          setState(() {
                            channelColor = true;
                          });
                        }
                      }
                      if (_currentPage != "Blogs" &&
                          pageKeys[index] == "Blogs") {
                        if (isChannelOpen4) {
                          setState(() {
                            channelColor = true;
                          });
                        }
                      }

                      if (index == _selectedIndex) {
                        if (pageKeys[index] == "Feeds") {
                          _onTapFeed();
                          _selectTab("Feeds", 0);
                        } else if (pageKeys[index] ==
                            "Discover") {
                          _selectTab("Discover", 1);

                          _onTapSearch();
                        } else if (pageKeys[index] ==
                            "Videos") {
                          _onTapVideo();
                        } else if (pageKeys[index] == "Blogs") {
                          _selectTab("Blogs", 3);
                          setState(() {
                            isProfileOpen = false;
                          });
                        } else if (pageKeys[index] ==
                            "Profile") {
                          _selectTab("Profile", 4);
                        }
                      } else {
                        _selectTab(pageKeys[index], index);
                        // Get.delete<BuzzerfeedController>();
                        // Get.delete<BuzzerfeedMainController>();
                      }
                    },
                    backgroundColor:
                    (_currentPage == "Blogs") &&
                        isProfileOpen == false
                        ? Colors.black
                        : channelColor == true ||
                        _currentPage == "Videos"
                        ? Colors.grey[900]
                        : Colors.white,
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor:
                    (_currentPage == "Blogs" ||
                        _currentPage == "Videos" ||
                        channelColor == true) &&
                        isProfileOpen == false
                        ? Colors.white
                        : Colors.black,
                    selectedItemColor:
                    (_currentPage == "Blogs" ||
                        _currentPage == "Videos" ||
                        channelColor == true) &&
                        isProfileOpen == false
                        ? Colors.white
                        : primaryBlueColor,
                    currentIndex: _selectedIndex,
                    items: [
                      _bottomButtons(CustomIcons.home__1_, 28),
                      _bottomButtons(CustomIcons.newsearch, 28),
                      _bottomButtons(CustomIcons.newvideo1, 28),
                      _bottomButtons(CustomIcons.shortbuz1, 28),
                      _bottomButtons(
                          BuzzfeedLogo.buzzfeedlogo, 35),
                      _bottomButtons(CustomIcons.chat_icon, 30),

                      // _buzzfeed(35),
                    ],
                  ),
                ),
                body: Stack(children: <Widget>[
                  _buildOffstageNavigator("Feeds"),
                  _buildOffstageNavigator("Discover"),
                  _buildOffstageNavigator("Videos"),
                  _buildOffstageNavigator("Blogs"),
                  _buildOffstageNavigator("Profile"),
                  _buildOffstageNavigator("Buzzfeed"),
                ]),
              );
            }),
      )
              : HomeVideoCallScreen(
                  channelName: channelName,
                  isFromHome: true,
                  callType: CallType.video,
                  callFromButton: false,
                  oppositeMemberId: objUserDetailModel.memberId!,
                  name: objUserDetailModel.memberName ?? "",
                  token: token,
                  userImage: objUserDetailModel.image ?? "",
                ),
      //Addthis to generate token
      //  PlayVideoCallScreen(
      //                     name: objUserDetailModel.memberName ?? "",
      //                     oppositeMemberId: objUserDetailModel.memberId,
      //                     userImage: objUserDetailModel.image ?? "",
      //                   )
    );
  }

  Future sendPushMessage(String oppositeMemberId) async {
    print("bia nia");
    UserDetailModel objUserDetailModel1 =
        await ApiProvider().getUserDetail(oppositeMemberId);
    await ChatApiCalls.sendFcmRequest(
        objUserDetailModel1.memberName!,
        "cut+videobia",
        "call",
        "otherMemberID",
        objUserDetailModel1.firebaseToken!,
        0,
        0,
        isVideo: true);
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  print("${message.data['body'].toString()}");
  String notification = message.data['body'].toString();

  if (notification.isNotEmpty) {
    if (notification.contains('cut')) {
    } else {
      List<String> splittextreal = notification.split('+token=');
      List<String> splittext = splittextreal[0].split('+');

      String uid = splittext[0] ?? "";
      String callType = splittext[1] ?? "";
      List<String> splittextreal2 = splittextreal[1].split('+channelName=');
      String calltoken = splittextreal2[0];
      String callchannel = splittextreal2[1];

      UserDetailModel objUserDetailModel =
          await ApiProvider().getUserDetail(uid);
      if (objUserDetailModel != null &&
          objUserDetailModel.memberId != null &&
          objUserDetailModel.memberId != "") {
        // String platformVersion = await getPlatformVersion();
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: Random().nextInt(2147483647),
              channelKey: 'call_channel',
              title: 'Incoming Call',
              body: 'from ${objUserDetailModel.memberName}',
              category: NotificationCategory.Call,
              // largeIcon: objUserDetailModel.image,
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: false,
              // backgroundColor: (platformVersion == 'Android-31')
              //     ? Color(0x00796a)
              //     : Colors.white,
              payload: {
                'USERNAME': objUserDetailModel.memberName,
                'CALLTYPE': callType,
                'CALLTOKEN': calltoken,
                'CALLCHANNEL': callchannel,
                'USERIMAGE': objUserDetailModel.image,
                'OPPOSITEMEMBERID': uid,
              },
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
                  autoDismissible: true),
            ]);
      }
    }
  }
}
