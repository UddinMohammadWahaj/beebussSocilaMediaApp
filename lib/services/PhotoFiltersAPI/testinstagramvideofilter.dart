import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bizbultest/Language/appLocalization.dart';

import 'package:bizbultest/services/PhotoFiltersAPI/instagramvideofiltercontroller.dart';

import 'package:bizbultest/widgets/FeedPosts/feed_post_gallery.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'package:screenshot/screenshot.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart' as wb;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InstagramSingleVideoFilter extends StatefulWidget {
  InstagramSingleVideoFilter({
    Key? key,
    this.crop,
    this.filePath,
    this.flip,
    this.from,
    this.refresh,
    this.multiplefileList,
    this.multiplefiles,
    this.heightV,
    this.widthV,
    this.unitList,
  }) : super(key: key);

  final bool? crop;
  final File? filePath;
  final bool? flip;
  final String? from;
  final Function? refresh;
  List<AssetsCustom>? multiplefileList = const [];
  List? multiplefiles = const [];
  final heightV;
  final widthV;
  final unitList;

  @override
  State<InstagramSingleVideoFilter> createState() =>
      _InstagramSingleVideoFilterState();
}

class _InstagramSingleVideoFilterState
    extends State<InstagramSingleVideoFilter> {
  final List<Color> colors = <Color>[
    Colors.transparent,
    Colors.blue,
    Colors.amber,
    Colors.blueGrey,
    Colors.cyan,
    Colors.white,
    Colors.brown,
    Colors.black,
    Colors.teal,
    Colors.pink,
    Colors.deepPurple,
    Colors.lime,
    Colors.indigo,
    Colors.deepPurpleAccent,
    Colors.green,
    Colors.red,
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.amberAccent,
    Colors.deepOrange
  ];
  int colors_index = 0;
  late FlickManager flickManager;
  late Uint8List unit8list;
  late VideoPlayerController _controller;
  // void initState(){
  //   //    setState(() {
  //   //   flickManager = new FlickManager(G
  //   //     autoInitialize: true,
  //   //     autoPlay: true,
  //   //     videoPlayerController: VideoPlayerController.file(file),
  //   //   );
  //   //   isDisposed = false;
  //   // });
  // }
  //File filein;
  bool vloume = true;
  void initState() {
    super.initState();
    // filein = widget.filePath;
    // InstagramVideoFilterController insta =
    //     InstagramVideoFilterController(file: filein);
    //insta.getImageLink();
    _controller = VideoPlayerController.network(widget.filePath!.path);
    // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4");
    // insta.mainurl.value);
    _controller.play();
    _controller.setLooping(true);
    _controller.addListener(() {
      // setState(() {});
    });

    _controller.initialize();
    // .then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PreloadPageController pagecontroller;

    final controller = Get.put(InstagramVideoFilterController(
      crop: widget.crop,
      file: widget.filePath,
      flip: widget.flip,
      from: widget.from,
      path: widget.filePath!.path,
    ));
    Widget filterListWidget() {
      return Obx(
        () => Container(
          width: Get.width,
          height: 20.0.h,
          margin: EdgeInsets.only(top: 4),
          child: (controller.filterlist.length != 0)
              ? ListView.builder(
                  itemCount: controller.filterlist.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.all(4),
                      height: 103
                      // controller.imageHeight.value > 0
                      //     ? (controller.imageHeight ~/ 4).toDouble()
                      //     : 50.0
                      ,
                      width: 103
                      //  controller.imageWidth.value > 0
                      //     ? (controller.imageWidth ~/ 4).toDouble()
                      //     : 50.0
                      ,
                      //    cacheHeight: image.height ~/ 4,
                      // cacheWidth: image.width ~/ 4,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.filternamelist[index]}',
                              style: TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0.sp),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: Container(
                                child: Stack(
                                  children: [
                                    Center(
                                      child: AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        child: VideoPlayer(_controller),
                                      ),
                                    ),
                                    Container(
                                        height: 103,
                                        width: 103,
                                        color: colors[index].withOpacity(.4)),
                                    InkWell(onTap: () async {
                                      print("tapped");
                                      // controller.switchFilter(
                                      //     controller.filternamelist[index],
                                      //     index);
                                      setState(() {
                                        colors_index = index;
                                      });
                                    })
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )

                      //  InkWell(

                      //     onTap: () {
                      //       print("tapped");
                      //       controller.switchFilter(
                      //           controller.filternamelist[index], index);
                      //     },
                      //     child:

                      //     //     CachedNetworkImage(
                      //     //   imageUrl: Uri.parse(controller.filterlist[index])
                      //     //       .toString(),
                      //     //   fit: BoxFit.contain,
                      //     // )

                      //     ),
                      ),
                )
              : Container(color: Colors.white),
        ),
      );
    }

    Widget mainImage() {
      return Obx(
        () => Screenshot(
          controller: controller.scontroller,
          child: RepaintBoundary(
            key: controller.globalKey,
            child: Container(
              height: 50.0.h,
              color: Colors.white,
              // width: controller.imageHeight.value == 0
              //     ? Get.width
              //     : controller.imageWidth.toDouble(),
              child: (controller.mainurl.value != '')
                  ? Stack(
                      children: [
                        Center(
                          child: VideoPlayer(
                              _controller..setVolume(vloume == true ? 1 : 0)),
                        ),
                        Container(
                          // height: 500,
                          // width: 500,
                          color: colors[colors_index].withOpacity(.4),
                        ),
                      ],
                    )

                  // WebView(0
                  //     initialUrl: controller.mainurl.value,
                  //     onPageFinished: (s) {},
                  //     onWebViewCreated: (wcontroller) {
                  //       controller.webviewcontroller = wcontroller;
                  //     })

                  // CachedNetworkImage(imageUrl: controller.mainurl.value)

                  : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Get.delete<InstagramVideoFilterController>();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
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
                        onTap: () {
                          Get.delete<InstagramVideoFilterController>();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 4.0.w, top: 10, bottom: 10),
                          child: Icon(
                            Icons.keyboard_backspace,
                            size: 3.5.h,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        'Filters',
                        style:
                            TextStyle(color: Colors.black, fontSize: 15.0.sp),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      SchedulerBinding.instance.addPostFrameCallback((_) async {
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

                        List<File> finalFiles = [controller.file!];
                        print("----- $finalFiles");
                        // if (controller.selectedTab.value == "FILTER") {
                        // var uintlist1 = await controller.inAppWebViewController
                        //     .takeScreenshot(
                        //   screenshotConfiguration: ScreenshotConfiguration(
                        //     quality: 80,
                        //     compressFormat: CompressFormat.JPEG,
                        //   ),
                        // );
                        // finalFiles = [controller.converListToFile(uintlist)];
                        // } else {
                        //   finalFiles = [await controller.cropImage()];
                        // }
                        Timer(Duration(seconds: 1), () {
                          // print(
                          //     "height${controller.imageHeight ~/ 4}width=${controller.imageWidth ~/ 4}");
                          // print("final file=${finalFiles.length}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    // TestFilterScreen(
                                    //       image: finalFiles,
                                    //     )

                                    UploadPost(
                                  isSingleVideoFromStory: false,
                                  videoWidth: widget.widthV,
                                  videoHeight: widget.heightV,
                                  unit8list: widget.unitList,
                                  // thumbs: controller.filteredImageMap.values,
                                  // width: flickManager.flickVideoManager
                                  //     .videoPlayerController.value.size.width
                                  //     .toInt(),
                                  // height: flickManager.flickVideoManager
                                  //     .videoPlayerController.value.size.height
                                  //     .toInt(),
                                  crop: 1,
                                  from: widget.from,
                                  refresh: widget.refresh,
                                  clear: () {
                                    finalFiles.clear();
                                  },
                                  hasVideo: 1,
                                  finalFiles: finalFiles,
                                ),

                                // UploadPost(
                                //   unit8list: unit8list,
                                //   crop: 1,
                                //   hasVideo: 1,
                                //   from: 'editor',
                                //   refresh: widget.refresh,
                                //   finalFiles: finalFiles,
                                //   clear: () {
                                //     setState(() {
                                //       finalFiles.clear();
                                //     });
                                //   },
                                //   videoHeight: flickManager.flickVideoManager
                                //       .videoPlayerController.value.size.height
                                //       .toInt(),
                                //   videoWidth: flickManager.flickVideoManager
                                //       .videoPlayerController.value.size.height
                                //       .toInt(),
                                // ),
                              ));
                        });
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 4.0.w, top: 10, bottom: 10),
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                (controller.selectedTab.value == "FILTER")
                    ? Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                vloume = !vloume;
                              });
                            },
                            icon: vloume == true
                                ? Icon(Icons.volume_up,
                                    size: 40, color: Colors.black87)
                                : Icon(Icons.volume_off,
                                    size: 40, color: Colors.black87),
                          ),
                          mainImage(),
                        ],
                      )
                    : Container(),
                SizedBox(height: 10.0.h),
                filterListWidget(),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.5.h),
                          child: Container(
                              color: Colors.transparent,
                              width: 50.0.w,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(
                                    "FILTER",
                                  ),
                                  style: TextStyle(
                                      color: controller.selectedTab.value ==
                                              "FILTER"
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ),
                      ],
                    ))
              ],
            ),
          )),
    );
  }
}
