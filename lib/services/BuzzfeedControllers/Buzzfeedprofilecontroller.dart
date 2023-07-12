import 'package:bizbultest/models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class BuzzerfeedProfileController extends GetxController {
  String memberId;
  var highLightview = false.obs;
  BuzzerfeedProfileController(this.memberId);
  var listbuzzerfeeddata = <BuzzerfeedDatum>[].obs;
  var isUpload = false.obs;
  var page = 1.obs;
  void fetchData() async {
    page.value = 1;
    var data = await BuzzerFeedAPI.getMyBuzz(memberId: this.memberId);
    listbuzzerfeeddata.value = data;
  }

  void rebuzzPost(postId) async {
    await BuzzerFeedAPI.rebuzz(postId);
    Get.snackbar('Success', 'Rebuzzed Successfully');
  }

  void pollvote(answerID, index) async {
    var result = await BuzzerFeedAPI.pollVote(answerID);
    if (result['message'] == 'You have already answer.') {
      Get.snackbar('Failed', 'You have already voted!!');
      return;
    } else {
      listbuzzerfeeddata[index].testpoll!.value = List<PollDatum>.from(
          result['data'].map((x) => PollDatum.fromJson(x)));
      listbuzzerfeeddata[index].testpoll!.refresh();
      print("poll ans =${result['data']}");
    }
  }

  void removeData() {}

  void fetchLoadData() async {
    page.value = page.value + 1;
    var data = await BuzzerFeedAPI.getMyBuzz(
        page: page.value, memberId: this.memberId);
    listbuzzerfeeddata.addAll(data);
    listbuzzerfeeddata.refresh();
    // listbuzzerfeeddata.refresh();
    // print("getData() response=${data[0].pollAnswer}");
  }

  void fetchFirstPost(postid) async {
    var data = await BuzzerFeedAPI.getRecentData(postid);
    print("firstpostcame =${data}");
    listbuzzerfeeddata.insert(0, data[0]);
    isUpload.value = false;
  }

  @override
  void onInit() async {
    listbuzzerfeeddata.value =
        await BuzzerFeedAPI.getMyBuzz(memberId: this.memberId) ??
            <BuzzerfeedDatum>[];
    highLightview.value = false;

    super.onInit();
  }

  void removePost(postId, index) async {
    Get.snackbar('Success', 'Buzz removed successfully!!',
        backgroundColor: HexColor('#FFFFFF'));
    listbuzzerfeeddata.removeAt(index);
    listbuzzerfeeddata.refresh();
    await BuzzerFeedAPI.deletePost(postId);
  }
}
