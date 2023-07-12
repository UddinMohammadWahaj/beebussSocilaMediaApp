import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/add_multiple_stories_model.dart';
import 'package:bizbultest/services/Highlight/newhighlightcontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/edit_profile_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/form_data.dart' as dio;
import 'package:dio/dio.dart' as diomul;
import 'edit_highlight_cover.dart';

class NewHighlightFromMultipleStories extends StatefulWidget {
  final Function? setNavbar;
  final List<String>? selectedStoriesID;
  final List<FileElement>? selectedFiles;

  NewHighlightFromMultipleStories(
      {Key? key, this.setNavbar, this.selectedFiles, this.selectedStoriesID})
      : super(key: key);

  @override
  _NewHighlightFromMultipleStoriesState createState() =>
      _NewHighlightFromMultipleStoriesState();
}

class _NewHighlightFromMultipleStoriesState
    extends State<NewHighlightFromMultipleStories> {
  String? selectedCoverID = "";
  String? selectedCoverImage = "";
  TextEditingController _controller = TextEditingController();
  File? cover;
  bool? isCoverFromGallery = false;
  var highlightID;

  Future<void> addToNewHighlight() async {
    var url =
        "https://www.bebuzee.com/api/add_new_heightlight_cover_data.php?action=add_new_heightlight_data_cover_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_ids_story_ids=${widget.selectedStoriesID!.join(",")}&default=$selectedCoverID&hightlight_name=${_controller.text.isNotEmpty ? _controller.text : "Highlights"}";

    var response = await ApiProvider().fireApi(url).then((value) => value);

    // print("response of api call=${response.data}");

    if (response.data['success'] == 1) {
      if (mounted) {
        setState(() {
          print("response of api call=${response.data}");
          // try {
          //   print("cover highlightid before=${response.data['data_id']}");
          // } catch (e) {
          //   print("cover highlightid before=$e");
          // }
          highlightID = response.data['data_id'].toString();
          print(
              "cover highlightid resp=${highlightID} response=${response.data['data_id']}");
        });
      }

      try {
        customCover(response.data['data_id']);
      } catch (e) {
        print("cover error $e");
      }
    }
  }

  Future<void> customCover(highlightID) async {
    // var request = mp.MultipartRequest();
    print("custom cover called");
    var url =
        'https://www.bebuzee.com/api/update_highlight_default_picture.php?action=update_highlight_default_picture&highlight_id=$highlightID&user_id=${CurrentUser().currentUser.memberID}';
    print("cover add url=${url}");
    var formdata = dio.FormData();
    formdata.files.add(
        MapEntry('file1', await diomul.MultipartFile.fromFile(cover!.path)));
    var response = await ApiProvider()
        .fireApiWithParamsData(url, data: formdata)
        .then((value) => value);
    print("cover add respinse=${response.data}");
    // request.setUrl(
    //     "https://www.bebuzee.com/api/update_highlight_default_picture.php?action=update_highlight_default_picture&highlight_id=$highlightID&user_id=${CurrentUser().currentUser.memberID}&file1=");
    // request.addFile("file1", cover.path);
    // mp.Response response = request.send();
    // response.onError = () {
    //   print("Error");
    // };
    // response.onComplete = (response) {
    //   print(response);
    // };
    // response.progress.listen((int progress) {
    //   print("progress from response object " + progress.toString());
    // });
  }

  @override
  void initState() {
    selectedCoverImage =
        widget.selectedFiles![0].image?.replaceAll(".mp4", ".jpg");
    selectedCoverID = widget.selectedStoriesID![0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(
                      "Edit",
                    ),
                    style: blackBold.copyWith(fontSize: 14.0.sp),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    addToNewHighlight();

                    Fluttertoast.showToast(
                      msg: AppLocalizations.of(
                        "New Highlight Added",
                      ),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.black.withOpacity(0.7),
                      textColor: Colors.white,
                      fontSize: 15.0,
                    );

                    Timer(Duration(seconds: 2), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Get.delete<AddNewHighlightController>();
                      widget.setNavbar!(false);
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        AppLocalizations.of(
                          "Done",
                        ),
                        style: TextStyle(
                            color: primaryBlueColor, fontSize: 12.0.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(0.5.w),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: isCoverFromGallery! && cover != null
                          ? Image.file(
                              cover!,
                              fit: BoxFit.cover,
                              height: 100,
                              alignment: Alignment.topCenter,
                            )
                          : Image.network(
                              selectedCoverImage!,
                              fit: BoxFit.cover,
                              height: 100,
                              alignment: Alignment.topCenter,
                            )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditHighlightCover(
                                selectedFiles: widget.selectedFiles!,
                                selectedStoriesID: widget.selectedStoriesID!,
                                isImageFromGallery: () {
                                  setState(() {
                                    cover = null;
                                    isCoverFromGallery = false;
                                  });
                                },
                                setCover: (coverID, coverImage) {
                                  setState(() {
                                    selectedCoverID = coverID;
                                    selectedCoverImage = coverImage;
                                  });
                                },
                                clear: () {},
                                coverFromGallery: (coverFile) {
                                  setState(() {
                                    cover = coverFile;
                                    isCoverFromGallery = true;
                                  });
                                },
                              )));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    AppLocalizations.of(
                      "Edit cover",
                    ),
                    style: TextStyle(color: primaryBlueColor, fontSize: 9.0.sp),
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  onChanged: (val) {},
                  maxLines: null,
                  controller: _controller,
                  cursorColor: Colors.grey.withOpacity(0.4),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.grey, fontSize: 9.0.sp),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: AppLocalizations.of(
                      "Highlights",
                    ),

                    //alignLabelWithHint: true,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
