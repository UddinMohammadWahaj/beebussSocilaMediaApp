import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class InstagramMultipleFilter extends StatefulWidget {
  InstagramMultipleFilter(
      {Key? key,
      this.title,
      this.listoffiles,
      this.flip,
      this.refresh,
      this.from,
      this.crop})
      : super(key: key);

  final String? title;
  final List<File>? listoffiles;
  final bool? flip;
  final Function? refresh;
  final String? from;
  final bool? crop;

  @override
  State<InstagramMultipleFilter> createState() =>
      _InstagramMultipleFilterState();
}

class _InstagramMultipleFilterState extends State<InstagramMultipleFilter> {
  @override
  Widget build(BuildContext context) {
    Widget buildMainImages() {
      return ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              child: Stack(
                children: [
                  Image.network(''),
                  // Positioned(child: CustomIcons.ed)
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
          itemCount: widget.listoffiles!.length);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(7.0.h),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 4.0.w, top: 10, bottom: 10),
                      child: Icon(
                        Icons.keyboard_backspace,
                        size: 3.5.h,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'Filters',
                    style: TextStyle(color: Colors.black, fontSize: 15.0.sp),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  Fluttertoast.showToast(
                    msg: AppLocalizations.of(
                      "Processing",
                    ),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black.withOpacity(0.7),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  // var uintlist = await controller.inAppWebViewController
                  //     .takeScreenshot(
                  //         screenshotConfiguration:
                  //             ScreenshotConfiguration(quality: 80));

                  //  await controller.scontroller
                  //     .capture()
                  //     .then((value) => value);

                  // List<File> finalFiles = [
                  //   controller.converListToFile(uintlist)
                  // ];

                  // Timer(Duration(seconds: 2), () {
                  //   print("final file=${finalFiles.length}");
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               // TestFilterScreen(
                  //               //       image: finalFiles,
                  //               //     )
                  //               UploadPost(
                  //                 isSingleVideoFromStory: false,
                  //                 width: controller.imageWidth.value,
                  //                 height: controller.imageHeight.value,
                  //                 crop: widget.crop ? 1 : 0,
                  //                 from: widget.from,
                  //                 refresh: widget.refresh,
                  //                 clear: () {
                  //                   finalFiles.clear();
                  //                 },
                  //                 finalFiles: finalFiles,
                  //               )));
                  // });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0.w, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: 3.5.h,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
