import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io' as i;
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ChangeThumbnail extends StatefulWidget {
  final String? thumbnail;
  final Function? refreshChannel;
  final String? postID;

  ChangeThumbnail({Key? key, this.thumbnail, this.refreshChannel, this.postID})
      : super(key: key);

  @override
  _ChangeThumbnailState createState() => _ChangeThumbnailState();
}

class _ChangeThumbnailState extends State<ChangeThumbnail> {
  bool imagePicked = false;

  late i.File _image;

  _imgFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _image = i.File(result.files.single.path!);
        imagePicked = true;
      });
    } else {
      // User canceled the picker
    }
  }

  void uploadImage() async {
    final uri = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/channel_apis_calls.php?action=create_custom_thumb_for_video&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.postID}&file1=file1");
    final req = new http.MultipartRequest("POST", uri);

    print(imagePicked.toString() + "   is image picked");
    final stream = http.ByteStream(Stream.castFrom(_image.openRead()));
    final length = await _image.length();
    final multipartFile = http.MultipartFile(
      'file1',
      stream,
      length,
      filename: path.basename(_image.path),
    );

    req.files.add(multipartFile);

    final res = await req.send();
    await for (var value in res.stream.transform(utf8.decoder)) {
      print(value + " bodyyyyyyyyyy");
    }
    print(res.statusCode);
    print(res.contentLength);
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          splashColor: Colors.grey.withOpacity(0.3),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_backspace_outlined,
                  size: 3.5.h,
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Text(
                  AppLocalizations.of(
                    "Change Thumbnail",
                  ),
                  style: whiteBold.copyWith(fontSize: 16.0.sp),
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
      ),
      body: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                    child: Image.network(
                      widget.thumbnail!,
                      fit: BoxFit.cover,
                    ))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
            child: !imagePicked
                ? InkWell(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: new Border.all(
                            color: Colors.white,
                            width: 0.5,
                          ),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 3.0.h,
                              ),
                              Text(
                                AppLocalizations.of(
                                  "Add new thumbnail",
                                ),
                                style: whiteBold.copyWith(fontSize: 12.0.sp),
                              )
                            ],
                          ),
                        )),
                  )
                : Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.file(i.File(_image.path)))),
          ),
          Padding(
            padding: EdgeInsets.only(right: 3.0.w, top: 2.0.h, bottom: 2.0.h),
            child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.refreshChannel!();
                    uploadImage();
                  },
                  child: Text(
                    AppLocalizations.of(
                      "Update",
                    ),
                    style: TextStyle(fontSize: 10.0.sp),
                  ),
                )

                //  RaisedButton(
                //   color: Colors.white,
                //   focusColor: Colors.white,
                //   onPressed: () {
                //     Navigator.pop(context);
                //     widget.refreshChannel();
                //     uploadImage();
                //   },
                //   child: Text(
                //     AppLocalizations.of(
                //       "Update",
                //     ),
                //     style: TextStyle(fontSize: 10.0.sp),
                //   ),
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
