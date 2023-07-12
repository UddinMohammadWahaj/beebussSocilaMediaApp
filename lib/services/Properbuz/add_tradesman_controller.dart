import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/Properbuz/manage_tradesman_model.dart';
import 'package:bizbultest/models/Tradesmen/tradesmens_work_category_model.dart';
import 'package:bizbultest/models/TradesmenCountryModel.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Properbuz/api/home_api.dart';
import 'package:bizbultest/services/Properbuz/api/searchbymapapi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_New_tradesmen_view.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart' as imgpicker;
import 'package:image_picker/image_picker.dart';

import '../../Language/appLocalization.dart';
import '../../api/ApiRepo.dart' as ApiRepo;
import '../../models/Properbuz/city_list_model.dart';
import '../../models/Tradesmen/tradesmen_subcat_model.dart';
import '../../utilities/colors.dart';
import '../../utilities/custom_icons.dart';

class AddTradesmenController extends GetxController {
  List<String> textsWorkList =
      ["Domestic", "Commercial", "Both Domestic and Commercial"].obs;

  var typeOfWorkList = {
    "Domestic": false,
    "Commercial": false,
    "Both Domestic and Commercial": false
  }.obs;
  var select = "Please select";
  var iconLoadCountry = false.obs;

  var manageTradesman = <ManageTradesmanModel>[].obs;
  var albumList = [].obs;
  var albumImageList = [].obs;

  TextEditingController searchCountryloc = new TextEditingController();
  var searchCountryList = [].obs;
  var currentCountryIndex = 0.obs;

  void updateCountryList(String pattern) async {
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

  late int selectedIndex;
  late String companyId;

  var message = "".obs;
  var workAreaLocation = "".obs;

  var WebMassage = "".obs;
  var isLocationLoading = false.obs;
  var isWebLocationLoading = false.obs;
  var currentCountry = ''.obs;
  // var currentWebCountry = ''.obs;
  var locations = [].obs;
  var newlocations = <CityListModel>[].obs;
  var WebLocation = [].obs;
  TextEditingController searchTextLoc = TextEditingController();
  late GoogleMapController controller;
  late LatLng currentLocation;
  var maploc1 = "Choose Tradesman Location".obs;
  var currentlat = "".obs;
  var currentlong = "".obs;
  TextEditingController propertyLat = new TextEditingController();
  TextEditingController propertyLong = new TextEditingController();
  var countrylist = <CountryListModel>[].obs;
  var selectedMarker = Marker(
    markerId: MarkerId(''),
    visible: false,
  ).obs;
  var lstAlubmData = <AlbumData>[].obs;

  var lstTradesmenData = <ManageData>[].obs;
  late Future<List<ManageData>> TradesManData;

  Future<void> fetchTradesmenList(
      {int? companyId, StateSetter? setsate}) async {
    List<ManageData>? data =
        await DirectApiCalls.newManageTradesmenList(companyId);
    setsate!(
      () => lstTradesmenData.value = data!,
    );
    print("==== #### 33 $lstTradesmenData");
  }

  Future<void> fetchAlubmList({
    int? comId,
    int? trdId,
    StateSetter? setsate,
  }) async {
    List<AlbumData>? lstAlbumModel =
        await ApiProvider.AlbumListData(trdId, comId);
    print("==== #### 467 album ${lstAlbumModel}");
    setsate!(() => lstAlubmData.value = lstAlbumModel!);
    print("==== #### 44 album ${lstAlubmData.length}");
  }

  void ttsaddMarker(double lat, double long) {
    selectedMarker.value = Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('${lat}${long}'),
        position: LatLng(lat, long));
    currentlat.value = lat.toString();
    currentlong.value = long.toString();
  }

  void fetchCountryList(VoidCallback callback) async {
    var dataList = await CountryAPI.fetchCountries();
    iconLoadCountry.value = false;
    countrylist.value = dataList;
    callback();
  }

  Future<void> fetchDat1() async {
    List<WorkCategory> lstPropertyBuyingModel =
        await ApiProvider().tradsmenWorkCategory();

    lstWorkCat1.value = lstPropertyBuyingModel;
    print("=== 111 22 ${lstWorkCat1.value}");
    await fetchcountryData();
  }

