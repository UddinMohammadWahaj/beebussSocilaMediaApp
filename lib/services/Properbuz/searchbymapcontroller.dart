import 'dart:async';
import 'dart:typed_data';

import 'package:bizbultest/models/Properbuz/SearchTextLocationModel.dart';
import 'package:bizbultest/models/Properbuz/add_property_list_model.dart';
import 'package:bizbultest/models/Properbuz/location_categories_model.dart';
import 'package:bizbultest/models/Properbuz/popular_real_estate_market_overview_model.dart';
import 'package:bizbultest/services/Properbuz/api/properties_api.dart';
import 'package:bizbultest/services/Properbuz/api/searchbymapapi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Wallet/Overview_page.dart';
import 'package:bizbultest/widgets/Properbuz/utils/popularenum.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:helpers/helpers/print.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:location/location.dart' as loc;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

import 'api/add_prop_api.dart';
import 'api/populare_real_estate_api.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

late String newdata;

enum MapSearchType { searchByName, searchByDraw, searchByMetro, searchByNull }

enum TravelTimeSearchType {
  searchByCar,
  searchByBike,
  searchByWalk,
  searchByRadius,
}

class SearchByMapController extends GetxController {
  late MapSearchType maptype;
  SearchByMapController({this.maptype = MapSearchType.searchByNull});
  var currrentTravelTimeSearchType = TravelTimeSearchType.searchByCar.obs;
  var radialdistance = 1325.0.obs;
  TravelTimeSearchType gettravelTimeSearchType(int index) {
    switch (index) {
      case 0:
        print("searchByCar");
        return TravelTimeSearchType.searchByCar;
      case 1:
        print("searchByBike");
        return TravelTimeSearchType.searchByBike;
      case 2:
        print("searchByWalk");
        return TravelTimeSearchType.searchByWalk;
      case 3:
        print("searchByRadius");
        return TravelTimeSearchType.searchByRadius;
      default:
        print("searchByRadius");
        return TravelTimeSearchType.searchByRadius;
    }
  }

  TextEditingController searchTextLoc = TextEditingController();
  Completer<GoogleMapController> mapcontroller = Completer();
  RxSet<Marker> markset = <Marker>{}.obs;
  RxSet<Circle> circleset = <Circle>{}.obs;
  late GoogleMapController controller;
  late Uint8List markerIcon;
  var currentMapSearchType = MapSearchType.searchByNull.obs;
  var circle = Circle(
          circleId: CircleId('id'),
          center: LatLng(0.0, 0.0),
          radius: 0,
          visible: false)
      .obs;
  setCircle(double lat, double long) {
    circle.value = Circle(
        circleId: CircleId('id$lat$long'),
        center: LatLng(lat, long),
        radius: radius.value,
        strokeWidth: 2,
        fillColor: settingsColor.withOpacity(0.5));
  }

  TextEditingController searchLocation = new TextEditingController();
  var textColor = HexColor("#727a85");
  var currentCountry = "".obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var propertylist = <LocationCategoriesModel?>[].obs;
  PageController virtualTourPageController = PageController();
  PageController pageController = PageController();
  CarouselController carouselController = CarouselController();
  var textBgColor = HexColor("#f5f7f6");
  var isdrawonareaenabled = false.obs;
  var drawStatus = 0.obs;
  var mapEnabled = true.obs;
  var message = "".obs;
  var isLocationLoading = false.obs;
  var page = 1.obs;
  var isShare = false.obs;
  var visibilityKey = GlobalKey();
  var propertyContentIndex = 0.obs;
  var travelTimeContentIndex = 0.obs;
  TextEditingController writeShareFeed = new TextEditingController();
  var propertydetailslist = <PopularOverviewModel>[].obs;
  RxList<dynamic> locations = [].obs;
  RxList<Offset> lstoffset = <Offset>[].obs;
  RxList<ScreenCoordinate> lstofcoordinate = <ScreenCoordinate>[].obs;
  var selectedMarker = Marker(
    markerId: MarkerId(''),
    visible: false,
  ).obs;
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

  var filtterApply = false.obs;
  var selectedType = 0.obs;

