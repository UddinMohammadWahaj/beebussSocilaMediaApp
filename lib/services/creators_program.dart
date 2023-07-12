import 'dart:convert';

import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;

class CreatorsProgramApi {
  static Future<int> getApplicationStatus() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_check_creators_program.php?user_id=${CurrentUser().currentUser.memberID}");
    var response = await http.get(url);
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body != "") {
      print(response.body);
      int statusCode = jsonDecode(response.body)['success'];
      return statusCode;
    } else {
      return 0;
    }
  }

  //! updated api
  static Future<int> applyToProgram(String firstName, String surname,
      String emailAddress, String countryValue) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/creators_program_apply.php?user_id=${CurrentUser().currentUser.memberID}&first_name=$firstName&last_name=$surname&email=$emailAddress&country=$countryValue");

    Map<String, String> head = {
      "Content-Type": "application/json",
      "Authorization":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvd3d3LmJlYnV6ZWUuY29tXC8iLCJhdWQiOiJodHRwczpcL1wvd3d3LmJlYnV6ZWUuY29tXC8iLCJpYXQiOjE2MzgxODI0NzQsImV4cCI6MTYzODE4NjA3NCwiZGF0YSI6eyJtZW1iZXJfaWQiOiIxNzk3NjMwIn19.XH_5oBJK8scbe0qnu7LOTmhO5VMrWuaCkg-eTtrjTMM"
    };
    var response = await http.get(url, headers: head);
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body != "") {
      print(response.body);
      int statusCode = jsonDecode(response.body)['success'];
      return statusCode;
    } else {
      return 0;
    }
  }
}
