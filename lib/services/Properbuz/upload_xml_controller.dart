import 'package:bizbultest/services/Properbuz/api/uploadxml_api.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../current_user.dart';

class UploadXMLController extends GetxController {
  var xmlList = [].obs;
  var isUploading = false.obs;

  int val = CurrentUser().currentUser.memberType!;

  Future<void> pickXml() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.any);

    List<File> allFiles = result!.paths.map((path) => File(path!)).toList();
    allFiles.forEach((element) {
      print("file ${element}");
    });
    xmlList.value = allFiles;
  }

  Future pickAFile(context, Function showSuccess, Function showFail) async {
    String url = 'https://www.bebuzee.com/api/file_upload_xml_list.php';
    FilePickerResult? res = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.any);
    if (res != null) {
      isUploading.value = true;
      File file = File(res.files.single.path!);

      await UploadXmlAPI.uploadXMLfile(url, file).then((value) async {
        if (value == 1) {
          await showSuccess(context);
        } else {
          showFail();
        }
      });
      isUploading.value = false;

      // d.FormData data = new d.FormData.fromMap({
      //   'agent_id': '${CurrentUser().currentUser.memberID}',
      //   "uploadxml": await dio.MultipartFile.fromFile(file.path)
      // });
      // var client = Dio();
      // client
      //     .post('https://www.bebuzee.com/webservices/file_upload_xml_list.php',
      //         data: data)
      //     .then((value) async {
      //   print(
      //       "after xml sent ${value.data} ${value.statusCode} ${value.statusMessage}}");
      //   isUploading.value = false;
      //   await showSuccess(context);
      // });
    } else
      return null;
  }
}
