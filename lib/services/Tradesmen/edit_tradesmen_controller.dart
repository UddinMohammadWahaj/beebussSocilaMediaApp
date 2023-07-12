import 'dart:io';

import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../models/Properbuz/country_list_model.dart';
import '../../models/Tradesmen/newtradesmendetailmodel.dart';
import '../../models/Tradesmen/tradesmen_subcat_model.dart';
import '../../models/Tradesmen/tradesmens_work_category_model.dart';
import '../../utilities/Chat/colors.dart';
import '../../utilities/colors.dart';

class EditTradesmenController extends GetxController {
  var namcontroller = TextEditingController();
  String? from = '';
  String? tradesmenId = '';
  EditTradesmenController({this.from, this.tradesmenId});
  var contactcontroller = TextEditingController();
  var alternativecontactcontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var experiencecontroller = TextEditingController();
  var serviceDescribeController = TextEditingController();
  var tradesmendetail = <Record>[].obs;
  var currentWorkCategory = <WorkCategory>[].obs;
  var workCategoryList = <WorkCategory>[].obs;
  var currentCountryIid = '';
  var lisofworkareafromapi = [];
  var currentCountry = <CountryListModel>[].obs;
  var countryList = <CountryListModel>[].obs;
  var iconLoadCountry = false.obs;
  var searchCountryList = <CountryListModel>[].obs;
  var subcatvalue = 'Select Sub category'.obs;
  var locationtext = ''.obs;
  TextEditingController typeOfWorkController = new TextEditingController();
  TextEditingController searchCountryloc = new TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController workarealocationController = TextEditingController();
  var workArea = [].obs;
  TextEditingController tradesmenalbumnamecontroller =
      new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  var lstWorksubCat = <TradesmenSubCatModelWorkSubCategory>[].obs;
  var selectedsbcat = <TradesmenSubCatModelWorkSubCategory>[].obs;
  var currentPhotoAlbumList = <AlbumDatum>[].obs;
  var currentPhotoAlbumList2 = <AlbumDatum2>[].obs;
  var albumCoverList = <File>[].obs;
  List<String> textsWorkList =
      ["Domestic", "Commercial", "Both Domestic and Commercial"].obs;

