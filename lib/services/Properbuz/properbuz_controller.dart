import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/PopularRealEstateMarketModel.dart';
import 'package:bizbultest/models/Properbuz/city_list_model.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/RecentlyLocationModel.dart';
import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Properbuz/api/home_api.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/view/Properbuz/home/searched_properties_view.dart';
import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../current_user.dart';

class ProperbuzController extends GetxController {
  var tabIndex = 0.obs;
  var currentIndex = 0.obs;
  var hasLoadedCountry = ''.obs;
  var isLocationLoading = false.obs;
  var hasLoaded = false.obs;
  var listOfLoc = [].obs;
  var countryList = [].obs;
  var message = "".obs;
  var cityList = <CityListModel>[].obs;
  Rx<TextEditingController> locationFieldController =
      TextEditingController().obs;
  var locationTradeController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  var minPrice = "".obs;
  var maxPrice = "".obs;
  var selectedCountry = AppLocalizations.of("Select Country").obs;
  var selectedCountryFinal = ''.obs;
  var price = AppLocalizations.of("Price").obs;
  var selectedBedroom = AppLocalizations.of("").obs;
  RxList<dynamic> bedrooms = [].obs;
  RxList<dynamic> locations = [].obs;
  var locationExpandedStatus = [false.obs, false.obs, false.obs].obs;
  var locationCategoryList = [].obs;
  RxList<dynamic> prices = [].obs;
  var minPricesList = [].obs;
  var maxPricesList = [].obs;
  var minTextEditingController = TextEditingController();
  var maxTextEditingController = TextEditingController();

  var priceSelected = false.obs;
  var selectmin = false.obs;
  var selectmax = false.obs;

  Future fetchCountry() async {
    List<CountryListModel> listofcountry = await CountryAPI.fetchCountries();
    countryList.value = listofcountry;
  }

  Future fetchCity() async {
    List<CityListModel> listofcity =
        await CountryAPI.fetchCities(selectedCountryFinal.value);
    cityList.value = listofcity;
  }

  void selectCountry(Country country) async {
    selectedCountryFinal.value = country.name;
    await fetchCity();
  }

  var recentlyAddedLocationStatus = [false.obs, false.obs, false.obs].obs;
  var recentlyAddedLocation = [].obs;

  var recentlySearchCityStatus = [false.obs, false.obs, false.obs].obs;
  var recentlySearchCity = [].obs;

  // ignore: deprecated_member_use
  var lstPropertySaved = <RecentlyLocationModel>[].obs;
  var lstPopularRealEstateMarketSaved = <PopularRealEstateMarketModel>[].obs;

  var popularRealLoader = false.obs;
  var recentlyAddLoactionLoader = false.obs;
  var recentPropertySearchLoader = false.obs;

  Future<void> fetchData() async {
    // popularRealLoader.value = true;
    List<PopularRealEstateMarketModel> lstPopularRealEstateMarketModel =
        await ApiProvider().popularRealEstateMarket();
    lstPopularRealEstateMarketSaved.value = lstPopularRealEstateMarketModel;
    // popularRealLoader.value = false;
  }

  Future<void> fetchRecentlyAddedLocation() async {
    List<RecentlyLocationModel> lstPropertyBuyingModel =
        await ApiProvider().recentlyAddedByLocation();
    lstPropertySaved.value = lstPropertyBuyingModel;
  }

  // ignore: deprecated_member_use
  var lstPropertySearch = <RecentlyLocationModel>[].obs;

  Future<void> searchByCityData() async {
    List<RecentlyLocationModel> lstPropertyBuyingModel =
        await ApiProvider().recentlyPropertiesSearch();
    lstPropertySearch.value = lstPropertyBuyingModel;
  }

