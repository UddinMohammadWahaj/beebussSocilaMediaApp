import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';

class EditMultipleScreenPhoto extends StatefulWidget {
  EditMultipleScreenPhoto(
      {Key? key,
      this.imageBytes,
      this.colorFilter,
      this.uploadImages,
      this.keylength,
      this.screenshotController,
      this.length})
      : super(key: key);
  Uint8List? imageBytes;
  var length;
  var colorFilter;
  var keylength;
  Function? uploadImages;
  ScreenshotController? screenshotController;
  @override
  State<EditMultipleScreenPhoto> createState() =>
      _EditMultipleScreenPhotoState();
}

class _EditMultipleScreenPhotoState extends State<EditMultipleScreenPhoto> {
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.keylength < widget.length) widget.uploadImages!(_globalKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(milliseconds: 250), () {
    //   if (widget.keylength < widget.length) widget.uploadImages(_globalKey);
    // });
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        height: 40.0.h,
        child:
            // key: josKeys1,

            ColorFiltered(
          colorFilter: widget.colorFilter,
          child: Container(
            child: Image.memory(
              widget.imageBytes!,
              fit: BoxFit.contain,
              height: 40.0.h,
            ),
          ),
        ),
      ),
    );
  }
}
