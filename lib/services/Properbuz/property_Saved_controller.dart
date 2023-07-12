import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/SavedPropertiesModel.dart';
import 'package:bizbultest/models/SearchPropertiesListModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:get/get.dart';

class PropertySavedController extends GetxController {
  var lstPropertySaved = <SavedPropertiesList>[].obs;

  @override
  void onInit() {
    super.onInit();
    String uid = CurrentUser().currentUser.memberID!;
    // uid = "1796768";
    fetchData(uid);
  }

  Future<void> fetchData(uid) async {
    List<SavedPropertiesList> lstPropertyBuyingModel =
        await ApiProvider().savepropertiesList(uid);
    lstPropertySaved.value = lstPropertyBuyingModel;
  }
}
