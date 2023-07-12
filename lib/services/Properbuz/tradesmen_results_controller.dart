import 'dart:async';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TradeDescriptionModel.dart';
import 'package:bizbultest/models/TradesmanSearchModel.dart';
import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

import '../../models/Tradesmen/find_tradesmen_company_detail_mode.dart'
    as companydetailmodel;
import '../../models/Tradesmen/findtradesmensolodetailmodel.dart'
    as solodetailmodel;
import '../../models/Tradesmen/newfifndtradesmenlistmodel.dart';
import '../../models/Tradesmen/tradesmens_work_category_model.dart';
import '../Chat/direct_api.dart';

class TradesmenResultsController extends GetxController {
  TextEditingController keyWordController = TextEditingController();
  var distance = 100.0.obs;
  var top = 0.0.obs;
  var lstReviewDataLength = 0.obs;
  var webArea = <String>[].obs;
  var subCatId = "".obs;
  var shortBy = "".obs;
  var workType = "".obs;
  var passWorkType = "".obs;
  // var typesOfWork = <String>[].obs;
  var loader = false.obs;
  var finalSubCatId = "".obs;
  int? selectedIndex;
  int? selectedWorkIndex;

  var servicestatus = false.obs;
  var haspermission = false.obs;
  LocationPermission? permission;
  Position? position;
  var long = "".obs, lat = "".obs;
  StreamSubscription<Position?>? positionStream;

  var currentIndex = 0.obs;
  TabController? managePropertiesController;

  void switchTabs(int index) {
    currentIndex.value = index;
  }

  var tradesmanpicurl =
      'http://www.bebuzee.com/upload/images/properbuz/tradesmen/images/';
  // var tradesmenReviewCompany = <companydetailmodel.>[].obs;
  var tradesmenAlbumListCompany = <companydetailmodel.CompanyAlbum>[].obs;
  var tradesmenServicesCompany =
      <companydetailmodel.FindTradesmenCompanyDetailModelSubcategory>[].obs;
  var tradesmenReviewList = <companydetailmodel.Review>[].obs;
  // var ttradesmenServicesCompany=<companydetailmodel.>[].obs;

  var tradesmenAlbumListSolo = <solodetailmodel.Album>[].obs;
  var tradesmenServiceSolo = <solodetailmodel.SubcategoryElement>[].obs;
  var tradesmenReviewListSolo = <solodetailmodel.Review>[].obs;
  var tradesmencatsolo = ''.obs;
  void getFindTradesmenSoloDetail(id) async {
    var data = await TradesmanApi.getFindTradesmenSoloDetail(id)
        .then((value) => value);
    tradesmenAlbumListSolo.value = data.tradesmen!.album!;
    tradesmenReviewListSolo.value = data.review!;
    tradesmenServiceSolo.value = data.subcategory!;
    tradesmencatsolo.value = data.tradesmen!.category!.name!;
  }

  void getFindTradesmenCompanyDetail(id) async {
    print('called fetch review $id');
    var data = await TradesmanApi.getFindTradesmenCompanyDetail(id)
        .then((value) => value);
    tradesmenServicesCompany.value = data.subcategory!;
    tradesmenAlbumListCompany.value = data.data!.companyAlbum!;
    tradesmenReviewList.value = data.review!;
  }

  var findtradesmenlist = <FindTradesmenRecord>[].obs;

  var lstTradesmanSearch = <searchTradesmenData>[].obs;
  var lstReviewData = <ReviewData>[].obs;
  var lstReviewCountData = <ReviewCount>[].obs;
  var lstServiceData = <serviceData>[].obs;
  var lstRequestData = <RequestedData>[].obs;
  var lstEnquiryData = <enquiryData>[].obs;

  ReviewData? lstReviewDataModelData;

