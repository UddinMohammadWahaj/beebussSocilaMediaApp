import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/models/Streaming/episodes_model.dart';
import 'package:bizbultest/models/Streaming/genres_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/api/api.dart';

class StreamHomeApi {
  // static final String _baseUrl = "https://www.bebuzee.com/app_develop_stream.php";
  static final String _baseUrl =
      "https://www.bebuzee.com/api/streaming/featuredTailor";
  static final String _memberID = CurrentUser().currentUser.memberID!;

  static Future<StreamCategoryVideos> getCoverPage(String filter) async {
    try {
      var url =
          "$_baseUrl?action=get_featured_trailor_data&user_id=$_memberID&filter=$filter&country=${CurrentUser().currentUser.memberID}";
      print("stream url=$url");
      var response = await ApiProvider().fireApi(url);
      print("stream response= ${response.data}");
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "") {
        StreamCategoryVideos coverData =
            StreamCategoryVideos.fromJson(response.data['data']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("stream_cover", jsonEncode(response.data['data']));
        return coverData;
      } else {
        return StreamCategoryVideos([]);
      }
    } on SocketException {
      print("no internet");
      return StreamCategoryVideos([]);
    }
  }

  static Future<StreamCategoryVideos> getCategoricalVideos(
      String filter, String categoryID) async {
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/api/strem_top_menu_list.php?action=top_menu_list&user_id=$_memberID&filter=$filter&category_id=$categoryID&country=${CurrentUser().currentUser.memberID}");
      print('stream categorical=$url');
      var response = await ApiProvider().fireApi(url.toString());
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "" &&
          response.data != "null") {
        StreamCategoryVideos category =
            StreamCategoryVideos.fromJson(response.data['data']);
        return category;
      } else {
        return StreamCategoryVideos([]);
      }
    } on SocketException {
      print("no internet");
      return StreamCategoryVideos([]);
    }
  }

  static Future<StreamCategoryVideos> getMoreLikeThisVideos(
      String videoID) async {
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/api/streaming/similerVideo?action=get_similar_videos&video_id=$videoID&user_id=$_memberID&country=${CurrentUser().currentUser.memberID}");
      print("stream get more like this-${url}");
      var response = await ApiProvider().fireApi(url.toString());

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "" &&
          response.data != "null") {
        print(videoID);
        StreamCategoryVideos category =
            StreamCategoryVideos.fromJson(response.data['data']);
        return category;
      } else {
        return StreamCategoryVideos([]);
      }
    } on SocketException {
      print("no internet");
      return StreamCategoryVideos([]);
    }
  }

  static Future<StreamCategoryVideos> getMyListVideos() async {
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/api/streaming/myList?action=get_my_list&user_id=$_memberID&country=${CurrentUser().currentUser.country}");
      print("stream my list url=${url}");
      var response = await ApiProvider().fireApi(url.toString());
      print("--- Strem my list -- ${response.data['data']}");
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "" &&
          response.data != "null") {
        StreamCategoryVideos category =
            StreamCategoryVideos.fromJson(response.data['data']);
        return category;
      } else {
        return StreamCategoryVideos([]);
      }
    } on SocketException {
      print("no internet");
      return StreamCategoryVideos([]);
    } catch (e) {
      return StreamCategoryVideos([]);
    }
  }

  static Future<String?> addToMyList(String videoID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/myListAddRemove?action=add_my_list&video_id=$videoID&user_id=$_memberID&country=${CurrentUser().currentUser.country}");
    print("stream add my list =${url}");

    var response = await ApiProvider().fireApi(url.toString());
    print("stream add my list response =${response.data}");
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      return "Success";
    } else {
      return null;
    }
  }

  static Future<String?> removeFromMyList(String videoID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/streaming/myListAddRemove?action=remove_my_list&video_id=$videoID&user_id=$_memberID&country=${CurrentUser().currentUser.memberID}");
    print("stream remove video url=$url");
    var response = await ApiProvider().fireApi(url.toString());
    print("stream remove video url=${response.data}");
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      return "Success";
    } else {
      return null;
    }
  }

  static Future<String?> likeVideo(String videoID) async {
    print("stream like");
    var url = Uri.parse(
        "https://www.bebuzee.com/api/strem_like_video.php?action=like_video&video_id=$videoID&user_id=$_memberID&country=${CurrentUser().currentUser.memberID}");
    print("stream url like vide=$url");
    var response = await ApiProvider().fireApi(url.toString());
    print("stream response like video=${response.data}");
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      return "Success";
    } else {
      return null;
    }
  }

  static Future<String?> dislikeVideo(String videoID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/strem_dislike_video.php?action=dislike_video&video_id=$videoID&user_id=$_memberID&country=${CurrentUser().currentUser.memberID}");
    print("stream dislike video $url");
    var response = await ApiProvider().fireApi(url.toString());

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      return "Success";
    } else {
      return null;
    }
  }

  static Future<String?> removeLikeDislike(String videoID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/streaming/dislikeUnlike?action=remove_like_dislike&video_id=$videoID&user_id=$_memberID&country=${CurrentUser().currentUser.memberID}");

    var response = await ApiProvider().fireApi(url.toString());

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      return "Success";
    } else {
      return null;
    }
  }

  static Future<List<GenresModel>> getGenres() async {
    var url = Uri.parse("https://www.bebuzee.com/api/streaming_genres.php/");
    print("stream generes url=$url");
    var client = Dio();
    var response = await client.getUri(url);
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "" &&
        response.data != "null") {
      print("got genres");
      Genres genres = Genres.fromJson(response.data['data']);
      print(genres.genres[0].categoryName);
      print("cat name");
      return genres.genres;
    } else {
      return <GenresModel>[];
    }
  }

  static Future<List<CategoryDataModel>> fetchTopSearchedVideos() async {
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/webservices/streaming_auto_search.php?user_id=$_memberID&country=${CurrentUser().currentUser.country}");
      var response = await http.get(url);
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body != "" &&
          response.body != "null") {
        CategoryData categoryDatum =
            CategoryData.fromJson(jsonDecode(response.body));
        print(categoryDatum.videos[0].title);
        print(" is title");
        return categoryDatum.videos;
      } else {
        return <CategoryDataModel>[];
      }
    } on SocketException {
      print("no internet");
      return <CategoryDataModel>[];
    }
  }

  static Future<List<CategoryDataModel>> fetchSearchedVideos(
      String keyword) async {
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/api/streaming_video_list.php?user_id=$_memberID&country=${CurrentUser().currentUser.country}&page=1&keyword=$keyword");
      var response = await ApiProvider().fireApi(url.toString());
      print("search videos url=$url");
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "" &&
          response.data != "null") {
        print("search videos response= ${response.data}");
        CategoryData categoryDatum =
            CategoryData.fromJson(response.data['data']);

        print(" is title");
        return categoryDatum.videos;
      } else {
        return <CategoryDataModel>[];
      }
    } on SocketException {
      print("no internet");
      return <CategoryDataModel>[];
    }
  }

  static Future<List<EpisodesModel>> fetchEpisodes(
      String videoID, String season) async {
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/api/streaming_series_list.php?user_id=$_memberID&video_id=$videoID&season=$season");
      print('fetchEpisodes ${url}');
      var response = await ApiProvider().fireApi(url.toString());
      print('fetchEpisodes ${url}');
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "" &&
          response.data != "null") {
        Episodes episodes = Episodes.fromJson(response.data['data']);
        print(" is title");
        print('fetchEpisodes ${url}');
        return episodes.episodes;
      } else {
        return <EpisodesModel>[];
      }
    } on SocketException {
      print("no internet");
      return <EpisodesModel>[];
    }
  }
}
