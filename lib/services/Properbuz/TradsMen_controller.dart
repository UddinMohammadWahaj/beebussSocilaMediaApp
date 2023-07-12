import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/city_list_model.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/Tradesmen/search_tradesmen.dart';
import 'package:bizbultest/models/Tradesmen/tradesmen_country_list_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmen_subcat_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmens_work_category_model.dart';
import 'package:bizbultest/models/TradesmenCountryModel.dart';
import 'package:bizbultest/models/Tradesmen/TradesmenWorkCategoryModel.dart';
import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Properbuz/api/home_api.dart';
import 'package:bizbultest/shared/shared.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TradsmenController extends GetxController {
  TextEditingController selectLocation = TextEditingController();
  TextEditingController searchByNameController = TextEditingController();
  TextEditingController searchCountry = new TextEditingController();
  TextEditingController propertyLocation = new TextEditingController();
  TextEditingController locationFieldController = TextEditingController();
  TextEditingController newlocationFieldController = TextEditingController();
  var isLocationLoading = false.obs;
  var isSearching = false.obs;

  var message = "".obs;
  var selectedCountryFinal = ''.obs;
  var currentCountry = ''.obs;
  var select = "Please select";
  var countrylist = <TradesCountry>[].obs;

  var iconLoadCountry = false.obs;
  var searchCountryList = [].obs;
  var currentCountryIndex = 0.obs;
  var iconLoadBathroom = false.obs;

  var locations = [].obs;

  void getLocations() {
    print("getting values");
    if (message.value.isNotEmpty) {
      isLocationLoading.value = true;
      ProperbuzHomeApi.fetchLocations(
        currentCountry.value,
        message.value,
      ).then((value) {
        locations.assignAll(value);
        isLocationLoading.value = false;
      });
    } else {
      locations.clear();
    }
    print("got values");

    print("response location=${locations.value}");
  }

  void setLocation(String location, BuildContext context) {
    message.value = location;
    Navigator.pop(context);
  }

  void fetchCountryList(VoidCallback callback) async {
    var dataList = await ApiProvider().tradesmenCountry();
    iconLoadCountry.value = false;
    countrylist.value = dataList;
    callback();
  }

  void updateCountryList(String pattern) {
    var dataList = countrylist;
    if (pattern.isNotEmpty) {
      searchCountryList.value = dataList
          .where(
              (e) => e.country!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
      print(
          "search countrylist ${searchCountryList} ${searchCountryList[0].country}");
      // selectCountry(searchCountryList[0].country);
    } else
      searchCountryList.value = [];
  }

  var countryId = ''.obs;
  var cityList = <CityListModel>[].obs;
  var countryList = [].obs;
  List<CountryListModel> listofcountry = [];
  // Future fetchCountry() async {
  //   print("fetch country");
  //   listofcountry = await CountryAPI.fetchCountries();
  //   countryList.value = listofcountry;
  // }

  void selectCountry(Country country) async {
    print("select country");
    print(country);
    selectedCountryFinal.value = country.name;
    listofcountry.forEach((element) {
      if (element.country!.toLowerCase() == country.name.toLowerCase()) {
        countryId.value = element.countryID!;
        print(country.name);
        print("selected ${element.countryID}");
      }
    });

    print(countryId.value.toString() + "country id");
    await fetchCity();
  }

  Future fetchCity() async {
    print("start fetching city");
    List<CityListModel> listofcity =
        await CountryAPI.fetchCities(selectedCountryFinal.value);
    cityList.value = listofcity;

    print("citylist fetch");
  }

  @override
  void onInit() {
    print("fetch data");
    fetchData();
    // fetchCountry();
    selectLocation = TextEditingController();
    debounce(message, (_) {
      getLocations();
    }, time: Duration(milliseconds: 800));
    super.onInit();
  }

  @override
  void dispose() {
    selectLocation.dispose();
    super.dispose();
  }

  var lstWorkCat = <WorkCategory>[].obs;
  var lstWorkCat1 = <Data1>[].obs;

  Future<void> fetchData() async {
    List<WorkCategory> lstPropertyBuyingModel =
        await ApiProvider().tradsmenWorkCategory();
    lstWorkCat.value = lstPropertyBuyingModel;
    await fetchcountryData();
  }

  var lstWorksubCat = <TradesmenSubCatModelWorkSubCategory>[].obs;

  Future<void> fetchsubData(String catid) async {
    // lstWorksubCat.clear();
    List<TradesmenSubCatModelWorkSubCategory> lstTradesmenWorkCategoryModel =
        await ApiProvider().tradsmenSubWorkCategory(catid);
    lstWorksubCat.value = lstTradesmenWorkCategoryModel;
  }

  var lstWorkcountryCat = <TradesCountry>[].obs;

  Future<void> fetchcountryData() async {
    List<TradesCountry> lstWorklstTradesmenCountryModelCat =
        await ApiProvider().tradesmenCountry();
    lstWorkcountryCat.value = lstWorklstTradesmenCountryModelCat;
  }

  var lstWorklocation = <TradsmenWorkLocationModel>[].obs;
  var lstWorklocationSearch = <TradsmenWorkLocationModel>[].obs;

  void updateList() {
    print('update val');
    lstWorklocationSearch.value = lstWorklocation.value
        .where((loc) =>
            loc.area!.toLowerCase().contains(selectLocation.text.toLowerCase()))
        .toList();
    // print(lstWorklocationSearch.value.length);
  }

  Future<void> fetchlocation(String countryid) async {
    lstWorklocation.clear();
    List<TradsmenWorkLocationModel> lstTradsmenWorkLocationModel =
        await ApiProvider().tradsmenWorkLocation(countryid);
    lstWorklocation.value = lstTradsmenWorkLocationModel;
    lstWorklocationSearch.value = lstTradsmenWorkLocationModel;
  }

  //

  var trademenNameList = <ManageData>[].obs;
  var trademenId = ''.obs;

  searchByName(String name) async {
    print(name);
    //! api need to be updated
    // trademenNameList.value =
    //     await ApiProvider().searchTradesmenByComapnyName(name);
  }
}
