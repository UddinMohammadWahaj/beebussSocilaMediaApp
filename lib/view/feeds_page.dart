import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/boost_post_slider_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/suggested_users_model.dart';
import 'package:bizbultest/models/video_ads_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/providers/feeds/popular_videos_provider.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/FeedAllApi/main_feeds_page_api_calls.dart';
import 'package:bizbultest/services/FeedAllApi/tokenutil.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/common_appbar.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/view/shortbuz_%20main_page_suggestion.dart';
import 'package:bizbultest/view/shortbuz_main_page.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_footer.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_header.dart';
import 'package:bizbultest/widgets/Newsfeeds/feed_stories.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:bizbultest/widgets/Newsfeeds/suggested_shortbuzz_videos_card.dart';
import 'package:bizbultest/widgets/Newsfeeds/suggestions_list.dart';
import 'package:bizbultest/widgets/Newsfeeds/suggestions_popup.dart';
import 'package:bizbultest/widgets/boosted_post_slider_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../services/FeedAllApi/feed_likes_api_calls.dart';
import 'Feeds/popular_videos.dart';
import 'Feeds/trending_topics.dart';
import 'Profile/profile_settings_page.dart';
import 'discover_people_from_tags.dart';

class FeedsPage extends StatefulWidget {
  final String? url;

  final String? logo;
  final String? memberID;
  String? country;
  final ScrollController? scrollController;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? profileOpen;
  final Function? refresh;

  FeedsPage(
      {Key? key,
      this.logo,
      this.country,
      this.memberID,
      this.url,
      this.scrollController,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.profileOpen,
      this.refresh})
      : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> with WidgetsBindingObserver {
  late int postID;
  var followSuccess;
  bool hasFollowed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Suggestions suggestionsList = new Suggestions([]);
  bool hasSuggestions = false;
  bool isFeedLoaded = false;
  AllFeeds? feedsList;
  Video videoList = new Video([]);
  String videoUrl = "";
  String h = "";
  String w = "";
  String fnImage = "";
  String dataVideoUrl = "";
  Future? _userStoryList;
  Future? _popularVideosFuture;
  Future? _shortbuzFuture;
  Future? _userSuggestionsFuture;
  late BoostPosts boostsList;
  bool isSliderLoaded = false;
  late VideoAds adsList;
  HomepageRefreshState refresh = new HomepageRefreshState();
  RefreshShortbuz shortbuzRefresh = new RefreshShortbuz();
  var feedController = Get.put(FeedController());
  var currentPage = 1;

  RefreshProfile refreshProfile = new RefreshProfile();

  Future<String> getCurrentMember() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var url =
        "https://www.bebuzee.com/api/user/userDetails?action=member_details_data&user_id=${CurrentUser().currentUser.memberID}";

    var response = await ApiProvider().fireApi(url);

    if (response!.statusCode == 200) {
      if (mounted) {
        setState(() {
          var res = response.data;
          print("got current again=${res['data']}");
          CurrentUser().currentUser.image = res['data']['image'];

          CurrentUser().currentUser.logo = widget.logo!;
          CurrentUser().currentUser.logo = res['data']['location_logo'];
          print("got current again=${CurrentUser().currentUser.image}");
          CurrentUser().currentUser.memberID = widget.memberID!;
          CurrentUser().currentUser.shortcode = res['data']['shortcode'];
          CurrentUser().currentUser.fullName = res['data']['name'];

          CurrentUser().currentUser.country = widget.country!;
          CurrentUser().currentUser.country = res['data']['country_name'];
          CurrentUser().currentUser.email = res['data']['email'];
          pref.setString("country", res['data']['country_name'].toString());

          CurrentUser().currentUser.properbuzLogo =
              res['data']['properbuz_logo'];
          CurrentUser().currentUser.shoppingbuzLogo =
              res['data']['shopping_logo'];
          CurrentUser().currentUser.tradesmenLogo =
              res['data']['tradesmen_logo'];
          print("shoppingbuzlogo=${CurrentUser().currentUser.properbuzLogo}");
          pref.setString("logo", res['location_logo'].toString());
          CurrentUser().currentUser.memberType =
              int.parse(res['data']['member_type'] ?? 0);
        });
      }
    }
    return "Success";
  }

  Future<void> getAds() async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/advertisment_list.php?action=get_next_advertisment&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&all_ids=');
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      print("getads =${value.data}");
      try {
        if (value.statusCode == 200) {
          VideoAds videoData = VideoAds.fromJson(value.data['data']);

          if (mounted) {
            setState(() {
              adsList = videoData;
            });
          }
        }
      } catch (e) {}
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=get_next_advertisment&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&all_ids=");