  Future<void> fetchsubData(String catid) async {
    // lstWorksubCat.clear();
    List<TradesmenSubCatModelWorkSubCategory> lstTradesmenWorkCategoryModel =
        await ApiProvider().tradsmenSubWorkCategory(catid);
    lstWorksubCat.value = lstTradesmenWorkCategoryModel;
  }

  Completer<GoogleMapController> mapcontroller = Completer();
  TextEditingController selectLocation = TextEditingController();
  TextEditingController locationFieldController = TextEditingController();
  TextEditingController WorkAreaFieldController = TextEditingController();
  void getLocations() {
    print("getting values");
    if (message.value.isNotEmpty) {
      isLocationLoading.value = true;
      print("current country=${currentCountry.value}");
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
  }

  void setLocation(String location, BuildContext context) {
    message.value = location;
    Navigator.pop(context);
  }

  void getWebLocations() {
    print("getting values");
    if (WebMassage.value.isNotEmpty) {
      isWebLocationLoading.value = true;
      ProperbuzHomeApi.fetchWebLocations(
        currentCountry.value,
        WebMassage.value,
      ).then((value) {
        WebLocation.assignAll(value);
        isWebLocationLoading.value = false;
      });
    } else {
      WebLocation.clear();
    }
    print("got values");

    print("response location=${WebLocation.value}");
  }

  @override
  Future<void> onInit() async {
    print("fetch data");
    selectLocation = TextEditingController();
    debounce(message, (_) {
      getLocations();
    }, time: Duration(milliseconds: 800));
    debounce(WebMassage, (_) {
      getWebLocations();
    }, time: Duration(milliseconds: 800));
    controller = await mapcontroller.future;
    super.onInit();
  }

  updateTypeOfWork(String key, bool val) {
    typeOfWorkList[key] = val;
  }

  var availabel = true.obs;
  var publiclibelity = true.obs;
  var workUndertaking = true.obs;

  updateAvailabel(bool val) {
    availabel.value = val;
  }

  updatepublic(bool val) {
    publiclibelity.value = val;
  }

  updateWorkUnderTaking(bool val) {
    workUndertaking.value = val;
  }

  final ImagePicker picker = ImagePicker();
  var isImagePicked = false.obs /* ¸ */;
  var image = File('').obs;
  var albumCoverImage = File('').obs;
  var isalbumCoverPicked = false.obs;
  var isLogoPicked = false.obs;
  var imageLogo = File('').obs;
  var successMsg = "".obs;
  var photos = <File>[].obs;
  var selectedPge = 1.obs;

  TextEditingController locationController = TextEditingController();

  var lstWorkcountryCat = <TradesmenCountryModel>[].obs;

  var searchedCountry = <TradesmenCountryModel>[].obs;

  var lstWorkCat1 = <WorkCategory>[].obs;
  var lstWorksubCat = <TradesmenSubCatModelWorkSubCategory>[].obs;

  Future<void> fetchcountryData() async {
    var response = await ApiRepo.getWithToken("api/country_list.php");
    if (response!.success == 1) {
      if (response!.data != null) {
        var tradCountryList = <TradesmenCountryModel>[];
        response!.data.forEach((v) {
          tradCountryList.add(new TradesmenCountryModel.fromJson(v));
        });
        lstWorkcountryCat.value = tradCountryList;
      }
    }
  }

  searchCountry(String val) async {
    searchedCountry.value = lstWorkcountryCat.value
        .where((loc) => loc.country!.toLowerCase().contains(val.toLowerCase()))
        .toList();
  }

  var serviceCategories = {
    "Commercial Pipe Fitter Journeyman": false,
    "Gas Pipe Fitter": false,
    "Journeyman Pipe Fitter": false,
    "Marine Pipe Fitter": false,
    "Marine Pipe Fitter or CNC Machinist": false,
    "Marine Pipe Welder": false,
    "Millwright/Pipe Fitter Journeyman": true,
    "Pipe Fitter": false,
    "Pipe Insulator": false,
    "Pipe Layer": false,
    "Pipe Welder": false,
    "Pipe Welder Journeyman": false,
    "Pipe Fitter Apprentice": false,
    "Pipe Fitter Journeyman": false
  }.obs;

  updateServiceCategories(String key, bool val) {
    serviceCategories[key] = val;
  }

  pickImage() async {
    var pathfile = await picker.pickImage(source: ImageSource.gallery);

    image.value = File(pathfile!.path);

    if (image.value.path.length > 1) {
      isImagePicked.value = true;
    }
  }

  pickLogo() async {
    var pathfile = await picker.pickImage(source: ImageSource.gallery);

    imageLogo.value = File(pathfile!.path);

    if (imageLogo.value.path.length > 1) {
      isLogoPicked.value = true;
    }
  }

  pickAlbumCoverImage() async {
    var pathfile = await picker.pickImage(source: ImageSource.gallery);

    albumCoverImage.value = File(pathfile!.path);

    if (albumCoverImage.value.path.length > 1) {
      isalbumCoverPicked.value = true;
    }
  }

  void pickPhotosFiles() async {
    List<imgpicker.XFile> allFiles =
        await imgpicker.ImagePicker().pickMultiImage();
    List<File> imgFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      imgFiles.add(File(allFiles[i].path));
    }

    // photos.addAll(imgFiles);
    photos.value = imgFiles;

    print("=== ## photos $photos");
  }

