import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/hashtags.dart';
import 'package:bizbultest/models/shortbuz_suggestions_model.dart';
import 'package:bizbultest/models/suggested_users_model.dart';
import 'package:bizbultest/models/user_story_list_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/homepage.dart';
import '../current_user.dart';

class MainFeedsPageApi {
  static Future<List<VideoModel>> getVideoSuggestions(
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? video = prefs.getString("videoData");
    String? token = await ApiProvider().getTheToken();

    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/video/videoSuggestion?action=popular_video_data_new_feed&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&sequence=');
      var client = Dio();
      print("get video suggestion url=$newurl $token");
      return await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("getvideosuggestion= ${value.data}");
        // print("video suggestion image=${value.data['data'].image}");
        if (value.statusCode == 200) {
          Video videoData = Video.fromJson(value.data['data']);
          // print(
          //     "videosuggestion image = ${value.data['data'][0].containsKey('image')}");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("videoData", value.data['data'].toString());
          return videoData.videos;
        } else {
          return <VideoModel>[];
        }
      });
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=popular_video_data_new_feed&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&sequence=");

      // var response = await http.get(url);

      // if (response.statusCode == 200 &&
      //     response.body != null &&
      //     response.body != "") {
      //   print(response.body);
      //   print("got videos");
      //   Video videoData = Video.fromJson(jsonDecode(response.body));
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString("videoData", response.body);
      //   return videoData.videos;
      // } else {
      //   if (video != null) {
      //     Video videoData = Video.fromJson(jsonDecode(video));
      //     return videoData.videos;
      //   } else {
      //     return <VideoModel>[];
      //   }
      // }
    } on SocketException {
      if (video != null) {
        Video videoData = Video.fromJson(jsonDecode(video));
        return videoData.videos;
      } else {
        return <VideoModel>[];
      }
    }
  }

  // static Future<List> getDataProperty() async {
  //   var data = await ApiProvider().fireApiWithParams('https://w').then((value) => value);
  // }

  static Future<List<VideoModel>> getVideoSuggestionsLocal(
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? video = prefs.getString("videoData");
    if (video != null) {
      try {
        Video videoData = Video.fromJson(jsonDecode(video));
        return videoData.videos;
      } catch (e) {
        return <VideoModel>[];
      }
    } else {
      print("22222222222222");
      return <VideoModel>[];
    }
  }

  static Future<List<VideoModel?>?>? onLoadingVideo(List<VideoModel?> videoList,
      BuildContext context, RefreshController _videoRefreshController) async {
    int len = videoList.length;
    if (len < 40) {
      String urlStr = "";
      for (int i = 0; i < len; i++) {
        // videoList[i].category = videoList[i].category.replaceFirst('&', '@');
        var dummy = videoList[i]!.category;
        dummy = dummy!.replaceFirst('&', '@');
        print('new =${dummy}');

        urlStr += dummy;

        if (i != len - 1) {
          urlStr += ",";
        }
      }

      print("the urlStr=${urlStr}");
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

      try {
        var newurl = Uri.parse(
            'https://www.bebuzee.com/api/video_suggestion_data.php?action=popular_video_data_new_feed&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&sequence=&categories=$urlStr');
        var client = Dio();
        print("onloading url=$newurl");
        return await client
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
            Video videoData = Video.fromJson(value.data['data']);
            await Future.wait(videoData.videos
                .map((e) => Preload.cacheImage(context, e.image!))
                .toList());
            _videoRefreshController.loadComplete();
            print("got");
            for (var v in videoData.videos) {
              print("${v.category}\n");
            }
            return videoData.videos;
          } else {
            _videoRefreshController.loadComplete();
            return null;
          }
        });

        // var url = Uri.pa
        // rse(
        //     "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php");

        // final response = await http.post(url, body: {
        //   "user_id": CurrentUser().currentUser.memberID,
        //   "categories": urlStr,
        //   "action": "popular_video_data_new_feed"
        // });
        // if (response.statusCode == 200) {
        //   Video videoData = Video.fromJson(jsonDecode(response.body));
        //   await Future.wait(videoData.videos
        //       .map((e) => Preload.cacheImage(context, e.image))
        //       .toList());
        //   _videoRefreshController.loadComplete();
        //   print("got");
        //   return videoData.videos;
        // } else {
        //   _videoRefreshController.loadComplete();
        //   return null;
        // }
      } on SocketException catch (e) {
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
            _videoRefreshController.loadFailed();
            Timer(Duration(seconds: 2), () {
              Navigator.pop(context);
            });

            // return object of type Dialog
            return Container();
          },
        );
      }
      _videoRefreshController.loadComplete();
      return null;
    } else {
      _videoRefreshController.loadComplete();
      return null;
    }
  }

  static Future<List<VideoModel?>?>? getVideoDetails(
      context, String postId) async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/video_data.php?user_id=${CurrentUser().currentUser.memberID}&post_id=${postId}');
      var client = Dio();
      print("onloading url=$newurl");
      return await client
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
          Video videoData = Video.fromJson(value.data['data']);
          await Future.wait(videoData.videos
              .map((e) => Preload.cacheImage(context, e.image!))
              .toList());

          print("got");
          for (var v in videoData.videos) {
            print(
                "vidcat =${videoData.videos[0].category}\n vidnamebia=${videoData.videos[0].name}");
          }
          return videoData.videos;
        } else {
          return null;
        }
      });
    } on SocketException catch (e) {
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
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          // return object of type Dialog
          return Container();
        },
      );
    }

    return null;
  }

  static Future<List<TrendingTopicsModel>> getHashtags(String tag) async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/image/searchHastagData?searchword=$tag');
    print("search tend called=${newurl}");
    var client = Dio();
    String? token = await ApiProvider().newRefreshToken();
    return await client
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
        print("trending data= ${value.data['data']}");
        TrendingTopics hashTagData =
            TrendingTopics.fromJson(value.data['data']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("tagsData", jsonEncode(value.data['data']));
        return hashTagData.topics;
      } else {
        return <TrendingTopicsModel>[];
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=hastag_data_search&user_id=${CurrentUser().currentUser.memberID}&searchword=$tag");

    // var response = await http.get(url);

    // if (response.statusCode == 200) {
    //   TrendingTopics hashTagData =
    //       TrendingTopics.fromJson(jsonDecode(response.body));
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("tagsData", response.body);
    //   return hashTagData.topics;
    // } else {
    //   return <TrendingTopicsModel>[];
    // }
  }

  static Future<List<TrendingTopicsModel>> getHashtagsLocal(String tag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tagsData = prefs.getString("tagsData");
    print("trending hashtaglocal");
    if (tagsData != null) {
      try {
        print("trending hashtaglocal not null");
        print('trending hashtag local data $tagsData');
        TrendingTopics hashTagData =
            TrendingTopics.fromJson(jsonDecode(tagsData));
        print("trending hashtag local data after ");

        return hashTagData.topics;
      } catch (e) {
        print("trend error $e");
        return <TrendingTopicsModel>[];
      }
    } else {
      print("trending hashtaglocal  null");
      return <TrendingTopicsModel>[];
    }
  }

  static Future<UserStoryList?>? getStoryUserList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storiesData = prefs.getString("storyData");
    String? token = await ApiProvider().getTheToken();
    try {
      var url = Uri.parse(
          'https://www.bebuzee.com/api/storyData?action=storyData&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}');
      print("story url=$url");
      var client = Dio();

      return await client
          .postUri(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("story list data=${value.data}  rl=${url}");

        if (value.data['success'] == 1) {
          print("success story 0");
          UserStoryList userData = UserStoryList.fromJson(value.data['data']);
          await Future.wait(userData.users
              .map((e) => PreloadCached.cacheImage(context, e.image!))
              .toList());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("storyData", jsonEncode(value.data['data']));
          print("c");
          return userData;
        } else {
          return UserStoryList([]);
        }
      });
    } catch (e) {
      print("story error $e");
    }
    // try {
    //   var url = Uri.parse(
    //       "https://www.bebuzee.com/app_devlope_story_data.php?action=story_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    //   var response = await http.get(url);

    //   if (response.statusCode == 200) {
    //     UserStoryList userData =
    //         UserStoryList.fromJson(jsonDecode(response.body));
    //     await Future.wait(userData.users
    //         .map((e) => PreloadCached.cacheImage(context, e.image))
    //         .toList());
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.setString("storyData", response.body);
    //     return userData;
    //   } else {
    //     if (storiesData != null) {
    //       UserStoryList userData =
    //           UserStoryList.fromJson(jsonDecode(storiesData));
    //       return userData;
    //     } else {
    //       return UserStoryList([]);
    //     }
    //   }
    // }

    on SocketException {
      if (storiesData != null) {
        UserStoryList userData =
            UserStoryList.fromJson(jsonDecode(storiesData));
        return userData;
      } else {
        return UserStoryList([]);
      }
    }
  }

  static Future<UserStoryList> getStoryUserListLocal(
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storiesData = prefs.getString("storyData");
    if (storiesData != null) {
      print("story user list not null ${storiesData.length}");
      UserStoryList userData = UserStoryList.fromJson(jsonDecode(storiesData));
      return userData;
    } else {
      print("story user list  null ");
      return UserStoryList([]);
    }
  }

  static Future<Suggestions> getSuggestions() async {
    print("suggestion call");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? suggestions = prefs.getString("user_suggestions");
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    try {
      var newurl = 'https://www.bebuzee.com/api/member_suggestion_list.php';
      var client = Dio();
      return await client
          .post(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        if (value.statusCode == 200) {
          print("suggestion list=${value.data}");
          Suggestions suggestionsData =
              Suggestions.fromJson(value.data['data']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString("user_suggestions", value.data['data']);
          print(
              "suggested userlist=${suggestionsData.suggestions[0].followStatus}");
          return suggestionsData;
        } else
          return Suggestions([]);
      });

      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/signup_login_api_call.php?action=suggestion_right_data&user_id=${CurrentUser().currentUser.memberID}");

      // var response = await http.get(url);

      // if (response.statusCode == 200) {
      //   Suggestions suggestionsData =
      //       Suggestions.fromJson(jsonDecode(response.body));
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString("user_suggestions", response.body);
      //   return suggestionsData;
      // } else {
      //   if (suggestions != null) {
      //     Suggestions suggestionsData =
      //         Suggestions.fromJson(jsonDecode(suggestions));
      //     return suggestionsData;
      //   } else {
      //     return Suggestions([]);
      //   }
      // }
    } on SocketException {
      if (suggestions != null) {
        Suggestions suggestionsData =
            Suggestions.fromJson(jsonDecode(suggestions));
        return suggestionsData;
      } else {
        return Suggestions([]);
      }
    }
  }

  static Future<Suggestions> getSuggestionsLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? suggestions = prefs.getString("user_suggestions");

    if (suggestions != null) {
      try {
        Suggestions suggestionsData =
            Suggestions.fromJson(jsonDecode(jsonEncode(suggestions)));
        return suggestionsData;
      } catch (e) {
        return Suggestions([]);
      }
    } else {
      return Suggestions([]);
    }
  }

  static Future<ShortbuzSuggestions> getShortbuzSuggestions(
      BuildContext context) async {
    String? token = await ApiProvider().getTheToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? video = prefs.getString("shortbuz_suggestions");
    try {
      var url = Uri.parse(
          'https://www.bebuzee.com/api/shortbuz/shortbuzSuggested?action=shortbuz_suggestion_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&page=1');
      var client = Dio();
      print("the shortbuz suggested url=${url}");
      print("api call success ,");
      return await client
          .postUri(url,
        options: Options(headers: {
          // 'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        if (value.statusCode == 200) {
          print("shortbuz suggestion list = ${value.data}");
          ShortbuzSuggestions videoData =
              ShortbuzSuggestions.fromJson(value.data['data']);
          await Future.wait(videoData.videos
              .map((e) => PreloadCached.cacheImage(context, e.postImgData!))
              .toList());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(
              "shortbuz_suggestions", jsonEncode(value.data['data']));
          print('shortbuz suggestion done');
          return videoData;
        } else {
          if (video != null) {
            ShortbuzSuggestions videoData =
                ShortbuzSuggestions.fromJson(jsonDecode(video));
            return videoData;
          } else {
            return ShortbuzSuggestions([]);
          }
        }
      });
    } catch (e) {
      return ShortbuzSuggestions([]);
    } // try {
    //   var url = Uri.parse(
    //       "https://www.bebuzee.com/new_files/all_apis/shortbuz_api_call.php?action=shortbuz_suggestion_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    //   var response = await http.get(url);

    //   if (response.statusCode == 200) {
    //     ShortbuzSuggestions videoData =
    //         ShortbuzSuggestions.fromJson(jsonDecode(response.body));
    //     await Future.wait(videoData.videos
    //         .map((e) => PreloadCached.cacheImage(context, e.postImgData))
    //         .toList());
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.setString("shortbuz_suggestions", response.body);
    //     return videoData;
    //   } else {
    //     if (video != null) {
    //       ShortbuzSuggestions videoData =
    //           ShortbuzSuggestions.fromJson(jsonDecode(video));
    //       return videoData;
    //     } else {
    //       return ShortbuzSuggestions([]);
    //     }
    //   }
    // }
    on SocketException {
      if (video != null) {
        ShortbuzSuggestions videoData =
            ShortbuzSuggestions.fromJson(jsonDecode(video));
        return videoData;
      } else {
        return ShortbuzSuggestions([]);
      }
    }
  }

  static Future<ShortbuzSuggestions> getShortbuzSuggestionsLocal(
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? video = prefs.getString("shortbuz_suggestions");
    try {
      if (video != null) {
        ShortbuzSuggestions videoData =
            ShortbuzSuggestions.fromJson(jsonDecode(video));
        return videoData;
      } else {
        return ShortbuzSuggestions([]);
      }
    } catch (e) {
      return ShortbuzSuggestions([]);
    }
  }
}
