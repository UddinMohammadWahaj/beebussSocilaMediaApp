import 'package:http/http.dart' as http;

import '../current_user.dart';

class ChatProfileApiCalls {
  //TODO:: inSheet 299
  static Future<String> deletePhoto() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=remove_profile_picture&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);

      return "success";
    } else {
      return "failed";
    }
  }
}
