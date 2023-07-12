import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/User/user_api_calls.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  HomepageRefreshState refreshFeeds = new HomepageRefreshState();

  void changeName(String name) async {
    await UserApiCalls.changeUserName(name);
    FeedController feedController = Get.put(FeedController());
    feedController.hideNavBar.value = true;
    refreshFeeds.updateRefresh(true);
  }
}
