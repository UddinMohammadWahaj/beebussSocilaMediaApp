import 'package:bizbultest/models/Properbuz/hot_properties_model.dart';
import 'package:bizbultest/models/Properbuz/hot_properties_model.dart';
import 'package:bizbultest/models/Properbuz/location_categories_model.dart';
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_overview_model.dart';
import 'package:bizbultest/models/Properbuz/property_country_filter_model.dart';
import 'package:bizbultest/models/Properbuz/property_type_filter_model.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/property/detailed_filter_bottom_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/property/filter_location_search_page.dart';
import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Language/appLocalization.dart';
import 'api/home_api.dart';
import 'api/populare_real_estate_api.dart';
import 'api/properties_api.dart';

class PropertiesController extends GetxController {
  Color appBarColor = HexColor("#2b6482");
  Color appBarLightColor = HexColor("#488aa4");
  Color settingsColor = HexColor("#3c5f6e");
  Color featuredColor = HexColor("#377fa9");
  Color iconColor = HexColor("#6d8f9f");
  Color statusBarColor = HexColor("#1e475b");

  List<String> sortList = [
    AppLocalizations.of("Latest"),
    AppLocalizations.of("Featured"),
    AppLocalizations.of("Maximum") + " " + AppLocalizations.of("Price"),
    AppLocalizations.of("Minimum") + " " + AppLocalizations.of("Price"),
    AppLocalizations.of("Minimum") + " " + AppLocalizations.of("Area"),
    AppLocalizations.of("Maximum") + " " + AppLocalizations.of("Area"),
  ];

  List<String> images = [
    "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8YXBhcnRtZW50JTIwbGl2aW5nJTIwcm9vbXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
    "https://res.cloudinary.com/apartmentlist/image/fetch/f_auto,q_auto,t_renter_life_cover/https://images.ctfassets.net/jeox55pd4d8n/63f7dRCQZRCXDDOYx6p9fo/5d0dd6ba4a252bbc5415d437ee09270a/images_Studio-Apartment-.jpg",
    "http://cdn.home-designing.com/wp-content/uploads/2018/06/Studio-apartment-with-loft-bed.jpg",
    "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/35jon-9979new-1593615607.jpg",
    "https://www.thespruce.com/thmb/ms_TeL_W-keH53AacSifzYGYi5o=/1200x800/filters:no_upscale():max_bytes(150000):strip_icc()/commonwealth_ave-01-d7c62f2d66584c6f93558b6700a881e1.jpeg",
    "https://www.arlingtonhouse.co.uk/wp-content/uploads/2020/09/Superior-Two-Bedroom-Apartment-with-Street-View003-1366x768-fp_mm-fpoff_0_0.jpg",
    "https://pyxis.nymag.com/v1/imgs/3b7/66f/9f550fcdabe47c4fd4f7943e4988993522-small-apartment-lede.jpg",
    "https://cdn.decorilla.com/online-decorating/wp-content/uploads/2020/07/Luxury-bedroom-with-modern-apartment-decor-ideas-by-TabbyTiara.jpg",
    "https://cdn.decoratorist.com/wp-content/uploads/modern-simple-bedroom-apartment-design-style-laredoreads-145411.jpg",
    "https://www.essexapartmenthomes.com/-/media/Project/EssexPropertyTrust/Sites/EssexApartmentHomes/Blog/2021/2021-01-12-Studio-vs-One-Bedroom-Apartment-How-They-Measure-Up/Studio-vs-One-Bedroom-Apartment-How-They-Measure-Up-1.jpg"
  ];

  var isLoadingSearch = false.obs;

  late TabController userPropertiesController;
  var currentIndex = 0.obs;
  var hotPropertiesPage = 1.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RefreshController refreshController1 =
      RefreshController(initialRefresh: false);
  String propertyfetchNearby(String lat, String long, String type) {
    return PopularRealEstateAPI.getNearbyLoc(lat, long, type);
  }

  var propertyfeatures1 = [
    "Penthouse",
    "Sea View",
    "Lake View",
    "Swimming Pool View",
    "Original Condition",
    "Low Floor",
    "Colonial Building"
  ].obs;
  var propertyfeatures2 = [
    "Corner Unit",
    "City View",
    "Park Greenery View",
    "Renovated",
    "Ground Floor",
    "High Floor"
  ].obs;
  String propertyfetchStreetView(String lat, String long) {
    return PopularRealEstateAPI.getStreetView(lat, long);
  }

  var selectedIndex = 0.obs;

