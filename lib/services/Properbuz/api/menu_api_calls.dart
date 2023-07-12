import 'dart:convert';
import 'package:bizbultest/models/Properbuz/property_buying_guide_model.dart';
import 'package:http/http.dart' as http;

class ProperbuzMenuAPI {
  static Future<List<PropertyBuyingModel>> fetchBlogs(int page, int filterVal) async {
    var url = Uri.parse("https://www.bebuzee.com/webservices/property_buying_list.php?page=$page&filter_val=$filterVal");
    var response = await http.get(url);
    if (response.statusCode == 200 && response.body != null && response.body != "" && response.body != "null") {
      GuideBlogs directUserData = GuideBlogs.fromJson(jsonDecode(response.body));
      return directUserData.blogs;
    } else {
      return [];
    }
  }
}
