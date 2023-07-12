import 'dart:io';

import 'package:bizbultest/models/Properbuz/add_feature_list_model.dart';
import 'package:bizbultest/models/Properbuz/add_fixture_list_model.dart';
import 'package:bizbultest/models/Properbuz/add_property_list_model.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/Properbuz/listing_type_model.dart';
import 'package:bizbultest/services/Properbuz/api/add_facilities_model.dart';
import 'package:bizbultest/services/Properbuz/api/add_outin_space_model.dart';
import 'package:bizbultest/services/Properbuz/api/add_prop_api.dart';
import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Properbuz/api/home_api.dart';
import 'package:bizbultest/services/Properbuz/api/properties_api.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import 'api/searchbymapapi.dart';

class AddPropertyController extends GetxController {
  var photos = <File>[].obs;
  var floorplanphotos = <File>[].obs;
  var select = "Please select";
  TextEditingController propertyTitle = new TextEditingController();
  TextEditingController propertyVideo = new TextEditingController();
  TextEditingController propertyPrice = new TextEditingController();
  TextEditingController propertyWidth = new TextEditingController();
  TextEditingController propertyLength = new TextEditingController();
  TextEditingController propertyLandArea = new TextEditingController();
  TextEditingController propertyDescription = new TextEditingController();
  TextEditingController propertyLocation = new TextEditingController();
  TextEditingController propertyHouseName = new TextEditingController();
  TextEditingController propertStreet1 = new TextEditingController();
  TextEditingController propertyStreet2 = new TextEditingController();
  TextEditingController propertyZipCode = new TextEditingController();
  TextEditingController propertyLat = new TextEditingController();
  TextEditingController propertyLong = new TextEditingController();
  TextEditingController propertyNeighbourhood = new TextEditingController();
  TextEditingController searchCountry = new TextEditingController();
  var currentListingType = ''.obs;
  var currentVideoType = ''.obs;
  var currentListingTypeIndex = 0.obs;
  var currentCountry = ''.obs;
  var countryid = ''.obs;
  var currentCountryIndex = 0.obs;
  var currentPropertyType = ''.obs;
  var currentPropertyTypeIndex = 0.obs;
  var currentCurrency = ''.obs;
  var currentPreference = ''.obs;
  var currentPreferenceIndex = 0.obs;
  var currentCurrencyIndex = 0.obs;
  var currentFloor = ''.obs;
  var currentFloorIndex = 0.obs;
  var currentBedroom = ''.obs;
  var currentBedroomIndex = 0.obs;
  var currentBathroomIndex = 0.obs;
  var currentDimension = ''.obs;
  var currentDimensionIndex = 0.obs;
  var currentLandArea = ''.obs;
  var currentLandAreaIndex = 0.obs;
  var currentBathroom = ''.obs;
  var iconLoadListingType = false.obs;
  var iconLoadPropertyType = false.obs;
  var iconLoadCurrency = false.obs;
  var iconLoadFloor = false.obs;
  var iconLoadBedroom = false.obs;
  var iconLoadBathroom = false.obs;
  var iconLoadDimension = false.obs;
  var iconLoadCountry = false.obs;

  var iconLoadDate = false.obs;
  var iconLoadMeasurement = false.obs;
  var iconLoadFeature = false.obs;
  var iconLoadFixture = false.obs;
  var iconLoadOutinspace = false.obs;
  var iconLoadLandArea = false.obs;
  var iconLoadPreference = false.obs;
  RxMap<String, dynamic> isFurnishedProp =
      {"name": "Furnished *", "value": false.obs}.obs;

  Map<String, dynamic> isListedProp =
      {"name": "Is the listing a new home *", "value": false.obs}.obs;

  var isFurnished = true.obs;
  var isaddLoad = false.obs;

  var isproperyPaid = {"name": "Property paid", "value": false.obs};
  // var ispropertyPaid = false.obs;

  var ispropertyPaidIcon = Icon(
    CupertinoIcons.square,
    color: settingsColor,
  ).obs;
  var issharedOwnership = {"name": "Shared Ownership", "value": false.obs};

  var isretirementHome = {"name": "Retirement Homes", "value": false.obs};

  var underOfferSold = {"name": "Under Offer or sold", "value": false.obs};

  var isnewHome = false.obs;
  var isnewHomeIcon = Icon(
    CupertinoIcons.square,
    color: settingsColor,
  ).obs;

