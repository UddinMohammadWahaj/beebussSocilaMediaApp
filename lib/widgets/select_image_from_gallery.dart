import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/profile_picture_picker_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../api/ApiRepo.dart' as ApiRepo;
import 'Chat/chat_camera_screen.dart';
import 'Newsfeeds/publish_state.dart';

class SelectImageFromGallery extends StatefulWidget {
  final GlobalKey<ScaffoldState>? sKey;
  final VoidCallback? changeImage;

  SelectImageFromGallery({Key? key, this.sKey, this.changeImage})
      : super(key: key);

  @override
  _SelectImageFromGalleryState createState() => _SelectImageFromGalleryState();
}

class _SelectImageFromGalleryState extends State<SelectImageFromGallery> {
  // final imgCropKey = GlobalKey<ImgCropState>();
  late List<FileModel> files;
  late FileModel selectedModel;
  late String image;
  late File selectedFile;
  HomepageRefreshState refresh = new HomepageRefreshState();
  List<GalleryThumbnails> assets = [];
  bool areAssetsLoaded = false;

  void _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    List<GalleryThumbnails> data = [];
    recentAssets.forEach((element) {
      data.add(GalleryThumbnails(element, false));
    });

    if (mounted) {
      setState(() => assets = data);
      File? file = await assets[0].asset!.file;
      setState(() {
        selectedFile = file!;
        areAssetsLoaded = true;
      });
    }
  }

  // Future<void> updateImageProgress() async {
  //   final crop = imgCropKey.currentState;
  //   final croppedFile = await crop.cropCompleted(selectedFile, preferredSize: 1000);
  //   var request = mp.MultipartRequest();
  //   request.setUrl(
  //       "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=update_profile_picture&user_id=${CurrentUser().currentUser.memberID}&image=kkk");
  //   request.addFile("image", croppedFile.path);
  //   mp.Response response = request.send();
  //   response.onError = () {
  //     print("Error");
  //   };
  //   response.onComplete = (response) async {
  //     print(response);
  //      CurrentUser().currentUser.image =  jsonDecode(response)['image'];
  //   //    });setState(() {
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString("image", jsonDecode(response)['image']);
  //     print("changed");
  //     refresh.updateRefresh(true);
  //     Navigator.pop(context);
  //   };
  //   print(croppedFile.path.toString());
  //   response.progress.listen((int progress) {
  //     print("progress from response object " + progress.toString());
  //   });
  // }

  Future<void> updateProfilePicture() async {
    var client = new dio.Dio();
    dio.FormData formData = new dio.FormData.fromMap({
      "user_id": CurrentUser().currentUser.memberID,
      // "image":"kkk",
      "image": await dio.MultipartFile.fromFile(selectedFile.path),
    });
    Get.dialog(ProcessingDialog(
      title: "Updating your profile photo...",
      heading: "Please wait",
    ));
    // var res = await client.post(
    //   "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=update_profile_picture&user_id=${CurrentUser().currentUser.memberID}&image=kkk",
    //   data: formData,
    //   onSendProgress: (int sent, int total) {
    //     final progress = (sent / total) * 100;
    //     print('profile picture progress: $progress');
    //   },
    // );

    var response = await ApiRepo.postWithTokenAndFormData(
        "api/member_profile_update.php", formData, (int sent, int total) {
      final progress = (sent / total) * 100;
      print('profile picture progress: $progress');
    });
    if (response.success == 1) {
      setState(() {
        CurrentUser().currentUser.image = response.data['data']['image'];
      });
      Get.back();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("image", response.data['data']['image']);
      print("changed");
      refresh.updateRefresh(true);
      customToastWhite("Profile picture updated", 15, ToastGravity.BOTTOM);
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
      print(response.data.toString() + " profile picture");
    } else {
      Get.back();
      customToastWhite(response?.message ?? "Profile picture not updated", 15,
          ToastGravity.BOTTOM);
    }
  }

  Widget _iconButton(
      IconData icon, VoidCallback onTap, Color color, Alignment alignment) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        width: 15.0.w,
        height: 50,
        color: Colors.transparent,
        child: Icon(
          icon,
          size: 30,
          color: color,
        ),
      ),
    );
  }

  Widget _titleBar() {
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(Icons.clear, () {
            Navigator.pop(context);
          }, Colors.black, Alignment.centerLeft),
          Container(
            height: 50,
            color: Colors.transparent,
            width: 70.0.w - 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(
                    "Gallery",
                  ),
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ],
            ),
          ),
          _iconButton(Icons.check, () {
            updateProfilePicture();
          }, Colors.green, Alignment.centerRight)
        ],
      ),
    );
  }

  Widget _cropper() {
    return Stack(
      children: [
        Container(
            height: 50.0.h,
            width: 100.0.w,
            color: Colors.transparent,
            child: Image.file(
              selectedFile,
              fit: BoxFit.cover,
            )),
        Container(
          height: 50.0.h,
          width: 100.0.w,
          color: Colors.grey.withOpacity(0.7),
        ),
        Center(
          child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25.0.h,
                backgroundImage: FileImage(selectedFile)),
          ),
        )
      ],
    );
  }

  Widget _assetsGrid() {
    return GridView.builder(
        padding: EdgeInsets.only(top: 3),
        itemCount: assets.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1),
        itemBuilder: (context, index) {
          return ImageThumbnails(
            onTap: () async {
              File? file = await assets[index].asset!.file;
              setState(() {
                selectedFile = file!;
              });
            },
            asset: assets[index].asset!,
          );
        });
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          titleSpacing: 5,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: _titleBar(),
        ),
      ),
      body: areAssetsLoaded
          ? Column(
              children: [
                _cropper(),
                Container(height: 50.0.h - 125, child: _assetsGrid()),
              ],
            )
          : Container(),
    );
  }
}

class ImageThumbnails extends StatefulWidget {
  final VoidCallback? onTap;
  final int? index;
  final int? currentIndex;

  const ImageThumbnails({
    Key? key,
    required this.asset,
    this.onTap,
    this.index,
    this.currentIndex,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  _ImageThumbnailsState createState() => _ImageThumbnailsState();
}

class _ImageThumbnailsState extends State<ImageThumbnails> {
  late Future<Uint8List?> future;

  @override
  void initState() {
    future = widget.asset.thumbnailData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: future,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null)
          return Container(
              color: Colors.black,
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))));
        // If there's data, display it as an image
        return InkWell(
          onTap: widget.onTap ?? () {},
          child: Container(child: Image.memory(bytes, fit: BoxFit.cover)),
        );
      },
    );
  }
}
