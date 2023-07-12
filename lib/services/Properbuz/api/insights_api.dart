import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';

class InsightsAPI {
  String memberID = CurrentUser().currentUser.memberID!;
  static Future<Map<String, dynamic>> getInsights(String propertyID) async {
    // var url =
    //     'https://www.bebuzee.com/api/get_property_analytic_list.php?agent_id=${CurrentUser().currentUser.memberID}&property_id=$propertyID';
    var newurl =
        'https://www.bebuzee.com/api/property/getPropertyAnalyticList?agent_id=${CurrentUser().currentUser.memberID}&property_id=$propertyID';
    var client = Dio();
    var response = await ApiProvider().fireApiWithParamsGet(newurl);
    print("view insights response=${response.data}");
    return response.data['data'];
  }
}
