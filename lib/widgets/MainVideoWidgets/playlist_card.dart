import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_playlist_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class PlayListCard extends StatefulWidget {
  final int? index;
  final VideoPlayListModel? playlists;
  final String? postID;
  final Function? refresh;

  const PlayListCard(
      {Key? key, this.playlists, this.index, this.postID, this.refresh})
      : super(key: key);

  @override
  _PlayListCardState createState() => _PlayListCardState();
}

class _PlayListCardState extends State<PlayListCard> {
  String? selectedID;

  Future<void> addToWatchLater() async {
    var url =
        'https://www.bebuzee.com/api/post_add_to_watchlater.php?action=add_to_playlist_to_watchlater&user_id=${CurrentUser().currentUser.memberID}&ids_to_add=${widget.postID}';
    print("watchlaterurl= ${url}");
    var response = await ApiProvider().fireApi(url);
    if (response.statusCode == 200) {
      print("success added to watch later ${response.data}");
    }
  }

  Future<void> addVideo(String id) async {
    var url =
        "https://www.bebuzee.com/api/post_add_to_playlist.php?action=add_new_video_to_playlist&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.postID}&country=${CurrentUser().currentUser.country}&playlist_id=$id";

    var response = await ApiProvider().fireApi(url);

    if (response.statusCode == 200) {
      print('added normal video to playlist =${response.data}');
    }
  }

  Future<void> removeVideo(String id) async {
    var url =
        "https://www.bebuzee.com/api/post_remove_to_playlist.php?action=remove_video_from_playlist&user_id=${CurrentUser().currentUser.memberID}&playlist_id=$id&post_id=${widget.postID}";

    var response = await ApiProvider().fireApi(url);

    if (response.statusCode == 200) {
      print('added normal video to playlist =${response.data}');
    }
  }

  Future<void> removeVideoFromWatchLater() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?"
    //         "action=remove_from_list_watch_later&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.postID}");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/post_remove_to_watchlater.php", {
      "action": "remove_from_list_watch_later",
      "user_id": CurrentUser().currentUser.memberID,
      "post_id": widget.postID,
    });

    if (response!.success == 1) {
      print(response.data);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Theme(
      data: ThemeData(unselectedWidgetColor: Colors.white),
      child: CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
          activeColor: Colors.white,
          checkColor: Colors.black,
          dense: true,
          //font change
          title: new Text(widget.playlists!.name!,
              style: whiteNormal.copyWith(fontSize: 12.0.sp)),
          value: widget.playlists!.checked == 1 ? true : false,
          secondary: widget.playlists!.type != "public"
              ? Icon(
                  Icons.lock_open,
                  color: Colors.white,
                  size: 2.0.h,
                )
              : Icon(
                  Icons.public,
                  color: Colors.white,
                  size: 2.0.h,
                ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? val) {
            if (val == true) {
              setState(() {
                selectedID = widget.playlists!.id;
                widget.playlists!.checked = 1;
              });
              print("post id=${widget.postID}");
              if (widget.playlists!.name == "Watch later")
                addToWatchLater();
              else
                addVideo(selectedID!);
              widget.refresh!();
            } else {
              setState(() {
                selectedID = widget.playlists!.id;
                widget.playlists!.checked = 0;
              });
              print("name=${widget.playlists!.name} ");
              print("post id=${widget.postID}");
              if (widget.playlists!.name == "Watch later") {
                print("yo watch");
                removeVideoFromWatchLater();
                widget.refresh!();
              } else {
                removeVideo(selectedID!);
                widget.refresh!();
              }
            }
          }),
    ));
  }
}
