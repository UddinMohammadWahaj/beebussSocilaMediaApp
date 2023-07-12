import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_search_model.dart';
import 'package:bizbultest/models/watch_later_search_video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class WatchLaterVideoSearch extends StatefulWidget {
  final Function refreshWatchLater;

  WatchLaterVideoSearch({Key? key, required this.refreshWatchLater})
      : super(key: key);

  @override
  _WatchLaterVideoSearchState createState() => _WatchLaterVideoSearchState();
}

class _WatchLaterVideoSearchState extends State<WatchLaterVideoSearch> {
  late WatchLaterSearch videoList;
  bool areVideosLoaded = false;
  List list = [];

  TextEditingController _controller = TextEditingController();

  Future<void> getVideos(String search) async {
    var url =
        "https://www.bebuzee.com/api/playlist_data_search.php?action=search_playlist_data&user_id=${CurrentUser().currentUser.memberID}&playlist_id=wl&data_val=$search&all_ids=";
    print("url Get Videos :--$url");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    if (response.data['success'] == 1) {
      print('url Get Videos success');
      WatchLaterSearch videoData =
          WatchLaterSearch.fromJson(response.data['data']);
      await Future.wait(videoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());
      if (mounted) {
        setState(() {
          videoList = videoData;
          areVideosLoaded = true;
        });
      }
    }
    if (response.data == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areVideosLoaded = false;
        });
      }
    }
  }

  Future<void> addVideoFromUrl(String ids) async {
    var url =
        "https://www.bebuzee.com/api/video/videoAddWatchLater?action=add_to_playlist_to_watchlater&user_id=${CurrentUser().currentUser.memberID}&ids_to_add=$ids";

    var response = await ApiProvider().fireApi(url).then((value) => value);

    if (response.statusCode == 200) {
      print(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.5.h),
            child: TextFormField(
              onChanged: (val) {
                if (val != "") {
                  getVideos(val);
                }
              },
              maxLines: 1,
              controller: _controller,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: AppLocalizations.of('Search'),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0.sp),
              ),
            ),
          ),
          areVideosLoaded == true
              ? Container(
                  height: 65.0.h,
                  child: ListView.builder(
                      itemCount: videoList.videos.length,
                      itemBuilder: (context, index) {
                        var video = videoList.videos[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              video.isSelected = !video.isSelected!;

                              if (video.isSelected!) {
                                list.add(video.postId);
                              } else {
                                list.remove(video.postId);
                              }

                              print(list);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0.h),
                            child: Container(
                              color: video.isSelected!
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.0.h, horizontal: 3.0.w),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28.0.w,
                                        height: 8.0.h,
                                        child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Image.network(
                                              video.image!,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 5.0.w,
                                      ),
                                      Container(
                                          width: 60.0.w,
                                          child: Text(
                                            video.title!,
                                            maxLines: 2,
                                            style: whiteNormal.copyWith(
                                                fontSize: 10.0.sp),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : Container(),
          areVideosLoaded == true
              ? Padding(
                  padding:
                      EdgeInsets.only(right: 3.0.w, top: 1.0.h, left: 3.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(
                          "Select videos",
                        ),
                        style: whiteBold.copyWith(fontSize: 12.0.sp),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            overlayColor:
                                MaterialStateProperty.all(Colors.white)),

                        // color: Colors.white,
                        // focusColor: Colors.white,
                        onPressed: () {
                          addVideoFromUrl(list.join(','));
                          print(list.join(','));
                          widget.refreshWatchLater();
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(
                            "Add videos",
                          ),
                          style: TextStyle(fontSize: 10.0.sp),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
