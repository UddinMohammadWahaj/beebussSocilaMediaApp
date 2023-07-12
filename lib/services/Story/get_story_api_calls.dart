import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;

class GetStoryApi {
  static Future<String> sharePostToStory(String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_post_share_on_story.php?user_id=${CurrentUser().currentUser.memberID}&post_id=$postID");
    var url =
        'https://www.bebuzee.com/api/story_post_share.php?user_id=${CurrentUser().currentUser.memberID}&post_id=$postID';
    var response = await ApiProvider().fireApi(url);
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print('post to story ${response.data}');
      return "Success";
    } else {
      return "Failed";
    }
  }
}
