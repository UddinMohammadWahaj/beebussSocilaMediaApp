import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Properbuz/city_list_model.dart';
import 'package:bizbultest/models/Properbuz/country_list_model.dart';
import 'package:bizbultest/models/Tradesmen/findtrademendetailmodel.dart'
    as detailmodel;
import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Properbuz/api/location_reviews_api.dart';
import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart' as imgpicker;
import '../../Language/appLocalization.dart';
import '../../api/ApiRepo.dart' as ApiRepo;
import '../current_user.dart';

class WriteReviewController extends GetxController {
  var rating = 0.0.obs;
  Rx<File> thumbnail = File("aa").obs;
  var selectedCountry = 'Select a country'.obs;
  var photos = <File>[].obs;
  var cityList = <CityListModel>[].obs;
  var countryList = <CountryListModel>[].obs;
  TextEditingController searchCity = new TextEditingController();

  var selectedPge = 1.obs;
  var isUploading = false.obs;
  var editLoding = false.obs;

  void selectCountry(Country ct) async {
    selectedCountry.value = ct.name;
    await fetchCity();
  }

  Future fetchLoc(
    key,
  ) async {
    List listofcity =
        await CountryAPI.fetchLocations(key, selectedCountry.value);
    print("fetch location outpur=$listofcity");
    cityList.value = listofcity as List<CityListModel>;
  }

  Future fetchCity() async {
    List<CityListModel> listofcity =
        await CountryAPI.fetchCities(selectedCountry.value);
    cityList.value = listofcity;
  }

  Future fetchCountry() async {
    List<CountryListModel> listofcountry = await CountryAPI.fetchCountries();
    countryList.value = listofcountry;
  }

  String ratingString(int rating) {
    switch (rating) {
      case 1:
        return AppLocalizations.of("Terrible");
        break;
      case 2:
        return AppLocalizations.of("Poor");
        break;
      case 3:
        return AppLocalizations.of("Average");
        break;
      case 4:
        return AppLocalizations.of("Very") + " " + AppLocalizations.of("good");
        break;
      case 5:
        return AppLocalizations.of("Excellent");
        break;
      default:
        return AppLocalizations.of("Not") + " " + AppLocalizations.of("rated");
        break;
    }
  }

  var pickedThumbnail = false.obs;

  void pickThumbnail() async {
    pickedThumbnail.value = true;
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    thumbnail.value = allFiles[0];
  }

  void pickPhotos() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    photos.value = allFiles;
  }

  var pickedPhotosFile = false.obs;

  void pickPhotosFiles() async {
    pickedPhotosFile.value = true;
    List<imgpicker.XFile> allFiles =
        await imgpicker.ImagePicker().pickMultiImage();
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

  Future<void> onSubmit(
      context, Map<String, dynamic> query, Function showSuccess) async {
    isUploading.value = true;

    var resp = await LocationReviewsAPI.postLocationReview(
        query, thumbnail.value.path == "aa" ? null : thumbnail.value, photos);

    if (resp == 1) {
      await showSuccess(context);
    }

    isUploading.value = false;
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

  Future<String> AddFeedback(
      {companyId: '',
      tradesmenId: '',
      relaibility: '',
      tidiness: '',
      courtesy: '',
      workmanship: '',
      description: ''}) async {
    // var data = {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "time_rate": timeRate,
    //   "work_rate": workRate,
    //   "satisfaction_rate": satisfactionRTate,
    //   "service_rate": serviceRate,
    //   "tradesman_id": tradesmanId,
    //   "company_id": companyId,
    //   "review": review,
    // };
    // print("object.. add feedback data == $data");
    var url = 'https://www.bebuzee.com/api/tradesmen/addTradesmenReview';
    var formData = dio.FormData();
    formData.fields.addAll([
      MapEntry('company_id', companyId),
      MapEntry('tradesmen_id', tradesmenId),
      MapEntry('reliability', relaibility),
      MapEntry('tidiness', tidiness),
      MapEntry('courtesy', courtesy),
      MapEntry('workmanship', workmanship),
      MapEntry('description', description),
      MapEntry('user_id', CurrentUser().currentUser.memberID!)
    ]);
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, formdata: formData)
        .then((value) => value);
    // var response =
    //     await ApiRepo.postWithToken("api/tradesmen_add_review.php", data);

    print("object....441 ${response!.data}");
    if (response!.data == null) {
      print("object....442 ${response!.data}");
      return "false";
    } else if (response!.data['success'] == 0) {
      print("object....444 ${response!.data}");
      return "false";
    } else {
      print("object....443 ${response!.data}");
      return "${response!.data['msg']}";
    }
  }

  Future<String> AddRequestCallback(
    String name,
    String mobile,
    String tradesmanId,
    String companyId,
  ) async {
    var data = {
      "user_id": CurrentUser().currentUser.memberID,
      "name": name,
      "mobile": mobile,
      "tradesman_id": tradesmanId,
      "company_id": companyId,
    };
//     name:Aditya Pandey
// contact_number:5655766567
// description:test
// tradesmen_id:
// company_id:3
    var formData = dio.FormData();
    formData.fields.addAll([
      MapEntry('name', name),
      MapEntry('contact_number', mobile),
      MapEntry('tradesmen_id', tradesmanId),
      MapEntry('company_id', companyId)
    ]);
    var response =
        await TradesmanApi.requestCallback(data).then((value) => value);

    print("object....441 ${response!.data}");
    if (response!.data == null) {
      print("object....442 ${response!.data}");
      return "false";
    } else if (response!.data['success'] == 0) {
      print("object....444 ${response!.data}");
      return "false";
    } else {
      print("object....443 ${response!.data}");
      return "Success";
    }
  }

  Future<String> deleteFeedback(
    String mamberId,
    String reviewId,
  ) async {
    var data = {
      "user_id": mamberId,
      "review_id": reviewId,
    };
    var response =
        await ApiRepo.postWithToken("api/tradesmen_review_delete.php", data);

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
