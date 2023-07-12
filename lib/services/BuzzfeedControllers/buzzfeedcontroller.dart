import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Buzzerfeed/buzzfeedgifmodel.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/services/Properbuz/api/add_prop_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';

enum privacy { public, follow, mention }

enum postType { poll, text, images, videos, gif }

class BuzzerfeedController extends GetxController {
  var editfiles = [];
  var edittype = '';

  String? purpose = '';
  String? edittext = '';
  String? editbuzzerfeedid = '';
  var editIndex;
  String? replymemberId;
  BuzzerfeedController(
      {this.purpose,
      this.replymemberId,
      this.edittype = '',
      this.editfiles = const [],
      this.edittext,
      this.editIndex,
      this.editbuzzerfeedid});

  var currentgiflist = <GiphyGif>[].obs;
  var listoffiles = [].obs;
  var showPoll = false.obs;
  var showImage = false.obs;
  var description = "".obs;
  var message = "".obs;
  var currentchoicelength = 2.obs;
  var recentid = "";
  var selectedGif = false.obs;
  var currentGif = ''.obs;
  var currentGifPreview = ''.obs;
  var currentCountry = ''.obs;
  var currentCity = ''.obs;
  var isLocationLoading = false.obs;
  var locationselected = false.obs;
  var descriptioncontroller = TextEditingController();
  RxList<dynamic> locations = [].obs;
  var showMentions = false.obs;
  var currentPostType = "";
  var currentPollLength = "1 day".obs;
  var showVideo = false.obs;
  resetGif() {
    selectedGif.value = false;
    currentGif.value = "";
    currentGifPreview.value = "";
  }

  resetVideo() {
    showVideo.value = false;
    listoffiles.value = [];
  }

  resetPoll() {
    showPoll.value = false;
    listoffiles.value = [];
  }

  resetImage() {
    showImage.value = false;
    listoffiles.value = [];
  }

  String getcurrentposttype() {
    if (selectedGif.value == true)
      return "gif";
    else if (showPoll.value == true) {
      return "poll";
    } else if (showImage.value) {
      return "images";
    } else if (showVideo.value) {
      return "videos";
    } else {
      return "text";
    }
  }

  String? getCurrentPrivacy() {
    if (currentPrivacy.value == "${privacy.public}")
      return "public";
    else if (currentPrivacy.value == "${privacy.follow}")
      return "follow";
    else if (currentPrivacy.value == "${privacy.mention}") return "mention";
  }

  Future<void> postCommentReply(buzzerfeedId, replymemberId) async {
    var postComment = {
      "comment_id": buzzerfeedId,
      "reply_user_id": replymemberId,
      "user_id": "${CurrentUser().currentUser.memberID!}",
      "comments": descriptioncontroller.text,
      "comment_type": getcurrentposttype(),
      "comment_location": currentCity.value,
      "gif_id": currentGif.value,
      "comment_poll_question": descriptioncontroller.text,
      "comment_poll_choice":
          "${choicescontroller[0].text}^^^${choicescontroller[1].text}^^^${choicescontroller[2].text}^^^${choicescontroller[3].text}",
      "comment_poll_length": "1"
    };
    print("buzzerfeedId=${buzzerfeedId} $postComment");
    print("test reply =${postComment}");
    // commentUpload.value = true;
    // var recentCommentId =
    await BuzzerFeedAPI.postCommentReply(postComment, files: []);
    // getRecentComment(recentCommentId);
  }

  Future postComment(buzzerfeedId) async {
    var postComment = {
      "buzzerfeed_id": buzzerfeedId,
      "user_id": "${CurrentUser().currentUser.memberID!}",
      "comments": descriptioncontroller.text,
      "comment_type": getcurrentposttype(),
      "comment_location": currentCity.value,
      "gif_id": currentGif.value,
      "comment_poll_question": descriptioncontroller.text,
      "comment_poll_choice":
          "${choicescontroller[0].text}^^^${choicescontroller[1].text}^^^${choicescontroller[2].text}^^^${choicescontroller[3].text}",
      "comment_poll_length": "1"
    };
    print("buzzerfeedId=${buzzerfeedId} $postComment");
    return await BuzzerFeedAPI.postComment(postComment,
        files: listoffiles.value);
  }

  void deleteFile(index, path) async {
    await BuzzerFeedAPI.deleteFile(
        this.editbuzzerfeedid, path, getcurrentposttype());
  }

  Future<void> requoteBuzz() async {
    var topostdata = {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "buzzerfeed_id": this.editbuzzerfeedid,
      "post_type": getcurrentposttype(),
      "post_privacy": getCurrentPrivacy(),
      "post_description": descriptioncontroller.text,
      "post_location": currentCity.value,
      "gif_id": currentGif.value,
      "post_poll_question": descriptioncontroller.text,
      "post_poll_choice":
          "${choicescontroller[0].text}^^^${choicescontroller[1].text}^^^${choicescontroller[2].text}^^^${choicescontroller[3].text}",
      "post_poll_length": "HH:MM:SS",
      "mention_id": "123,423",
    };
    print("resp= ${topostdata}");
    print("response filelength=${listoffiles.value}");

    recentid = await BuzzerFeedAPI.postRequote(topostdata,
        files: (listoffiles.length == 1 &&
                listoffiles[0].runtimeType.toString() != "String")
            ? [listoffiles.value[0].path]
            : listoffiles.value);
    print("recentId=${recentid}");
  }