  void deleteFile(int index) {
    selectedPge.value = index - 1;
    photos.removeAt(index);
  }

  String photosString() {
    switch (photos.length) {
      case 1:
        return AppLocalizations.of("Photo");
        break;
      default:
        return AppLocalizations.of("Photos");
        break;
    }
  }

  var mapLocationAdded = false.obs;

  Map<String, LatLng> markers = <String, LatLng>{};
  List<Marker> customMarker = [];

  void addMarker(LatLng latLng) async {
    print('update marker');
    markers['marker'] = latLng;
    mapLocationAdded.value = !mapLocationAdded.value;
    if (customMarker.length > 0) {
      customMarker[0] =
          Marker(markerId: MarkerId(latLng.toString()), position: latLng);
    } else {
      customMarker
          .add(Marker(markerId: MarkerId(latLng.toString()), position: latLng));
    }
    print(customMarker.toString());
  }

  //query

  Future<bool> saveTradesmenData(
      String countryId,
      String countryName,
      String companyName,
      String location,
      String street1,
      String street2,
      String zip,
      String categoryId,
      String name,
      String manager,
      String contact,
      String email,
      String additional,
      String description,
      String yourEmail,
      File logo) async {
    var data = {
      "user_id": CurrentUser().currentUser.memberID,
      "service_user_email": yourEmail,
      "service_user_type": categoryId,
      "service_company_name": name,
      "service_comapny_auth_name": name,
      "service_company_contact1": contact,
      "service_company_contact2": additional,
      "service_company_emai": email,
      "service_company_website": "",
      "service_company_logo": logo.path,
      "service_company_cover": logo.path,
      "service_company_based_in": countryName,
      "service_country_id": countryId,
      "service_area_id": location,
      "service_house_number": location + street1,
      "service_street_line_one": street1,
      "service_street_line_two": street2,
      "service_zipcode": zip,
      "service_latitude": customMarker.last.position.latitude.toString(),
      "service_longitude": customMarker.last.position.longitude.toString(),
      "service_details": description,
      "service_category": typeOfWorkList,
      "service_subcategory": serviceCategories,
      "service_work_type": typeOfWorkList,
      "service_call_out_hours": availabel.toString(),
      "service_public_liability": publiclibelity.toString(),
      "service_ins_work_done": workUndertaking.toString(),
      "service_if_old_photos": ""
    };

    var response =
        await ApiRepo.postWithToken("api/tradesmen_signup.php", data);

    // bool response = await ApiProvider().addTradesmen(data);
    if (response!.success == 1) {
      return true;
    }
    var encode = jsonEncode(data);
    log(encode.toString());
    return false;
  }

