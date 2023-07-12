import 'dart:core';

import 'package:bizbultest/models/Properbuz/add_property_list_model.dart';
import 'package:bizbultest/models/Properbuz/location_categories_model.dart';
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_overview_model.dart';
import 'package:bizbultest/services/Properbuz/api/populare_real_estate_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/utils/popularenum.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Language/appLocalization.dart';
import 'api/add_prop_api.dart';
import 'api/properties_api.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

class PopularRealEstateMarketController extends GetxController {
  String country;
  String city;
  TextEditingController writeShareFeed = new TextEditingController();
  PopularRealEstateMarketController(this.country, this.city);
  var lstofpopularrealestatemodel = <LocationCategoriesModel>[].obs;
  var propertytypelist = <AddPropertyListModel>[].obs;
  Color appBarColor = HexColor("#2b6482");
  Color appBarLightColor = HexColor("#488aa4");
  Color settingsColor = HexColor("#3c5f6e");
  Color featuredColor = HexColor("#377fa9");
  Color iconColor = HexColor("#6d8f9f");
  Color statusBarColor = HexColor("#1e475b");
  var selectedTab = 0.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  PageController virtualTourPageController = PageController();
  PageController pageController = PageController();
  CarouselController carouselController = CarouselController();
  var coltype = 1.obs;
  var popularpage = 1.obs;

  var visibilityKey = GlobalKey();
  var isContactVisible = false.obs;
  var currentPropertyType = ''.obs;
  var currentPropertyTypeIndex = 0.obs;
  var currrentPropertyCode = ''.obs;
  var iscurrentPropertyLoad = false.obs;

  var currentBedroom = ''.obs;
  var currentBedroomIndex = 0.obs;
  var iscurrentBedroomLoad = false.obs;

  var currentBathroomIndex = 0.obs;
  var currentBathroom = ''.obs;
  var iscurrentBathroomLoad = false.obs;

  var currentMaxPrice = ''.obs;
  var iscurrentMaxPriceLoad = false.obs;
  var currentMaxPriceIndex = 0.obs;

  var currentMinPrice = ''.obs;
  var iscurrentMinPriceLoad = false.obs;
  var currentMinPriceIndex = 0.obs;
  var propertydetailslist = <PopularOverviewModel>[].obs;
  var selectedPhotoIndex = 0.obs;
  var pricelistsale = [].obs;
  var pricelistrental = [].obs;
  var isSearch = false.obs;
  var isShare = false.obs;
  var neighbourhood = "This is the Neighbourhood. ".obs;

  var currentSearchType = 'Sale'.obs;
  var currentOrder = ''.obs;
  var currentColType = 'latest'.obs;
  var propertyDescription = ''.obs;

  var selectedIndex = 0.obs;

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

  List<String> sortList = [
    AppLocalizations.of("Latest"),
    AppLocalizations.of("Featured"),
    AppLocalizations.of("Maximum") + " " + AppLocalizations.of("Price"),
    AppLocalizations.of("Minimum") + " " + AppLocalizations.of("Price"),
    AppLocalizations.of("Minimum") + " " + AppLocalizations.of("Area"),
    AppLocalizations.of("Maximum") + " " + AppLocalizations.of("Area"),
    // "Min rooms",
    // "Max rooms"
  ];
  var fetchListLoader = false.obs;
  var filterdatalist = <LocationCategoriesModel>[].obs;
  var propertyContentIndex = 0.obs;
  void fetchListPopularRealEstate(String country, String city) async {
    fetchListLoader.value = true;
    List<LocationCategoriesModel> lstofloccatmodels =
        await PopularRealEstateAPI.getData(country, city);
    lstofloccatmodels.forEach((element) {
      if (element.images!.isEmpty) {
        print("emptyt uimage ");
        element.images!.addAll(images);
      }
    });
    print('baal ');
    lstofpopularrealestatemodel.value = lstofloccatmodels;
    fetchListLoader.value = false;

    print('baal ---- ${lstofpopularrealestatemodel.value}');
  }

  var selectedType = 0.obs;
  var bathroomlist = [].obs;
  var bedroomlist = [].obs;

  void switchTabs(int index) {
    selectedTab.value = index;
    selectedType.value = index + 1;
  }

  void changePropertyImagesPage(int page, int index) {
    lstofpopularrealestatemodel[index].selectedPhotoIndex!.value = page;
  }

