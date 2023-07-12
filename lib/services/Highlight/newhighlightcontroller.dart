import 'package:get/get.dart';

import '../../models/add_multiple_stories_model.dart';
import '../current_user.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

class AddNewHighlightController extends GetxController {
  var areStoriesLoaded = false.obs;
  var selectedStoriesID = <String>[].obs;
  var selectedStoriesImages = <String>[].obs;
  var allFiles = <FileElement>[].obs;
  var defaultCoverID = "".obs;
  var selectedFiles = <FileElement>[].obs;
  Future<void> getStories() async {
    // var url = Uri.parse(
    // "https://www.bebuzee.com/app_devlope_story_data.php?action=story_data_details_data_all&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_ids=");
//
    // var response = await http.get(url);
    print("get Stories called");
    var response =
        await ApiRepo.postWithToken("api/story_data_all_details.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "post_ids": ""
    });

    if (response!.success == 1) {
      MultipleStories storyData =
          MultipleStories.fromJson(response.data['data']);

      storyData.stories.forEach((element) {
        element.files!.forEach((file) {
          /*List<FileElement> all = [];
          await Future.wait(all.map((e) => Preload.cacheImage(context, e.image)).toList());*/

          allFiles.add(file);
        });
      });
      allFiles.refresh();
      areStoriesLoaded.value = true;
    }
    if (response.data['data'] == null || response.success != 1) {
      areStoriesLoaded.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getStories();
    super.onInit();
  }
}
