import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/manage_properties_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;

class ManagePropertiesAPI {
  String memberID = CurrentUser().currentUser.memberID!;

  static Future<List<ManagePropertiesModel>> manageProperties(
      {page: '', type: ''}) async {
    var url =
        'https://www.bebuzee.com/api/manage_property_list.php?agent_id=${CurrentUser().currentUser.memberID}';

    var newurl =
        'https://www.bebuzee.com/api/property/manageProperty?user_id=1797163&page=$page&keyword=&listing_type=$type&status=&property_category=';
    print("--- url --- ${newurl}");
    var response = await ApiProvider().fireApiWithParamsGet(newurl);

    print("response of manage properties${response.data}");

    if (response.statusCode == 200 && response.data != null) {
      ManageProperties propertiesdata =
          ManageProperties.fromJson(response.data['record']);
      return propertiesdata.properties;
    } else {
      return [];
    }
  }
}