  void changePropertyFloorPage(int page, int index) {
    lstofpopularrealestatemodel[index].selectedFloorIndex!.value = page;
  }

  String getcoltype(int val) {
    coltype.value = val;
    switch (val) {
      case 1:
        return "latest";
      case 2:
        return "featured";
      default:
        return "latest";
    }
  }

  String fetchNearby(String lat, String long, String type) {
    return PopularRealEstateAPI.getNearbyLoc(lat, long, type);
  }

  String fetchStreetView(String lat, String long) {
    return PopularRealEstateAPI.getStreetView(lat, long);
  }

  void refreshData() async {
    fetchListLoader.value = true;
    popularpage.value = 1;
    lstofpopularrealestatemodel.clear();
    reset();
    var propertyData = await PopularRealEstateAPI.getData(country, city,
        page: '${popularpage.value}');
    if (propertyData != null) {
      propertyData.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      lstofpopularrealestatemodel.assignAll(propertyData);
      refreshController.refreshCompleted();
    } else {
      print("nullhai");
      refreshController.refreshCompleted();
    }
    fetchListLoader.value = false;
  }

  void saveAndUnSave(int index) {
    print(
        "prev saved status=${lstofpopularrealestatemodel[index].savedStatus!.value}");
    lstofpopularrealestatemodel[index].savedStatus!.value =
        !lstofpopularrealestatemodel[index].savedStatus!.value;

    print(
        "current saved status=${lstofpopularrealestatemodel[index].savedStatus!.value}");
    PropertyAPI.savUnsaveProperty(
        lstofpopularrealestatemodel[index].propertyId!);
  }

  void loadMoreData() async {
    print("load more data called");
    popularpage.value++;
    var datalist = await PopularRealEstateAPI.getFilterDataList(country, city,
        page: '${popularpage.value}',
        bathroomcount: currentBathroom.value,
        bedroomcount: currentBedroom.value,
        coltype: currentColType.value,
        maxprice: currentMaxPrice.value,
        order: currentOrder.value,
        propertytype: currentPropertyType.value,
        searchtype: currentSearchType.value,
        type: selectedType.value.toString());

    // getData(country, city, page: '${popularpage.value}');
    if (datalist != null) {
      datalist.forEach((element) {
        if (element.images!.isEmpty || element.images!.length == 0) {
          element.images!.addAll(images);
        }
      });
      lstofpopularrealestatemodel.addAll(datalist);
      refreshController.loadComplete();
    } else {
      print("nullhai");
      refreshController.loadComplete();
    }
  }

  void changePropertyContentIndex(int? index) async {
    propertyContentIndex.value = index!;
    print("its working");
  }

  void reset() {
    currentBedroom.value = '';
    currentBedroomIndex.value = 0;
    currentBathroom.value = '';
    currentBathroomIndex.value = 0;
    currentMaxPrice.value = '';
    currentMaxPriceIndex.value = 0;
    currentPropertyType.value = '';
    currentPropertyTypeIndex.value = 0;
    currrentPropertyCode.value = "";
    currentMinPrice.value = '';
    currentMaxPrice.value = '';
    currentOrder.value = '';
    currentSearchType.value = 'Sale';
    selectedType.value = 0;
    print("value reset");
  }

