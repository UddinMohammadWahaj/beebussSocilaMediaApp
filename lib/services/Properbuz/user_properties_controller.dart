import 'package:bizbultest/models/Properbuz/featured_prop_analytics_prop_info_model.dart';
import 'package:bizbultest/models/Properbuz/featured_propert_location_list_model.dart';
import 'package:bizbultest/models/Properbuz/featured_properties_analytics_model.dart';
import 'package:bizbultest/models/Properbuz/featured_property_graph_data_model.dart';
import 'package:bizbultest/models/Properbuz/hot_properties_model.dart';
import 'package:bizbultest/models/Properbuz/manage_properties_model.dart';
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_overview_model.dart';
import 'package:bizbultest/services/Properbuz/api/add_prop_api.dart';
import 'package:bizbultest/services/Properbuz/api/featured_property_analytics_api.dart';
import 'package:bizbultest/services/Properbuz/api/insights_api.dart';
import 'package:bizbultest/services/Properbuz/api/manage_properties_api.dart';
import 'package:bizbultest/services/Properbuz/api/populare_real_estate_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/api.dart';
import '../../models/Properbuz/edit_property_model.dart';
import '../current_user.dart';
import 'api/properties_api.dart';

class UserPropertiesController extends GetxController {
  var revLoding = false.obs;
  var currentIndex = 0.obs;
  var totalsales = 0.obs;
  var salePropertyList = [].obs;
  List photos = [].obs;
  var selectedPge = 1.obs;
  var isShare = false.obs;
  TabController? userPropertiesController;
  TabController? managePropertiesController;
  TextEditingController writeShareFeed = new TextEditingController();
  var featuredProperties = <FeaturedPropertiesAnalyticsModel>[].obs;
  var featuredPropertiesLocationList =
      <FeaturedPropertyLocationListModel>[].obs;

  var manageProperties = <ManagePropertiesModel>[].obs;
  var saleProperties = <ManagePropertiesModel>[].obs;
  var rentalProperties = <ManagePropertiesModel>[].obs;

  PageController managepropertyvirtualTourPageController = PageController();
  PageController managepropertypageController = PageController();
  CarouselController managepropertycarouselController = CarouselController();
  var managepropertyContentIndex = 0.obs;
  var managepropertyfeatures1 = [
    "Penthouse",
    "Sea View",
    "Lake View",
    "Swimming Pool View",
    "Original Condition",
    "Low Floor",
    "Colonial Building"
  ].obs;
  var managepropertyfeatures2 = [
    "Corner Unit",
    "City View",
    "Park Greenery View",
    "Renovated",
    "Ground Floor",
    "High Floor"
  ].obs;
  var savedProperties = <HotPropertiesModel>[].obs;
  var alertProperties = <HotPropertiesModel>[].obs;
  var savedPage = 1.obs;
  var alertPage = 1.obs;
  var managepropertydetailslist = <PopularOverviewModel>[].obs;
  var loactionReviewList = [].obs;

  Future<List> getRev() async {
    revLoding.value = true;
    var data = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/get_my_reviews_list.php?user_id=${CurrentUser().currentUser.memberID}');

    // print('getrev data =${data.data['data'].len}');
    loactionReviewList.value = data.data['data'];
    revLoding.value = false;
    return loactionReviewList;
  }

  var currentIndex1 = 1.obs;