  Future<String?> getToken() async {
    return await ApiProvider()
        .refreshToken(CurrentUser().currentUser.memberID!);
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

  CameraPosition positonMapToCurrentLocation() {
    return CameraPosition(
        bearing: 192.8334901395799,
        target: currentLocation != null
            ? currentLocation
            : LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }

  Future<String> updateCompanyData(
    String companyId,
    String companyName,
    String managerName,
    String managerNum,
    String email,
    String comContact,
    String countryId,
    String workarea,
    String website,
    String location,
    String details,
    File logo,
    File coverPic,
  ) async {
    var data = {
      "user_id": CurrentUser().currentUser.memberID,
      "name": companyName,
      "company_id": companyId,
      "tradesman_id": null,
      "mobile": comContact,
      "email": email,
      "website": website,
      "country_id": countryId,
      "location": location,
      "details": details,
      "work_area": workarea,
      "manager_name": managerName,
      "manager_mobile": managerNum,
    };

    var formdata = dio.FormData();
    if (isLogoPicked.isTrue) {
      formdata.files.addAll(
          [MapEntry("logo", await dio.MultipartFile.fromFile(logo.path))]);
    }
    if (isImagePicked.isTrue) {
      formdata.files.addAll([
        MapEntry("cover_pic", await dio.MultipartFile.fromFile(coverPic.path))
      ]);
    }
    Future<String> massag = updateData(formdata, data);
    ;
    return massag;
  }

  Future<String> saveCompanyData(
    String companyName,
    String managerName,
    String managerNum,
    String email,
    String comContact,
    String countryId,
    String workarea,
    String website,
    String location,
    String details,
    File logo,
    File coverPic,
  ) async {
    var data = {
      "user_id": CurrentUser().currentUser.memberID,
      "name": companyName,
      "type": "company",
      "mobile": comContact,
      "email": email,
      "website": website,
      "country_id": countryId,
      "location": location,
      "details": details,
      "work_area": workarea,
      "manager_name": managerName,
      "manager_mobile": managerNum,
    };

    var formdata = dio.FormData();

    formdata.files.addAll(
        [MapEntry("logo", await dio.MultipartFile.fromFile(logo.path))]);
    formdata.files.addAll([
      MapEntry("cover_pic", await dio.MultipartFile.fromFile(coverPic.path))
    ]);

    Future<String> massag = saveData(formdata, data);

    return massag;
  }

  Future<String> saveData(formdata, data) async {
    var token = await getToken();
    var clicent = dio.Dio();
    var response = await clicent.post(
      "https://www.bebuzee.com/api/tradesmen_signup.php",
      data: formdata,
      queryParameters: data,
      options: dio.Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response!.data['success'] == 0) {
      return "false";
    } else {
      return "${response!.data['message']}";
    }
  }

  Future<String> updateData(formdata, data) async {
    var token = await getToken();
    var clicent = dio.Dio();
    var response = await clicent.post(
      "https://www.bebuzee.com/api/tradesmen_update.php",
      data: formdata,
      queryParameters: data,
      options: dio.Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response!.data['success'] == 0) {
      return "false";
    } else {
      return "${response!.data['message']}";
    }
  }

  Future<String> updateSoloTradesmenData(
    String tradesmenName,
    String tradesmenNum,
    String alterNum,
    String email,
    String experience,
    String countryId,
    String location,
    String workarea,
    String workCat,
    String workSubCat,
    String typeOfWork,
    int callOut,
    int publicLiability,
    int workUnderTaken,
    String details,
    File coverPic,
    String tradesmenId,
  ) async {
    var data = {
      "user_id": CurrentUser().currentUser.memberID,
      "tradesman_id": tradesmenId,
      "company_id": null,
      "full_name": tradesmenName,
      "email": email,
      "mobile": tradesmenNum,
      "at_mobile": alterNum,
      "experience": experience,
      "country_id": countryId,
      "location": location,
      "category": workCat,
      "subcategory": workSubCat,
      "work_area": workarea,
      "details": details,
      "work_type": typeOfWork,
      "call_out_hours": callOut,
      "public_libility": publicLiability,
      "work_undertaken": workUnderTaken,
    };
    var formdata = dio.FormData();

    if (isImagePicked.isTrue) {
      formdata.files.addAll([
        MapEntry("profile", await dio.MultipartFile.fromFile(coverPic.path))
      ]);
    }
    Future<String> massag = updateData(formdata, data);

    return massag;
  }

  Future<String> saveSoloTradesmenData(
    int companyId,
    String tradesmenName,
    String tradesmenNum,
    String alterNum,
    String email,
    String experience,
    String countryId,
    String location,
    String workarea,
    String workCat,
    String workSubCat,
    String typeOfWork,
    int callOut,
    int publicLiability,
    int workUnderTaken,
    String details,
    File coverPic,
    String type,
  ) async {
    var data = {
      "user_id": CurrentUser().currentUser.memberID,
      "type": "solo",
      "company_id": companyId,
      "full_name": tradesmenName,
      "email": email,
      "mobile": tradesmenNum,
      "at_mobile": alterNum,
      "experience": experience,
      "country_id": countryId,
      "location": location,
      "category": workCat,
      "subcategory": workSubCat,
      "work_area": workarea,
      "details": details,
      "work_type": typeOfWork,
      "call_out_hours": callOut,
      "public_libility": publicLiability,
      "work_undertaken": workUnderTaken,
    };
    var formdata = dio.FormData();

    if (isImagePicked.isTrue) {
      formdata.files.addAll([
        MapEntry("profile", await dio.MultipartFile.fromFile(coverPic.path))
      ]);
    }
    Future<String> massag = saveData(formdata, data);

    return massag;
  }

  Future<String> AddImagesAlbumData(
      String albumId, List<File> addImages) async {
    var data = {
      "album_id": albumId,
    };
    var formdata = dio.FormData();
    addImages.forEach((element) async {
      formdata.files.add(
          MapEntry("image[]", await dio.MultipartFile.fromFile(element.path)));
    });

    var token = await getToken();
    var clicent = dio.Dio();
    var response = await clicent.post(
      "https://www.bebuzee.com/api/tradesmen_add_album_image.php",
      data: formdata,
      queryParameters: data,
      options: dio.Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response!.data['success'] == 0) {
      return "false";
    } else {
      imageAdded.value = true;
      return "${response!.data['message']}";
    }
  }

  var imageAdded = false.obs;

  var albumAdded = false.obs;

  Future<String> AddAlbumData(String companyId, String tradesmenId,
      String albumName, File albumPic) async {
    var data = {
      "company_id": companyId,
      "tradesman_id": tradesmenId,
      "album_name": albumName,
    };
    var formdata = dio.FormData();

    formdata.files.addAll([
      MapEntry("album_pic", await dio.MultipartFile.fromFile(albumPic.path))
    ]);

    var token = await getToken();
    var clicent = dio.Dio();
    var response = await clicent.post(
      "https://www.bebuzee.com/api/tradesmen_add_album.php",
      data: formdata,
      queryParameters: data,
      options: dio.Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response!.data['success'] == 0) {
      return "false";
    } else {
      albumAdded.value = true;
      return "${response!.data['message']}";
    }
  }

  Widget exitingCompanyList(futureListName, Function ontap, page) {
    return FutureBuilder<List<DataCompany>>(
      future: futureListName,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          print("has data ");
          if (snapshot.hasData) {
            print("has data ");
            if (snapshot.data!.isEmpty) {
              print("==== ### 11");

              return noCompanyView();
            }
            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    // physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: Column(children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    shape: BoxShape.rectangle,
                                    color: settingsColor,
                                    border: new Border.all(
                                      color: settingsColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 50,
                                  child: Text(
                                    AppLocalizations.of(
                                        snapshot.data![index].name!),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: (() {
                                    selectedIndex = index;
                                    companyId =
                                        snapshot.data![index].companyId!;
                                    ontap();
                                  }),
                                  contentPadding: EdgeInsets.only(
                                      left: 10, bottom: 5, top: 5),
                                  leading: Container(
                                    margin: EdgeInsets.only(right: 5, left: 5),
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      backgroundColor: settingsColor,
                                      child: ClipOval(
                                        child: snapshot.data![index].logo ==
                                                    null ||
                                                snapshot.data![index].logo == ""
                                            ? Icon(
                                                CustomIcons.employee,
                                                size: 40,
                                                color: Colors.white,
                                              )
                                            : Image.network(
                                                snapshot.data![index].logo!,
                                                fit: BoxFit.fill,
                                                height: 50,
                                                width: 50,
                                              ),
                                      ),
                                    ),
                                  ),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of("Contact number") +
                                          " : ${snapshot.data![index].mobile.toString()}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text(AppLocalizations.of(
                                            "Work Area") +
                                        " : ${snapshot.data![index].workArea}"),
                                  ),
                                  trailing: IconButton(
                                      onPressed: (() {}),
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: settingsColor,
                                      )),
                                ),
                              ])),
                        ),
                      );
                    }));
          } else {
            return noCompanyView();
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Center(
            child: Container(
                height: 30,
                child: CircularProgressIndicator(
                  color: settingsColor,
                )));
      },
    );
  }

  Widget noCompanyView() {
    return Center(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CustomIcons.employee,
            size: 70,
            color: settingsColor,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'No Company Added Yet..!',
            style: TextStyle(fontSize: 20, color: settingsColor),
          ),
        ],
      )),
    );
  }
}
