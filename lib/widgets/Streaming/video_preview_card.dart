import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VideoPreviewCard extends StatefulWidget {
  final CategoryDataModel? video;
  final VoidCallback? onTap;

  const VideoPreviewCard({Key? key, this.video, this.onTap}) : super(key: key);

  @override
  _VideoPreviewCardState createState() => _VideoPreviewCardState();
}

class _VideoPreviewCardState extends State<VideoPreviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 30.0.h,
      child: Stack(
        children: [
          Container(
              child: Image(
            image: CachedNetworkImageProvider(widget.video!.poster!),
            fit: BoxFit.cover,
          )),
          Positioned.fill(
            left: 10,
            bottom: 10,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 8),
                      child: Text(
                        AppLocalizations.of(
                          "Preview",
                        ),
                        style: TextStyle(
                            fontSize: 10.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ))),
          ),
          Center(
              child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: FloatingActionButton(
              onPressed: widget.onTap ?? () {},
              foregroundColor: Colors.black.withOpacity(0.2),
              backgroundColor: Colors.black.withOpacity(0.2),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