  void openYouTube(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void changeIndex(int page) {
    currentIndex1.value = page + 1;
  }

  void changePropertyImagesPage(int page, int index, int val) {
    value(val)[index].selectedPhotoIndex!.value = page;
  }

  void changePropertyFloorPage(int page, int index, int val) {
    value(val)[index].selectedFloorIndex!.value = page;
  }

  void shareProp(String id, String shareUrl, Function callback,
      {String msg: ""}) async {
    var data =
        await PopularRealEstateAPI.sharePropertyToFeed(id, shareUrl, msg: msg);
    callback(data);
    print("shareddd $data");
  }

  String managepropertyfetchNearby(String lat, String long, String type) {
    return PopularRealEstateAPI.getNearbyLoc(lat, long, type);
  }

  String managepropertyfetchStreetView(String lat, String long) {
    return PopularRealEstateAPI.getStreetView(lat, long);
  }

  void changePropertyContentIndex(int index) async {
    managepropertyContentIndex.value = index;
    print("its working");
  }

  var selectedfeaturedanalyticspropname = ''.obs;
  var selectedfeaturedanalyticspropid = ''.obs;
  var isLoadFeatured = false.obs;
  var analyticsgraphdata = <FeaturedAnalyticsGraphDataModel>[].obs;
  var graphdatalist = <double>[].obs;
  var featuredanalyticspropinfo = <FeaturedAnalyticsPropertyInfoModel>[].obs;

  void getGraphData(String id) async {
    var data = await FeaturedPropertyAnalyticsAPI.fetchGraphData(id);
    if (data != null) {
      analyticsgraphdata.value = [data];
      print(analyticsgraphdata[0]);
      var datalist = <double>[];
      analyticsgraphdata[0].graphData!.forEach((element) {
        datalist.add(double.parse(element.viewed!));
      });
      graphdatalist.value = datalist;
    }
  }

  void getFeaturedPropertyList(VoidCallback callback) async {
    var data = await FeaturedPropertyAnalyticsAPI.fetchFeaturedPropList();
    featuredPropertiesLocationList.value = data;
    isLoadFeatured.value = false;

    callback();
  }

  void getFeaturedPropertyInfo() async {
    var data = await FeaturedPropertyAnalyticsAPI.fetchFeaturePropInfo();
    featuredanalyticspropinfo.value = data;
  }

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

  var viewInsightsLoder = false.obs;

  Future<Map<String, dynamic>> getInsights(String? propertyID) async {
    viewInsightsLoder.value = true;
    var data = await InsightsAPI.getInsights(propertyID!);
    viewInsightsLoder.value = false;
    return data;
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

    managepropertyfeatures1.value = datalist1.map((e) => '$e').toList();
    managepropertyfeatures2.value = datalist2.map((e) => '$e').toList();
    print("features 1 and 2 chaged");
  }

  Future fetchDetails(id) async {
    print("called fetch details");
    var datalist = await PopularRealEstateAPI.getPropertyDetails(id);
    managepropertydetailslist.value = datalist;
    print("here is the response overview ${managepropertydetailslist}");
    if (managepropertydetailslist[0].features!.length != 0) {
      if (managepropertydetailslist[0].features!.length > 1)
        splitList(managepropertydetailslist[0].features!);
      else {
        managepropertyfeatures1.value =
            managepropertydetailslist[0].features!.map((e) => '$e').toList();
        managepropertyfeatures2.value = [];
      }
    }
    return datalist;

    // print(propertydetailslist[0].features);
  }

  List<ManagePropertiesModel> value(int val) {
    switch (val) {
      case 1:
        return saleProperties.value;
      case 2:
        return rentalProperties.value;
      default:
        return saleProperties.value;
    }
  }

  void deleteFile(int index) {
    selectedPge.value = index - 1;
    photos.removeAt(index);
  }

  void getSavedProperties() async {
    var data = await PropertyAPI.fetchSavedProperties(savedPage.value);
    data.forEach((element) {
      if (element.images!.isEmpty) {
        element.images!.addAll(images);
      }
    });
    savedProperties.assignAll(data);
    print(savedProperties.length.toString() + " lennnnnnn");
  }

  void getAlertProperties() async {
    var data = await PropertyAPI.fetchAlertpropperties(alertPage.value);
    data.forEach((element) {
      if (element.images!.isEmpty || element.images!.length < 6) {
        element.images!.addAll(images);
      }
    });
    alertProperties.assignAll(data);
    print(alertProperties.length.toString() + " lennnnnnn");
  }

  void unsaveProperty(int index) {
    String id = savedProperties[index].propertyId!;
    savedProperties.removeAt(index);
    PropertyAPI.saveUnsave(id);
  }

  // void getFeaturedProperties() async {
  //   var data = await PropertyAPI.fetchFeaturedProperties();

  //   featuredProperties.addAll(data);
  // }

  var managepropertyLoding = false.obs;

  void getManageProperties() async {
    managepropertyLoding.value = true;
    var data = await ManagePropertiesAPI.manageProperties();

    if (data != null) {
      data.forEach((element) {
        if (element.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
    }

    managepropertyLoding.value = false;
    saleProperties.value = data.where((e) {
      return e.listingtype == "SALE";
    }).toList();

    rentalProperties.value = data.where((e) {
      return e.listingtype != "SALE";
    }).toList();
    // print('Sale prop ${saleProperties} ${saleProperties.length}');
    // print('Rental data prop ${rentalProperties[0].images} ${data.length}');
    // manageProperties.addAll(data);
  }

  var managePropertiesPage = 1.obs;
  void loadManageProperties(type, VoidCallback loadComplete) async {
    var data = await ManagePropertiesAPI.manageProperties(
        page: '${managePropertiesPage++}', type: type);
    if (data.length == 0) {
      managePropertiesPage--;
      return;
    }
    if (type == 'rental') {
      var temp = rentalProperties.value;

      temp.addAll(data);
      rentalProperties.value = temp;
    } else {
      var temp = saleProperties.value;
      temp.addAll(data);
      saleProperties.value = temp;
    }
    loadComplete();
  }

  @override
  void onInit() async {
    getRev();
    getSavedProperties();
    getAlertProperties();
    getFeaturedPropertyInfo();
    // getFeaturedProperties();
    getManageProperties();
    super.onInit();
    // await Dio()
    //     .get(
    //         'https://www.bebuzee.com/webservices/get_manage_property_list.php?agent_id=${4}')
    //     .then((value) {
    //   print(value.data[0]['property_id']);
    //   print("length=${value.data.length}");
    //   totalsales.value = value.data.length;
    //   salePropertyList.value = value.data;
    //   print("sales property list ${salePropertyList.first}");
    // });/
  }

  void switchTabs(int index) {
    currentIndex.value = index;
  }

  properties(int val) {}
  var floorImagesNew = [].obs;

  Future getFloorImages(proid) async {
    var data = await AddPropertyAPI.getEditPropertyDetail(proid);
    print("------ 22 ${data.country}");

    floorImagesNew.value = data.floorimages;
    print("------ 33 ${data.floorimages}");
  }
}
