import 'package:http/http.dart' as http;
import '../current_user.dart';

class UserApiCalls {
  static Future<String> changeUserName(String name) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_change_username.php?user_id=${CurrentUser().currentUser.memberID}&name=$name");
    var response = await http.get(url);
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body != "") {
      print(response.body);
      return "Success";
    } else {
      return "Failed";
    }
  }
}
