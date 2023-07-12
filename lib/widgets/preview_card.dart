import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
// import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/utilities/orientation_utils.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PreviewCardWidget extends StatelessWidget {
  final String lastPhotoPath;
  final Animation<Offset> previewAnimation;
  final ValueNotifier<CameraOrientations> orientation;
  // final imgCropKey = GlobalKey<ImgCropState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PreviewCardWidget({
    Key? key,
    required this.lastPhotoPath,
    required this.previewAnimation,
    required this.orientation,
  }) : super(key: key);

  // void updateImage() async {
  //   final crop = imgCropKey.currentState;
  //   final croppedFile = await crop.cropCompleted(File(lastPhotoPath), preferredSize: 1000);

  //   final uri = Uri.parse(
  //       "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=update_profile_picture&user_id=${CurrentUser().currentUser.memberID}&image=kkk");
  //   final req = new http.MultipartRequest("POST", uri);
  //   final stream = http.ByteStream(Stream.castFrom(croppedFile.openRead()));
  //   final length = await croppedFile.length();
  //   final multipartFile = http.MultipartFile(
  //     'image',
  //     stream,
  //     length,
  //     filename: path.basename(croppedFile.path),
  //   );

  //   req.files.add(multipartFile);

  //   final res = await req.send();
  //   await for (var value in res.stream.transform(utf8.decoder)) {
  //     print(value);
  //   }

  //   print(res.statusCode);
  //   print(res.contentLength);

  //   print(res);
  // }

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    bool mirror;
    switch (orientation.value) {
      case CameraOrientations.PORTRAIT_UP:
      case CameraOrientations.PORTRAIT_DOWN:
        alignment = orientation.value == CameraOrientations.PORTRAIT_UP
            ? Alignment.bottomLeft
            : Alignment.topLeft;
        mirror = orientation.value == CameraOrientations.PORTRAIT_DOWN;
        break;
      case CameraOrientations.LANDSCAPE_LEFT:
      case CameraOrientations.LANDSCAPE_RIGHT:
        alignment = Alignment.topLeft;
        mirror = orientation.value == CameraOrientations.LANDSCAPE_LEFT;
        break;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.keyboard_backspace_outlined,
                    size: 4.0.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      // updateImage();
                      ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
                          AppLocalizations.of(
                              'Profile picture updated successfully')));

                      Timer(Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    child: Icon(
                      Icons.check,
                      size: 4.0.h,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ),
          _buildPreviewPicture(reverseImage: mirror),
        ],
      ),
    );
  }

  Widget _buildPreviewPicture({bool reverseImage = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: lastPhotoPath != null
          ? Container(height: 40.0.h, color: Colors.black, child: Text("data")
              // ImgCrop(
              //   key: imgCropKey,
              //   chipRadius: 32.0.w, // crop area radius
              //   chipShape: ChipShape.circle, // crop type "circle" or "rect"
              //   image: FileImage(
              //     File(lastPhotoPath),
              //   ), // you selected image file
              // ),
              )
          : Container(
              width: OrientationUtils.isOnPortraitMode(orientation.value)
                  ? 128
                  : 256,
              height: 40.0.h,
              decoration: BoxDecoration(
                color: Colors.black38,
              ),
              child: Center(
                child: Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
