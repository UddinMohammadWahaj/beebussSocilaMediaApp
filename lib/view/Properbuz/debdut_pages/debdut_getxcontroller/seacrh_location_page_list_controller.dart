import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/view/Properbuz/debdut_pages/debdut_model/SearchLocationPageListModel.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SearchLocationPageListController extends GetxController {
  String? country;
  String? city;
  SearchLocationPageListController({this.country, this.city});
  var lstofreviewdata = [].obs;

  Future<List> getlstSearchLocationPageListModel() async {
    List testlstofreviewdatafromapi = [];
    String query =
        'https://www.bebuzee.com/webservices/get_reviews_by_country_city.php?country=${this.country}&city=${this.city}';
    Map<String, dynamic> head = {
      "Content-Type": "application/json",
    };
    try {
      var response = await Dio().get(query, options: Options(headers: head));
      if (response.statusCode == 200) {
        print("response of search country location review ${response.data}");
        response.data.forEach((element) {
          // SearchLocationPageListModel objSearchLocationPageListModel =
          //     new SearchLocationPageListModel();
          // objSearchLocationPageListModel =
          //     SearchLocationPageListModel.fromJson(element);
          // lstofreviewdatafromapi.add(objSearchLocationPageListModel);
          testlstofreviewdatafromapi.add(element);
        });
      }
    } catch (e) {
      print("error ho gaya ");
    }

    return testlstofreviewdatafromapi;
  }

  Future<void> fetchData() async {
    List lstSearchLocationPageModel = await getlstSearchLocationPageListModel();
    print("data success");
    lstofreviewdata.value = lstSearchLocationPageModel;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    await fetchData();
    super.onInit();
  }
}
