import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/property_buying_guide_filter_model.dart';
import 'package:bizbultest/models/Properbuz/property_buying_guide_model.dart';
import 'package:bizbultest/services/Properbuz/api/menu_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PropertyGuidesController extends GetxController {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var page = 1.obs;
  var selectedFilterIndex = 0.obs;
  var belogLoding = false.obs;

  var blogsList = <PropertyBuyingModel>[].obs;

  List<PropertyBuyingFilterModel> filterList = [
    PropertyBuyingFilterModel(
        filter: "Real estate tips", value: 1, selected: false.obs),
    PropertyBuyingFilterModel(
        filter: "Personal finance", value: 2, selected: false.obs),
    PropertyBuyingFilterModel(
        filter: "International real estate trends",
        value: 3,
        selected: false.obs),
    PropertyBuyingFilterModel(
        filter: "Country-specific real estate tips",
        value: 4,
        selected: false.obs),
    PropertyBuyingFilterModel(
        filter: "Travel tips", value: 5, selected: false.obs),
  ];

  @override
  void onInit() {
    getBlogs();
    super.onInit();
  }

  String blogImage(int index) {
    return blogsList[index].blogImageBaseUrl! + blogsList[index].blogImage!;
  }

  String getFilter() {
    switch (selectedFilterIndex.value) {
      case 1:
        return 'real_state';
      case 2:
        return 'personal_finance';

      case 3:
        return "internation_real_state_trends";
      case 4:
        return "country_specific_real_state";
      case 5:
        return "travel_tips";
      default:
        return "";
    }
  }

  void selectFilter(int index) {
    blogsList.clear();
    if (filterList[index].selected.value) {
      filterList[index].selected.value = false;
      selectedFilterIndex.value = 0;
      getBlogs();
    } else {
      filterList.forEach((element) {
        element.selected.value = false;
      });
      filterList[index].selected.value = true;
      selectedFilterIndex.value = index + 1;

      getBlogs();
    }
  }

  void getBlogs() async {
    belogLoding.value = true;
    var blogData = await ApiProvider()
        .proprtyBuying(1, selectedFilterIndex.value, type: getFilter());
    if (blogData != null) {
      blogsList.assignAll(blogData);
    }
    belogLoding.value = false;
  }

  void loadMoreData() async {
    page.value++;
    var blogData = await ApiProvider().proprtyBuying(
        page.value, selectedFilterIndex.value,
        type: getFilter());
    if (blogData != null) {
      blogsList.addAll(blogData);
      refreshController.loadComplete();
    } else {
      refreshController.loadComplete();
    }
  }

  void refreshData() async {
    page.value = 1;
    var blogData = await ApiProvider().proprtyBuying(
        page.value, selectedFilterIndex.value,
        type: getFilter());
    if (blogData != null) {
      blogsList.assignAll(blogData);
      refreshController.refreshCompleted();
    } else {
      refreshController.footerMode;

      refreshController.refreshCompleted();
    }
  }
}
