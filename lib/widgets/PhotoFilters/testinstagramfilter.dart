import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/PhotoFiltersAPI/instagramphotofiltercontroller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/FeedPosts/edit_multiple_files.dart';
import 'package:bizbultest/widgets/FeedPosts/feed_post_gallery.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:bizbultest/widgets/PhotoFilters/testfilterscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart' as wb;
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InstagramSinglePhotoFilter extends StatefulWidget {
  InstagramSinglePhotoFilter({
    Key? key,
    this.title,
    this.filePath,
    this.flip,
    this.refresh,
    this.from,
    this.crop,
    this.multiplefileList,
    this.multiplefiles,
  }) : super(key: key);

  final String? title;
  final File? filePath;
  final bool? flip;
  final Function? refresh;
  final String? from;
  final bool? crop;
  List<AssetsCustom>? multiplefileList = const [];
  List? multiplefiles = const [];
  @override
  State<InstagramSinglePhotoFilter> createState() =>
      _InstagramSinglePhotoFilterState();
}

class _InstagramSinglePhotoFilterState
    extends State<InstagramSinglePhotoFilter> {
  late PreloadPageController pagecontroller;



late InstagramPhotoFilterController controller;

@override
  void initState() {
    controller = Get.put(InstagramPhotoFilterController(
      crop: widget.crop!,
      file: widget.filePath!,
      flip: widget.flip!,
      from: widget.from!,
      path: widget.filePath!.path.toString(),
    ));
    // TODO: implement initState
    super.initState();
  }
    Widget _buildSat() {
      return InkWell(
        onTap: () {
          controller.selectedSlider.value = "Saturation";
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              AppLocalizations.of(
                "Saturation",
              ),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 8.0.sp),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.grey,
                  width: 0.3,
                ),
              ),
              child: CircleAvatar(
                radius: 5.5.h,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(left: 2.8.w),
                  child: Icon(
                    CustomIcons.saturation,
                    color: Colors.black,
                    size: 7.0.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget editAndContrast() {
      return Obx(() => Center(
              child: Padding(
            padding: EdgeInsets.only(bottom: 2.0.h),
            child: Container(
              width: 80.0.w,
              child: SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                      disabledThumbRadius: 4,
                      pressedElevation: 1),
                ),
                child: Slider(
                  activeColor: Colors.black,
                  inactiveColor: Colors.black26,
                  onChanged: (double value) {
                    controller.con.value = value;
                  },
                  divisions: 50,
                  value: controller.con.value,
                  min: 0,
                  max: 4,
                ),
              ),
            ),
          )));
    }

    Widget editAndBrightness() {
      return Obx(() => Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.0.h),
              child: Container(
                width: 80.0.w,
                child: SliderTheme(
                  data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                        disabledThumbRadius: 4,
                        pressedElevation: 1),
                  ),
                  child: Slider(
                    activeColor: Colors.black,
                    inactiveColor: Colors.black26,
                    onChanged: (double value) {
                      controller.bright.value = value;
                    },
                    divisions: 50,
                    value: controller.bright.value,
                    min: -1,
                    max: 1,
                  ),
                ),
              ),
            ),
          ));
    }

    Widget editAndSaturation() {
      return Obx(
        () => Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 2.0.h),
            child: Container(
              width: 80.0.w,
              child: SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                      disabledThumbRadius: 4,
                      pressedElevation: 1),
                ),
                child: Slider(
                  activeColor: Colors.black,
                  inactiveColor: Colors.black26,
                  onChanged: (double value) {
                    controller.sat.value = value;
                  },
                  divisions: 50,
                  value: controller.sat.value,
                  min: 0,
                  max: 2,
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildBrightness() {
      return InkWell(
        onTap: () {
          controller.selectedSlider.value = "Brightness";
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              AppLocalizations.of(
                "Brightness",
              ),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 8.0.sp),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.grey,
                  width: 0.3,
                ),
              ),
              child: CircleAvatar(
                radius: 5.5.h,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                child: Icon(
                  CustomIcons.brightness__1_,
                  color: Colors.black,
                  size: 7.0.h,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildCon() {
      return InkWell(
        onTap: () {
          controller.selectedSlider.value = "Contrast";
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              AppLocalizations.of(
                "Contrast",
              ),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 8.0.sp),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.grey,
                  width: 0.3,
                ),
              ),
              child: CircleAvatar(
                radius: 5.5.h,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                child: Icon(
                  CustomIcons.contrast,
                  color: Colors.black,
                  size: 7.0.h,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget editSlider() {
      return SliderTheme(
        data: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.never,
        ),
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 3),
              _buildSat(),
              Spacer(flex: 1),
              _buildBrightness(),
              Spacer(flex: 1),
              _buildCon(),
              Spacer(flex: 3),
            ],
          ),
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
              height: 40.0.h,

              color: Colors.green,
              // width:
              //controller.imageHeight.value == 0
              //     ? Get.width
              // :
              // controller.imageWidth.toDouble(),

              child: Column(children: [
                // CachedNetworkImage(
                //   imageUrl: controller.mainurl.value,
                //   fit: BoxFit.cover,
                // ),
                Container(
                  height: 40.h,
                  // width: 90.w,
                  child: (controller.mainurl.value != ''||controller.mainurl.value.isNotEmpty)
                      ? InAppWebView(
                          initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[controller.currentFilterIndex.value]}&url=${controller.mainurl.value}')),
                          onWebViewCreated: (inappcontroller) {
                            print("final file ${inappcontroller}");
                            controller.inAppWebViewController = inappcontroller;
                          },
                        )

                      // WebView(
                      //     initialUrl: controller.mainurl.value,
                      //     onPageFinished: (s) {},
                      //     onWebViewCreated: (wcontroller) {
                      //       controller.webviewcontroller = wcontroller;
                      //     })

                      : Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        ),
                )
              ]),
            ),
          ),
        ),
      );
    }

    Widget multipleImage() {
      return Obx(() => Container(
            height: 40.0.h,
            child: PreloadPageView.builder(
              preloadPagesCount: 15,
              onPageChanged: (val) {},
              controller: pagecontroller,
              itemCount: widget.multiplefileList!.length,
              itemBuilder: (context, index) {
                print("built pageloader $index");
                return Padding(
                  padding: EdgeInsets.only(right: 2.0.w),
                  child: Container(
                    child: widget.multiplefileList![index].asset!.type
                                .toString() ==
                            "AssetType.video"
                        ? FittedVideoPlayer(
                            video: widget.multiplefiles![index],
                          )
                        : Stack(
                            children: [
                              Container(
                                  child: Center(
                                      child: InAppWebView(
                                initialUrlRequest: URLRequest(
                                    url: Uri.parse(
                                        'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[controller.currentFilterIndex.value]}&url=${controller.mainurl.value}')),
                                onWebViewCreated: (inappcontroller) {
                                  print("final file ${inappcontroller}");
                                  controller.inAppWebViewController =
                                      inappcontroller;




                                },
                              )

                                      //  Image.memory(
                                      //   ,
                                      //   fit: widget.crop
                                      //       ? BoxFit.cover
                                      //       : BoxFit.contain,
                                      //   height: 40.0.h,
                                      // ),
                                      )),
                              widget.multiplefileList!.length > 1
                                  ? Positioned.fill(
                                      left: 1.5.w,
                                      bottom: 1.5.w,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                              color: !widget.crop!
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              width: 1,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                              radius: 1.8.h,
                                              backgroundColor: Colors.white,
                                              child: IconButton(
                                                  splashColor:
                                                      Colors.transparent,
                                                  padding: EdgeInsets.zero,
                                                  icon: Icon(
                                                    CustomIcons.edit_image,
                                                    size: 1.8.h,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    // isEdit = true;
                                                    // selectedIndex = index;
                                                    // image = images[index];

                                                    // finalFiles.clear();
                                                    // finalImages.clear();
                                                  })),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                  ),
                );
              },
            ),
          ));
    }

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
                                    wb.WebView(
                                      gestureRecognizers: null,
                                      initialUrl: controller.filterlist[index],
                                      zoomEnabled: false,
                                      gestureNavigationEnabled: false,
                                    ),
                                    Container(
                                      child: InkWell(
                                        onTap: () async {
                                          print("tapped");
                                          controller.switchFilter(
                                              controller.filternamelist[index],
                                              index);

                                          await controller
                                              .inAppWebViewController!
                                              .loadUrl(
                                                  urlRequest: URLRequest(
                                                      url: Uri.parse(controller
                                                          .mainurl.value)))
                                              .then((value) async {
                                            // var filteruint8list = await controller
                                            //     .inAppWebViewController
                                            //     .takeScreenshot(
                                            //         screenshotConfiguration:
                                            //             ScreenshotConfiguration(
                                            //                 compressFormat:
                                            //                     CompressFormat
                                            //                         .PNG,
                                            //                 quality: 80));

                                            // controller.testfilteredImages.assign(
                                            //     "${controller.filternamelist[index]}",
                                            //     filteruint8list);

                                            // controller.filteredImages.value =
                                            //     controller.testfilteredImages;

                                            // .assign(
                                            //     "${controller.filternamelist[index]}",
                                            //     filteruint8list);
                                            // print(controller.fil)
                                          });

                                          // await controller.webviewcontroller
                                          //     .loadUrl(
                                          //         controller.mainurl.value);
                                        },
                                      ),
                                    )
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

    Widget editImage() {
      print(
          "current selected filter=${controller.filternamelist[controller.currentFilterIndex.value]}");

      return Obx(
        () => ColorFiltered(
          colorFilter: ColorFilter.matrix(
              controller.calculateContrastMatrix(controller.con.value)),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(
                controller.calculateSaturationMatrix(controller.sat.value)),
            child: ExtendedImage(
              afterPaintImage: (canvas, rect, image, paint) async {},
              color: controller.bright.value > 0
                  ? Colors.white.withOpacity(controller.bright.value)
                  : Colors.black.withOpacity(-controller.bright.value),
              colorBlendMode: controller.bright.value > 0
                  ? BlendMode.lighten
                  : BlendMode.darken,
              image: ExtendedFileImageProvider(
                controller.finalFiles['file'],
                cacheRawData: true,
              ),
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              extendedImageEditorKey: controller.editorKey,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              initEditorConfigHandler: (ExtendedImageState? state) {
                return EditorConfig(
                  cornerColor: Colors.transparent,
                  cornerSize: Size(0, 0),

                  // cornerPainter: ExtendedImageCropLayerPainterNinetyDegreesCorner(
                  //   color: Colors.transparent,
                  //   cornerSize: Size(0, 0),
                  // ),
                );
              },
            ),
          ),
        ),
      );
    }


  Widget build(BuildContext context) {
   
    return WillPopScope(
        onWillPop: () async {
          Get.delete<InstagramPhotoFilterController>();
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
                          Get.delete<InstagramPhotoFilterController>();
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

                      List<File> finalFiles;
                      Uint8List? uinilist;
                      File? fileimage;
                       print("final file= ${controller.selectedTab.value}");
                      if (controller.selectedTab.value == "FILTER") {
                         print("final file= filter");
                        var uintlist = await controller.inAppWebViewController!
                            .takeScreenshot(
                          screenshotConfiguration: ScreenshotConfiguration(
                            quality: 80,
                            compressFormat: CompressFormat.PNG,
                          ),
                          
                        );
                        // var uintlist = await controller.inAppWebViewController!
                        //     .takeScreenshot(
                        //   screenshotConfiguration: ScreenshotConfiguration(
                        //     quality: 80,
                        //     compressFormat: CompressFormat.PNG,
                        //   ),
                          
                        // );

var rng = new Random();

Directory tempDir = await getTemporaryDirectory();

String tempPath = tempDir.path;

File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');

http.Response response = await http.get(Uri.parse(
                                  'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[controller.currentFilterIndex.value]}&url=${controller.mainurl.value}'));

print("final file=${Uri.parse(
                                  'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[controller.currentFilterIndex.value]}&url=${controller.mainurl.value}')}");
uinilist=response.bodyBytes;
setState(() {
  
});
file =await file.writeAsBytes(response.bodyBytes);
fileimage=file;

                        print("final file=${uinilist}");
                        finalFiles = [file];
                      } else {
                         print("final file=");
                        finalFiles = [await controller.cropImage()];
                      }
                      Timer(Duration(seconds: 1), () {
       
                        print("final file=${finalFiles[0]}");
                        Get.to(()=>UploadPost(
                          // unit8list: uinilist!,
         
                          
                                      isSingleVideoFromStory: false,
                                      width: 0,
                                      height: 0,
                                      crop: widget.crop! ? 1 : 0,
                                      from: "capture",
                                      hasVideo: 0,
                                         videoHeight: 0,
                                    videoWidth: 0,
                                      // refresh: widget.refresh!,
                                      clear: () {
                                        finalFiles.clear();
                                      },
                                      finalFiles: finalFiles,
                                    ));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             // TestFilterScreen(
                        //             //       image: finalFiles,
                        //             //     )

                        //             UploadPost(
                        //               isSingleVideoFromStory: false,
                        //               width: controller.imageWidth.value,
                        //               height: controller.imageHeight.value,
                        //               crop: widget.crop! ? 1 : 0,
                        //               from: widget.from!,
                        //               refresh: widget.refresh!,
                        //               clear: () {
                        //                 finalFiles.clear();
                        //               },
                        //               finalFiles: finalFiles,
                        //             )));
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
         
          body:
           Obx(
            () => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (controller.selectedTab.value == "FILTERR")
                      ? mainImage()
                      : Container(height: 50.0.h, child: editImage()),
                  SizedBox(height: 10.0.h),
                  (controller.selectedTab.value == "EDIT" &&
                          controller.selectedSlider.value == "Saturation")
                      ? editAndSaturation()
                      : (controller.selectedTab.value == "EDIT" &&
                              controller.selectedSlider.value == "Brightness")
                          ? editAndBrightness()
                          : (controller.selectedTab.value == "EDIT" &&
                                  controller.selectedSlider.value == "Contrast")
                              ? editAndContrast()
                              : Container(
                                  height: controller.selectedTab.value == "EDIT"
                                      ? 6.5.h
                                      : 0,
                                ),
                  (controller.selectedTab.value == "FILTERR")
                      ? filterListWidget()
                      : editSlider(),

                  // SizedBox(height: 4.8.h),
                  Obx(
                    () => Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            controller.selectedTab.value = "FILTERR";

                            // finalFiles.clear();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.5.h),
                            child: Container(
                                color: Colors.transparent,
                                width: 50.0.w,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      "FILTERR",
                                    ),
                                    style: TextStyle(
                                        color: controller.selectedTab.value ==
                                                "FILTERR"
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () async {
                            controller.selectedTab.value = "EDIT";
                            print(
                                "finalFile changed ${controller.testfilteredImages[controller.filternamelist[controller.currentFilterIndex.value]]}");

                            var filteruint8list = await controller
                                .inAppWebViewController!
                                .takeScreenshot(
                                    screenshotConfiguration:
                                        ScreenshotConfiguration(
                                            compressFormat: CompressFormat.PNG,
                                            quality: 80));
                            // controller.testfilteredImages.assign(
                            //     "${controller.filternamelist[controller.currentFilterIndex.value]}",
                            //     filteruint8list);

                            // controller.filteredImages.value =
                            //     controller.testfilteredImages;

                            controller.finalFile =
                                controller.converListToFile(filteruint8list!);
                            // controller.finalFile = controller.converListToFile(
                            //     controller.testfilteredImages[
                            //         controller.filternamelist[
                            //             controller.currentFilterIndex.value]]);

                            print(
                                "finalFile changed current filter=${controller.filternamelist[controller.currentFilterIndex.value]}");

                            var x = {};
                            x['file'] = controller.finalFile;
                            controller.finalFiles.value = x;
                            // finalFile = editFile;
                            // finalFiles.clear();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.5.h),
                            child: Container(
                                color: Colors.transparent,
                                width: 50.0.w,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      "EDIT",
                                    ),
                                    style: TextStyle(
                                        color: controller.selectedTab.value ==
                                                "EDIT"
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: controller.selectedSlider.value == ""
                          ? 4.8.h
                          : 3.6.h),
                ],
              ),
            ),
          ),
        
        ));
  }
}
