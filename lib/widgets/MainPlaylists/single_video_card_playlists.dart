import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/models/user_playlists_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class SingleVideoCard extends StatefulWidget {
  final UserPlaylistsModel? playlists;
  final VideoModel? video;
  final Function? refresh;
  final Function? delete;
  final int? index;
  final int? lastIndex;
  final Function? sort;
  final VoidCallback? play;

  SingleVideoCard(
      {Key? key,
      this.playlists,
      this.refresh,
      this.delete,
      this.video,
      this.index,
      this.lastIndex,
      this.sort,
      this.play})
      : super(key: key);

  @override
  _SingleVideoCardState createState() => _SingleVideoCardState();
}

class _SingleVideoCardState extends State<SingleVideoCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.index == 0
            ? Divider(
                thickness: 1,
                color: Colors.grey,
              )
            : Container(),
        InkWell(
          onTap: widget.play ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6.0.w, vertical: 1.0.h),
                    child: Container(
                      child: Container(
                        width: 30.0.w,
                        height: 10.0.h,
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              widget.video!.image!,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.0.w,
                        child: Text(
                          widget.video!.postContent!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: whiteNormal.copyWith(fontSize: 11.0.sp),
                        ),
                      ),
                      Text(
                        widget.video!.name!,
                        style: greyNormal.copyWith(fontSize: 9.0.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      //  Text(widget.totalVideos.toString(),style: whiteBold,),
                      // Text(widget.index.toString(),style: whiteBold,),
                      // Text(widget.lastIndex.toString(),style: whiteBold,),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        widget.index == widget.lastIndex
            ? Divider(
                thickness: 1,
                color: Colors.grey,
              )
            : Container(),
      ],
    );
  }
}