  var manageProperties = <HotPropertiesModel>[].obs;
  var saleProperties = <HotPropertiesModel>[].obs;
  var rentalProperties = <HotPropertiesModel>[].obs;

  var selectedTab = 0.obs;
  var selectedPropertyPage = 1.obs;
  var isContactVisible = false.obs;
  PageController pageController = PageController();
  PageController virtualTourPageController = PageController();
  CarouselController carouselController = CarouselController();
  var visibilityKey = GlobalKey();
  var propertyContentIndex = 0.obs;
  var propertydetailslist = <PopularOverviewModel>[].obs;

  var hotProperties = <HotPropertiesModel>[].obs;
  var searchedProperties = <HotPropertiesModel>[].obs;
  var selectedSort = "".obs;
  var savedProperties = <HotPropertiesModel>[].obs;
  var alertProperties = <HotPropertiesModel>[].obs;
  var savedPage = 1.obs;
  var alertPage = 1.obs;

  var minPricesList = [].obs;
  var maxPricesList = [].obs;
  var bedrooms = [].obs;
  var countriesList = <PropertyCountryFilterModel>[].obs;
  var propertyTypesList = <PropertyTypeFilterModel>[].obs;
  var hotmodel = <HotPropertiesModel>[].obs;
  TextEditingController locationFieldController = TextEditingController();
  var isLocationLoading = false.obs;
  var locations = [].obs;
  var selectedCountry = "".obs;
  var selectedCountryID = "".obs;
  var selectedLocation = "".obs;
  var minPrice = "".obs;
  var maxPrice = "".obs;
  var rooms = "".obs;
  var bathrooms = "".obs;
  var propertyType = "".obs;
  var selectedPropertyTypeID = "".obs;
  var page = 1.obs;
  var currentColType = "latest".obs;
  var currentOrder = "".obs;
  var selctedType = 0.obs;
  var features1 = [
    "Penthouse",
    "Sea View",
    "Lake View",
    "Swimming Pool View",
    "Original Condition",
    "Low Floor",
    "Colonial Building"
  ].obs;
  var features2 = [
    "Corner Unit",
    "City View",
    "Park Greenery View",
    "Renovated",
    "Ground Floor",
    "High Floor"
  ].obs;

  void resetFilters() {
    selectedCountry.value = "";
    selectedCountryID.value = "";
    selectedLocation.value = "";
    minPrice.value = "";
    maxPrice.value = "";
    rooms.value = "";
    bathrooms.value = "";
    propertyType.value = "";
    selectedPropertyTypeID.value = "";
    currentColType.value = "latest";
    currentOrder.value = "";
    sortType.value = "";
    selectedIndex.value = -1;
    selctedType.value = 0;
  }

  void splitList(List<dynamic> l) {
    var datalist1 = [];
    var datalist2 = [];

    if (l.length < 2) {}
    for (int i = 0; i < (l.length / 2).toInt(); i++) {
      datalist1.add(l[i]);
    }
    for (int i = (l.length / 2).toInt(); i < l.length; i++) {
      datalist2.add(l[i]);
    }

    features1.value = datalist1.map((e) => '$e').toList();
    features2.value = datalist2.map((e) => '$e').toList();
    print("features 1 and 2 chaged");
  }

  Future fetchDetails(id) async {
    print("called fetch details");
    var datalist = await PopularRealEstateAPI.getPropertyDetails(id);
    propertydetailslist.value = datalist;
    print("here is the response overview ${propertydetailslist}");
    if (propertydetailslist[0].features!.length != 0) {
      if (propertydetailslist[0].features!.length > 1)
        splitList(propertydetailslist[0].features!);
      else {
        features1.value =
            propertydetailslist[0].features!.map((e) => '$e').toList();
        features2.value = [];
      }
    }
    return datalist;

    // print(propertydetailslist[0].features);
  }

