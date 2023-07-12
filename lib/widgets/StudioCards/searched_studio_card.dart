import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/StudioCards/update_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class SearchedStudioVideoCard extends StatefulWidget {
  final VideoModel? video;
  final VideoStudioModel playlists;
  final Function refreshWatchLater;

  SearchedStudioVideoCard(
      {Key? key,
      this.video,
      required this.refreshWatchLater,
      required this.playlists})
      : super(key: key);

  @override
  _SearchedStudioVideoCardState createState() =>
      _SearchedStudioVideoCardState();
}

class _SearchedStudioVideoCardState extends State<SearchedStudioVideoCard> {
  List list = [];
  late Video channelVideoList;
  bool areChannelVideosLoaded = false;

  Future<void> addVideos(String ids) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=add_to_playlist_to_watchlater&user_id=${CurrentUser().currentUser.memberID}&ids_to_add=$ids");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  Future<void> getChannelVideo() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/channel_apis_calls.php?action=channel_main_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&current_user_id=${CurrentUser().currentUser.memberID}&all_ids=");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Video channelVideoData = Video.fromJson(jsonDecode(response.body));
      await Future.wait(channelVideoData.videos
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());
      await Future.wait(channelVideoData.videos
          .map((e) => PreloadUserImage.cacheImage(context, e.userImage!))
          .toList());

      if (mounted) {
        setState(() {
          channelVideoList = channelVideoData;
          areChannelVideosLoaded = true;
        });
      }
    }

    if (response.body == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areChannelVideosLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    getChannelVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: 75.0.h,
          child: areChannelVideosLoaded == true
              ? ListView.builder(
                  itemCount: channelVideoList.videos.length,
                  itemBuilder: (context, index) {
                    var video = channelVideoList.videos[index];
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
                                        video.postContent!,
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
                  })
              : Container(),
        ),
        areChannelVideosLoaded == true
            ? Padding(
                padding: EdgeInsets.only(right: 3.0.w, top: 1.0.h, left: 3.0.w),
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
                      onPressed: () {
                        UpdateStudioDetails().addVideosToPlaylist(
                            widget.playlists.playlistId!, list.join(','));

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
    );
  }
}
