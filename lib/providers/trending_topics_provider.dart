import 'dart:io';

import 'package:bizbultest/models/hashtags.dart';
import 'package:bizbultest/services/FeedAllApi/main_feeds_page_api_calls.dart';
import 'package:flutter/cupertino.dart';

class TrendingTopicsProvider with ChangeNotifier {
  late Future trendingTopicsFuture;
  List<TrendingTopicsModel> topics = <TrendingTopicsModel>[];

  TrendingTopicsProvider() {
    trendingTopicsFuture = this.getLocalTopics();
  }

  Future<List<TrendingTopicsModel>> getLocalTopics() async {
    print("trending local topics called");
    List<TrendingTopicsModel> topics =
        await MainFeedsPageApi.getHashtagsLocal("");
    if (topics != null) {
      this.topics = topics;
      notifyListeners();
      this.getTopics();
      return this.topics;
    } else {
      notifyListeners();
      this.getTopics();
      return <TrendingTopicsModel>[];
    }
  }

  Future<List<TrendingTopicsModel>> getTopics() async {
    try {
      List<TrendingTopicsModel> topics = await MainFeedsPageApi.getHashtags("");
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