  void openDetailedFilterSheet(int type, BuildContext context) {
    if (type == 2) {
      if (selectedCountry.value.isEmpty) {
        Get.showSnackbar(properbuzSnackBar(
            AppLocalizations.of("Please select a country first")));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterLocationSearchPage()));
      }
    } else {
      Get.bottomSheet(
          DetailedFilterBottomSheet(
            filterType: type,
            title: getTitle(type),
          ),
          enableDrag: false,
          isScrollControlled: true,
          ignoreSafeArea: false,
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0))));
    }
  }

  String getTitle(int val) {
    switch (val) {
      case 1:
        return AppLocalizations.of("Select") +
            " " +
            AppLocalizations.of("country");
        break;
      case 2:
        return AppLocalizations.of("Select") +
            " " +
            AppLocalizations.of("Location");
        break;
      case 3:
        return AppLocalizations.of("Select") +
            " " +
            AppLocalizations.of("Minimum") +
            " " +
            AppLocalizations.of("Price");
        break;
      case 4:
        return AppLocalizations.of("Select") +
            " " +
            AppLocalizations.of("Maximum") +
            " " +
            AppLocalizations.of("Price");
        break;
      case 5:
        return AppLocalizations.of("Select") +
            " " +
            AppLocalizations.of("Rooms");
        break;
      case 6:
        return AppLocalizations.of("Select") +
            " " +
            AppLocalizations.of("Property Type");
        break;
      default:
        return AppLocalizations.of("Select") +
            " " +
            AppLocalizations.of("Value");
        break;
    }
  }

  void getPriceRanges() async {
    minPrice.value = "";
    maxPrice.value = "";
    int val = 1;
    if (selectedTab.value == 1) {
      val = 2;
    }
    var ranges = await ProperbuzHomeApi.fetchPriceRanges(val);
    minPricesList.assignAll(ranges);
    maxPricesList.assignAll(ranges);
    print(minPricesList.length.toString() + " min list");
  }

  void getBedrooms() async {
    var bedroomData = await ProperbuzHomeApi.getBedrooms();
    bedrooms.assignAll(bedroomData);
  }

  void getFilterCountries() async {
    var countries = await PropertyAPI.fetchFilterCountries();
    countriesList.assignAll(countries);
  }

  void getFilterPropertyTypes() async {
    var propertyTypes = await PropertyAPI.fetchFilterPropertyTypes();
    propertyTypesList.assignAll(propertyTypes);
  }

  void getLocations() {
    if (selectedLocation.value.isNotEmpty) {
      isLocationLoading.value = true;
      ProperbuzHomeApi.fetchLocations(
              selectedCountry.value, selectedLocation.value)
          .then((value) {
        locations.assignAll(value);
        isLocationLoading.value = false;
      });
    } else {
      locations.clear();
    }
  }

  @override
  void onInit() {
    WebView.platform = SurfaceAndroidWebView();
    ProperbuzController controller = Get.put(ProperbuzController());
    selctedType.value = controller.selctedType.value;
    debounce(selectedLocation, (_) {
      getLocations();
    }, time: Duration(milliseconds: 800));
    getPriceRanges();
    getBedrooms();
    getFilterCountries();
    getFilterPropertyTypes();
    super.onInit();
  }

  List<HotPropertiesModel> properties(int val) {
    if (val == 1) {
      return hotProperties;
    } else if (val == 2) {
      return savedProperties;
    } else if (val == 3) {
      return searchedProperties;
    } else {
      return alertProperties;
    }
  }

  void deleteController() {
    Get.delete<PropertiesController>();
  }

  void switchTabs(int? index) {
    selectedTab.value = index!;
    getPriceRanges();
    selctedType.value = index + 1;
  }

  void switchUserPropertyTabs(int index) {
    currentIndex.value = index;
  }

  void changePropertyImagesPage(int page, int index, int val) {
    properties(val)[index].selectedPhotoIndex!.value = page;
  }

  void changeHomeIndex(int index, int val) {
    // hotProperties[index].selectedPhotoIndex.value = 0;
    hotProperties[index].selectedPhotoIndex!.value = val;
    print(hotProperties[index].selectedPhotoIndex!.value);
  }

  void changePropertyFloorPage(int page, int index, int val) {
    properties(val)[index].selectedFloorIndex!.value = page;
  }

  // void changeFloorIndex(int index, int val) {
  //   hotProperties[index].selectedFloorIndex.value = val;
  //   print(hotProperties[index].selectedFloorIndex.value);
  // }

  void changePropertyContentIndex(int index) {
    propertyContentIndex.value = index;
  }

  var saveLoding = false.obs;

  void getSavedProperties() async {
    savedProperties.clear();
    saveLoding.value = true;
    savedPage.value = 1;
    var data = await PropertyAPI.fetchSavedProperties(savedPage.value);
    data.forEach((element) {
      if (element.images!.isEmpty) {
        element.images!.addAll(images);
      }
    });
    print("saved prop data=$data");

    savedProperties.value = data;
    saveLoding.value = false;
  }

  void refreshSaveProperties() async {
    savedPage.value = 1;
    savedProperties.clear();
    saveLoding.value = true;
    print("saved prop data");
    var data = await PropertyAPI.fetchSavedProperties(savedPage.value);

    if (data != null) {
      data.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      savedProperties.addAll(data);
      print("saved prop data=$data");
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshCompleted();
    }

    saveLoding.value = false;
  }

  void loadMoreSavedProperties() async {
    savedPage.value++;
    var data = await PropertyAPI.fetchSavedProperties(savedPage.value);

    if (data != null) {
      data.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      print("saved prop data=$data");

      savedProperties.addAll(data);

      refreshController.loadComplete();
    } else {
      refreshController.loadComplete();
    }
  }

