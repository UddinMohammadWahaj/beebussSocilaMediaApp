import 'dart:io';

import 'package:get/get.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHomeController extends GetxController {
  var imagePath = "".obs;
  var videoPath = "".obs;
  var docPath = "".obs;
  var audioPath = "".obs;
  var voicePath = "".obs;
  var thumbsPath = "".obs;

  @override
  void onInit() {
    checkPlatform();
    getPrefs();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setPrefs(String imagePath, String videoPath, String docPath,
      String audioPath, String voicePath, String thumbPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("images", imagePath);
    prefs.setString("videos", videoPath);
    prefs.setString("docs", docPath);
    prefs.setString("audio", audioPath);
    prefs.setString("voice", voicePath);
    prefs.setString("thumb", thumbPath);
  }

  void getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? images = prefs.getString("images");
    String? videos = prefs.getString("videos");
    String? docs = prefs.getString("docs");
    String? audio = prefs.getString("audio");
    String? voice = prefs.getString("voice");
    String? thumb = prefs.getString("thumb");
    if (images != null &&
        videos != null &&
        docs != null &&
        audio != null &&
        voice != null &&
        thumb != null) {
      print("got all paths");
      imagePath.value = images;
      videoPath.value = videos;
      docPath.value = docs;
      audioPath.value = audio;
      voicePath.value = voice;
      thumbsPath.value = thumb;
      print(thumbsPath.value.toString() + " thumbs path");
    } else {
      print("got no paths");
    }
  }

  void checkPlatform() async {
    if (Platform.isAndroid) {
      createFolder();
    }
  }

  void createFolder() async {
    String directory = (await p.getExternalStorageDirectory())!.path;
    List<String> externalPathList = directory.split('/');
    int posOfAndroidDir = externalPathList.indexOf('Android');
    String rootPath = externalPathList.sublist(0, posOfAndroidDir).join('/');
    final path = Directory("$rootPath/Bebuzee");
    var storageStatus = await Permission.storage.status;
    var externalStorageStatus = await Permission.manageExternalStorage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
    if (!externalStorageStatus.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if ((await path.exists())) {
      setPrefs(
          rootPath + "/Bebuzee" + "/Bebuzee Images",
          rootPath + "/Bebuzee" + "/Bebuzee Video",
          rootPath + "/Bebuzee" + "/Bebuzee Documents",
          rootPath + "/Bebuzee" + "/Bebuzee Audio",
          rootPath + "/Bebuzee" + "/Bebuzee Voice Notes",
          rootPath + "/Bebuzee" + "/.thumbnails");
      getPrefs();
      print("exists");
      await Directory(rootPath + "/Bebuzee" + "/.thumbnails")
          .create(recursive: true);
      print(path.path.toString());
    } else {
      var value = await path.create();
      print("create success");
      print(value.path.toString());
      await Directory(rootPath + "/Bebuzee" + "/Bebuzee Images")
          .create(recursive: true);
      await Directory(rootPath + "/Bebuzee" + "/Bebuzee Video")
          .create(recursive: true);
      await Directory(rootPath + "/Bebuzee" + "/Bebuzee Documents")
          .create(recursive: true);
      await Directory(rootPath + "/Bebuzee" + "/Bebuzee Audio")
          .create(recursive: true);
      await Directory(rootPath + "/Bebuzee" + "/Bebuzee Voice Notes")
          .create(recursive: true);
      await Directory(rootPath + "/Bebuzee" + "/.thumbnails")
          .create(recursive: true);
      setPrefs(
          rootPath + "/Bebuzee" + "/Bebuzee Images",
          rootPath + "/Bebuzee" + "/Bebuzee Video",
          rootPath + "/Bebuzee" + "/Bebuzee Documents",
          rootPath + "/Bebuzee" + "/Bebuzee Audio",
          rootPath + "/Bebuzee" + "/Bebuzee Voice Notes",
          rootPath + "/Bebuzee" + "/.thumbnails");
      getPrefs();
    }
  }

  void refreshGallery(String path) {
    if (Platform.isAndroid) {
      MediaScanner.loadMedia(path: path);
    }
  }
}