    // var response = await http.get(url);

    // if (response!.statusCode == 200 &&
    //     response!.body != null &&
    //     response!.body != "" &&
    //     response!.body != "null") {
    //   VideoAds videoData = VideoAds.fromJson(jsonDecode(response!.body));
    //   if (mounted) {
    //     setState(() {
    //       adsList = videoData;
    //     });
    //   }
    // }
  }

  // Future<void> postRebuzz(String postType, String postID) async {
  //   print("Rebuzz clicked");
  //   var url = Uri.parse(
  //       "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=share_post_data&post_type=$postType&post_id=$postID&user_id=${widget.memberID}");

  //   var response = await http.get(url);

  //   if (response!.statusCode == 200) {
  //     return "success";
  //   }
  // }

  Future<void> getFeeds() async {
    print("get feeds called");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/new_feed_data.php?action=new_feed_data&user_id=${CurrentUser().currentUser.memberID}&post_ids=&country=${CurrentUser().currentUser.country}&page=1');

    var client = Dio();
    var url = Uri.parse(
        'https://www.bebuzee.com/api/newsfeed/list?user_id=${CurrentUser().currentUser.memberID}&post_ids=&country=${CurrentUser().currentUser.country}&page=1');
    print("get feed =${url} called");

    SharedPreferences pref = await SharedPreferences.getInstance();
    print("after login newsfeed token=${pref.getString('token')}");
    String token = await ApiProvider().getTheToken(from: 'newsfeed');

    // newRefreshToken(from: 'newsfeed');
    // String token =
    //     await ApiProvider().refreshToken(CurrentUser().currentUser.memberID);

    print("  $url newsfeed${token}");
    await client
        .postUri(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      print("feed er baal ${value.statusCode} ${value.data} ");
      print("feed url=${url} ");
      if (value.statusCode == 200) {
        var response = value.data['data'];
        print("feed before");
        try {
          AllFeeds feedData = AllFeeds.fromJson(response);

          await Future.wait(feedData.feeds
              .map((e) => PreloadCached.cacheImage(
                  context, e.postImgData!.split("~~")[0]))
              .toList());
          await Future.wait(feedData.feeds
              .map((e) => PreloadCached.cacheImage(context, e.postUserPicture!))
              .toList());
          if (mounted) {
            setState(() {
              isFeedLoaded = false;
              print("feed loaded =$isFeedLoaded");
            });
          }
          if (mounted) {
            Timer(Duration(milliseconds: 50), () {
              setState(() {
                feedsList = feedData;
                isFeedLoaded = true;
                print("feed loaded feedList=$feedData loadvalue=$isFeedLoaded");
              });
            });
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("feedData", jsonEncode(response));
        } catch (e) {
          print("feed after erroe $e");
        }
        print("feed after");
      } else {
        if (mounted) {
          setState(() {
            isFeedLoaded = false;
          });
        }
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_news_feed.php?action=new_feed_data&user_id=${widget.memberID}&post_ids=&country=${widget.country}");

    // var response = await http.get(url

    // );

    // if (response!.statusCode == 200 && response!.body != "" && response!.body != null) {
    //   AllFeeds feedData = AllFeeds.fromJson(jsonDecode(response!.body));
    //   await Future.wait(feedData.feeds.map((e) => PreloadCached.cacheImage(context, e.postImgData.split("~~")[0])).toList());
    //   await Future.wait(feedData.feeds.map((e) => PreloadCached.cacheImage(context, e.postUserPicture)).toList());
    //   if (mounted) {
    //     setState(() {
    //       isFeedLoaded = false;
    //     });
    //   }
    //   if (mounted) {
    //     Timer(Duration(milliseconds: 50), () {
    //       setState(() {
    //         feedsList = feedData;
    //         isFeedLoaded = true;
    //       });
    //     });
    //   }
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("feedData", response!.body);
    // } else {
    //   if (mounted) {
    //     setState(() {
    //       isFeedLoaded = false;
    //     });
    //   }
    // }
  }

  Future<BoostPosts?> getBoostedSlider(
      String postID, String postType, String memberID) async {
    var newurl =
        'https://www.bebuzee.com/api/prmoted_slider_data.php?action=prmoted_slider_data?action=prmoted_slider_data&post_type=$postType&post_id=$postID&user_id=$memberID';
    print("boost post slider url=$newurl");
    var client = Dio();
    var response = await ApiProvider().fireApi(newurl).then((v) => v);

    // await client.postUri(newurl).then((v) => v);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=prmoted_slider_data?action=prmoted_slider_data&post_type=$postType&post_id=$postID&user_id=$memberID");

    // var response = await http.get(url);
    print("boost post slider response ${response!.data}");
    if (response!.statusCode == 200) {
      BoostPosts boostData = BoostPosts.fromJson(response!.data['data']);

      return boostData;
    } else {
      return null;
    }
  }

  Future<String> followUser(String otherMemberId, int index) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${widget.memberID}&user_id_to=$otherMemberId");
    var response = await http.get(url);
    return "success";
  }

  Future<String> unfollow(String unfollowerID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${widget.memberID}&user_id_to=$unfollowerID");

    var response = await http.get(url);

    if (response!.statusCode == 200) {}

    return "success";
  }

  Future<String> videoCompression(String postID) async {
    var url = Uri.parse(
        "https://www.upload.bebuzee.com/video_upload_api.php?action=compress_video_data&post_id=$postID");
    var response = await http.get(url);
    if (response!.statusCode == 200) {
      print(response!.body);
      getFeeds();
    }
    return "success";
  }

  Future<void> storyCompression() async {
    var url = Uri.parse(
        "https://www.upload.bebuzee.com/story_upload_api.php?action=compress_story_data&post_id=${CurrentUser().currentUser.storyPostID}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  Future<String> saveRatio(String video, String h, String w) async {
    var url = Uri.parse(
        "https://www.upload.bebuzee.com/video_upload_api.php?action=save_videos_to_other_ratio&video_url=$video&video_height=$h&video_width=$w");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      print(response!.body);
      // getFeeds();
    }
    return "success";
  }

  Future<String> generateThumbnail(String fn, String video) async {
    var url = Uri.parse(
        "https://www.upload.bebuzee.com/short_video.php?action=upload_short_video_thumb_generate&data_video_url=$video&fn_image=$fn");
    var response = await http.get(url);
    if (response!.statusCode == 200) {
      print(response!.body);
    }
    return "success";
  }

  void removeUserSuggestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("storyData");
    if (data != null) {
      // prefs.remove('storyData');
      prefs.remove('user_suggestions');
      print("suggestion removed success");
    }
  }

  void removeLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("feedData");
    if (data != null) {
      prefs.remove('feedData');
      print("local data removed success");
    }
  }

  void getLocalFeedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString("feedData");

    if (data != null) {
      print(
          "local data called feed data success type=${data.runtimeType} data== ${data}");
      try {
        AllFeeds feedData = AllFeeds.fromJson(jsonDecode(data));
        if (mounted) {
          setState(() {
            feedsList = feedData;
            isFeedLoaded = true;
          });
        }
      } catch (e) {}
    }
  }

  void getLocalStoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storyData = prefs.getString("storyData");
    if (storyData != null) {
      print("storylocal data =${storyData}");
      try {
        if (mounted) {
          setState(() {
            _userStoryList = MainFeedsPageApi.getStoryUserListLocal(context);

            isFeedLoaded = true;
          });
        }
      } catch (e) {}
    }
  }

  void getLocalData() async {
    print("Local data called");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString("feedData");
    String? storyData = prefs.getString("storyData");

    if (data != null && storyData != null) {
      print("storylocal data =${storyData}");
      AllFeeds feedData = AllFeeds.fromJson(jsonDecode(data));
      if (mounted) {
        setState(() {
          _userStoryList = MainFeedsPageApi.getStoryUserListLocal(context);
          feedsList = feedData;
          isFeedLoaded = true;
        });
      }
    } else {
      print("no local data");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // removeStroyData();
      // removeLocalData();
      // removeUserSuggestion();
      // getLocalFeedData();
      // getLocalStoryData();
      getFeeds();

      _popularVideosFuture =
          Provider.of<PopularVideosProvider>(context, listen: false)
              .getVideoSuggestionsLocal(context);

      // getFeeds();

      _userStoryList = MainFeedsPageApi.getStoryUserList(context);

      _shortbuzFuture = MainFeedsPageApi.getShortbuzSuggestionsLocal(context);
      _shortbuzFuture = MainFeedsPageApi.getShortbuzSuggestions(context);

      _userSuggestionsFuture = MainFeedsPageApi.getSuggestionsLocal();

      _userSuggestionsFuture = MainFeedsPageApi.getSuggestions();

      getCurrentMember();
      getAds();
      //wakeLockStatus();
    });

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  RefreshController _feedRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController _videoRefreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    print("on refresh called");
    try {
      if (mounted) {
        setState(() {
          currentPage = 1;
          feedsList!.feeds = [];
          _userStoryList = MainFeedsPageApi.getStoryUserList(context);
        });
      }
      print("on refresh called 2");
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/app_devlope_news_feed.php?action=new_feed_data&user_id=${widget.memberID}&post_ids=&country=${widget.country}");

      // var response = await http.get(url);

      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/newsfeed/list?user_id=${CurrentUser().currentUser.memberID}&post_ids=&country=${CurrentUser().currentUser.country}&page=1');

      var client = Dio();
      String token = await ApiProvider().getTheToken(from: 'newsfeedrefresh ');
      print("on refresh called 3");
      await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        if (value.statusCode == 200) {
          AllFeeds feedData = AllFeeds.fromJson(value.data['data']);

          await Future.wait(feedData.feeds
              .map((e) => PreloadCached.cacheImage(context,
                  e.postImgData != null ? e.postImgData!.split("~~")[0] : ""))
              .toList());
          if (mounted) {
            setState(() {
              isFeedLoaded = false;
            });
          }
          if (mounted) {
            Timer(Duration(milliseconds: 50), () {
              setState(() {
                feedsList = feedData;
                isFeedLoaded = true;
              });
            });
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("feedData", jsonEncode(value.data['data']));
        } else {
          if (mounted) {
            setState(() {
              isFeedLoaded = false;
            });
          }
        }
      });

      /*
    if (mounted) {
      setState(() {
        feedsList.feeds = [];
        _userStoryList = MainFeedsPageApi.getStoryUserList(context);
      });
    }
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_news_feed.php?action=new_feed_data&user_id=${widget.memberID}&post_ids=&country=${widget.country}");
    var response = await http.get(url);
    if (response!.statusCode == 200) {
      AllFeeds feedData = AllFeeds.fromJson(jsonDecode(response!.body));
      await Future.wait(feedData.feeds
          .map((e) =>
              PreloadCached.cacheImage(context, e.postImgData.split("~~")[0]))
          .toList());
      if (mounted) {
        setState(() {
          isFeedLoaded = false;
        });
      }
      if (mounted) {
        Timer(Duration(milliseconds: 50), () {
          setState(() {
            feedsList = feedData;
            isFeedLoaded = true;
          });
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("feedData", response!.body);
    }
    if (response!.body == null || response!.statusCode != 200) {
      if (mounted) {
        setState(() {
          isFeedLoaded = false;
        });
      }
    }
    */
      _feedRefreshController.refreshCompleted();
    } catch (e) {
      print("error newsfeed refresh=${e}");
      _feedRefreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    int len = feedsList!.feeds.length;
    // String urlStr = "";
    // for (int i = 0; i < len; i++) {
    //   urlStr += feedsList.feeds[i].postId;
    //   if (i != len - 1) {
    //     urlStr += ",";
    //   }
    // }
    var page = feedsList!.feeds[len - 1].page;
    // if (page < currentPage) {
    //   page = currentPage;
    // }

    print("page=${page} currentPage=$currentPage");
    if (page == 1 && currentPage > page!) {
      page = currentPage;
    }
    if (page != currentPage &&
        widget.country == CurrentUser().currentUser.country.toString()) {
      print(
          "page=${page} current=${currentPage}loading url country change : https://www.bebuzee.com/api/new_feed_data.php?action=new_feed_data&user_id=${widget.memberID}&page=$currentPage&country=${widget.country}");

      return;
    } else {
      if (widget.country != CurrentUser().currentUser.country.toString()) {
        widget.country = CurrentUser().currentUser.country.toString();
      }
      currentPage = page! + 1;
    }
    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/newsfeed/list?user_id=${CurrentUser().currentUser.memberID}&post_ids=&country=${widget.country}&page=$currentPage');
      print("loading url=${newurl}");
      var client = Dio();
      String token = await ApiProvider().getTheToken();
      await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("page=$page statuss=${value.data}");

        if (value.statusCode == 200 && value.data['status'] == 1) {
          print("onLoading= ${value.data['data']}");

          AllFeeds feedData = AllFeeds.fromJson(value.data['data']);
          await Future.wait(feedData.feeds
              .map((e) => PreloadCached.cacheImage(
                  context, e.postsmlImgData!.split("~~")[0]))
              .toList());
          await Future.wait(feedData.feeds
              .map((e) => PreloadCached.cacheImage(context, e.postUserPicture!))
              .toList());
          if (mounted) {
            setState(() {
              feedsList!.feeds.addAll(feedData.feeds);
              isFeedLoaded = true;
            });
          }
        } else {
          _feedRefreshController.loadComplete();
          currentPage = page!;
          setState(() {
            isFeedLoaded = false;
          });
        }
      });
    }

    // try {

    //   var url = Uri.parse("https://www.bebuzee.com/app_devlope_news_feed.php");
    //   final response = await http.post(url, body: {
    //     "user_id": widget.memberID,
    //     "post_ids": urlStr,
    //     "action": "new_feed_data",
    //     "country": widget.country
    //   });
    //   if (response!.statusCode == 200) {
    //     AllFeeds feedData = AllFeeds.fromJson(jsonDecode(response!.body));
    //     await Future.wait(feedData.feeds
    //         .map((e) =>
    //             PreloadCached.cacheImage(context, e.postImgData.split("~~")[0]))
    //         .toList());
    //     await Future.wait(feedData.feeds
    //         .map((e) => PreloadCached.cacheImage(context, e.postUserPicture))
    //         .toList());
    //     if (mounted) {
    //       setState(() {
    //         feedsList.feeds.addAll(feedData.feeds);
    //         isFeedLoaded = true;
    //       });
    //     }
    //   }

    //   else {
    //     setState(() {
    //       isFeedLoaded = false;
    //     });
    //   }
    // }

    on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh feed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _feedRefreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _feedRefreshController.loadComplete();
  }

  DateTime offTime = DateTime.now();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.toString() == "AppLifecycleState.resumed") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _userStoryList = MainFeedsPageApi.getStoryUserList(context);
        });
      });
    }
    if (state.toString() == "AppLifecycleState.paused") {
      setState(() {
        offTime = DateTime.now();
      });
    }
    var diff = DateTime.now().difference(offTime).inMinutes;
    if (state.toString() == "AppLifecycleState.resumed" && diff > 10) {
      setState(() {
        isFeedLoaded = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // getFeeds();
      });
      setState(() {
        isFeedLoaded = true;
      });
    }
  }

  void getStories() {
    setState(() {
      _userStoryList = MainFeedsPageApi.getStoryUserList(context);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return StreamBuilder(
        initialData: refresh.currentSelect,
        stream: refresh.observableCart,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.setNavBar!(feedController.hideNavBar.value);
              widget.changeColor!(false);
              Timer(Duration(milliseconds: 500), () {
                // getFeeds();
                // getCurrentMember();
                // getStories();
                refresh.updateRefresh(false);
              });
            });
          }
          return Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: CommonAppbar(
                  setNavbar: widget.setNavBar,
                  isChannelOpen: widget.isChannelOpen,
                  changeColor: widget.changeColor,
                  elevation: 0,
                  logo: widget.logo,
                  country: widget.country,
                  memberID: widget.memberID,
                ),
              ),
              body: SizedBox(
                child: Container(
                  height: MediaQuery.of(context).size.height - 6.6.h,
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (v) {
                      print("feed scrolll direction=${v.direction}");
                      return true;

                    },
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: CustomHeader(
                        builder: (context, mode) {
                          return Container(
                            child: Center(child: loadingAnimation()),
                          );
                        },
                      ),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
                          Widget body;

                          if (mode == LoadStatus.idle) {
                            body = Text("");
                          } else if (mode == LoadStatus.loading) {
                            body = loadingAnimation();
                          } else if (mode == LoadStatus.failed) {
                            body = Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                      color: Colors.black, width: 0.7),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Icon(CustomIcons.reload),
                                ));
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text(
                              AppLocalizations.of("release to load more"),
                            );
                          } else {
                            body = Text(
                              AppLocalizations.of("No more Data"),
                            );
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _feedRefreshController,
                      onRefresh: () async {
                        _onRefresh();
                      },
                      onLoading: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _onLoading();
                        });
                      },
                      child: isFeedLoaded && feedsList != null
                          ? ListView.builder(
                              addAutomaticKeepAlives: true,
                              controller: widget.scrollController,
                              itemCount: (feedsList!.feeds.length ?? 0) + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<dynamic>(
                                            future: _userStoryList,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                print(
                                                    "snap story lis=${snapshot.data} lengh-${snapshot.data!.users.length}");
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.0.h,
                                                        bottom: 3.0.h),
                                                    child: Container(
                                                      height: 140,
                                                      child: ListView.builder(
                                                          addAutomaticKeepAlives:
                                                              false,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: snapshot
                                                              .data
                                                              .users
                                                              .length,
                                                          itemBuilder: (context,
                                                              storyIndex) {
                                                            var user = snapshot
                                                                    .data.users[
                                                                storyIndex];
                                                            return FeedStories(
                                                              profilePage:
                                                                  (memID,
                                                                      code) {
                                                                print(memID);
                                                                print(code);
                                                                setState(() {
                                                                  OtherUser()
                                                                      .otherUser
                                                                      .memberID = memID;
                                                                  OtherUser()
                                                                      .otherUser
                                                                      .shortcode = code;
                                                                });
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ProfilePageMain(
                                                                              setNavBar: widget.setNavBar,
                                                                              from: "story",
                                                                              isChannelOpen: widget.isChannelOpen,
                                                                              changeColor: widget.changeColor,
                                                                              otherMemberID: memID,
                                                                            )));
                                                              },
                                                              goToProfile: () {
                                                                print(user
                                                                    .shortcode);

                                                                setState(() {
                                                                  OtherUser()
                                                                          .otherUser
                                                                          .memberID =
                                                                      user.memberId;
                                                                  OtherUser()
                                                                          .otherUser
                                                                          .shortcode =
                                                                      user.shortcode;
                                                                });
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ProfilePageMain(
                                                                              setNavBar: widget.setNavBar,
                                                                              from: "story",
                                                                              isChannelOpen: widget.isChannelOpen,
                                                                              changeColor: widget.changeColor,
                                                                              otherMemberID: user.memberId,
                                                                            )));
                                                              },
                                                              stories: snapshot
                                                                  .data.users,
                                                              animate: () {
                                                                print(
                                                                    "animateeeee");
                                                              },
                                                              setNavBar: widget
                                                                  .setNavBar,
                                                              user: snapshot
                                                                      .data
                                                                      .users[
                                                                  storyIndex],
                                                              e: storyIndex,
                                                            );
                                                          }),
                                                    ));
                                              } else {
                                                return Container(
                                                  height: 140,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: 10,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          child: Container(
                                                            child:
                                                                SkeletonAnimation(
                                                              child: Container(
                                                                width: 80,
                                                                height:
                                                                    100 + 1.0.w,
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                );
                                              }
                                            }),
                                        TrendingTopics(
                                          changeColor: widget.changeColor,
                                          isChannelOpen: widget.isChannelOpen,
                                          setNavBar: widget.setNavBar,
                                          profileOpen: widget.profileOpen,
                                        )
                                      ],
                                    ),
                                  );
                                }
                                else if (index == 5) {
                                  print("i am here shortbuz");
                                  return Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: FutureBuilder<dynamic>(
                                              future: _shortbuzFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  print("shortbuzz snapshot ${snapshot.data} ");
                                                  print(snapshot.data!.videos.length.toString()+" this is listtt");
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1.0
                                                                          .h),
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          "Suggested") +
                                                                      " " +
                                                                      AppLocalizations.of(
                                                                          "Shortbuz"),
                                                                  style:
                                                                      blackBold),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  widget.setNavBar!(
                                                                      true);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ShortbuzMainPageSuggestion(
                                                                                from: "disco",
                                                                                profileOpen: widget.profileOpen,
                                                                                setNavBar: widget.setNavBar,
                                                                                isChannelOpen: widget.isChannelOpen,
                                                                                changeColor: widget.changeColor,
                                                                                postID: " ",
                                                                              )));
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: Padding(
                                                                      padding: EdgeInsets.all(1.0.h),
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.play_arrow,
                                                                            size:
                                                                                2.5.h,
                                                                          ),
                                                                          Text(
                                                                              AppLocalizations.of("Watch All"),
                                                                              style: blackBold),
                                                                        ],
                                                                      )),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 30.0.h,
                                                        child:  ListView.builder(
                                                            addAutomaticKeepAlives: false,
                                                            scrollDirection: Axis.horizontal,
                                                            shrinkWrap: true,
                                                            itemCount: snapshot.data!.videos.length,
                                                            itemBuilder: (context, index) {
                                                              return SuggestedShortBuzzCard(
                                                                onTap: () {
                                                                  print("tapped");
                                                                  print(snapshot.data.videos[index].postId);
                                                                  widget.setNavBar!(true);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ShortbuzMainPageSuggestion(
                                                                            from: "disco",
                                                                            profileOpen: widget.profileOpen,
                                                                            setNavBar: widget.setNavBar,
                                                                            isChannelOpen: widget.isChannelOpen,
                                                                            changeColor: widget.changeColor,
                                                                            postID: snapshot.data.videos[index].postId,
                                                                          )));
                                                                },
                                                                video: snapshot.data.videos[index],
                                                              );
                                                            }),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                else if (index == 8) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: _currentScreenSize.width * 0.80,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(
                                                      "Suggested"),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      showMaterialModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                    const Radius
                                                                            .circular(
                                                                        20.0),
                                                                topRight:
                                                                    const Radius
                                                                            .circular(
                                                                        20.0))),
                                                        //isScrollControlled:true,
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          // return object of type Dialog
                                                          return Container(
                                                            height: 60.0.h,
                                                            child: FutureBuilder<
                                                                    dynamic>(
                                                                future:
                                                                    _userSuggestionsFuture,
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    return ListView
                                                                        .builder(
                                                                      addAutomaticKeepAlives:
                                                                          false,
                                                                      controller:
                                                                          ModalScrollController.of(
                                                                              context),
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount: snapshot
                                                                          .data
                                                                          .suggestions
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        // return Container(
                                                                        //   height: 50,
                                                                        //   width: 100,
                                                                        //   color: Colors.pink,
                                                                        // );
                                                                        return SuggestionsPopup(
                                                                          user: snapshot
                                                                              .data
                                                                              .suggestions[index],
                                                                          onPressed:
                                                                              () {
                                                                            print("member id clicked=${snapshot.data.suggestions[index].memberId}");

                                                                            setState(() {
                                                                              OtherUser().otherUser.memberID = snapshot.data.suggestions[index].memberId;
                                                                              OtherUser().otherUser.shortcode = snapshot.data.suggestions[index].shortcode;
                                                                            });

                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => ProfilePageMain(
                                                                                          setNavBar: widget.setNavBar,
                                                                                          from: "story",
                                                                                          isChannelOpen: widget.isChannelOpen,
                                                                                          changeColor: widget.changeColor,
                                                                                          otherMemberID: snapshot.data.suggestions[index].memberId,
                                                                                        )));
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                }),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                "See All"),
                                                            style: TextStyle(
                                                                color:
                                                                    primaryBlueColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder<dynamic>(
                                              future: _userSuggestionsFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Container(
                                                    height: 225,
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: 10,
                                                        itemBuilder:
                                                            (context, index) {
                                                          var value = snapshot
                                                                  .data
                                                                  .suggestions[
                                                              index];

                                                          return SuggestionsList(
                                                            remove: () {
                                                              setState(() {
                                                                snapshot.data
                                                                    .suggestions
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            },
                                                            onTap: () {
                                                              setState(() {
                                                                OtherUser()
                                                                        .otherUser
                                                                        .memberID =
                                                                    value
                                                                        .memberId;
                                                                OtherUser()
                                                                        .otherUser
                                                                        .shortcode =
                                                                    value
                                                                        .shortcode;
                                                              });
                                                              print(
                                                                  "member id clicke=${snapshot.data.suggestions[index].memberId}");
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProfilePageMain(
                                                                            setNavBar:
                                                                                widget.setNavBar,
                                                                            isChannelOpen:
                                                                                widget.isChannelOpen,
                                                                            changeColor:
                                                                                widget.changeColor,
                                                                            otherMemberID:
                                                                                snapshot.data.suggestions[index].memberId,
                                                                          )));
                                                            },
                                                            followStatus: value
                                                                        .followStatus ==
                                                                    0
                                                                ? AppLocalizations
                                                                    .of(
                                                                        "Follow")
                                                                : value.followStatus ==
                                                                        1
                                                                    ? AppLocalizations.of(
                                                                        "Following")
                                                                    : value.followStatus ==
                                                                            0
                                                                        ? AppLocalizations.of(
                                                                            "Follow")
                                                                        : value.followStatus ==
                                                                                4
                                                                            ? AppLocalizations.of("Follow Back")
                                                                            : AppLocalizations.of("Requested"),
                                                            image: value.image,
                                                            name: value.name,
                                                            shortcode:
                                                                value.shortcode,
                                                            onPressed:
                                                                () async {
                                                              var status = await FeedLikeApiCalls.memberfollowunfollow(
                                                                  snapshot
                                                                      .data
                                                                      .suggestions[
                                                                          index]
                                                                      .memberId,
                                                                  snapshot
                                                                      .data
                                                                      .suggestions[
                                                                          index]
                                                                      .followStatus);
                                                              setState(() {
                                                                snapshot
                                                                    .data
                                                                    .suggestions[
                                                                        index]
                                                                    .followStatus = status;
                                                              });

                                                              // print(snapshot
                                                              //     .data
                                                              //     .suggestions[
                                                              //         index]
                                                              //     .followStatus);
                                                              // setState(() {
                                                              //   if (snapshot
                                                              //           .data
                                                              //           .suggestions[
                                                              //               index]
                                                              //           .followStatus ==
                                                              //       1) {
                                                              //     snapshot
                                                              //             .data
                                                              //             .suggestions[
                                                              //                 index]
                                                              //             .followStatus =
                                                              //         AppLocalizations.of(
                                                              //             "Follow");
                                                              //   } else {
                                                              //     snapshot
                                                              //             .data
                                                              //             .suggestions[
                                                              //                 index]
                                                              //             .followStatus =
                                                              //         AppLocalizations.of(
                                                              //             "Following");
                                                              //   }
                                                              //   _userSuggestionsFuture =
                                                              //       MainFeedsPageApi
                                                              //           .getSuggestions();
                                                              // });
                                                              // followUser(
                                                              //     value
                                                              //         .memberId,
                                                              //     index);
                                                            },
                                                          );
                                                        }),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                else if (index == 2) {
                                  return PopularVideos(
                                    popularVideosFuture: _popularVideosFuture,
                                    setNavBar: widget.setNavBar,
                                    changeColor: widget.changeColor,
                                  );
                                }
                                else if ((index == 1 ||
                                    index == 3 ||
                                    index == 4 ||
                                    index == 6 ||
                                    index == 7 ||
                                    index > 8)) {
                                  int feedIndex;
                                  if (index == 1) {
                                    feedIndex = index - 1;
                                  } else if (index == 3 || index == 4) {
                                    feedIndex = index - 2;
                                  } else if (index == 6 || index == 7) {
                                    feedIndex = index - 3;
                                  } else {
                                    feedIndex = index - 4;
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 1.5.h),
                                    child: Obx(
                                      () => Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            feedController.isUploading.value == true &&
                                                    index == 1
                                                ? Container(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 1.0.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              feedController.file.value.path.endsWith(".png") ||
                                                                      feedController.file.value.path.endsWith(".jpg") ||
                                                                      feedController.file.value.path.endsWith(".PNG") ||
                                                                      feedController.file.value.path.endsWith(".JPG")
                                                                  ? Container(
                                                                      height: 50,
                                                                      width: 50,
                                                                      child: Image.file(feedController.file.value,
                                                                        fit: BoxFit.cover,))
                                                                  : Container(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      child:
                                                                          FittedVideoPlayerThumbnail(
                                                                        video: feedController
                                                                            .file
                                                                            .value,
                                                                      )),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                AppLocalizations
                                                                    .of(
                                                                  "Finishing up",
                                                                ),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        11.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          CircularProgressIndicator(
                                                              value: feedController
                                                                  .uploadProgress
                                                                  .value,
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade400,
                                                              color:
                                                                  Colors.white,
                                                              strokeWidth: 3,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      primaryBlueColor))
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            FeedHeader(
                                              refresh: () {
                                                Timer(Duration(seconds: 2), () {
                                                  getFeeds();
                                                });
                                              },
                                              setNavBar: widget.setNavBar,
                                              isChannelOpen:
                                              widget.isChannelOpen,
                                              changeColor: widget.changeColor,
                                              feed: feedsList!.feeds[feedIndex],
                                              sKey: _scaffoldKey,
                                            ),

                                            FeedFooter(
                                              stickerList: feedsList!
                                                  .feeds[feedIndex].stickers,
                                              positionList: feedsList!
                                                  .feeds[feedIndex].position,
                                              setNavBar: widget.setNavBar,
                                              isChannelOpen:
                                              widget.isChannelOpen,
                                              changeColor: widget.changeColor,
                                              sKey: _scaffoldKey,
                                              feed: feedsList!.feeds[feedIndex],
                                              onPressMatchText: (value) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DiscoverFromTagsView(
                                                            tag: value
                                                                .toString()
                                                                .substring(1),
                                                          ),
                                                    ));
                                              },
                                            ),
                                            feedsList!.feeds[feedIndex]
                                                        .postPromotedSlider! >
                                                    0
                                                ? FutureBuilder<dynamic>(
                                                    future: getBoostedSlider(
                                                        feedsList!
                                                            .feeds[feedIndex]
                                                            .postId!,
                                                        feedsList!
                                                            .feeds[feedIndex]
                                                            .postType,
                                                        feedsList!
                                                            .feeds[feedIndex]
                                                            .postUserId!),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Container(
                                                          height: 25.0.h,
                                                          child:
                                                              ListView.builder(
                                                            addAutomaticKeepAlives:
                                                                false,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: snapshot
                                                                .data
                                                                .boosts
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    indexBoost) {
                                                              return BoostedPostCards(
                                                                memberID: widget
                                                                    .memberID,
                                                                country: widget
                                                                    .country,
                                                                boost: snapshot
                                                                        .data
                                                                        .boosts[
                                                                    indexBoost],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    })
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          : Container(),
                    ),
                  ),
                ),
              ));
        });
  }
}
