import 'package:bizbultest/models/Properbuz/hot_properties_model.dart';
import 'package:bizbultest/models/SavedPropertiesModel.dart';
import 'package:get/get.dart';

import 'api/properties_api.dart';

class SavedPropertyController extends GetxController {
  var lstPropertySaved = <SavedPropertiesList>[].obs;
  var savedProperties = <HotPropertiesModel>[].obs;
  var page = 1.obs;

  @override
  void onInit() {
    getSavedProperties();
    super.onInit();
  }

  void getSavedProperties() async {
    var data = await PropertyAPI.fetchSavedProperties(page.value);
    savedProperties.assignAll(data);
  }
}
