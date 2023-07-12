import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_quality_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class VideoQualityCard extends StatefulWidget {
  final VideoListModelData? video;
  final VideoQualityModel? quality;
  final VoidCallback? onTap;
  final Function? changeVideo;
  String? defaultQuality;

  VideoQualityCard(
      {Key? key,
      this.video,
      this.quality,
      this.onTap,
      this.changeVideo,
      this.defaultQuality})
      : super(key: key);

  @override
  _VideoQualityCardState createState() => _VideoQualityCardState();
}

class _VideoQualityCardState extends State<VideoQualityCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.quality!.quality != "" && widget.quality != null
          ? ListTile(
              onTap: widget.onTap ??
                  () {
                    // Navigator.pop(context);
                    // widget.changeVideo(widget.quality.video,widget.quality.quality);
                  },
              leading: widget.defaultQuality == widget.quality!.quality
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 3.0.h,
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
              title: Text(
                widget.quality!.quality! + "p",
                style: whiteNormal.copyWith(fontSize: 12.0.sp),
              ),
            )
          : Container(),
    );
  }
}
