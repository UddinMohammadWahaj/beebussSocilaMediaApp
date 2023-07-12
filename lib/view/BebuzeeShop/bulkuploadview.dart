import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';
import '../../models/BebuzeeShop/merchantstorelistmodel.dart';
import '../../utilities/loading_indicator.dart';

class BulkploadView extends StatefulWidget {
  const BulkploadView({Key? key}) : super(key: key);

  @override
  State<BulkploadView> createState() => _BulkploadViewState();
}

class _BulkploadViewState extends State<BulkploadView> {
  var controller = Get.put(BulkUploadController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.delete<BulkUploadController>();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Bulk Upload',
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          height: 100.0.h,
          width: 100.0.w,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select Store',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Card(
                child: Obx(
                  () => ListTile(
                    leading: controller.storeselected.value
                        ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                controller
                                    .merchantstorelist[
                                        controller.currentStoreIndex.value]
                                    .storeIcon!))
                        : Icon(Icons.store),
                    title: controller.storeselected.value
                        ? Text(controller
                            .merchantstorelist[
                                controller.currentStoreIndex.value]
                            .storeName!)
                        : Text('Select Your Store'),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () {
                      showBarModalBottomSheet(
                          context: context,
                          builder: (ctx) => Obx(
                                () => Container(
                                  height: 50.0.h,
                                  width: 100.0.w,
                                  child: controller.merchantstorelist.length ==
                                          0
                                      ? Center(child: loadingAnimation())
                                      : ListView.builder(
                                          itemCount: controller
                                              .merchantstorelist.length,
                                          itemBuilder: (ctx, index) => ListTile(
                                                onTap: () {
                                                  controller.currentStoreIndex
                                                      .value = index;
                                                  controller.storeselected
                                                      .value = true;
                                                  Navigator.of(context).pop();
                                                },
                                                leading: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            controller
                                                                .merchantstorelist[
                                                                    index]
                                                                .storeIcon!)),
                                                title: Text(controller
                                                    .merchantstorelist[index]
                                                    .storeName!),
                                              )),
                                  // child:controller. ,
                                ),
                              ));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select XML file',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Card(
                child: Obx(
                  () => ListTile(
                    onTap: () async {
                      controller.pickXml();

                      // showBarModalBottomSheet(
                      //     context: context,
                      //     builder: (ctx) => Obx(
                      //           () => Container(
                      //             height: 50.0.h,
                      //             width: 100.0.w,
                      //             // child:controller. ,
                      //           ),
                      //         ));
                    },
                    leading: Icon(Icons.upload),
                    title: controller.xmlList.length > 0
                        ? Text('XML file added')
                        : Text('Upload XML'),
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (controller.xmlList.length == 0 &&
                          !controller.storeselected.value) {
                        Get.snackbar('Error', 'Please fill the reqired',
                            icon: Icon(Icons.error_outline),
                            backgroundColor: Colors.white,
                            duration: Duration(milliseconds: 500));
                        return;
                      }
                      controller.bebuzeeshopapi.bulkUpload(
                          controller
                              .merchantstorelist[
                                  controller.currentStoreIndex.value]
                              .storeId,
                          controller.xmlList[0]);
                      Get.snackbar('Success', 'Bulk Upload success',
                          icon: Icon(Icons.check),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 500));
                      controller.storeselected.value = false;
                      controller.xmlList.value = [];
                    },
                    icon: Icon(Icons.upload_file),
                    label: Text('Upload'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
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

class BulkUploadController extends GetxController {
  var bebuzeeshopapi = BebuzeeShopApi();
  var merchantstorelist = <MerchantStoreListDatum>[].obs;
  var ismerchantstoreloading = false.obs;
  var xmlList = <File>[].obs;
  var storeselected = false.obs;
  var currentStoreIndex = 0.obs;
  void getMerchantStores() async {
    ismerchantstoreloading.value = true;
    var data = await bebuzeeshopapi.getStoreData();
    print("merchant store list=$data");
    merchantstorelist.value = data;
    ismerchantstoreloading.value = false;
    merchantstorelist.refresh();
  }

  @override
  void onInit() {
    getMerchantStores();
    super.onInit();
  }

  Future<void> postXml(storeid) async {
    var data = await bebuzeeshopapi.bulkUpload(
        storeid, xmlList.length > 0 ? xmlList[0] : null);
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