  Future<void> sendData() async {
    var topostdata = {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "post_type": getcurrentposttype(),
      "post_privacy": getCurrentPrivacy(),
      "post_description": descriptioncontroller.text,
      "post_location": currentCity.value,
      "gif_id": currentGif.value,
      "post_poll_question": descriptioncontroller.text,
      "post_poll_choice":
          "${choicescontroller[0].text}^^^${choicescontroller[1].text}^^^${choicescontroller[2].text}^^^${choicescontroller[3].text}",
      "post_poll_length": "HH:MM:SS",
      "mention_id": "123,423",
    };
    print("resp= ${topostdata}");
    print("response filelength=${listoffiles.value}");

    recentid = await BuzzerFeedAPI.postData(topostdata,
        files: (listoffiles.length == 1 &&
                listoffiles[0].runtimeType.toString() != "String")
            ? [listoffiles.value[0].path]
            : listoffiles.value);
    print("recentId=${recentid}");
  }

  Future<void> sockeencapsulation() async {
    print("data has a socket channel enabled");
  }

  Future<void> updateData() async {
    var topostdata = {
      "user_id": CurrentUser().currentUser.memberID!,
      "country": CurrentUser().currentUser.country,
      "buzzerfeed_id": this.editbuzzerfeedid,
      "post_type": getcurrentposttype(),
      "post_privacy": getCurrentPrivacy(),
      "post_description": descriptioncontroller.text,
      "post_location": currentCity.value,
      "gif_id": currentGif.value,
      "post_poll_question": descriptioncontroller.text,
      "post_poll_choice":
          "${choicescontroller[0].text}^^^${choicescontroller[1].text}^^^${choicescontroller[2].text}^^^${choicescontroller[3].text}",
      "post_poll_length": "HH:MM:SS",
      "mention_id": "123,423",
    };
    print("resp= ${topostdata}");
    print("response filelength=${listoffiles.value}");

    recentid =
        await BuzzerFeedAPI.updateData(topostdata, files: listoffiles.value);

    print("recentId=${recentid}");
  }

  var choicescontroller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  var userLocation = TextEditingController();
  var start = 0.obs;
  var end = 0.obs;
  void toggleShowImage() {
    showImage.value = !showImage.value;
    if (showPoll.value) showPoll.value = false;
  }

  var currentPrivacy = "${privacy.public}".obs;

  void hideImage() {
    showImage.value = false;
  }

  void togglePoll() {
    showPoll.value = !showPoll.value;
    if (showPoll.value) hideImage();
  }

  Future<List<Datum>> getGif() async {
    print("called gif");
    var url = 'https://www.bebuzee.com/api/story_gif_category.php';
    var client = Dio();
    var response = await client
        .get(url)
        .then((value) => BuzzerfeedGif.fromJson(value.data));
    print("gif response=${response}");
    if (response.data == null) {
      return <Datum>[];
    }
    return response.data!;
  }

  void getLocations() {
    if (message.value.isNotEmpty) {
      isLocationLoading.value = true;
      var loclist = [];
      AddPropertyAPI.fetchLocations(
              message.value, CurrentUser().currentUser.country!)
          .then((value) {
        value.forEach((element) {
          print(element);

          loclist.add(element['area']);
        });
        locations.value = loclist;
        // locations.assignAll(value);
        isLocationLoading.value = false;
      });
    } else {
      locations.clear();
    }
    print("response location=${locations.value}");
  }

  Future<void> getUserTags(String searchedTag) async {
    print("get User tags Called");

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/user/userSearchFollowers?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID!}&searchword=$searchedTag');
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await client
        .postUri(
          newurl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);

    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID!}&searchword=$searchedTag");

    // var response = await http.get(url);

    // print(response.body);
    if (response.statusCode == 200) {
      print("get user taglist response= ${response.data}");
      UserTags tagsData = UserTags.fromJson(response.data['data']);

      // if (mounted) {
      //   setState(() {
      //     tagList = tagsData;
      //     areTagsLoaded = true;
      //   });
      // }
    }

    if (response.data == null || response.statusCode != 200) {
      // setState(() {
      //   areTagsLoaded = false;
      // });
    }
  }

  @override
  void onInit() {
    if (this.purpose == "post_edit") {
      listoffiles.value = this.editfiles;

      currentPostType = this.edittype;
      if (currentPostType == "images") {
        showImage.value = true;
        this.listoffiles.value = this.editfiles;
        // for (var i in this.editfiles) {
        //   // GallerySaver.saveImage(i).then((value) => null);

        // }
      } else if (currentPostType == "gif") {
        selectedGif.value = true;
        currentGif.value = editfiles[0];
      } else if (currentPostType == "poll")
        showPoll.value = true;
      else
        ;

      if (this.edittext != '')
        descriptioncontroller.value = TextEditingValue(text: this.edittext!);
      ;
    }

    debounce(message, (_) {
      getLocations();
    }, time: Duration(milliseconds: 800));
    // TODO: implement onInit
    super.onInit();
  }
}