  var selectedPge = 1.obs;
  PageController pageController = PageController();
  var listingtype = <ListingTypeModel>[].obs;
  var propertytypelist = <AddPropertyListModel>[].obs;
  var outinspacelist = <AddOutinSpaceListModel>[].obs;
  var featurelist = <AddFeatureListModel>[].obs;
  var fixturelist = <AddFixtureListModel>[].obs;
  var countrylist = <CountryListModel>[].obs;
  var currencylist = [].obs;
  var bathroomlist = [].obs;
  var bedroomlist = [].obs;
  var measurementlist = [].obs;
  var floornamelist = [].obs;
  var preferencelist = [].obs;
  var featureList1 = <AddFeatureListModel>[].obs;
  var featureList2 = <AddFeatureListModel>[].obs;
  var feature1iconlist = <Icon>[].obs;
  var feature2iconlist = <Icon>[].obs;
  var fixtureList1 = <AddFixtureListModel>[].obs;
  var fixtureList2 = <AddFixtureListModel>[].obs;
  var fixture1iconlist = <Icon>[].obs;
  var fixture2iconlist = <Icon>[].obs;
  var outinspaceList1 = <AddOutinSpaceListModel>[].obs;
  var outinspaceList2 = <AddOutinSpaceListModel>[].obs;
  var outinspace1iconlist = <Icon>[].obs;
  var outinspace2iconlist = <Icon>[].obs;
  var facilitiesList1 = <AddFacilitiesModel>[].obs;
  var facilitiesList2 = <AddFacilitiesModel>[].obs;
  var facilities1iconlist = <Icon>[].obs;
  var facilities2iconlist = <Icon>[].obs;

  var topostFeatures = ''.obs;
  var topostFixtures = ''.obs;
  var topostOutinSpace = ''.obs;
  var topostFacilities = ''.obs;

  var selectedDate = ''.obs;
  String converttoCSV(String x) {
    return "$x";
  }

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

  var fixtures1 =
      ["Air conditioning", "Cooker Hob/Hood", "Intercom", "Private Pool"].obs;
  var fixtures2 = ["Bathtub", "Hairdryer", "Jacuzzi", "Water Heater"].obs;

  var spaces1 =
      ["Balcony", "Bomb shelter", "Garage", "Maids room", "Outdoor Patio"].obs;
  var spaces2 = [
    "Private Garden",
    "Private Terrace",
    "Terrace",
    "Walk-in wardrobe",
    "None"
  ].obs;

  var facilities1 = [
    "24 hours security",
    "Aerobic pool",
    "Badminton hall",
    "Basketball court",
    "Billiards room",
    "Clubhouse",
    "Driving range",
    "Fun pool",
    "Game room",
    "Jacuzzi",
    "Karaoke",
    "Launderette",
    "Lounge",
    "Mini golf range",
    "Multi-purpose hall",
    "Playground",
    "Reflexology Path",
    "Spa pool",
    "Steam bath",
    "Tennis courts",
    "Pool Deck",
    "Sky Lounge",
    "Salon",
    "Landscaped Garden",
    "Cafe",
    "Table Tennis",
    "Snooker Room",
    "Perimeter Fencing"
  ].obs;

  var facilities2 = [
    "Adventure park",
    "Amphitheatre",
    "Basement car park",
    "BBQ pits",
    "Bowling alley",
    "Covered car park",
    "Fitness corner",
    "Function room",
    "Gymnasium room"
        "Jogging track",
    "Lap pool",
    "Library",
    "Meeting room",
    "Mini-Mart",
    "Open car park",
    "Putting Green",
    "Sauna",
    "Squash court",
    "Swimming pool",
    "Wading pool",
    "Pavilion",
    "Business Centre",
    "Nursery",
    "Recreation Lake",
    "Aero yoga Room",
    "Reading Room",
    "Picnic Area",
    "Recreation Room"
  ].obs;
  var message = "".obs;

  var isLocationLoading = false.obs;
  RxList<dynamic> locations = [].obs;
  var searchCountryList = [].obs;

  var validateField = false.obs;

  void getLocations() {
    if (message.value.isNotEmpty) {
      isLocationLoading.value = true;
      var loclist = [];
      AddPropertyAPI.fetchLocations(message.value, currentCountry.value)
          .then((value) {
        value.forEach((element) {
          print('areaid=${element['area_id']}');

          loclist.add(element);
        });
        locations.value = loclist;
        // locations.assignAll(value);
        isLocationLoading.value = false;
      });
    } else {
      locations.clear();
    }
    print("response location=${locations.value}");
  }

