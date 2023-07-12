import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/stickers_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../current_user.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class PostStoryApi {
  static Future<Stickers> getGiphyGifs(
      {gif_search: '', pagination: '1'}) async {
    print("got tgif getgiphy called");
    var response = await ApiProvider().fireApiWithParamsGet(
        'https://properbuzcoin.com/api/giphyStickerData',
        params: {
          "gif_search": gif_search,
          "pagination": pagination
        }).then((value) => value);
    print("got tgif getgiphy called ${response.data}");
    if (response.data["data"].length > 0) {
      print("got gif success");
      Stickers stickerData = Stickers.fromJson(response.data["data"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        prefs.setString("stickers_data", jsonEncode(response.data["data"]));
      } catch (e) {
        print("got tgif getgiphy called error $e");
      }
      print("got gif=$stickerData");
      return stickerData;
    } else {
      print("got gif fail");
      return Stickers([]);
    }
  }

  static Future<Stickers> getGiphyEmojis(
      {gif_search: '', pagination: '1'}) async {
    print("got tgif getgiphy called");
    var response = await ApiProvider().fireApiWithParamsGet(
        'https://properbuzcoin.com/api/giphyGifData',
        params: {
          "gif_search": gif_search,
          "pagination": pagination
        }).then((value) => value);
    print("got tgif getgiphy called ${response.data}");
    if (response.data["data"].length > 0) {
      print("got gif success");
      Stickers stickerData = Stickers.fromJson(response.data["data"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        prefs.setString("stickers_data", jsonEncode(response.data["data"]));
      } catch (e) {
        print("got tgif getgiphy called error $e");
      }
      print("got gif=$stickerData");
      return stickerData;
    } else {
      print("got gif fail");
      return Stickers([]);
    }
  }

  static Future<Stickers> getGiphyStickers(
      {gif_search: '', pagination: '1'}) async {
    print("got tgif getgiphy called");
    var response = await ApiProvider().fireApiWithParamsGet(
        'https://properbuzcoin.com/api/giphyStickerData',
        params: {
          "gif_search": gif_search,
          "pagination": pagination
        }).then((value) => value);
    print("got tgif getgiphy called ${response.data}");
    if (response.data["data"].length > 0) {
      print("got gif success");
      Stickers stickerData = Stickers.fromJson(response.data["data"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        prefs.setString("stickers_data", jsonEncode(response.data["data"]));
      } catch (e) {
        print("got tgif getgiphy called error $e");
      }
      print("got gif=$stickerData");
      return stickerData;
    } else {
      print("got gif fail");
      return Stickers([]);
    }
  }

  static Future<Stickers> getStickers() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_story_data.php?user_id=${CurrentUser().currentUser.memberID}&action=story_swipe_image&keyword=");
    // var response = await http.get(url);

    var response = await ApiRepo.post('api/story_swipe_image.php',
        {"user_id": CurrentUser().currentUser.memberID, "keyword": ""});

    if (response.success == 1) {
      Stickers stickerData = Stickers.fromJson(response.data["data"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("stickers_data", jsonEncode(response.data["data"]));
      return stickerData;
    } else {
      return Stickers([]);
    }
  }

  static Future<Stickers> getEmojis() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_story_data.php?action=story_stickers_image&user_id=${CurrentUser().currentUser.memberID}");
    // var response = await http.get(url);

    var response = await ApiRepo.post('api/story_stickers_image.php',
        {"user_id": CurrentUser().currentUser.memberID, "keyword": ""});

    if (response.success == 1) {
      Stickers stickerData = Stickers.fromJson(response.data["data"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("emoji_data", jsonEncode(response.data["data"]));
      return stickerData;
    } else {
      return Stickers([]);
    }

    // if (response.statusCode == 200) {
    //   Stickers stickerData = Stickers.fromJson(jsonDecode(response.body));
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("emoji_data", response.body);
    //   return stickerData;
    // } else {
    //   return Stickers([]);
    // }
  }

  static Future<Stickers> getGIFs() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_story_data.php?user_id=${CurrentUser().currentUser.memberID}&action=story_gif_data&keyword=");
    // var response = await http.get(url);

    var response = await ApiRepo.post('api/story_gif_data.php',
        {"user_id": CurrentUser().currentUser.memberID, "keyword": ""});

    if (response.success == 1) {
      Stickers stickerData = Stickers.fromJson(response.data["data"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("gif_data", jsonEncode(response.data["data"]));
      return stickerData;
    } else {
      return Stickers([]);
    }

    // if (response.statusCode == 200) {
    //   Stickers stickerData = Stickers.fromJson(jsonDecode(response.body));
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("gif_data", response.body);
    //   return stickerData;
    // } else {
    //   return Stickers([]);
    // }
  }

  static Future<Stickers> getLocalStickers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stickers = prefs.getString("stickers_data");
    if (stickers != null) {
      Stickers stickerData = Stickers.fromJson(jsonDecode(stickers));
      return stickerData;
    } else {
      return Stickers([]);
    }
  }

  static Future<Stickers> getLocalEmojis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stickers = prefs.getString("emoji_data");
    if (stickers != null) {
      Stickers stickerData = Stickers.fromJson(jsonDecode(stickers));
      return stickerData;
    } else {
      return Stickers([]);
    }
  }

  static Future<Stickers> getLocalGIFs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stickers = prefs.getString("gif_data");
    if (stickers != null) {
      Stickers stickerData = Stickers.fromJson(jsonDecode(stickers));
      return stickerData;
    } else {
      return Stickers([]);
    }
  }
}
