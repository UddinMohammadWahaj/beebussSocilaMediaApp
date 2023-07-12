import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/manage_properties_model.dart';
import 'package:bizbultest/models/Properbuz/manage_tradesman_model.dart';
import 'package:bizbultest/services/current_user.dart';

class ManagetradesmanAPI {
  String memberID = CurrentUser().currentUser.memberID!;

  static Future<List<ManageTradesmanModel>> managetradesman() async {
    var url =
        'https://www.bebuzee.com/api/manage_property_list.php?agent_id=${CurrentUser().currentUser.memberID}';
    var response = await ApiProvider().fireApi(url);
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print(response.data);
      ManageTradesman propertiesdata =
          ManageTradesman.fromJson(response.data['data']);
      return propertiesdata.properties;
    } else {
      return [];
    }
  }
}
