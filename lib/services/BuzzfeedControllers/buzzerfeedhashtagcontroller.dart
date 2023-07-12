import 'package:bizbultest/models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/utilities/FlickPlayer/flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';
import '../../../api/ApiRepo.dart' as ApiRepo;
import '../current_user.dart';

class BuzzerfeedHashtagController extends GetxController {
  String? fromhashtag = '';

  BuzzerfeedHashtagController({this.fromhashtag});

  var listbuzzerfeeddata = <BuzzerfeedDatum>[].obs;
  var isUpload = false.obs;
  var tag = ''.obs;
  var hashtagIndex = 0.obs;
  var hashtagSelected = false.obs;
  var currentbuzzerfeedpag = 1.obs;
  var tags = [].obs;
  late FlickManager flickManager;
  var headerTag = ''.obs;
  var searchbarText = ''.obs;

  var country = '${CurrentUser().currentUser.country}'.obs;
  var urllist = [
    'https://www.bebuzee.com/new_files/buzzerfeed/videos/20220426025411xat1VvBvT8.mp4',
    'https://www.bebuzee.com/new_files/buzzerfeed/videos/202204260254038ddrj4nKrI.mp4'
  ];
  var listofflickrmanager = <FlickManager>[
    FlickManager(
      videoPlayerController: VideoPlayerController.network(
        " ",
      ),
    )
  ];
  void loadData({page: 1, tag: ''}) async {
    print("onloadtag=${tag.value}");
    var data = await BuzzerFeedAPI.getData(
        page: page, tag: tag.value == '' ? headerTag.value : tag.value);
    listbuzzerfeeddata.addAll(data);
    listbuzzerfeeddata.refresh();
  }

  var hasstarttag = false;
  void resetTag() {
    tag.value = '';
    hasstarttag = false;
  }

  void getTrendingCountry() async {
    var data = await BuzzerFeedAPI.getTrendingCountry();
    countries.value = data;
  }

  bool checkTag() {
    if (tag.value[0] == '@')
      return true;
    else
      return false;
  }

  void pollvote(answerID, index) async {
    var result = await BuzzerFeedAPI.pollVote(answerID);
    if (result['message'] == 'You have already answer.') {
      Get.snackbar('Failed', 'You have already voted!!');
      return;
    } else {
      Get.snackbar('Success', 'Voted successfully!!',
          icon: Icon(
            Icons.check,
            color: Colors.green,
          ),
          backgroundColor: Colors.white);
      listbuzzerfeeddata[index].isvoting!.value = true;
      listbuzzerfeeddata[index].testpoll!.value = List<PollDatum>.from(
          result['data'].map((x) => PollDatum.fromJson(x)));
      listbuzzerfeeddata[index].testpoll!.refresh();
      print("poll ans =${result['data']}");
    }
  }

  void removePost(postId, index) async {
    Get.snackbar('Success', 'Buzz removed successfully!!',
        backgroundColor: HexColor('#FFFFFF'));
    listbuzzerfeeddata.removeAt(index);
    listbuzzerfeeddata.refresh();
    await BuzzerFeedAPI.deletePost(postId);
  }

  void rebuzzPost(postId) async {
    await BuzzerFeedAPI.rebuzz(postId);
  }

  var countries = [].obs;

  void fetchData({page: 1, tag: ''}) async {
    var data = await BuzzerFeedAPI.getData(page: page, tag: tag);
    listbuzzerfeeddata.value = data;
    listbuzzerfeeddata.refresh();
    // print("getData() response=${data[0].pollAnswer}");
  }

  var todaytrendinglist = [].obs;
  void fetchTrendingToday() async {
    var data = await BuzzerFeedAPI.getTrendingList(country: country);
    print("data trend=$data");
    todaytrendinglist.value = data;
  }

  void quoteRetweet(topostdata) async {
    await BuzzerFeedAPI.postRequote(topostdata);
  }

  void getTags() async {
    var tagsData = await BuzzerFeedAPI.getTagsList(country: country.value);
    tags.assignAll(tagsData);
    tags.refresh();
  }

  void likeUnlike(index) async {
    var data =
        await BuzzerFeedAPI.likeUnlike(listbuzzerfeeddata[index].buzzerfeedId);
    if (data != null) {
      print("likeunlike api ${data}");
      listbuzzerfeeddata[index].likeStatus!.value = data['like_status'];
      listbuzzerfeeddata[index].totalLikes!.value =
          data['total_likes'].toString();
      listbuzzerfeeddata.refresh();
    }
  }