// ============================================================
  var alertLoding = false.obs;

  void getAlertProperties() async {
    alertPage.value = 1;
    alertProperties.clear();
    alertLoding.value = true;
    print("alert prop data--");
    var data = await PropertyAPI.fetchAlertpropperties(alertPage.value);
    data.forEach((element) {
      if (element.images!.isEmpty) {
        element.images!.addAll(images);
      }
    });
    print("alert prop data=$data");

    alertProperties.value = data;
    alertLoding.value = false;
  }

  void refreshAlertProperties() async {
    alertPage.value = 1;
    alertProperties.clear();
    alertLoding.value = true;
    print("alert prop data--");
    var data = await PropertyAPI.fetchAlertpropperties(alertPage.value);

    if (data != null) {
      data.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      alertProperties.addAll(data);
      print("alert prop data=$data");
      refreshController1.refreshCompleted();
    } else {
      refreshController1.refreshCompleted();
    }

    alertLoding.value = false;
  }

  void loadMoreAlertProperties() async {
    alertPage.value++;
    print("alert prop data--");
    var data = await PropertyAPI.fetchAlertpropperties(alertPage.value);

    if (data != null) {
      data.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      print("alert prop data=$data");

      alertProperties.addAll(data);

      refreshController1.loadComplete();
    } else {
      refreshController1.loadComplete();
    }
  }

// ============================================================

  var sortType = "".obs;

  void searchFilter({String? coltype, String? order}) async {
    Get.back();
    isLoadingSearch.value = true;
    searchedProperties.clear();
    page.value = 1;
    print("search sort data------");
    ProperbuzController controller = Get.put(ProperbuzController());
    // currentIndex.value = selectedTab.value + 1;
    var data = await PropertyAPI.fetchSearchedProperties(
        page.value,
        minPrice.value,
        maxPrice.value,
        selctedType.value,
        rooms.value,
        controller.message.value.replaceAll(" ", "_"),
        CurrentUser().currentUser.country!,
        selectedPropertyTypeID.value,
        currentColType.value,
        currentOrder.value);
    data.forEach((element) {
      if (element.images!.isEmpty) {
        element.images!.addAll(images);
      }
    });
    searchedProperties.assignAll(data);
    isLoadingSearch.value = false;
  }

  void getSearchedProperties({location: '', sortBy: ''}) async {
    isLoadingSearch.value = true;
    searchedProperties.clear();
    page.value = 1;
    ProperbuzController controller = Get.put(ProperbuzController());
    selctedType.value = controller.selctedType.value;
    var data = await PropertyAPI.fetchSearchedProperties(
        page.value,
        minPrice.value,
        maxPrice.value,
        selctedType.value,
        rooms.value,
        controller.messageId.value,
        selectedCountryID.value,
        selectedPropertyTypeID.value,
        "",
        "",
        listingType:
            controller.selctedType.toString() == "1" ? 'SALE' : 'RENTAL',
        areaId: controller.messageId.value);
    print("i am here 2");
    data.forEach((element) {
      if (element.images!.isEmpty) {
        element.images!.addAll(images);
      }
    });
    searchedProperties.assignAll(data);
    isLoadingSearch.value = false;
  }

  Future<void> propertSearchLoadMoreData() async {
    page.value++;
    // currentIndex.value = selectedTab.value + 1;
    ProperbuzController controller = Get.put(ProperbuzController());
    var propertyData = await PropertyAPI.fetchSearchedProperties(
        page.value,
        minPrice.value,
        maxPrice.value,
        selctedType.value,
        rooms.value,
        controller.message.value.replaceAll(" ", "_"),
        CurrentUser().currentUser.country!,
        selectedPropertyTypeID.value,
        currentColType.value,
        currentOrder.value);

    if (propertyData != null) {
      propertyData.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      searchedProperties.addAll(propertyData);
      refreshController.loadComplete();
    } else {
      refreshController.loadComplete();
    }
  }

  void propertSearchRefreshData() async {
    page.value = 1;
    isLoadingSearch.value = true;
    // currentIndex.value = 0;
    resetFilters();
    ProperbuzController controller = Get.put(ProperbuzController());
    var propertyData = await PropertyAPI.fetchSearchedProperties(
        page.value,
        minPrice.value,
        maxPrice.value,
        selctedType.value,
        rooms.value,
        controller.message.value.replaceAll(" ", "_"),
        CurrentUser().currentUser.country!,
        selectedPropertyTypeID.value,
        "latest",
        "");

    if (propertyData != null) {
      propertyData.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      searchedProperties.assignAll(propertyData);
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshCompleted();
    }
    isLoadingSearch.value = false;
  }

  void getHotProperties() async {
    hotPropertyLoding.value = true;
    var data = await PropertyAPI.fetchHotProperties(
        hotPropertiesPage.value,
        "",
        selectedTab.value + 1,
        selectedCountryID.value,
        selectedLocation.value,
        minPrice.value,
        maxPrice.value,
        rooms.value,
        selectedPropertyTypeID.value);
    data.forEach((element) {
      if (element.images!.isEmpty) {
        element.images!.addAll(images);
      }
    });
    hotProperties.assignAll(data);
    hotPropertyLoding.value = false;
  }

  // void saveAndUnSave(int index, int val) {
  //   properties(val)[index].savedStatus.value =
  //       !properties(val)[index].savedStatus.value;
  //   PropertyAPI.saveUnsave(properties(val)[index].propertyId);
  // }

  void saveUnsaveDetailed(int index, int val) {
    properties(val)[index].savedStatus!.value =
        !properties(val)[index].savedStatus!.value;
    PropertyAPI.savUnsaveProperty(properties(val)[index].propertyId!);
  }

