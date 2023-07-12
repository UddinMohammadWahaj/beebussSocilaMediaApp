import 'dart:io';

import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../models/Tradesmen/CompanyTradesmenList.dart';

class BulkUploadTradesmen extends StatefulWidget {
  const BulkUploadTradesmen({Key? key}) : super(key: key);

  @override
  State<BulkUploadTradesmen> createState() => _BulkUploadTradesmenState();
}

class _BulkUploadTradesmenState extends State<BulkUploadTradesmen> {
  @override
  Widget build(BuildContext context) {
    var buctr = Get.put(BulkUploadTradesmenController());
    showCompanyList() async {
      showBarModalBottomSheet(
          context: context,
          builder: (ctx) => Obx(
                () => Container(
                  height: 50.0.h,
                  child: buctr.merchantstorelist.length == 0
                      ? loadingAnimation()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: buctr.merchantstorelist.length,
                          itemBuilder: (ctx, index) => ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  buctr.currentStoreIndex.value = index;
                                  buctr.storeselected.value = true;
                                },
                                title: Text(buctr
                                    .merchantstorelist[index].companyName!),
                              )),
                ),
              ));
    }

    return WillPopScope(
      onWillPop: () async {
        Get.delete<BulkUploadTradesmenController>();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: settingsColor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.delete<BulkUploadTradesmenController>();
              }),
        ),
        body: Container(
          height: 100.0.h,
          width: 100.0.w,
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Card(
                    child: ListTile(
                        onTap: () {
                          showCompanyList();
                        },
                        leading: Icon(Icons.store, color: Colors.black),
                        title: Text(buctr.storeselected.value
                                ? buctr
                                    .merchantstorelist[
                                        buctr.currentStoreIndex.value]
                                    .companyName!
                                : 'Select Company'
                            // AppLocalizations.of("Add") +
                            //   " " +
                            //   AppLocalizations.of("Tradesmen"),

                            ),
                        trailing: buctr.storeselected.value
                            ? IconButton(
                                onPressed: () {
                                  buctr.storeselected.value = false;
                                },
                                icon: Icon(Icons.close))
                            : Icon(Icons.arrow_drop_down)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Obx(
                    () => ListTile(
                      onTap: () {
                        buctr.pickXml();
                      },
                      trailing: buctr.xmlList.length == 0
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : IconButton(
                              onPressed: () {
                                buctr.xmlList.value = [];
                                buctr.xmlList.refresh();
                              },
                              icon: Icon(Icons.close)),
                      leading:
                          Icon(Icons.file_upload_outlined, color: Colors.black),
                      title: Text(buctr.xmlList.length == 0
                              ? 'Select XML file'
                              : 'XML file added '
                          // AppLocalizations.of("Add") +
                          //   " " +
                          //   AppLocalizations.of("Tradesmen")

                          ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (buctr.xmlList.length == 0 &&
                          !buctr.storeselected.value) {
                        Get.snackbar('Error', 'Please fill the reqired',
                            icon: Icon(Icons.error_outline),
                            backgroundColor: Colors.white,
                            duration: Duration(milliseconds: 500));
                        return;
                      }
                      buctr
                          .postXml(
                              companyId: buctr
                                  .merchantstorelist[
                                      buctr.currentStoreIndex.value]
                                  .companyId
                                  .toString(),
                              tradesmenId: '')
                          .then((value) {
                        Get.delete<BulkUploadTradesmenController>();
                        Navigator.of(context).pop();
                      });
                    },
                    icon: Icon(Icons.upload_file),
                    label: Text('Upload'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(settingsColor)),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class BulkUploadTradesmenController extends GetxController {
  // var bebuzeeshopapi = BebuzeeShopApi();
  var merchantstorelist = <CompanyTradesmenListRecord>[].obs;
  var ismerchantstoreloading = false.obs;
  var xmlList = <File>[].obs;
  var storeselected = false.obs;
  var currentStoreIndex = 0.obs;
  void getMerchantStores() async {
    ismerchantstoreloading.value = true;
    print("merchant store call");
    var data =
        await TradesmanApi.getTraddesmenCompanyList().then((value) => value);
    print("merchant store list=$data");
    merchantstorelist.value = data!;
    ismerchantstoreloading.value = false;
    merchantstorelist.refresh();
  }

  @override
  void onInit() {
    getMerchantStores();
    super.onInit();
  }

  Future<void> postXml({
    companyId: '',
    tradesmenId: '',
  }) async {
    var formData = dio.FormData();
    formData.fields.addAll([
      MapEntry('company_id', companyId),
      MapEntry('user_id', CurrentUser().currentUser.memberID!)
    ]);
    formData.files.add(
        MapEntry('file', await dio.MultipartFile.fromFile(xmlList[0].path)));
// formDatat.
    var data = await TradesmanApi.bulkUploadTradesmen(formData);

    Get.snackbar('Success', 'Bulk Upload Success!!',
        duration: Duration(milliseconds: 1000), backgroundColor: Colors.white);
  }

  Future<void> pickXml() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.any);

    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    allFiles.forEach((element) {
      print("file ${element}");
    });
    xmlList.value = allFiles;
  }
}