  void fetchFirstPost(postid, {index: 0, type = "upload"}) async {
    isUpload.value = true;
    var data = await BuzzerFeedAPI.getRecentData(postid);
    print("firstpostcame =${data}");
    if (type == "upload")
      listbuzzerfeeddata.insert(0, data[0]);
    else {
      print("edit buzz");
      listbuzzerfeeddata[index] = data[0];
    }
    isUpload.value = false;
    listbuzzerfeeddata.refresh();

    // print("rescent ${listbuzzerfeeddata.length}");
    // print("rescent ${listbuzzerfeeddata[0].images[0]}");
  }

  @override
  void onInit() async {
    // await Wakelock.enable();
    listbuzzerfeeddata.value =
        await BuzzerFeedAPI.getData(tag: this.fromhashtag) ??
            <BuzzerfeedDatum>[];
    // await getTags();
    // await fetchTrendingToday();
    super.onInit();
  }
}






//   var listbuzzerfeeddata = <BuzzerfeedDatum>[].obs;
//   var isUpload = false.obs;
//   var tag = ''.obs;
//   var hashtagIndex = 0.obs;
//   var hashtagSelected = false.obs;
//   var currentbuzzerfeedpag = 1.obs;
//   var tags = [].obs;
//   FlickManager flickManager;
//   var headerTag = ''.obs;
//   var searchbarText = ''.obs;
//   var urllist = [
//     'https://www.bebuzee.com/new_files/buzzerfeed/videos/20220426025411xat1VvBvT8.mp4',
//     'https://www.bebuzee.com/new_files/buzzerfeed/videos/202204260254038ddrj4nKrI.mp4'
//   ];
//   var listofflickrmanager = <FlickManager>[
//     FlickManager(
//       videoPlayerController: VideoPlayerController.network(
//         " ",
//       ),
//     )
//   ];
//   void loadData({page: 1}) async {
//     var data = await BuzzerFeedAPI.getData(page: page, tag: fromhashtag);
//     listbuzzerfeeddata.addAll(data);
//     listbuzzerfeeddata.refresh();
//   }

//   var hasstarttag = false;
//   void resetTag() {
//     tag.value = '';
//     hasstarttag = false;
//   }

//   bool checkTag() {
//     if (tag.value[0] == '@')
//       return true;
//     else
//       return false;
//   }

//   void removePost(postId, index) async {
//     Get.snackbar('Success', 'Buzz removed successfully!!',
//         backgroundColor: HexColor('#FFFFFF'));
//     listbuzzerfeeddata.removeAt(index);
//     listbuzzerfeeddata.refresh();
//     await BuzzerFeedAPI.deletePost(postId);
//   }

//   void rebuzzPost(postId) async {
//     await BuzzerFeedAPI.rebuzz(postId);
//   }

//   List<String> countries = [
//     "Afghanistan",
//     "India",
//     "United Kingdom",
//     "Spain",
//     "San Marino",
//     "United Kingdom",
//     "Australia",
//     "Nigeria",
//     "Argentina",
//     "France",
//     "World"
//   ];

//   void fetchData({page: 1, tag: ''}) async {
//     var data = await BuzzerFeedAPI.getData(page: page, tag: tag);
//     listbuzzerfeeddata.value = data;
//     listbuzzerfeeddata.refresh();
//     // print("getData() response=${data[0].pollAnswer}");
//   }

//   void getTags() async {
//     var tagsData = await BuzzerFeedAPI.getTagsList();
//     tags.assignAll(tagsData);
//     tags.refresh();
//   }

//   void likeUnlike(index) async {
//     var data =
//         await BuzzerFeedAPI.likeUnlike(listbuzzerfeeddata[index].buzzerfeedId);
//     if (data != null) {
//       print("likeunlike api ${data}");
//       listbuzzerfeeddata[index].likeStatus = data['like_status'];
//       listbuzzerfeeddata[index].totalLikes = data['total_likes'].toString();
//       listbuzzerfeeddata.refresh();
//     }
//   }

//   void fetchFirstPost(postid) async {
//     isUpload.value = true;
//     var data = await BuzzerFeedAPI.getRecentData(postid);
//     print("firstpostcame =${data}");
//     listbuzzerfeeddata.insert(0, data[0]);
//     isUpload.value = false;
//     listbuzzerfeeddata.refresh();

//     // print("rescent ${listbuzzerfeeddata.length}");
//     // print("rescent ${listbuzzerfeeddata[0].images[0]}");
//   }

//   @override
//   void onInit() async {
//     listbuzzerfeeddata.value =
        // await BuzzerFeedAPI.getData(tag: this.fromhashtag) ??
        //     <BuzzerfeedDatum>[];
//     // await getTags();

//     super.onInit();
//   }
// }
