import 'dart:typed_data';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../constant.dart';

class ChatGalleryThumbnailsHorizontal extends StatefulWidget {
  final String? extension;
  final Function? setNavbar;
  final VoidCallback? onTap;
  final bool? isMultiOpen;
  final bool? grid;

  const ChatGalleryThumbnailsHorizontal({
    Key? key,
    required this.asset,
    this.setNavbar,
    this.extension,
    this.onTap,
    this.isMultiOpen,
    this.grid,
  }) : super(key: key);

  final GalleryThumbnails asset;

  @override
  _ChatGalleryThumbnailsHorizontalState createState() =>
      _ChatGalleryThumbnailsHorizontalState();
}

class _ChatGalleryThumbnailsHorizontalState
    extends State<ChatGalleryThumbnailsHorizontal> {
  Future<Uint8List>? future;

  @override
  void initState() {
    future = widget.asset.asset!.thumbnailData as Future<Uint8List>?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: future,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (!snapshot.hasData)
          return Padding(
            padding: EdgeInsets.only(right: widget.grid! ? 0 : 8.0),
            child: Container(
                height: 50,
                width: 70,
                color: Colors.black,
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey)))),
          );
        // If there's data, display it as an image
        else {
          return InkWell(
            onTap: widget.onTap ?? () {},
            child: Padding(
              padding: EdgeInsets.only(right: widget.grid! ? 0 : 8.0),
              child: Container(
                height: 50,
                width: 70,
                child: Stack(
                  children: [
                    // Wrap the image in a Positioned.fill to fill the space
                    Positioned.fill(
                      child: Image.memory(bytes!, fit: BoxFit.cover),
                    ),
                    // Display a Play icon if the asset is a video
                    widget.grid! && widget.asset.selected
                        ? Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check,
                                  size: 50,
                                  color: Colors.white,
                                )),
                          )
                        : Container(),
                    widget.asset.asset!.type.toString() == "AssetType.video"
                        ? Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.videocam_sharp,
                                  size: 18,
                                  color: Colors.white,
                                )),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
