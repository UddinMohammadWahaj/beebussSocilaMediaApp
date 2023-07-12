import 'dart:io';

import 'package:bizbultest/services/Properbuz/api/country_api.dart';
import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/Properbuz/country_list_model.dart';
import '../../models/Tradesmen/CompanyTradesmenList.dart';
import '../../models/Tradesmen/newtradesmendetailmodel.dart';

class AddTradesmenCompanyConttroller extends GetxController {
  CompanyTradesmenListRecord? companyDetails;
  String? type;
  AddTradesmenCompanyConttroller({this.companyDetails, this.type});
  var serviceDescribeController = TextEditingController();
  TextEditingController emailController = new TextEditingController();
  var nameController = TextEditingController();
  var contactcontroller = TextEditingController();
  var managerNameController = TextEditingController();
  var managerContactNoController = TextEditingController();
  var companylogo = <File>[].obs;
  var companycoverphoto = <File>[].obs;
  var iconLoadCountry = false.obs;
  var websiteController = TextEditingController();
  var countryList = <CountryListModel>[].obs;
  var currentCountry = <CountryListModel>[].obs;
  var locationtext = ''.obs;
  TextEditingController searchCountryloc = new TextEditingController();
  TextEditingController locationController = TextEditingController();
  var locationFieldController = new TextEditingController();
  var isLocationLoading = false.obs;
  var newlocations = [].obs;
  var searchCountryList = <CountryListModel>[].obs;
  void fetchCountry(VoidCallback callback, {countryId: ''}) async {
    var data = await CountryAPI.fetchCountries().then((value) => value);
    countryList.value = data;
    if (this.type == "edit") {
      var filtercountry = data
          .where(
              (element) => element.countryID == this.companyDetails!.countryId)
          .toList();
      currentCountry.value = filtercountry;
    }
    print("got current country=${currentCountry.length}");
  }

  TextEditingController tradesmenalbumnamecontroller =
      new TextEditingController();
  var companyCover = <File>[].obs;
  var companyLogo = <File>[].obs;
  var companyCoverEdit = <String>[].obs;
  var companyLogoEdit = <String>[].obs;
  var currentPhotoAlbumList = <AlbumDatum>[].obs;
  var currentPhotoAlbumList2 = <AlbumDatum2>[].obs;

  Future<void> pickCompanyCover() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    allFiles.forEach((element) {
      print("file ${element}");
    });
    companyCover.value = allFiles;
  }

  var workArea = <WorkArea>[].obs;
  void refreshTradesmenAlbum() {
    albumCoverList.value = [];
    tradesmenalbumnamecontroller.text = '';
  }

  TextEditingController workarealocationController = TextEditingController();
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

  Future<void> pickCompanyLogo() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    allFiles.forEach((element) {
      print("file ${element}");
    });
    companyLogo.value = allFiles;
  }

  Future<void> pickAlbumCover() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    allFiles.forEach((element) {
      print("file ${element}");
    });
    albumCoverList.value = allFiles;
  }

  var albumCoverList = <File>[].obs;

  filterandsetcurrentCountry() {
    // print(
    //     "countrylist=${}");
  }
  void parseAlbum() {}
  void setData() {
    CompanyTradesmenListRecord? data = this.companyDetails;

    nameController.text = data!.companyName!;
    emailController.text = data.companyEmail!;
    contactcontroller.text = data.companyContactNumber!;
    websiteController.text = data.companyWebsite!;
    managerNameController.text = data.managerName!;
    managerContactNoController.text = data.managerContactNumber!;
    serviceDescribeController.text = data.serviceDescription!;
    companyCoverEdit.value = [
      data.albumImageUrl! + '/' + data.companyCoverPhoto!
    ];
    locationtext.value = data.companyLocation!;
    companyLogoEdit.value = [data.albumImageUrl! + '/' + data.companyLogo!].obs;
    locationController.text = data.companyLocation!;
    print("got =${data.workArea![0].city}");
    workArea.addAll(data.workArea!);
    workArea.refresh();
    currentPhotoAlbumList.value = data.albumMedia!
        .map((e) => AlbumDatum(
              albumName: e.albumName,
              albumPic: e.albumPic,
              id: e.id,
              images: e.images!.length == 0
                  ? <String>[].obs
                  : e.images!.map((e) => '$e').toList().obs,
            ))
        .toList();
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

  @override
  void onInit() {
    fetchCountry(() {});
    if (this.type == 'edit') setData();
    super.onInit();
  }
}