  checkGps() async {
    servicestatus.value = await Geolocator.isLocationServiceEnabled();
    if (servicestatus.value) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission.value = true;
        }
      } else {
        haspermission.value = true;
      }

      if (haspermission.value) {
        print("GPS Service ${haspermission.value}");
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
    print("------- permission ----- ${haspermission.value}");
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position!.longitude); //Output: 80.24599079
    print(position!.latitude); //Output: 29.6593457

    long.value = position!.longitude.toString();
    lat.value = position!.latitude.toString();

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      // distanceFilter: 100 , //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    // ignore: cancel_subscriptions
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      long.value = position.longitude.toString();
      lat.value = position.latitude.toString();
    });
    print("---------- positionStream ---- $positionStream ");
    print("------- longitude -----  ${position!.longitude}");
    print("------- latitude -----  ${position!.latitude!}");
  }

  Future<void> fetchData({
    String? catId,
    String? subCatId,
    String? countryId,
    String? location,
    String? shortBy,
    String? keyWords,
    double? latitude,
    double? longitude,
    int? distance,
    String? typeOfWork,
  }) async {
    var data = {
      'country_id': countryId,
      'location': location,
      'category_id': catId,
      'subcategory_id': subCatId,
      'work_type': typeOfWork ?? '',
      // 'call_out': 'yes',
      // 'insurance': 'yes',
      // 'undertaken': 'yes',
      'distance': distance ?? '',
      'page': 1,
      'sort_by': shortBy ?? ''
    };
    print("data of refine=${data}");
    // List<searchTradesmenData> lstTradesmanSearchModel =
    //     await ApiProvider.tradsmenSearch(catId, subCatId, countryId, location,
    //         shortBy, keyWords, latitude, longitude, distance, typeOfWork);
    // print("object....13 $lstTradesmanSearchModel");
    // lstTradesmanSearch.value = lstTradesmanSearchModel;
    // print("object....14 ${lstTradesmanSearch.value}");
    var result =
        await TradesmanApi.fetchSearchTradesmen(data).then((value) => value);
    findtradesmenlist.value = result!;
  }

  Future<void> fetchRequestedList() async {
    List<RequestedData>? lstReqDataModel = await ApiProvider.RequestList();

    lstRequestData.value = lstReqDataModel!;
    print("object....13   ${lstRequestData}");
  }

  Future<void> fetchenquiryList({int? tradesmenId, int? companyId}) async {
    List<enquiryData> lstDataModel =
        await ApiProvider.enquiryList(tradesmenId, companyId);

    lstEnquiryData.value = lstDataModel;
    print("object....13   ${lstEnquiryData}");
  }

  Future<void> fetchReviewDataList({
    String? tradesmenId,
    String? companyId,
  }) async {
    ReviewData? lstReviewDataModel =
        await ApiProvider.reviewDataList(tradesmenId, companyId);

    lstReviewDataModelData = lstReviewDataModel;
    print("object....13   ${lstReviewDataModelData}");
  }

  Future<bool?> fetchServiceDataList({
    String? tradesmenId,
    String? companyId,
  }) async {
    List<serviceData>? lstServiceDataModel =
        await ApiProvider.ServiceDataList(tradesmenId, companyId);

    lstServiceData.value = lstServiceDataModel!;
    print("object....13   ${lstServiceData.length}");
  }

  var objTradeDescription = TradeDescriptionModel(
      profile: [
        Profile(
          serviceCompanyAuthName: "",
          serviceCompanyName: "",
          serviceCompanyContact1: "",
          serviceCompanyEmail: "",
        )
      ],
      description: "",
      basedIn: "",
      worksIn: "",
      review: Review(
          totalreviewaverage: "",
          reliability: "",
          totalreviewcount: 0,
          tidy: "",
          courtesy: "",
          workship: ""),
      services: Services(electricianCategory: [])).obs;
  var isLoaded = false.obs;
  var center = LatLng(28.535517, 77.391029).obs;

  var marker = <Marker>[
    Marker(
        markerId: MarkerId("shop location"),
        position: LatLng(28.535517, 77.391029))
  ];

  Future<void> getTradeDescription(String serviceId) async {
    if (serviceId != null && serviceId != "") {
      TradeDescriptionModel? objTradeDescriptionModel =
          await ApiProvider().tradDescription(serviceId);

      objTradeDescription.value = objTradeDescriptionModel!;
      isLoaded.value = true;

      if (objTradeDescriptionModel!.profile![0].serviceLatitude!.length > 1) {
        center.value = LatLng(
            double.parse(objTradeDescriptionModel.profile![0].serviceLatitude!),
            double.parse(
                objTradeDescriptionModel.profile![0].serviceLongitude!));
      }
    }
  }

  var listImages = <String>[].obs;
  fetchTradesmenImages(String serviceId) async {
    //! api need to be update
    // listImages.value = await ApiProvider().getTradesmenImages(serviceId);
  }
  conertList(String text) {
    var ab = text.split(',');
    webArea.value = ab;
  }

  //! api need to be update
  // var tradesmenComments = <TradesmenComments>[].obs;
  // fetchComments(String serviceId) async {
  //   tradesmenComments.value =
  //       await ApiProvider().getTradesmenComments(serviceId);
  // }

  @override
  void onInit() {
    super.onInit();
    // checkGps();
  }

  void callAgent(String number) async {
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }

  Future<String> deleteRquest(
    int enquiryId,
  ) async {
    var data = {
      "enquiry_id": enquiryId,
    };
    var response =
        await ApiRepo.postWithToken("api/tradesmen_enquiry_delete.php", data);

    print("object....441 ${response!.data}");
    if (response!.data == null) {
      print("object....442 ${response!.data}");
      return "false";
    } else if (response!.data['success'] == 0) {
      print("object....444 ${response!.data}");
      return "false";
    } else {
      print("object....443 ${response!.data}");
      return "${response!.data['message']}";
    }
  }

  Future<String> ReadRequest(
    int enquiryId,
  ) async {
    var data = {
      "enquiry_id": enquiryId,
    };
    var response =
        await ApiRepo.postWithToken("api/tradesmen_enquiry_read.php", data);

    print("object....441 ${response!.data}");
    if (response!.data == null) {
      print("object....442 ${response!.data}");
      return "false";
    } else if (response!.data['success'] == 0) {
      print("object....444 ${response!.data}");
      return "false";
    } else {
      print("object....443 ${response!.data}");
      return "${response!.data['message']}";
    }
  }
}
