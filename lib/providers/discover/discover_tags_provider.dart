import 'package:bizbultest/models/discover_hashtags.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/Discover/discover_api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscoverTagsProvider with ChangeNotifier {
  List<NewsFeedModel> postsList = <NewsFeedModel>[];
  List<DiscoverHashtagsModel> tagsList = <DiscoverHashtagsModel>[];
  String allPosts = "";
  String selectedTag = "";
  var currentPage = 1;
  RefreshController controller = new RefreshController(initialRefresh: false);

  Future<List<NewsFeedModel>> getPosts(BuildContext context, String tag) async {
    currentPage = 1;
    List<NewsFeedModel> posts =
        await DiscoverApiCalls.getPostsFromTag(tag, context);
    if (posts != null) {
      print("hashnotnull");
      this.postsList = posts;
      // this.allPosts = posts.map((value) => value.postId).toList().join(",");
      controller.loadComplete();
      print("hashnotnull check");
      notifyListeners();

      return postsList;
    } else {
      print("hashnotnull false");
      controller.loadComplete();
      notifyListeners();
      return <NewsFeedModel>[];
    }
  }

  Future<List<DiscoverHashtagsModel>> getHashtags(String tag) async {
    print("get hashtags");
    List<DiscoverHashtagsModel> tags = await DiscoverApiCalls.getHashtags(tag);
    if (tags != null) {
      this.tagsList = tags;
      notifyListeners();
      return tagsList;
    } else {
      notifyListeners();
      return <DiscoverHashtagsModel>[];
    }
  }

  void onRefresh(String tag, BuildContext context) async {
    print("onrefresh called tags");
    this.currentPage = 1;
    this.getPosts(context, tag).then((posts) {
      this.allPosts = posts.map((value) => value.postId).toList().join(",");
      controller.refreshCompleted();
      print("refresh comeplete");
      notifyListeners();
    });
  }

  void onLoading(String tag, BuildContext context) async {
    print("on load called tags");
    var page = this.postsList[this.postsList.length - 1].page;
    print("page=${page} currentPage=${currentPage}");
    if (page != currentPage)
      return;
    else
      currentPage = page! + 1;
    List<NewsFeedModel>? postData = await DiscoverApiCalls.onLoadingPosts(
        this.postsList, tag, context, controller,
        page: currentPage);
    print("onLoading hash tag called main");
    if (postData!.length == 0) {
      print("hashtag length=0 ");
      currentPage = page!;
    }
    if (postData != null) {
      this.postsList.addAll(postData);
      allPosts = postData.map((value) => value.postId).toList().join(",");
      controller.loadComplete();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print("disposed controller");
    controller.dispose();
    super.dispose();
  }
}
