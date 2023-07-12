import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/FeedAllApi/main_feeds_page_api_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/video_ads_model.dart';
import '../../services/current_user.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class PopularVideosProvider with ChangeNotifier {
  RefreshController videoRefreshController =
      RefreshController(initialRefresh: false);
  List<VideoModel?> videoList = <VideoModel?>[];
  List<bool> loadinglist = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  showLoad(index) {
    loadinglist[index] = true;
    notifyListeners();
  }

  stopLoad(index) {
    loadinglist[index] = false;
    notifyListeners();
  }

  Future<List<VideoModel?>> getVideoSuggestionsLocal(
      BuildContext context) async {
    print("get video suggestion called");
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
    List<VideoModel> videos =
        await MainFeedsPageApi.getVideoSuggestions(context);
    if (videos != null) {
      this.videoList = videos;
      notifyListeners();
      return videoList!;
    } else {
      notifyListeners();
      return <VideoModel>[];
    }
  }

  void onLoadingAds() {
    print("ad analysed successfully");
    print("data publishe success!! ----- ");
    var x = 2;
    for (int i = 0; i < x; i++) {
      print("x=$i");
      print("x=$i X=${2}");
      // if (x - 2) {
      //   print("x=x-2");
      // }
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

  Future<VideoAds?> getAds() async {
    print("magia get Ads called");
    var url = Uri.parse(
        "https://www.bebuzee.com/api/video_advertisment_list.php?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&all_ids=");
    print("response of get ads url=${url}");
    var response =
        await ApiRepo.postWithToken('api/video_advertisment_list.php', {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "all_ids": ""
    });
    print("response of get ads =${response!.data}");
    print(response!.data);
    if (response.data == null) return null;
    if (response.data['success'] == 1 && response.data['data'].length != 0) {
      VideoAds videoData = VideoAds.fromJson(response.data['data']);
      print("get ads success ${videoData}");
      return videoData;
    }

    return null;
  }

  Future<VideoModel?>? getVideoDetails(
      String postif, BuildContext context) async {
    print("called video details");
    List<VideoModel?>? videos =
        await MainFeedsPageApi.getVideoDetails(context, postif);
    print("succes video details ${videos![0]!.userImage}");
    return videos[0];
  }

  void onRefreshVideos(BuildContext context) {
    this.getVideoSuggestions(context).then((videos) {
      videoRefreshController.refreshCompleted();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    videoRefreshController.dispose();
    super.dispose();
  }
}
