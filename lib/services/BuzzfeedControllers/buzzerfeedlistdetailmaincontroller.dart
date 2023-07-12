import 'package:bizbultest/models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/FlickPlayer/flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../../../api/ApiRepo.dart' as ApiRepo;

class BuzzerfeedListDetailController extends GetxController {
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
  void loadData({page: 1}) async {
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
    Get.snackbar('Success', 'Rebuzzed Successfully');
  }

  void likeComment(commentId) async {
    await BuzzerFeedAPI.commentLike(commentId);
    Get.snackbar('Success', 'You liked a comment',
        icon: Icon(
          FontAwesomeIcons.heart,
          color: Colors.red,
        ));
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
      // listbuzzerfeeddata[index].likeStatus = data['like_status'];
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
    await Wakelock.enable();
    listbuzzerfeeddata.value =
        await BuzzerFeedAPI.getData() ?? <BuzzerfeedDatum>[];

    getTags();
    fetchTrendingToday();
    super.onInit();
  }
}
