import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import '../../api/api.dart';
import '../current_user.dart';

class VirtualTourController extends GetxController {
  var photos = [].obs;
  var current = 'scene'.obs;
  var marker = 0.obs;
  var selectedPge = 1.obs;
  void addScene(name, title, propertyId) async {
    await ApiProvider().fireApiWithParamsPost(
        'https://www.bebuzee.com/api/property/addScenes',
        params: {
          "name": name,
          "title": title,
          "property_id": propertyId,
          "user_id": "${CurrentUser().currentUser.memberID}"
        });
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

  void deleteFile(int index) {
    selectedPge.value = index - 1;
    photos.removeAt(index);
  }
}