  void removeProperty(int index) {
    // properties(val).removeAt(index);
    lstofpopularrealestatemodel.removeAt(index);
    PropertyAPI.deleteProperty(lstofpopularrealestatemodel[index].propertyId!);
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

  void searchFilter(
      {String? searchtype,
      String? propertytype,
      String? coltype,
      String? maxprice,
      String? bedroomcount,
      String? bathroomcount,
      String? order,
      String? page}) async {
    print("${this.country} ${this.city}");
    // currentColType.value = coltype;
    popularpage.value = 1;
    fetchListLoader.value = true;
    var datalist = await PopularRealEstateAPI.getFilterDataList(
        this.country, this.city,
        coltype: currentColType.value ?? "latest",
        bathroomcount: currentBathroom.value ?? "",
        maxprice: currentMaxPrice.value ?? "",
        order: currentOrder.value ?? "",
        propertytype: currentPropertyType.value ?? "",
        bedroomcount: currentBedroom.value ?? "",
        searchtype: currentSearchType.value ?? "Sale",
        page: '${popularpage.value ?? 1}',
        type: selectedType.value.toString());
    fetchListLoader.value = false;
    for (int i = 0; i < datalist.length; i++)
      print("datalistprice =${datalist[i]}");

    if (datalist != null) {
      datalist.forEach((element) {
        if (element.images!.isEmpty || element.images!.length == 0) {
          element.images!.addAll(images);
        }
      });
    }

    lstofpopularrealestatemodel.value = datalist;
  }

  // void followTheAgent(String agentId, int index) async {
  //   if (!lstofpopularrealestatemodel[index].followStatus.value) {
  //     await PopularRealEstateAPI.followAgent(agentId);
  //   } else {
  //     await PopularRealEstateAPI.unfollowAgent(agentId);
  //   }
  //   print("the function is called");
  //   lstofpopularrealestatemodel[index].followStatus.value =
  //       !lstofpopularrealestatemodel[index].followStatus.value;
  // }

  var followStatus;
  Future<String> followUser(String otherMemberId) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_follow_unfollow.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": otherMemberId,
      "follow_status": followStatus,
    });

    print(response!.data['data']);
    if (response!.success == 1) {
      print("followed user =${response!.data['data']}");
      followStatus = response!.data['data']['follow_status'];
    }
    return "success";
  }

  Future<String> unfollow(String unfollowerID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_follow_unfollow.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": unfollowerID,
      "follow_status": followStatus,
    });

    if (response!.success == 1) {
      print("unfollow user =${response!.data}");

      followStatus = response!.data['data']['follow_status'];

      print(response!.data['data']);
    }

    return "success";
  }

  void followTheAgent(String agentId, int index) async {
    followStatus = lstofpopularrealestatemodel[index].followStatus!.value;
    if (followStatus == 0) {
      await followUser(agentId);
    } else {
      await unfollow(agentId);
    }
    print("the function is called -- $followStatus");

    lstofpopularrealestatemodel[index].followStatus!.value = followStatus;
    //     !propertylist[index].followStatus.value;
  }

  void fetchBathroomList(VoidCallback callback) async {
    iscurrentBathroomLoad.value = true;
    var datalist = await AddPropertyAPI.getBathroomList();
    iscurrentBathroomLoad.value = false;
    // iconLoadBathroom.value = false;
    bathroomlist.value = datalist;
    print("bathroom $bathroomlist");
    callback();
  }

  void fetchBedroomList(VoidCallback callback) async {
    iscurrentBedroomLoad.value = true;
    var datalist = await AddPropertyAPI.getBedroomList();
    iscurrentBedroomLoad.value = false;
    // iconLoadBedroom.value = false;
    bedroomlist.value = datalist;
    callback();
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

  void fetchPriceListSale(VoidCallback callback, Price type) async {
    var datalist = await PopularRealEstateAPI.getPriceListSale();
    pricelistsale.value = datalist;
    callback();
  }

  void fetchPriceListRental(VoidCallback callback) async {
    var datalist = await PopularRealEstateAPI.getPriceListRental();
    pricelistrental.value = datalist;
  }

  void shareProp(String id, String shareUrl, Function callback,
      {String msg: ""}) async {
    print("your country is ${CurrentUser().currentUser.country}");
    var data =
        await PopularRealEstateAPI.sharePropertyToFeed(id, shareUrl, msg: msg);
    callback(data);
    print("shareddd $data");
  }

  void fetchPropertyList(VoidCallback callback) async {
    iscurrentPropertyLoad.value = true;
    var datalist = await AddPropertyAPI.getaddPropertyList();
    iscurrentPropertyLoad.value = false;
    // iconLoadPropertyType.value = false;
    propertytypelist.value = datalist;
    print('list fetch= $propertytypelist');
    callback();
  }

  // void loadMoreData() async {
  //   hotPropertiesPage.value++;
  //   var propertyData = await PropertyAPI.fetchHotProperties(
  //       hotPropertiesPage.value, selectedSort.value);
  //   if (propertyData != null) {
  //     propertyData.forEach((element) {
  //       if (element.images.isEmpty || element.images.length < 6) {
  //         element.images.addAll(images);
  //       }
  //     });
  //     hotProperties.addAll(propertyData);
  //     refreshController.loadComplete();
  //   } else {
  //     refreshController.loadComplete();
  //   }
  // }

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

  @override
  void onInit() {
    // searchFilter(
    //   () {},
    // );
    fetchListPopularRealEstate(this.country, this.city);
    super.onInit();
  }
}
