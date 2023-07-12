import 'dart:convert';

import 'package:bizbultest/models/Properbuz/featured_prop_analytics_prop_info_model.dart';
import 'package:bizbultest/models/Properbuz/featured_propert_location_list_model.dart';
import 'package:bizbultest/models/Properbuz/featured_property_graph_data_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/services/current_user.dart';

import 'package:http/http.dart' as http;
import '../../../api/ApiRepo.dart' as ApiRepo;

class FeaturedPropertyAnalyticsAPI {
  static Future<List<FeaturedPropertyLocationListModel>>
      fetchFeaturedPropList() async {
    // var url = Uri.parse(
    //     'https://www.bebuzee.com/webservices/get_manage_analytics_property_list.php?user_id=${CurrentUser().currentUser.memberID}');
    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken(
        "api/manage_analytics_property_list.php",
        {"user_id": CurrentUser().currentUser.memberID});
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      FeaturedPropertyLocationList lst =
          FeaturedPropertyLocationList.fromJson(response!.data['data']);
      return lst.lstfeaturedproploc;
    } else
      return [];
  }

  static Future<FeaturedAnalyticsGraphDataModel?> fetchGraphData(
      String pid) async {
    //var url = Uri.parse( 'https://www.bebuzee.com/webservices/get_manage_analytics_list.php?user_id=${CurrentUser().currentUser.memberID}&property_id=$pid');
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properties_analytics_list.php", {
      "agent_id": CurrentUser().currentUser.memberID,
      "property_id": pid
    }); //
    print("------ graph &${response!.data['data']}");
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      var data = FeaturedAnalyticsGraphData.fromJson(
          jsonDecode(response!.data['data']));
      print("------ graph-- &${data.datamodel}");
      return data.datamodel;
    } else
      return null;
  }

  static Future<List<FeaturedAnalyticsPropertyInfoModel>>
      fetchFeaturePropInfo() async {
    // var url = Uri.parse( 'https://www.bebuzee.com/webservices/get_manage_analytics_data.php?user_id=${CurrentUser().currentUser.memberID}');
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/properbuzz_manage_analytics_data.php",
        {"user_id": CurrentUser().currentUser.memberID});

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "") {
      var data =
          FeaturedAnalyticsPropertyInfoModel.fromJson(response!.data['data']);
      print("new= ${data.totalNewProperty}");
      return [data];
    } else
      return [];
  }
}
