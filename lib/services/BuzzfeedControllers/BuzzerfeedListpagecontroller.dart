import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Buzzerfeed/BuzzListDiscoverModel.dart';
import 'package:bizbultest/models/Buzzerfeed/BuzzerfeedMyListModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BuzzerFeedListPageController extends GetxController {
  TextEditingController listname = TextEditingController();
  TextEditingController description = TextEditingController();
  var filepath = ''.obs;
  var imgFilepath = ''.obs;
  var isLoading = false.obs;
  var mylist = <DataBuzzList>[].obs;
  var selctedListIndex = -1.obs;
  late TabController myListController;
  var discovernewlist = <Data>[].obs;
  var disCoverListLoder = false.obs;
  var selectedList = [].obs;

  void getDiscoverList() async {
    disCoverListLoder.value = true;
    var response = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/buzzerfeed/listData?user_id=${CurrentUser().currentUser.memberID}');
    print("buzz discoverlist=${response}");
    disCoverListLoder.value = false;
    if (response.data['success'] == 1) {
      var result =
          BuzzListDiscoverList.fromJson(response.data['data']).buzzlist;
      discovernewlist.value = result;
    }
  }

  var currentIndex = 0.obs;
  void switchUserPropertyTabs(int index) {
    currentIndex.value = index;
  }

  void createList(VoidCallback callback) async {
    isLoading.value = true;
    var formdata = dio.FormData();
    if (filepath.value != '')
      formdata.files.addAll([
        MapEntry("files", await dio.MultipartFile.fromFile(filepath.value))
      ]);
    print("buzz list create ");
    var response = await ApiProvider()
        .fireApiWithParamsData('https://www.bebuzee.com/api/buzzerfeed/addList',
            params: {
              'user_id': '${CurrentUser().currentUser.memberID}',
              'name': '${listname.text}',
              'description': '${description.text}',
              'privacy': 'public',
            },
            data: formdata);
    print("buzz list create ${response.data}");

    getMyList();
    isLoading.value = false;
    callback();
  }

  void editList(VoidCallback callback, listid) async {
    isLoading.value = true;
    var formdata = dio.FormData();
    if (filepath.value != '')
      formdata.files.addAll([
        MapEntry("files", await dio.MultipartFile.fromFile(filepath.value))
      ]);
    print("buzz list create ");
    var response = await ApiProvider().fireApiWithParamsData(
        'https://www.bebuzee.com/api/buzzerfeed_list_edit.php',
        params: {
          'list_id': listid,
          'user_id': '${CurrentUser().currentUser.memberID}',
          'name': '${listname.text}',
          'description': '${description.text}',
          'privacy': 'public',
        },
        data: formdata);
    print("buzz list create ${response.data}");

    getMyList();
    isLoading.value = false;
    callback();
  }

  var myListLoder = false.obs;
  void getMyList({String? feedMemberId}) async {
    myListLoder.value = true;
    var response = await ApiProvider().fireApiWithParams(
        'https://www.bebuzee.com/api/buzzerfeed/listUserDetails?user_id=${CurrentUser().currentUser.memberID}&feed_user_id=$feedMemberId');
    myListLoder.value = false;
    print("my list response=${response.data}");
    if (response.data['success'] == 1) {
      var data = BuzzListModel.fromJson(response.data['data']).databuzzlist;
      mylist.value = data;
      mylist.refresh();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getDiscoverList();
    getMyList();

    super.onInit();
  }
}
