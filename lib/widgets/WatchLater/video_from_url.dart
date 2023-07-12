import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../api/api.dart';

class VideoFromUrl extends StatefulWidget {
  final Function? refreshWatchLater;
  final VideoStudioModel? playlists;

  VideoFromUrl({Key? key, this.refreshWatchLater, this.playlists})
      : super(key: key);

  @override
  _VideoFromUrlState createState() => _VideoFromUrlState();
}

class _VideoFromUrlState extends State<VideoFromUrl> {
  TextEditingController _controller = TextEditingController();
  var videoTitle;
  var videoImage;
  bool correctUrl = false;
  var res;
  var postID;
//TODO:: inSheet 205
  Future<void> getVideoFromUrl(String urlS) async {
    var url =
        "https://www.bebuzee.com/api/url_add_to_watchlater.php?action=get_url_video_data&user_id=${CurrentUser().currentUser.memberID}&url=$urlS&list=wl";
    print("url by url=${url}");
    var response = await ApiProvider().fireApi(url).then((value) => value);

    if (response.statusCode == 200) {
      print(response.data);
      setState(() {
        videoImage = response.data['data']['image'];
        videoTitle = response.data['data']['video_title'];
        res = response.data['message'];
        postID = response.data['data']['post_id'];
        correctUrl = true;
      });
    } else {
      setState(() {
        correctUrl = false;
      });
    }
  }

//TODO:: inSheet 203
  Future<void> addVideoFromUrl() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=add_to_playlist_to_watchlater&user_id=${CurrentUser().currentUser.memberID}&ids_to_add=$postID");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 3.5.h, bottom: 0.0.h, left: 3.0.w, right: 3.0.w),
            child: Text(
              AppLocalizations.of(
                    "Paste Bebuzee URL here:",
                  ) +
                  " ",
              style: whiteNormal.copyWith(fontSize: 13.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.5.h),
            child: TextFormField(
              onChanged: (val) {
                if (val != "") {
                  getVideoFromUrl(val);
                }
              },
              maxLines: 1,
              controller: _controller,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: AppLocalizations.of(
                  "Link",
                ),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0.sp),
              ),
            ),
          ),
          correctUrl == false && _controller.text.isEmpty
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 3.0.w),
                  child: Text(
                    AppLocalizations.of(
                      "If your URL is correct, you'll see a video preview here. Large videos may take a few minutes to appear. Remember: Using others' videos on the web without their permission may be bad manners, or worse, copyright infringement.",
                    ),
                    style: whiteNormal.copyWith(fontSize: 9.0.sp),
                  ),
                )
              : correctUrl == true && _controller.text != ""
                  ? Container(
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        child: Text(
                          AppLocalizations.of(
                            "Invalid URL",
                          ),
                          style: whiteNormal.copyWith(fontSize: 15.0.sp),
                        ),
                      )),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2.0.h, horizontal: 3.0.w),
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              width: 28.0.w,
                              height: 8.0.h,
                              child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    videoImage,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            SizedBox(
                              width: 5.0.w,
                            ),
                            Container(
                                width: 60.0.w,
                                child: Text(
                                  videoTitle,
                                  maxLines: 2,
                                  style:
                                      whiteNormal.copyWith(fontSize: 10.0.sp),
                                )),
                          ],
                        ),
                      ),
                    ),
          Padding(
            padding: EdgeInsets.only(right: 3.0.w, top: 3.0.h),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    overlayColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  if (res == "success") {
                    addVideoFromUrl();
                    Navigator.pop(context);
                    widget.refreshWatchLater!();
                  }
                },
                child: Text(
                  AppLocalizations.of(
                    "Add video",
                  ),
                  style: TextStyle(fontSize: 10.0.sp),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
