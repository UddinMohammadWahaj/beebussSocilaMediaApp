import 'dart:io';

import 'package:bizbultest/models/hashtags.dart';
import 'package:bizbultest/services/FeedAllApi/main_feeds_page_api_calls.dart';
import 'package:flutter/cupertino.dart';

class TrendingTopicsProvider with ChangeNotifier {
  late Future trendingTopicsFuture;
  List<TrendingTopicsModel> topics = <TrendingTopicsModel>[];
  String selectedTag = "";

  TrendingTopicsProvider() {
    print("trending constructor called");
    trendingTopicsFuture = this.getLocalTopics();
  }

  void test(int index) {
    this.topics[index].hashtag = "aaaa";
    notifyListeners();
  }

  Future<List<TrendingTopicsModel>> getLocalTopics() async {
    print("trending topic func called");
    List<TrendingTopicsModel> topics =
        await MainFeedsPageApi.getHashtagsLocal("");
    if (topics != null) {
      print('trending topics list=${topics}');
      this.topics = topics;
      notifyListeners();
      this.getTopics();
      return this.topics;
    } else {
      notifyListeners();
      print('trending topics list other=');
      this.getTopics();
      return <TrendingTopicsModel>[];
    }
  }

  Future<List<TrendingTopicsModel>> getTopics() async {
    try {
      List<TrendingTopicsModel> topics = await MainFeedsPageApi.getHashtags("");
      print("trending topic func called");
      if (topics != null) {
        this.topics = topics;
        notifyListeners();
        return topics;
      } else {
        notifyListeners();
        return <TrendingTopicsModel>[];
      }
    } on SocketException {
      return getLocalTopics();
    }
  }
}
