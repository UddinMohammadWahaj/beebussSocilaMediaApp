import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/FeedAllApi/main_feeds_page_api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PopularVideosProvider with ChangeNotifier {
  RefreshController videoRefreshController =
      RefreshController(initialRefresh: false);
  List<VideoModel?> videoList = <VideoModel>[];
  Future<List<VideoModel?>> getVideoSuggestionsLocal(
      BuildContext context) async {
    List<VideoModel> videos =
        await MainFeedsPageApi.getVideoSuggestionsLocal(context);

    if (videos != null) {
      this.videoList = videos;
      notifyListeners();
      this.getVideoSuggestions(context);
      return videoList!;
    } else {
      notifyListeners();
      this.getVideoSuggestions(context);
      return <VideoModel>[];
    }
  }

  Future<List<VideoModel?>> getVideoSuggestions(BuildContext context) async {
    List<VideoModel?> videos =
        await MainFeedsPageApi.getVideoSuggestions(context);
    if (videos != null) {
      this.videoList = videos;
      notifyListeners();
      return videoList;
    } else {
      notifyListeners();
      return <VideoModel>[];
    }
  }

  void onLoadingVideos(BuildContext context) async {
    List<VideoModel?>? videos = await MainFeedsPageApi.onLoadingVideo(
        videoList, context, videoRefreshController);
    if (videos != null) {
      this.videoList.addAll(videos!);
      notifyListeners();
    }
  }

  void onRefreshVideos(BuildContext context) {
    this.getVideoSuggestions(context).then((videos) {
      videoRefreshController.refreshCompleted();
      notifyListeners();
    });
  }
}
