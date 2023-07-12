import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/streaming_home_api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StreamingSearchController extends GetxController {
  var topSearchedVideos = <CategoryDataModel>[].obs;
  var searchedVideos = <CategoryDataModel>[].obs;
  TextEditingController searchController = TextEditingController();
  var searchValue = "".obs;
  var isSearching = true.obs;

  @override
  void onInit() {
    debounce(searchValue, (callback) {
      if (searchValue.isNotEmpty) {
        getSearchedVideos(searchValue.value);
      } else {
        searchedVideos.clear();
         isSearching.value = true;
      }
    }, time: Duration(milliseconds: 300));
    getTopSearchedVideos();
    super.onInit();
  }

  void getTopSearchedVideos() async {
    var videos = await StreamHomeApi.fetchTopSearchedVideos();
    topSearchedVideos.assignAll(videos);
  }

  void getSearchedVideos(String keyword) async {
    isSearching.value = true;
    var videos = await StreamHomeApi.fetchSearchedVideos(keyword);
    searchedVideos.assignAll(videos);
    isSearching.value = false;
  }
}