  var cityid = '';
  void setLocation(String location, String id, BuildContext context) {
    message.value = location;
    cityid = id;
    print("city id selected=${cityid}");
    Navigator.pop(context);
  }

  void postData(Map<String, dynamic> dataMap, dio.FormData files,
      Function callback) async {
    print("here postdata called${photos.length}");

    var resp = await AddPropertyAPI.postAddProperty(dataMap, files)
        .then((value) => value);

    print("yo ${resp['success']}");
    callback(resp['success']);
  }

  void fetchListingType(VoidCallback callback) async {
    var datalist = await AddPropertyAPI.getListingType();
    iconLoadListingType.value = false;
    listingtype.value = datalist;
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
    } else
      searchCountryList.value = [];
  }

  void fetchCountryList(VoidCallback callback) async {
    var dataList = await CountryAPI.fetchCountries();
    iconLoadCountry.value = false;
    countrylist.value = dataList;
    callback();
  }

  void fetchCurrencyList(VoidCallback callback) async {
    var datalist = await AddPropertyAPI.getCurrencyList();
    iconLoadCurrency.value = false;
    currencylist.value = datalist;
    callback();
  }

  void fetchPreferenceList(VoidCallback callback) async {
    var datalist = await AddPropertyAPI.getPreferencesList();
    iconLoadPreference.value = false;
    print("load Pref=${iconLoadPreference.value}");
    preferencelist.value = datalist;
    callback();
  }

  void fetchBathroomList(VoidCallback callback) async {
    var datalist = await AddPropertyAPI.getBathroomList();
    iconLoadBathroom.value = false;
    bathroomlist.value = datalist;
    print("bathroom $bathroomlist");
    callback();
  }

  void fetchMeasurementList(VoidCallback callback, String key) async {
    var datalist = await AddPropertyAPI.getMeasurementList();
    if (key.contains('Dimension')) {
      iconLoadDimension.value = false;
    } else
      iconLoadLandArea.value = false;
    measurementlist.value = datalist;
    print("loadDimension =${iconLoadDimension.value}");
    print("measure ment lisst $measurementlist");
    callback();
  }

  void fetchBedroomList(VoidCallback callback) async {
    var datalist = await AddPropertyAPI.getBedroomList();
    iconLoadBedroom.value = false;
    bedroomlist.value = datalist;
    callback();
  }

  void fetchFloornamList(VoidCallback callback) async {
    var datalist = await AddPropertyAPI.getFloorNameList();
    iconLoadFloor.value = false;
    floornamelist.value = datalist;
    callback();
  }

  // void fetchFeatureList() async {
  //   var datalist = await AddPropertyAPI.getFeatureList();
  //   iconLoadFeature.value = false;
  //   featurelist.value = datalist;
  // }

  void fetchPropertyList(VoidCallback callback) async {
    var datalist = await AddPropertyAPI.getaddPropertyList();
    iconLoadPropertyType.value = false;
    propertytypelist.value = datalist;
    print('list fetch= $propertytypelist');
    callback();
  }

  void pickPhotosFilesFloor() async {
    List<XFile> allFiles = await ImagePicker().pickMultiImage();
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i].path));

      floorplanphotos.value = imgFiles;
      if (floorplanphotos == null) {
        print("null photo");
      } else {
        print(
            "image added floor ${floorplanphotos.first} length ${floorplanphotos.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  var attachmentFileList = <File>[].obs;
  var videoFileList = <File>[].obs;
  void pickAttachmentFiles() async {
    XFile? allFiles = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    List<File> imgFiles = [];
    for (int i = 0; i < 1; i++) {
      imgFiles.add(File(allFiles!.path));

      attachmentFileList.value = imgFiles;
      if (attachmentFileList == null || attachmentFileList.length == 0) {
        print("null photo");
      } else {
        print(
            "image added floor ${attachmentFileList.first} length ${attachmentFileList.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  void pickVideoFilesFloor() async {
    XFile? allFiles = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    List<File> imgFiles = [];
    for (int i = 0; i < 1; i++) {
      imgFiles.add(File(allFiles!.path));

      videoFileList.value = imgFiles;
      if (videoFileList == null || videoFileList.length == 0) {
        print("null photo");
      } else {
        print(
            "image added floor ${floorplanphotos.first} length ${floorplanphotos.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  void pickPhotosFiles() async {
    List<XFile> allFiles = await ImagePicker().pickMultiImage();
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i].path));

      photos.value = imgFiles;
      if (photos == null) {
        print("null photo");
      } else {
        print("image added ${photos.first} length ${photos.length}");
      }

      //     (allowMultiple: true, type: FileType.image);
      // List<File> allFiles = result.paths.map((path) => File(path)).toList();
      // photos.value = allFiles;
    }
  }

  void pickDate() async {
    var date = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        selectableDayPredicate: (day) {
          return true;
        },
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xFF8CE7F1),
              accentColor: const Color(0xFF8CE7F1),
              colorScheme: ColorScheme.light(primary: const Color(0xFF8CE7F1)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        firstDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        lastDate: DateTime.now().add(Duration(days: 365)));
    selectedDate.value = '${date!.year}-${date.month}-${date.day}';
    print("selectedf date ${selectedDate.value}");
  }

  // void pickPhotos() async {
  //   FilePickerResult result = await FilePicker.platform
  //       .pickFiles(allowMultiple: true, type: FileType.image);
  //   List<File> allFiles = result.paths.map((path) => File(path)).toList();
  //   photos.value = allFiles;
  // }

  void deleteFile(int index) {
    selectedPge.value = index - 1;
    photos.removeAt(index);
  }

  void deleteFileVideo(int index) {
    videoFileList.removeAt(index);
    videoFileList.refresh();
  }

  void deleteAttachments(int index) {
    attachmentFileList.removeAt(index);
    attachmentFileList.refresh();
  }

  void changePage(int page) {
    selectedPge.value = page + 1;
  }

  int getSeparation(int length) {
    if (length % 2 == 0) {
      return (length / 2).toInt();
    } else {
      length = length - 1;
      return (length / 2).toInt();
    }
  }

  void fetchFixtureList() async {
    print("fixtrelis=called");
    var datalist = await AddPropertyAPI.getFixtureList();
    print("fixtrelis=data=${datalist}");
    List<AddFixtureListModel> data1 = [], data2 = [];
    int length = datalist!.length;
    for (int i = 0; i < getSeparation(length); i++) {
      data1.add(datalist[i]!);
    }
    for (int i = getSeparation(length); i < length; i++) {
      data2.add(datalist[i]!);
    }
    fixtureList1.value = data1;
    fixtureList2.value = data2;
    for (int i = 0; i < fixtureList1.length; i++) {
      fixture1iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
    for (int i = 0; i < fixtureList2.length; i++) {
      fixture2iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
  }

  void fetchOutinspaceList() async {
    var datalist = await AddPropertyAPI.getOutinSpaceList();
    List<AddOutinSpaceListModel> data1 = [], data2 = [];
    int length = datalist!.length;

    for (int i = 0; i < getSeparation(length); i++) {
      data1.add(datalist[i]!);
    }
    for (int j = getSeparation(length); j < length; j++) {
      data2.add(datalist[j]!);
    }
    outinspaceList1.value = data1;
    outinspaceList2.value = data2;

    for (int i = 0; i < outinspaceList1.length; i++) {
      outinspace1iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
    for (int i = 0; i < outinspaceList2.length; i++) {
      outinspace2iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
  }

  void fetchFacilities() async {
    var datalist = await AddPropertyAPI.getFacilitiesList();
    List<AddFacilitiesModel> data1 = [], data2 = [];
    int length = datalist.length;
    for (int i = 0; i < getSeparation(length); i++) {
      data1.add(datalist[i]);
    }
    for (int j = getSeparation(length); j < length; j++) {
      data2.add(datalist[j]);
    }
    facilitiesList1.value = data1;
    facilitiesList2.value = data2;
    for (int i = 0; i < facilitiesList1.length; i++) {
      facilities1iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
    for (int i = 0; i < facilitiesList2.length; i++) {
      facilities2iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
  }

  void getSelectedFeatures() {
    String csvFeature = "";
    for (int i = 0; i < feature1iconlist.length; i++) {
      if (feature1iconlist[i].icon == CupertinoIcons.square_fill) {
        csvFeature += converttoCSV('${featureList1[i].featureID}') + ",";
      }
    }
    for (int i = 0; i < feature2iconlist.length; i++) {
      if (feature2iconlist[i].icon == CupertinoIcons.square_fill)
        csvFeature += converttoCSV('${featureList2[i].featureID}') + ",";
    }
    topostFeatures.value = csvFeature;
    print(topostFeatures);
  }

  void getSelectedFixtures() {
    String csvFixture = "";
    for (int i = 0; i < fixture1iconlist.length; i++) {
      if (fixture1iconlist[i].icon == CupertinoIcons.square_fill) {
        csvFixture += converttoCSV('${fixtureList1[i].fixtureID}') + ",";
      }
    }
    for (int i = 0; i < fixture2iconlist.length; i++) {
      if (fixture2iconlist[i].icon == CupertinoIcons.square_fill)
        csvFixture += converttoCSV('${fixtureList2[i].fixtureID}') + ",";
    }
    topostFixtures.value = csvFixture;
  }

  void getSelectedOutinSpace() {
    String csvOutin = "";
    for (int i = 0; i < outinspace1iconlist.length; i++) {
      if (outinspace1iconlist[i].icon == CupertinoIcons.square_fill) {
        csvOutin += converttoCSV('${outinspaceList1[i].outinspaceID}') + ",";
      }
    }
    for (int i = 0; i < outinspace2iconlist.length; i++) {
      if (outinspace2iconlist[i].icon == CupertinoIcons.square_fill)
        csvOutin += converttoCSV('${outinspaceList2[i].outinspaceID}') + ",";
    }
    topostOutinSpace.value = csvOutin;
  }

  void getSelectedFacilities() {
    String csvFacilities = "";
    for (int i = 0; i < facilities1iconlist.length; i++) {
      if (facilities1iconlist[i].icon == CupertinoIcons.square_fill) {
        csvFacilities += converttoCSV('${facilitiesList1[i].facilityID}') + ",";
      }
    }
    for (int i = 0; i < fixture2iconlist.length; i++) {
      if (facilities2iconlist[i].icon == CupertinoIcons.square_fill)
        csvFacilities = converttoCSV('${facilitiesList2[i].facilityID}') + ",";
    }
    topostFacilities.value = csvFacilities;
  }

  void fetchSpecialFeatures() async {
    print("special feature called");
    var datalist = await AddPropertyAPI.getFeatureList();
    List<AddFeatureListModel> data1 = [], data2 = [];

    print('special features ${datalist}');
    int length = datalist.length;
    for (int i = 0; i < getSeparation(length); i++) {
      data1.add(datalist[i]);
    }
    for (int j = getSeparation(length); j < length; j++) {
      data2.add(datalist[j]);
    }
    featureList1.value = data1;
    featureList2.value = data2;
    for (int i = 0; i < featureList1.length; i++) {
      feature1iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
    for (int i = 0; i < featureList2.length; i++) {
      feature2iconlist.add(Icon(
        CupertinoIcons.square,
        color: hotPropertiesThemeColor,
      ));
    }
    print(
        "feature1list =${featureList1.length} feature2List=${featureList2.length}");
  }

  String photosString() {
    switch (photos.length) {
      case 1:
        return "Photo";
        break;
      default:
        return "Photos";
        break;
    }
  }
//--------------------MAP SECTION-------------------------

  RxSet<Marker> markset = <Marker>{}.obs;
  Completer<GoogleMapController>? mapcontroller = Completer();
  late GoogleMapController controller;
  late Uint8List markerIcon;
  late LatLng currentLocation;
  var currentlat = "".obs, currentlong = "".obs;
  var maploc = "Choose Property Location".obs;
  var selectedMarker = Marker(
    markerId: MarkerId(''),
    visible: false,
  ).obs;
  void ttsaddMarker(double lat, double long) {
    selectedMarker.value = Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('${lat}${long}'),
        position: LatLng(lat, long));
    currentlat.value = lat.toString();
    currentlong.value = long.toString();
  }

  Future<CameraPosition> positonMapToNewLocation(
      double lat, double long) async {
    print("position new loc called $lat $long");
    currentlat.value = lat.toString();
    currentlong.value = long.toString();
    await SearchByMapApi.getLocationName(LatLng(lat, long));
    return CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }

  TextEditingController searchTextLoc = TextEditingController();
  CameraPosition positonMapToCurrentLocation() {
    return CameraPosition(
        bearing: 192.8334901395799,
        target: currentLocation != null
            ? currentLocation
            : LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }

  @override
  void onReady() {
    print("onReady called");
    super.onReady();
  }

//----Map SECTION END-----------------
  @override
  void onInit() async {
    // TODO: implement onInit

    print("i am here after oninit");
    fetchSpecialFeatures();
    fetchFixtureList();
    fetchOutinspaceList();
    fetchFacilities();
    debounce(message, (_) {
      getLocations();
    }, time: Duration(milliseconds: 800));
    controller = await mapcontroller!.future;
    super.onInit();
  }
}