  var selectedLatLong = <LatLng>[].obs;
  late LatLng currentLocation;
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
  var metrolatlnglist = <LatLng>[].obs;
  var propertytypelist = <AddPropertyListModel>[].obs;
  var currentColType = 'latest'.obs;
  var currentSearchType = 'Sale'.obs;
  var selectedTab = 0.obs;
  var bathroomlist = [].obs;
  var bedroomlist = [].obs;
  var pricelistsale = [].obs;
  var pricelistrental = [].obs;
  var currentOrder = ''.obs;
  var metrostationlist = <Result>[].obs;

  var selectedIndex = 0.obs;

  List<String> sortList = [
    "Latest",
    "Featured",
    "Max price",
    "Min price",
    "Min Area",
    "Max Area",
    // "Min rooms",
    // "Max rooms"
  ];

  void getMetroStation() async {
    print("get Metro called");
    var data = await SearchByMapApi.getMetroStation(currentLocation);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        positonMapToNewLocation(
            data.length != 0
                ? data[0].geometry!.location!.lat!
                : currentLocation.latitude!,
            data.length != 0
                ? data[0].geometry!.location!.lng!
                : currentLocation.longitude)));
    metrostationlist.value = data;
    Set<Marker> testset = {};
    metrostationlist.forEach((element) {
      testset.add(Marker(
          onTap: () {
            circleset.add(Circle(
                circleId: CircleId(
                    'id${element.geometry!.location!.lat}${element.geometry!.location!.lng}'),
                center: LatLng(element.geometry!.location!.lat!,
                    element.geometry!.location!.lng!),
                radius: 1000,
                strokeWidth: 10,
                fillColor: settingsColor.withOpacity(0.5)));

            print("added ${circleset.length} circle");
            selectedLatLong.add(LatLng(element.geometry!.location!.lat!,
                element.geometry!.location!.lng!));

            drawStatus.value = 2;
          },
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(
              '${element.geometry!.location!.lat}${element.geometry!.location!.lng}'),
          position: LatLng(element.geometry!.location!.lat!,
              element.geometry!.location!.lng!)));
    });
    markset.value = testset;
    // metrostationlist.forEach((element) {
    //   addMarker(element.geometry.location.lat, element.geometry.location.lng);
    // });
  }

  var filterLoding = false.obs;

  Future searchFilter({
    String? searchtype,
    String? propertytype,
    String? coltype,
    String? maxprice,
    String? bedroomcount,
    String? bathroomcount,
    String? order,
    String? from,
  }) async {
    filtterApply.value = true;
    metroLoading.value = true;
    page.value = 1;
    var datalist = await SearchByMapApi.getPropertyDeatils(
      selectedLatLong,
      coltype: currentColType.value ?? "",
      bathroomcount: currentBathroom.value ?? "",
      maxprice: maxprice ?? "",
      order: currentOrder.value ?? "",
      propertytype: currrentPropertyCode.value ?? "",
      bedroomcount: currentBedroom.value ?? "",
      searchtype: "",
      distance: "$radius" ?? "",
      fromPage: from!,
      page: page.value,
      type: selectedType.value.toString(),
    );

    print("datalistprice ## 33 =${datalist}");

    metroLoading.value = false;
    if (datalist != null && datalist.isNotEmpty) {
      datalist.forEach((element) {
        if (element!.images!.isEmpty) {
          element!.images!.addAll(images);
        }
      });

      return propertylist.value = datalist!;
    } else if (datalist!.isEmpty || datalist == null) {
      return propertylist.value = [];
    }
  }

  void fetchMetroPropertyList() async {
    page.value = 1;
    metroLoading.value = true;
    print("current selected lat loNG LENGTH-${selectedLatLong.length}");
    var data = await SearchByMapApi.getMetroProperties(selectedLatLong,
        page: page.value, distance: '${radius.value ?? ""}');

    print('list fetch propertylist = ${data}');
    if (data != null) {
      propertylist.value = data!;
    } else {
      propertylist.value = [];
    }
    metroLoading.value = false;
    print('list fetch propertylist = ${propertylist}');
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
    // searchTextLoc.text = '';
    page.value = 1;
    filtterApply.value = false;
    // this.maptype == MapSearchType.searchByName
    //     ? getSearchByName(currentLocation.latitude, currentLocation.longitude,
    //         page: page.value)
    //     : this.maptype == MapSearchType.searchByMetro
    //         ? fetchMetroPropertyList()
    //         : searchFilter(from: '');

    print("value reset");
  }

  void switchTabs(int index) {
    selectedTab.value = index;
    selectedType.value = index + 1;
  }

  void fetchBedroomList(VoidCallback callback) async {
    iscurrentBedroomLoad.value = true;
    var datalist = await AddPropertyAPI.getBedroomList();
    iscurrentBedroomLoad.value = false;
    // iconLoadBedroom.value = false;
    bedroomlist.value = datalist;
    callback();
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

  void fetchPriceListSale(VoidCallback callback, Price type) async {
    var datalist = await PopularRealEstateAPI.getPriceListSale();
    pricelistsale.value = datalist;
    print("get prices $pricelistsale");
    callback();
  }

  void fetchPriceListRental(VoidCallback callback) async {
    var datalist = await PopularRealEstateAPI.getPriceListRental();
    pricelistrental.value = datalist;
  }

  void toggledrawonarea() {
    isdrawonareaenabled.value = !isdrawonareaenabled.value;
  }

  String fetchNearby(String lat, String long, String type) {
    return PopularRealEstateAPI.getNearbyLoc(lat, long, type);
  }

  String fetchStreetView(String lat, String long) {
    return PopularRealEstateAPI.getStreetView(lat, long);
  }

  void changeTravelTimeContentIndex(int index) async {
    travelTimeContentIndex.value = index;
  }

  double getDistanceTravel() {
    switch (currrentTravelTimeSearchType.value) {
      case TravelTimeSearchType.searchByCar:
        return 1000.0;
      case TravelTimeSearchType.searchByBike:
        return 600.0;
      case TravelTimeSearchType.searchByWalk:
        return 300.0;
      default:
        return 250.0;
    }
  }

  void changePropertyContentIndex(int index) async {
    propertyContentIndex.value = index;
    print("its working");
  }

  void shareProp(String id, String shareUrl, Function callback,
      {String msg: ""}) async {
    print("your country is ${CurrentUser().currentUser.country}");
    var data =
        await PopularRealEstateAPI.sharePropertyToFeed(id, shareUrl, msg: msg);
    callback(data);
    print("shareddd $data");
  }

  var isContactVisible = false.obs;
  toPositive(var z) {
    if (z < 0) return -1 * z;
    return z;
  }

  void callAgent(String number) async {
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }

  void getCountry() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        selectedLatLong[0].latitude, selectedLatLong[0].longitude);

    currentCountry.value = placemarks[0].country!;
  }

  void emailAgent(String email) async {
    final url = Uri.encodeFull('mailto:$email?subject=Property Enquiry&body=');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  // String getcoltype(int val) {
  //   coltype.value = val;
  //   switch (val) {
  //     case 1:
  //       return "latest";
  //     case 2:
  //       return "featured";
  //     default:
  //       return "latest";
  //   }
  // }

  void changePropertyImagesPage(int page, int index) {
    propertylist[index]!.selectedPhotoIndex!.value = page;
  }

  void changePropertyFloorPage(int page, int index) {
    propertylist[index]!.selectedFloorIndex!.value = page;
  }

  void convertOffsetToScreenCoordinates() async {
    List<LatLng> testlst = <LatLng>[];
    lstoffset.forEach((element) async {
      var x = element.dx * MediaQuery.of(Get.context!).devicePixelRatio;
      var y = element.dy * MediaQuery.of(Get.context!).devicePixelRatio;
      ScreenCoordinate sc = ScreenCoordinate(x: x.round(), y: y.round());
      LatLng latLng = await controller.getLatLng(sc);

      testlst.add(latLng);
      selectedLatLong.value = testlst;
      // print('aa $latLng');
    });
    // getCountry();
    print("list iof latlng= $selectedLatLong length=${selectedLatLong.length}");
  }

  void fechttsRadiusDetails() async {
    metroLoading.value = true;
    var data = await SearchByMapApi.getMetroProperties([circle.value.center],
        distance: '${radius.value}');
    print('search by radius data list=$data');
    if (data != null) {
      propertylist.value = data;
    } else {
      propertylist.value = [];
    }
    metroLoading.value = false;
  }

  void fetchPropertyDetailsDraw() async {
    metroLoading.value = true;
    page.value = 1;
    print("fetch prop called ${selectedLatLong}");
    var data = await SearchByMapApi.getPropertyDeatils(
      selectedLatLong.value,
      searchtype: "",
      coltype: "",
      maxprice: "",
      bedroomcount: "",
      bathroomcount: "",
      propertytype: "",
      order: "",
      distance: "",
      page: page.value,
      type: selectedType.value.toString(),
    );
    print('fetch prop response=$data');
    if (data == null || data == []) {
      propertylist.value = [];
    } else {
      propertylist.value = data;
    }
    print('fetch prop response 1=-- $propertylist');
    metroLoading.value = false;

    if (propertylist != null || propertylist.length != 0) {
      propertylist.forEach((element) {
        print('fetch prop response 2=-- $element');
        if (element!.images!.length == 0) {
          element!.images = images;
        }
      });
    }
    mapEnabled.value = true;
    lstoffset.clear();
    drawStatus.value = 0;
  }

  var metroLoading = false.obs;

  void fetchPropertyDetails() async {
    print("fetch prop called ${selectedLatLong}");
    page.value = 1;
    propertylist.value = [];
    metroLoading.value = true;
    var data = await SearchByMapApi.getMetroProperties(
        [LatLng(circle.value.center.latitude, circle.value.center.longitude)],
        distance: '${radius.value}', page: page);
    metroLoading.value = false;
    print('fetch prop response=$data');
    this.page.value = int.parse(data![0]!.page!);

    if (data != null) {
      if (propertylist.length == 0)
        propertylist.value = data;
      else {
        List<LocationCategoriesModel?> temp = [];
        temp.addAll(propertylist);
        temp.addAll(data!);
        propertylist.value = temp;
      }

      if (propertylist != null || propertylist.length != 0) {
        propertylist.forEach((element) {
          if (element!.images!.length == 0) {
            element!.images = images;
          }
        });
      }
    } else {
      propertylist.value = [];
    }

    mapEnabled.value = true;

    lstoffset.clear();
    drawStatus.value = 0;

    print("fetch here is the list of ${metroLoading.value}");
  }

  void convertOffsettoLatLng(x, y) async {
    // double screenWidth = MediaQuery.of(Get.context).size.width *
    //     MediaQuery.of(Get.context).devicePixelRatio;
    // double screenHeight = MediaQuery.of(Get.context).size.height *
    //     MediaQuery.of(Get.context).devicePixelRatio;
    // double middleX = screenWidth / 2;
    // double middleY = screenHeight / 2;

    // ScreenCoordinate screenCoordinate =
    //     ScreenCoordinate(x: middleX.round(), y: middleY.round());

    // LatLng middlePoint = await controller.getLatLng(screenCoordinate);

    // LatLng loc = await controller.getLatLng(ScreenCoordinate(x: x, y: y));

    // print("{coord --> $middlePoint");
    // lstofcoordinate.add(screenCoordinate);
    setOffset(Offset(x, y));

    // addMarker(x, y);
  }

  void setOffset(Offset off) {
    lstoffset.add(off);
    print("offset set");

    // selectedMarkers.value.add(Marker(
    //     icon: BitmapDescriptor.defaultMarker,
    //     markerId: null,
    //     position: LatLng(lat, long)));
    print("called list");
    print("selected Marker list =${lstoffset} ");
    print("selected Marker list =${lstofcoordinate} ");
  }

  void convertLatLng() async {
    lstoffset.forEach((element) {
      LatLng(element.dx, element.dy);
    });
  }

  CameraPosition positonMapToCurrentLocation() {
    return CameraPosition(
        bearing: 192.8334901395799,
        target: currentLocation != null
            ? currentLocation
            : LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }

  CameraPosition positonMapToNewLocation(double lat, double long) {
    print("position new loc called $lat $long");

    return CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }

  void ttsaddMarker(double lat, double long) {
    selectedMarker.value = Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('${lat}${long}'),
        position: LatLng(lat, long));
  }

  void getSearchByName(double lat, double lng, {page}) async {
    propertylist.clear();
    print("searched lat lng =$lat $lng");
    metroLoading.value = true;
    var data = await SearchByMapApi.getSearchByName(lat, lng, page: page);

    // this.page.value = int.parse(data[0].page);
    // print('search by map current page=${this.page}');

    if (data.length != 0) {
      print(data);
      if (propertylist.value.length == 0) {
        propertylist.value = data;
      } else {
        List<LocationCategoriesModel?> temp = [];
        temp.addAll(propertylist.value);
        temp.addAll(data);
        propertylist.value = temp;
        print('search by map name =${propertylist.length}');
      }
    }
    metroLoading.value = false;
  }

  void addMarker(double lat, double long) {
    // ignore: invalid_use_of_protected_member
    selectedLatLong.add(LatLng(lat, long));
    // markset.add(Marker(
    //     icon: BitmapDescriptor.defaultMarker,
    //     markerId: MarkerId('${lat}${long}'),
    //     position: LatLng(lat, long))
    //     );
    // selectedMarkers.value.add(

    //
    // );
    print("selected Market List real =${selectedLatLong}");
    print("selected Marker list =${selectedLatLong}");
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setLocation(
      String location, double lat, double long, BuildContext context) async {
    print("Location set ${location}");
    message.value = location;

    Navigator.pop(context);
    await controller.animateCamera(
        CameraUpdate.newCameraPosition(positonMapToNewLocation(lat, long)));
  }

  void getLocations() {
    if (message.value.isNotEmpty) {
      isLocationLoading.value = true;
      AddPropertyAPI.fetchLocations(message.value, "Italy").then((value) {
        value.forEach((element) {
          print(element);
          locations.add(element);
        });
        // locations.assignAll(value);
        isLocationLoading.value = false;
      });
    } else {
      locations.clear();
    }

    print("response location=${locations.value}");
  }

  @override
  void onInit() async {
    // TODO: implement onInit

    if (currrentTravelTimeSearchType.value !=
        TravelTimeSearchType.searchByRadius) {
      radius.value = 5;
    }
    print("OnInitCalled ${this.maptype}");
    // await loc.Location.instance.getLocation().then((value) {
    //   currentLocation = LatLng(value.latitude, value.longitude);
    //   print("current location=${currentLocation}");
    // });
    controller = await mapcontroller.future;

    // await getBytesFromAsset('assets/images/travel_search_1.png', 100)
    //     .then((value) {
    //   markerIcon = value;
    //   print("marker icon =${markerIcon}");
    // });

    if (this.maptype == MapSearchType.searchByMetro) {
      print("metro type");

      getMetroStation();
    } else
      print("diff type");
    debounce(message, (_) {
      getLocations();
    }, time: Duration(milliseconds: 800));
    super.onInit();
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

  void searchPlace(String text) {}

  void loadMoreData1(String from) async {
    page.value++;
    print("search by map name on loading $page ");

    var propertyData;
    print("fetch prop called ${selectedLatLong}");
    if (this.maptype == MapSearchType.searchByDraw || filtterApply.isTrue) {
      print(" Search Draw current page=${page.value}");
      propertyData = await SearchByMapApi.getPropertyDeatils(
        selectedLatLong,
        coltype: currentColType.value ?? "",
        bathroomcount: currentBathroom.value ?? "",
        maxprice: currentMaxPrice.value ?? "",
        order: currentOrder.value ?? "",
        propertytype: currrentPropertyCode.value ?? "",
        bedroomcount: currentBedroom.value ?? "",
        searchtype: "",
        fromPage: from,
        page: page.value,
        distance: '${radius.value ?? ""}',
        type: selectedType.value.toString(),
      );
    } else if (this.maptype == MapSearchType.searchByName &&
        filtterApply.isFalse) {
      print("Search name current page=${page.value}");

      propertyData = await SearchByMapApi.getSearchByName(
          currentLocation.latitude, currentLocation.longitude,
          page: page.value);
    } else {
      print("Seaarch metro current page=${page.value}");
      propertyData = await SearchByMapApi.getMetroProperties(selectedLatLong,
          page: page.value);
    }
    print("search by map on data ==== $propertyData ");

    if (propertyData != null) {
      propertyData.forEach((element) {
        if (element.images.isEmpty) {
          element.images.addAll(images);
        }
      });
      propertylist.addAll(propertyData);
      refreshController.loadComplete();
    } else {
      refreshController.loadComplete();
    }
  }

  void refreshData() async {
    page.value = 1;
    // filtterApply.value = false;
    metroLoading.value = true;
    propertylist.clear();
    reset();
    var propertyData;

    print("fetch prop called ${selectedLatLong}");
    if (this.maptype == MapSearchType.searchByDraw) {
      propertyData = await SearchByMapApi.getPropertyDeatils(
        selectedLatLong.value,
        searchtype: "",
        coltype: "",
        maxprice: "",
        bedroomcount: "",
        bathroomcount: "",
        propertytype: "",
        order: "",
        distance: "",
        page: page.value,
        type: selectedType.value.toString(),
      );
    } else if (this.maptype == MapSearchType.searchByName) {
      print("search by map name on loading ");
      propertyData = await SearchByMapApi.getSearchByName(
          currentLocation.latitude, currentLocation.longitude,
          page: page.value);
    } else {
      print("metro current page=${page.value}");
      propertyData = await SearchByMapApi.getMetroProperties(selectedLatLong,
          page: page.value);
    }

    // await SearchByMapApi.getPropertyDeatils(
    //   selectedLatLong,
    //   searchtype: "",
    //   coltype: "",
    //   maxprice: "",
    //   bedroomcount: "",
    //   bathroomcount: "",
    //   propertytype: "",
    //   order: "",
    //   distance: "",
    //   page: 1,
    // );
    metroLoading.value = false;
    print("get property details called");
    if (propertyData != null) {
      propertyData.forEach((element) {
        if (element.images.isEmpty) {
          element.images = images;
        }
      });
      propertylist.value = propertyData;
      refreshController.refreshCompleted();
    } else {
      print("nullhai");
      refreshController.refreshCompleted();
    }
  }

  void loadMoreData() async {
    print("load more data called");

    var datalist = await SearchByMapApi.getPropertyDeatils(
      selectedLatLong.value,
      page: page.value,
      type: selectedType.value.toString(),
    );
    this.page.value = int.parse(datalist![0]!.page!);
    // getData(country, city, page: '${popularpage.value}');
    if (datalist != null) {
      datalist.forEach((element) {
        if (element!.images!.isEmpty) {
          element.images!.addAll(images);
        }
      });
      if (propertylist.length == 0) {
        propertylist.value = datalist;
      } else {
        List<LocationCategoriesModel?> temp = [];
        temp.addAll(propertylist);
        temp.addAll(datalist);
        propertylist.value = temp;
      }

      refreshController.loadComplete();
    } else {
      print("nullhai");
      refreshController.loadComplete();
    }
  }

  void startsliderfunction(v) {
    slidervalue.value = v;
    radius.value = v;
    slidervalue.value = 250.0 + v * 100.0;
    print("current sliding value=${slidervalue.value}");
  }

  void changeSliderValue() {
    switch (currrentTravelTimeSearchType.value) {
      case TravelTimeSearchType.searchByCar:
        radius.value = 5.0;
        break;
      case TravelTimeSearchType.searchByBike:
        radius.value = 5.0;
        break;
      case TravelTimeSearchType.searchByWalk:
        radius.value = 5.0;
        break;
      default:
        radius.value = 250.0;
    }
  }

  void removeProperty(int index) {
    // properties(val).removeAt(index);
    propertylist.removeAt(index);
    PropertyAPI.deleteProperty(propertylist[index]!.propertyId!);
  }

  void saveAndUnSave(int index) {
    print("prev saved status=${propertylist[index]!.savedStatus!.value}");
    propertylist[index]!.savedStatus!.value =
        !propertylist[index]!.savedStatus!.value;

    print("current saved status=${propertylist[index]!.savedStatus!.value}");
    PropertyAPI.saveUnsave(propertylist[index]!.propertyId!);
  }

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
    followStatus = propertylist[index]!.followStatus!.value;
    if (followStatus == 0) {
      await followUser(agentId);
    } else {
      await unfollow(agentId);
    }
    print("the function is called -- $followStatus");

    propertylist[index]!.followStatus!.value = followStatus;
    //     !propertylist[index].followStatus.value;
  }

  var slidervalue = 0.0.obs;
  var radius = 250.0.obs;
}
