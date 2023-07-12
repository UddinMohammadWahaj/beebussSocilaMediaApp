import 'dart:core';

import '../../api/ApiRepo.dart' as ApiRepo;

class NetworkHelper {
  Future<dynamic> getResponseData() async {
    try {
      // var urls = Uri.parse(url);

      var response = await ApiRepo.getWithToken("api/country_code_list.php");

      if (response.success == 1) {
        return (response.data);
      } else {
        return response.success;
      }
    } catch (e) {
      print(e);
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
