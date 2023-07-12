import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/SearchPropertiesListModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:get/get.dart';

class PropertySearchedController extends GetxController {
  // ignore: deprecated_member_use
  var lstPropertySearching = <SearchPropertiesList>[].obs;

  @override
  void onInit() {
    super.onInit();

    String uid = CurrentUser().currentUser.memberID!;
    fetchData(uid);
    print("-----------------init------");
  }

  var searchLoding = false.obs;
  Future<void> delete(searchId, index) async {
    var url =
        'https://www.bebuzee.com/api/property/removeSearchProperty?user_id=16&search_id=${searchId}';
    lstPropertySearching.removeAt(index);
    await ApiProvider().fireApiWithParamsGet(url);
  }

  Future<void> fetchData(uid) async {
    searchLoding.value = true;
    List<SearchPropertiesList> lstPropertyBuyingModel =
        await ApiProvider().searchpropertiesList(uid);
    lstPropertySearching.value = lstPropertyBuyingModel;
    searchLoding.value = false;
  }
}
