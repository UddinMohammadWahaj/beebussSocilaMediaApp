import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_section/top_slider_video_section_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/models/video_slider_model.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../current_user.dart';

class MainVideoApiCalls {
  //! api updated
  static Future<VideoSectionTopSliderModel> getTopSlider(
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? videos = prefs.getString("slider_videos");
    try {
      var url =
          "https://www.bebuzee.com/api/video/videoCategory?action=video_page_data_top_slider&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}";
      print('top slider url=${url}');
      var client = new dio.Dio();
      String? token = await ApiProvider().getTheToken();
      var head = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await client.post(
        url,
        options: dio.Options(headers: head),
      );
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "") {
        print('top slider ${response.data}');
        VideoSectionTopSliderModel sliderVideos =
            VideoSectionTopSliderModel.fromJson(response.data);

        await Future.wait(sliderVideos.category!
            .map((e) => PreloadCached.cacheImage(context, e.cateImage!))
            .toList());

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("slider_videos", json.encode(response.data));
        print("get top slider called = $url ${response.data}");
        return sliderVideos;
      } else {
        if (videos != null) {
          VideoSectionTopSliderModel sliderVideos =
              VideoSectionTopSliderModel.fromJson(jsonDecode(videos));
          await Future.wait(sliderVideos.category!
              .map((e) => PreloadCached.cacheImage(context, e.cateImage!))
              .toList());
          print("get top slider called not null=${response.data}");
          return sliderVideos;
        } else {
          return VideoSectionTopSliderModel(category: []);
        }
      }
    } on SocketException {
      if (videos != null) {
        VideoSectionTopSliderModel sliderVideos =
            VideoSectionTopSliderModel.fromJson(jsonDecode(videos));
        await Future.wait(sliderVideos.category!
            .map((e) => PreloadCached.cacheImage(context, e.cateImage!))
            .toList());

        return sliderVideos;
      } else {
        return VideoSectionTopSliderModel(category: []);
      }
    }
  }

  //! api updated
  static Future<VideoListModel> getSingleCategoryVideos(
      String category, BuildContext context) async {
    try {
      // var url =  "https://www.bebuzee.com/api/video/videoData?action=video_page_data_slide_more_videos&user_id=${CurrentUser().currentUser.memberID}&categories=$category&country=Srilanka";
      category = category.replaceFirst('&', '@');

      var url =
          "https://www.bebuzee.com/api/video/videoData?action=video_page_data_slide_more_videos&user_id=${CurrentUser().currentUser.memberID}&categories=$category&country=${CurrentUser().currentUser.country}&page=1";

      print("single url=${url}");
      var client = new dio.Dio();
      String? token = await ApiProvider().getTheToken();
      var head = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      var response = await client.post(
        url,
        options: dio.Options(headers: head),
      );

      if (response.statusCode == 200) {
        print('single url=${response.data}');
        VideoListModel videoData = VideoListModel.fromJson(response.data);
        await Future.wait(videoData.data!
            .map((e) => PreloadCached.cacheImage(context, e.image!))
            .toList());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("single_category_videos", json.encode(response.data));
        return videoData;
      } else {
        return VideoListModel(data: []);
      }
    } on SocketException {
      return VideoListModel(data: []);
    }
  }

  //! api updated
  static Future<VideoListModel> getVideosCategories(
      BuildContext context) async {
    print(CurrentUser().currentUser.memberID! + " before");
    print(CurrentUser().currentUser.country! + " before");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? videos = prefs.getString("main_videos");

    try {
      var url =
          "https://www.bebuzee.com/api/video/videoList?action=video_page_data&user_id=${CurrentUser().currentUser.memberID}&categories=&country=${CurrentUser().currentUser.country}&page=1";

      print("magia mainurl=$url");
      var client = new dio.Dio();
      String? token = await ApiProvider().getTheToken();

      var head = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await client.post(
        url,
        options: dio.Options(headers: head),
      );
      print("response big video=${response.data}");
      try {
        if (response.statusCode == 200) {
          VideoListModel videoData = VideoListModel.fromJson(response.data);
          print("response big video 2=${response.data}");
          await Future.wait(videoData.data!
              .map((e) => PreloadCached.cacheImage(context, e.image!))
              .toList());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("main_videos", json.encode(response.data));

          return videoData;
        } else {
          if (videos != null) {
            VideoListModel videoData =
                VideoListModel.fromJson(jsonDecode(videos));
            await Future.wait(videoData.data!
                .map((e) => PreloadCached.cacheImage(context, e.image!))
                .toList());

            return videoData;
          } else {
            return VideoListModel(data: []);
          }
        }
      } catch (e) {
        print("response big video $e");
        return VideoListModel(data: []);
      }
    } on SocketException {
      if (videos != null) {
        VideoListModel videoData = VideoListModel.fromJson(jsonDecode(videos));
        await Future.wait(videoData.data!
            .map((e) => PreloadCached.cacheImage(context, e.image!))
            .toList());
        return videoData;
      } else {
        return VideoListModel(data: []);
      }
    }
  }
}
