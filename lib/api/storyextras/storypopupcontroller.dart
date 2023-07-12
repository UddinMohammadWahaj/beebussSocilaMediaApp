import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/models/stickers_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../services/Story/post_story_api_calls.dart';

class StoryPopUpController extends GetxController {
  var gifListStickers = <StickersModel>[].obs;
  var emojiListStickers = <StickersModel>[].obs;
  var stickerListStickers=<StickersModel>[].obs;
  var searchText = ''.obs;
  var tappedSearch = false.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RefreshController refreshController2 =
      RefreshController(initialRefresh: false);
  RefreshController refreshController3 =
      RefreshController(initialRefresh: false);
  var currentPage = 1.obs;
  var emojicurrentPage = 1.obs;
var stickercurrentPage = 1.obs;
  var filteredgifListStickers = <StickersModel>[].obs;
  var gifloading = false.obs;
  void getFilteredGiphyGif(searchKey) async {
    gifloading.value = true;
    await PostStoryApi.getGiphyGifs(gif_search: searchKey).then((value) {
      filteredgifListStickers.value = value.stickers;
    });
    gifloading.value = false;
  }

  void getGiphyGif() async {
    await PostStoryApi.getGiphyGifs().then((value) {
      gifListStickers.value = value.stickers;
    });
  }

  void getGiphyemoji() async {
    await PostStoryApi.getGiphyGifs(gif_search: 'emoji').then((value) {
      emojiListStickers.value = value.stickers;
    });
  }
  void getGiphysticker() async {
    await PostStoryApi.getGiphyGifs(gif_search: 'sticker').then((value) {
      stickerListStickers.value = value.stickers;
    });
  }

  void nextGiphyGif({page: '1', search: ''}) async {
    await PostStoryApi.getGiphyGifs(pagination: page, gif_search: search)
        .then((value) {
      gifListStickers.addAll(value.stickers);
      print("next gifhy success ${gifListStickers.length}");
      gifListStickers.refresh();
    });
  }

  void nextGiphyemoji({page: '1', search: ''}) async {
    await PostStoryApi.getGiphyGifs(pagination: page, gif_search: search)
        .then((value) {
      emojiListStickers.addAll(value.stickers);
      // print("next gifhy success ${gifListStickers.length}");
      emojiListStickers.refresh();
    });
  }
   void nextGiphysticker({page: '1', search: ''}) async {
    await PostStoryApi.getGiphyGifs(pagination: page, gif_search: search)
        .then((value) {
      stickerListStickers.addAll(value.stickers);
      // print("next gifhy success ${gifListStickers.length}");
      stickerListStickers.refresh();
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getGiphyGif();
    getGiphyemoji();
    getGiphysticker();
    debounce(searchText, (_) => getFilteredGiphyGif(searchText),
        time: Duration(milliseconds: 300));
    super.onInit();
  }
}