  var typeOfWorkList = {
    "Domestic": false,
    "Commercial": false,
    "Both Domestic and Commercial": false
  }.obs;
  Future<void> pickAlbumCover() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    allFiles.forEach((element) {
      print("file ${element}");
    });
    albumCoverList.value = allFiles;
  }

  void refreshTradesmenAlbum() {
    albumCoverList.value = [];
    tradesmenalbumnamecontroller.text = '';
  }

  void addtoTradesmenAlbum() async {
    print("album length=${albumCoverList.length}");
    var albumUrl = await TradesmanApi.getAlbumLink(albumCoverList[0]);
    currentPhotoAlbumList.add(AlbumDatum(
      albumName: tradesmenalbumnamecontroller.text,
      albumPic: albumUrl,
      images: <String>[].obs,
    ));
    currentPhotoAlbumList.refresh();

    refreshTradesmenAlbum();
  }

  void pickAlbumImages(index, Function setState) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    var multipleurl = await TradesmanApi.getMultipleImagesLink(allFiles);
    var parsedurl = multipleurl.split(',');
    print("parsed url=${parsedurl}");
    currentPhotoAlbumList[index].images!.addAll(parsedurl);
    currentPhotoAlbumList[index].images!.refresh();
  }

  void removeFromTradesmenAlbum(index) async {
    currentPhotoAlbumList.removeAt(index);
    currentPhotoAlbumList.refresh();
  }

  getWorkTypeIndex(String worktype) {
    switch (worktype) {
      case "Domestic":
        return 0;
      case "Commercial":
        return 1;
      case "Both Domestic and Commercial":
        return 2;
      default:
        return 2;
        break;
    }
  }

  var selectedWorkTypeIndex = 0.obs;

  void setTradesmenCompanyData() {
    namcontroller.text = tradesmendetail[0].fullName ?? '';
    contactcontroller.text = tradesmendetail[0].contactNumber.toString() ?? '';
    alternativecontactcontroller.text =
        tradesmendetail[0].alternativeContactNumber.toString() ?? '';
    experiencecontroller.text = tradesmendetail[0].experience.toString() ?? '';
    serviceDescribeController.text =
        tradesmendetail[0].serviceDescription.toString() ?? '';
    available24.value =
        tradesmendetail[0].callOut!.toLowerCase() == "yes" ? true : false;
    workUndertaking.value =
        tradesmendetail[0].undertaken!.toLowerCase() == "yes" ? true : false;
    publicliability.value =
        tradesmendetail[0].insurance!.toLowerCase() == 'yes' ? true : false;
    currentCountryIid = tradesmendetail[0].countryId.toString();
    lisofworkareafromapi = tradesmendetail[0].workArea!;
    workArea.value = lisofworkareafromapi;
    print('workarea listt=${workArea.length}');
    locationController.text = tradesmendetail[0].location!;
    locationFieldController.text = tradesmendetail[0].location!;
    selectedWorkTypeIndex.value =
        getWorkTypeIndex(tradesmendetail[0].workType!);
    emailController.text = tradesmendetail[0].email!;
    fetchCountry(() {}, countryId: currentCountryIid);
    getTradeCat(tradeCatId: tradesmendetail[0].categoryId.toString());
  }

  void setTradesmenData() {
    namcontroller.text = tradesmendetail[0].fullName ?? '';
    contactcontroller.text = tradesmendetail[0].contactNumber.toString() ?? '';
    alternativecontactcontroller.text =
        tradesmendetail[0].alternativeContactNumber.toString() ?? '';
    experiencecontroller.text = tradesmendetail[0].experience.toString() ?? '';
    serviceDescribeController.text =
        tradesmendetail[0].serviceDescription.toString() ?? '';
    available24.value =
        tradesmendetail[0].callOut!.toLowerCase() == "yes" ? true : false;
    workUndertaking.value =
        tradesmendetail[0].undertaken!.toLowerCase() == "yes" ? true : false;
    publicliability.value =
        tradesmendetail[0].insurance!.toLowerCase() == 'yes' ? true : false;
    currentCountryIid = tradesmendetail[0].countryId.toString();
    lisofworkareafromapi = tradesmendetail[0].workArea!;

    emailController.text = tradesmendetail[0].email!;
    selectedWorkTypeIndex.value =
        getWorkTypeIndex(tradesmendetail[0].workType!);
    print("photo album length-${tradesmendetail[0].albumData!.length}");
    currentPhotoAlbumList.value = tradesmendetail[0].albumData!;
    fetchCountry(() {}, countryId: currentCountryIid);
    getTradeCat(tradeCatId: tradesmendetail[0].categoryId.toString());
  }

  var currentSubCategory = <TradesmenSubCatModelWorkSubCategory>[].obs;
  var workUndertaking = true.obs;

  var available24 = false.obs;
  var publicliability = false.obs;
  updatePublic(bool val) {
    publicliability.value = val;
  }

  Future<void> fetchsubData(String catid) async {
    // lstWorksubCat.clear();

    List<TradesmenSubCatModelWorkSubCategory> lstTradesmenWorkCategoryModel =
        await ApiProvider().tradsmenSubWorkCategory(catid);

    lstWorksubCat.value = lstTradesmenWorkCategoryModel;
    var dummyslected = <TradesmenSubCatModelWorkSubCategory>[];
    for (var allsubcat in tradesmendetail[0].workSubcategory!) {
      for (var availablesubcat in lstWorksubCat.value) {
        if (availablesubcat.tradeSubcatId == allsubcat.toString()) {
          dummyslected.add(availablesubcat);
          break;
        }
      }
    }
    print("selected response=${dummyslected.length}");
    selectedsbcat.value = dummyslected;
    selectedsbcat.refresh();
  }

  updateAvailabel(bool val) {
    available24.value = val;
  }

  void updateCountryList(String pattern) async {
    var dataList = countryList.value;
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

  getTradeCat({tradeCatId: ''}) async {
    print("called $tradeCatId");
    var data = await TradesmanApi.getTradesmenCategory();
    workCategoryList.value = data!;
    var filtertradecat =
        data!.where((element) => element.tradeCatId == tradeCatId).toList();
    currentWorkCategory.value = filtertradecat;
    print("current trade cat=${currentWorkCategory[0].tradeCatName}}");
    currentWorkCategory.refresh();
    fetchsubData(tradesmendetail[0].categoryId.toString());
  }

  updateWorkUnderTaking(bool val) {
    workUndertaking.value = val;
  }

  void fetchCountry(VoidCallback callback, {countryId: ''}) async {
    print("fetch country called");
    var data = await CountryAPI.fetchCountries().then((value) => value);
    countryList.value = data;
    print("country list=${data}");
    var filtercountry =
        data.where((element) => element.countryID == countryId).toList();
    currentCountry.value = filtercountry;
    print("got current country=${currentCountry[0].country}");
  }

  void getCompanyTradesmenDetail(tradesmenId) async {
    print("currentid=${tradesmenId}");
    var data = await TradesmanApi.getCompanyTradesmenDetail(tradesmenId);
    if (data != null) {
      tradesmendetail.value = [data];
      print("company trades data fetch");
      setTradesmenCompanyData();
    }
  }

  void getTradesmenDetail() async {
    print("currentid=${CurrentUser().currentUser.memberID}");
    var data = await TradesmanApi.getTradesmenDetail();
    if (data != null) {
      tradesmendetail.value = [data];
      setTradesmenData();
    }
  }

  var locationFieldController = new TextEditingController();
  var isLocationLoading = false.obs;
  var newlocations = [].obs;

  void updateCompanyTradesmen(
      Map<String, dynamic> data, VoidCallback callback) async {
    await TradesmanApi.updateCompanyTradesmenDetail(data);
    callback();
  }

  // void getFilteredLocation(searchKey) async {
  //   gifloading.value = true;
  //   await PostStoryApi.getGiphyGifs(gif_search: searchKey).then((value) {
  //     filteredgifListStickers.value = value.stickers;
  //   });
  //   gifloading.value = false;
  // }

  void fetchLoc() async {
    newlocations.value = await CountryAPI.fetchLocations(
        locationtext.value, currentCountry[0].country!);
    print(
        "location value=${newlocations[0].city} length=${newlocations.length}");
    isLocationLoading.value = false;
    newlocations.refresh();
  }

  @override
  void onInit() {
    if (this.from == 'company')
      getCompanyTradesmenDetail(this.tradesmenId);
    else
      getTradesmenDetail();

    debounce(locationtext, (_) => fetchLoc(),
        time: Duration(milliseconds: 300));
    super.onInit();
  }
}

class TradesmenAlbumModel {
  String? albumphotoUrl;
  String? albumName;
  List<String?>? albumImages;
  TradesmenAlbumModel({this.albumphotoUrl, this.albumName, this.albumImages});
}