// ================================================================
  void alertUnalertDetailed(int index, int val) {
    properties(val)[index].alertStatus!.value =
        !properties(val)[index].alertStatus!.value;
    PropertyAPI.addToalertsection(properties(val)[index].propertyId!);
  }
// =================================================================

  void unsaveProperty(int index) {
    String id = savedProperties[index].propertyId!;
    savedProperties.removeAt(index);
    PropertyAPI.savUnsaveProperty(id);
  }

// ==============================================
  void unalertProperty(int index) {
    String id = alertProperties[index].propertyId!;
    alertProperties.removeAt(index);
    PropertyAPI.addToalertsection(id);
  }

// ==============================================
  void removeProperty(int index, int val) {
    properties(val).removeAt(index);
    PropertyAPI.deleteProperty(properties(val)[index].propertyId!);
  }

  void removePropertyDetailed(int index, int val, BuildContext context) {
    Navigator.pop(context);
    properties(val).removeAt(index);
    PropertyAPI.deleteProperty(properties(val)[index].propertyId!);
  }

  var hotPropertyLoding = false.obs;

  void sortHotProperties(String sort) async {
    Get.back();
    hotPropertyLoding.value = true;
    hotPropertiesPage.value = 1;
    hotProperties.clear();
    selectedSort.value = sort;
    var data = await PropertyAPI.fetchHotProperties(
        hotPropertiesPage.value,
        sort,
        selectedTab.value + 1,
        selectedCountryID.value,
        selectedLocation.value,
        minPrice.value,
        maxPrice.value,
        rooms.value,
        selectedPropertyTypeID.value);
    data.forEach((element) {
      if (element.images!.isEmpty) {
        element.images!.addAll(images);
      }
    });
    hotProperties.assignAll(data);
    hotPropertyLoding.value = false;
  }

  void loadMoreData() async {
    hotPropertiesPage.value++;
    var propertyData = await PropertyAPI.fetchHotProperties(
        hotPropertiesPage.value,
        selectedSort.value ?? "",
        selectedTab.value + 1,
        selectedCountryID.value,
        selectedLocation.value,
        minPrice.value,
        maxPrice.value,
        rooms.value,
        selectedPropertyTypeID.value);
    if (propertyData != null) {
      propertyData.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      hotProperties.addAll(propertyData);
      refreshController.loadComplete();
    } else {
      refreshController.loadComplete();
    }
  }

  void refreshData() async {
    resetFilters();
    hotPropertiesPage.value = 1;
    var propertyData = await PropertyAPI.fetchHotProperties(
        hotPropertiesPage.value,
        "",
        selectedTab.value + 1,
        selectedCountryID.value,
        selectedLocation.value,
        minPrice.value,
        maxPrice.value,
        rooms.value,
        selectedPropertyTypeID.value);
    if (propertyData != null) {
      propertyData.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      hotProperties.assignAll(propertyData);
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshCompleted();
    }
  }

  void callAgent(String number) async {
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }

  void emailAgent(String email) async {
    final url = Uri.encodeFull('mailto:$email?subject=Property Enquiry&body=');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