  void onTapSearch(BuildContext context) async {
    //   if (locationFieldController.value.text.isEmpty) {
    //     Get.showSnackbar(properbuzSnackBar("Please enter a location"));

    //     print("empty");
    //   } else {
    // String token = await FirebaseMessaging.instance.getToken();
    // print("tokken------------$token");
    PropertiesController controller = Get.put(PropertiesController());
    controller.rooms.value = selectedBedroom.value;
    controller.minPrice.value = minPrice.value;
    controller.maxPrice.value = maxPrice.value;
    controller.selectedCountry.value = CurrentUser().currentUser.country!;
    controller.selectedLocation.value = message.value;
    controller.selectedTab.value = tabIndex.value;
    print("i am here");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchedPropertiesView(
                  location: message.value,
                )));
    // }
  }

  var messageId = ''.obs;
  void setLocation(String location, BuildContext context, String areaid) {
    print("set location $location $areaid");
    messageId.value = areaid;
    message.value = location;
    Navigator.pop(context);
  }

  Future fetchLoc(
    key,
  ) async {
    List listofcity =
        await CountryAPI.fetchLocations(key, selectedCountryFinal.value);
    print("fetch location outpur=$listofcity");
    cityList.value = listofcity as List<CityListModel>;
  }

  void getLocations() {
    if (message.value.isNotEmpty) {
      isLocationLoading.value = true;
      ProperbuzHomeApi.fetchLocations(
              CurrentUser().currentUser.country!, message.value)
          .then((value) {
        locations.assignAll(value);
        isLocationLoading.value = false;
      });
    } else {
      locations.clear();
    }
  }

  void clearSearchParameters() {
    locationFieldController.value.clear();
    minPriceController.clear();
    maxPriceController.clear();
    message.value = "";
    selectedBedroom.value = "";
  }

  void getPriceRanges() async {
    minPrice.value = "";
    maxPrice.value = "";
    int val = 1;
    if (tabIndex.value == 1) {
      val = 2;
    }
    var ranges = await ProperbuzHomeApi.fetchPriceRanges(val);
    minPricesList.assignAll(ranges);
    maxPricesList.assignAll(ranges);
    print(minPricesList.length.toString() + " min list");
  }

  @override
  void onInit() {
    minPriceController = TextEditingController()
      ..addListener(() {
        minPrice.value = minPriceController.text;
      });
    maxPriceController = TextEditingController()
      ..addListener(() {
        maxPrice.value = maxPriceController.text;
      });
    getPriceRanges();
    debounce(message, (_) {
      getLocations();
    }, time: Duration(milliseconds: 800));

    getBedrooms();
    fetchData();
    fetchRecentlyAddedLocation();
    searchByCityData();

    locationCategoryList = [
      {
        "value": AppLocalizations.of(
          "Popular Real Estate Market",
        ),
        "expanded": locationExpandedStatus[0].value
      },
    ].obs;

    recentlyAddedLocation = [
      {
        "value": AppLocalizations.of(
          "Recently Added by Location",
        ),
        "expanded": recentlyAddedLocationStatus[1].value
      },
    ].obs;

    recentlySearchCity = [
      {
        "value": AppLocalizations.of(
          "Recent Properties Searched by City",
        ),
        "expanded": locationExpandedStatus[2].value
      },
    ].obs;
    super.onInit();
  }

  var selctedType = 0.obs;

  void switchTabs(var index) {
    // PropertiesController ctr = Get.put(PropertiesController());
    tabIndex.value = index;
    getPriceRanges();
    selctedType.value = index + 1;
  }

  void changeTabs(int index) {
    currentIndex.value = index;
  }

  void getBedrooms() async {
    var bedroomData = await ProperbuzHomeApi.getBedrooms();
    bedrooms.assignAll(bedroomData);
  }

  void getPrices() async {
    var pricesData = await ProperbuzHomeApi.getPrices();
    prices.assignAll(pricesData);
    var tempList = prices.toList().toSet().toList();
    prices.value = tempList;
  }

  Future<bool> selectPrice(int index) async {
    if (minTextEditingController.text.length < 1) {
      priceSelected.value = !priceSelected.value;
      minTextEditingController.text = prices[index].toString();
      return false;
    } else {
      maxTextEditingController.text = prices[index].toString();
      priceSelected.value = !priceSelected.value;

      return true;
    }
  }

  void selectMinPrice(int index) async {
    minTextEditingController.text = prices[index].toString();
    priceSelected.value = !priceSelected.value;
    selectmin.value = false;
  }

  void selectMaxPrice(int index) async {
    maxTextEditingController.text = prices[index].toString();
    priceSelected.value = !priceSelected.value;
    selectmax.value = false;
  }

  int selectedIndex = -1.obs;

  void _onItemTapped(index) {
    Map map = imagesIcon.asMap();
    imagesIcon
        .map((view) => {
              view["selected"] = false.toString(),
              //  print(" index = $titles")
            })
        .toList();

    // debugPrint( "added index === ------- $titles");
    imagesIcon[index]['selected'] = true.toString();

    for (int i = 0; i < imagesIcon.length; i++) {}
  }

  List imagesIcon = [
    {"image": "assets/icons/carpenter.png"},
    {"image": "assets/icons/concrete.png"},
    {"image": "assets/icons/electrician.png"},
    {"image": "assets/icons/HVAC.png"},
    {"image": "assets/icons/industrial.png"},
    {"image": "assets/icons/other_category.png"},
    {"image": "assets/icons/pipe-fitting.png"},
    {"image": "assets/icons/plumber.png"},
    {"image": "assets/icons/services.png"},
    {"image": "assets/icons/welder.png"},
  ].obs;
}
