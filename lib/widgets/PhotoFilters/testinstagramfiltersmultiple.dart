import 'dart:io';
import 'dart:typed_data';

import 'package:bizbultest/services/PhotoFiltersAPI/instagramphotofiltermultiple.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/FeedPosts/edit_multiple_files.dart';
import 'package:bizbultest/widgets/FeedPosts/feed_post_gallery.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart' as wb;

import '../../Language/appLocalization.dart';
import 'package:image/image.dart' as img;

class InstagramFiltersMultiple extends StatefulWidget {
  final List<AssetsCustom>? fileList;
  final List? files;
  final bool? crop;
  final Function? refresh;
  const InstagramFiltersMultiple(
      {Key? key, this.fileList, this.crop, this.files, this.refresh})
      : super(key: key);

  @override
  State<InstagramFiltersMultiple> createState() =>
      _InstagramFiltersMultipleState();
}

class _InstagramFiltersMultipleState extends State<InstagramFiltersMultiple> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(InstagramPhotoFiltersMultipleController(
        assetfilelist: widget.fileList!, crop: widget.crop));

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
                    // height: 103
                    // controller.imageHeight.value > 0
                    //     ? (controller.imageHeight ~/ 4).toDouble()
                    //     : 50.0
                    // ,
                    // width: 103
                    //  controller.imageWidth.value > 0
                    //     ? (controller.imageWidth ~/ 4).toDouble()
                    //     : 50.0
                    // ,/
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
                          // Expanded(
                          // child:
                          Container(
                              // child: Stack(
                              // children: [
                              // Container(
                              height: 40.h,
                              // width: 70.w,
                              color: Colors.yellow,
                              child: wb.WebView(
                                javascriptMode: JavascriptMode.unrestricted,
                                gestureRecognizers: null,
                                initialUrl: controller.filterlist[index],
                                zoomEnabled: true,
                                gestureNavigationEnabled: true,
                              )),
                          Container(
                            color: Colors.pink,
                            child: InkWell(
                              onTap: () async {
                                controller.currentFilterIndex.value = index;

                                await controller.inAppWebViewController!
                                    .loadUrl(
                                        urlRequest: URLRequest(
                                            url: Uri.parse(
                                                controller.filterlist[index])));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    // )
                    // ],
                    // ),
                    // )

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

    var filtterlist = [].obs;
    Widget buildFilters() {
      // return Container();
      print("build filter called");

      return Obx(
        () => Container(
          margin: EdgeInsets.only(top: 4),
          height: 20.0.h,
          width: Get.width,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: controller.filterlist.length,
            itemBuilder: (context, index) {
              // final filter = filters[index];

              return Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.symmetric(vertical: 4),
                height: 103,
                width: 103,
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
                            Container(
                              height: 20.h,
                              child: wb.WebView(
                                gestureRecognizers: null,
                                initialUrl:
                                    controller.filterlist[index].toString(),
                                zoomEnabled: false,
                                gestureNavigationEnabled: false,
                              ),
                            ),
                            Container(
                              // color: Colors.yellow,
                              child: InkWell(
                                onTap: () async {
                                  print("tapped");
                                  // controller.switchFilter(
                                  //     controller.filternamelist[index],
                                  //     index);
                                  print(
                                      "tapped ${controller.listofinAppWebViewController.length}");
                                  for (int i = 0;
                                      i < controller.multipleurls.length;
                                      i++) {
                                    print(
                                        "general index=$i ${controller.multipleurls[i]}");
                                    setState(() {
                                      controller.multipleurls[i] =
                                          'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[index]}&url=${controller.multipleurls[i].toString().split('url=')[1]}';
                                      filtterlist = controller.multipleurls;
                                    });
                                    print(
                                        " -----check $i ${controller.multipleurls[i]}");
                                    try {
                                      await controller
                                          .listofinAppWebViewController[i]
                                          .loadUrl(
                                              urlRequest: URLRequest(
                                                  url: Uri.parse(controller
                                                      .multipleurls[i])));
                                    } catch (e) {
                                      print("----error $e");
                                    }
                                  }

                                  // await controller.inAppWebViewController
                                  //     .loadUrl(
                                  //         urlRequest: URLRequest(
                                  //             url: Uri.parse(controller
                                  //                 .multipleurls
                                  //                 .toString())))
                                  //     .then((value) async {});

                                  // await controller.webviewcontroller
                                  //     .loadUrl(
                                  //         controller.mainurl.value);
                                },
                                // child: wb.WebView(
                                //   // gestureRecognizers: null,
                                //   initialUrl:
                                //       controller.filterlist[index].toString(),
                                // zoomEnabled: false,
                                // gestureNavigationEnabled: false,
                                // ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

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
              );
            },
          ),
        ),
      );
    }

    Widget buildImage(index) {
      print("-----link-- ${controller.multipleurls[index].toString()}");
      return Obx(
        () => Stack(
          children: [
            // Container(≥
            // color: Colors.pink,
            // height: 40.0.h,
            // width: 70.w,
            // child: Expanded(
            // child:
            controller.multipleurls.length != 0
                // ? Image.network(
                //     controller.multipleurls[index].toString(),
                //     fit: BoxFit.fill,
                //   )

                // CachedNetworkImage(
                //     imageUrl: controller.multipleurls[index].toString(),
                //     // 'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[controller.currentFilterIndex.value]}&url=${controller.multipleurls[index]}',
                //     fit: BoxFit.fill,
                ? SizedBox.expand(
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                            width: 90.w,
                            height: 40.h,
                            child: InAppWebView(
                              // key: UniqueKey(),
                              initialOptions: InAppWebViewGroupOptions(
                                  android: AndroidInAppWebViewOptions(
                                      useHybridComposition: true,
                                      useWideViewPort: true,
                                      //     builtInZoomControls: true,
                                      //     textZoom: 100 * 2, // it makes 2 times bigger
                                      //     defaultFontSize: 100 * 2,
                                      loadsImagesAutomatically: true)),

                              initialUrlRequest: URLRequest(
                                  // body: controller.testlist[index],
                                  url: Uri.parse(
                                      //       controller.multipleurls[index].toString()),
                                      // ),
                                      'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[controller.currentFilterIndex.value]}&height=500&width=750&url=${controller.multipleurls[index].toString().split("&url=")[1]}')),
                              onWebViewCreated: (inappcontroller) {
                                print("---webview called $index");
                                setState(() {
                                  var x = controller.inAppWebViewController =
                                      inappcontroller;
                                  try {
                                    controller.listofinAppWebViewController[
                                        index] = inappcontroller;
                                  } catch (e) {
                                    print("---error web =$e");
                                    controller.listofinAppWebViewController
                                        .add(inappcontroller);
                                  }
                                  controller.inAppWebViewController =
                                      inappcontroller;
                                });
                              },
                            ))))
                : CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
            //  Image.memory(
            //   imageBytes,
            //   fit: widget.crop ? BoxFit.cover : BoxFit.contain,
            //   height: 40.0.h,
            // ),
            // )
            // ),
            widget.fileList!.length > 1
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
                                splashColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  CustomIcons.edit_image,
                                  size: 1.8.h,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  controller.isEdit.value =
                                      !controller.isEdit.value;

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
      );
    }

    List<File> editfinalFiles = [];
    InstagramEditController ctr = Get.put(InstagramEditController());
    var testCurrentType = "FILTER".obs;

    Widget editImage() {
      // print(
      //     "current selected filter=${controller.filternamelist[controller.currentFilterIndex.value]}");
      ScreenshotController screenshotController = new ScreenshotController();

      return Obx(
        () => Screenshot(
          controller: screenshotController,
          child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ctr.calculateContrastMatrix(ctr.con.value)),
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(
                  ctr.calculateSaturationMatrix(ctr.sat.value)),
              child: ExtendedImage(
                afterPaintImage: (canvas, rect, image, paint) async {
                  print("image operation done");
                },
                color: ctr.bright.value > 0
                    ? Colors.white.withOpacity(ctr.bright.value)
                    : Colors.black.withOpacity(-ctr.bright.value),
                colorBlendMode:
                    ctr.bright.value > 0 ? BlendMode.lighten : BlendMode.darken,
                image: ExtendedFileImageProvider(
                  editfinalFiles[0],
                  cacheRawData: true,
                ),
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                extendedImageEditorKey: ctr.editorKey,
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
        ),
      );
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
                    ctr.sat.value = value;
                  },
                  divisions: 50,
                  value: ctr.sat.value,
                  min: 0,
                  max: 2,
                ),
              ),
            ),
          ),
        ),
      );
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
                      ctr.bright.value = value;
                    },
                    divisions: 50,
                    value: ctr.bright.value,
                    min: -1,
                    max: 1,
                  ),
                ),
              ),
            ),
          ));
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
                    ctr.con.value = value;
                  },
                  divisions: 50,
                  value: ctr.con.value,
                  min: 0,
                  max: 4,
                ),
              ),
            ),
          )));
    }

    Widget _buildSat() {
      return InkWell(
        onTap: () {
          ctr.selectedSlider.value = "Saturation";
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

    Widget _buildCon() {
      return InkWell(
        onTap: () {
          ctr.selectedSlider.value = "Contrast";
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

    Widget _buildBrightness() {
      return InkWell(
        onTap: () {
          ctr.selectedSlider.value = "Brightness";
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

    String? dir;
    Future saveImage() async {
      final directory = await getExternalStorageDirectory();
      final myImagePath = '${directory!.path}/Cache';
      final myImgDir = await new Directory(myImagePath).create();
      setState(() {
        dir = myImagePath;
      });
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Get.delete<InstagramPhotoFiltersMultipleController>();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 3.0.w),
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.black,
                  size: 3.5.h,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                List<File> list = [];
                Get.dialog(ProcessingDialog(
                  title: "Processing...",
                  heading: "Please wait",
                ));
                for (int i = 0; i < controller.multipleurls.length; i++) {
                  var data = await controller.listofinAppWebViewController[i]
                      .takeScreenshot(
                          screenshotConfiguration: ScreenshotConfiguration(
                              compressFormat: CompressFormat.PNG));
                  var datafile = controller.converListToFile(data!);
                  list.add(datafile);
                }
                Get.back();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UploadPost(
                          isSingleVideoFromStory: false,
                          // hasVideo: hasVideos ? 1 : 0,
                          hasVideo: 0,
                          crop: widget.crop! ? 1 : 0,
                          refresh: widget.refresh!,
                          clear: () {},
                          finalFiles: list,
                          height: controller.images[0] == null
                              ? controller.image!.height
                              : controller.images[0].height,
                          width: controller.images[0] == null
                              ? controller.image!.height
                              : controller.images[0].width,
                        )));
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0.w, top: 10, bottom: 10),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 3.5.h,
                  ),
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Get.delete<InstagramPhotoFiltersMultipleController>();
          return true;
        },
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              height: 40.0.h,
              width: double.infinity,
              // color: Colors.green,
              color: Colors.grey.shade200,
              child: PreloadPageView.builder(
                preloadPagesCount: widget.fileList!.length,
                itemCount: widget.fileList!.length,
                controller: controller.pagecontroller,
                itemBuilder: (context, index) {
                  print(
                      "--------Link--- ${controller.multipleurls[index].toString().split("&url=")[1]}");
                  return Obx(() => controller.multipleurls.length == 0
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(right: 2.0.w),
                          child: Container(
                            width: 90.w,
                            // height: 40.h,
                            // color: Colors.yellow,
                            child: widget.fileList![index].asset!.type
                                        .toString() ==
                                    "AssetType.video"
                                ? FittedVideoPlayer(
                                    video: controller.multipleurls[index]

                                    // image: widget.files[index],
                                    )
                                :
                                //  Image(
                                //     image:
                                // InAppWebView(
                                // key: UniqueKey(),
                                // initialOptions: InAppWebViewGroupOptions(
                                // android: AndroidInAppWebViewOptions(
                                // useHybridComposition: true,
                                // builtInZoomControls: true,
                                // textZoom: 100 * 2, // it makes 2 times bigger
                                // defaultFontSize: 100 * 2,
                                // loadsImagesAutomatically: true)
                                // ),
                                //   initialUrlRequest: URLRequest(
                                //     // body: controller.testlist[index],
                                //     url: Uri.parse(controller
                                //         .multipleurls[index]
                                //         .toString()),
                                //   ),
                                //   // 'https://bebuzee.com/api/filter/filter-set.php?type=${controller.filternamelist[controller.currentFilterIndex.value]}&url=${controller.multipleurls[index]}')),
                                //   onWebViewCreated: (inappcontroller) {
                                //     print("webview called $index");

                                //     var x = controller.inAppWebViewController =
                                //         inappcontroller;
                                //     try {
                                //       controller.listofinAppWebViewController[
                                //           index] = inappcontroller;
                                //     } catch (e) {
                                //       print("error web =$e");
                                //       controller.listofinAppWebViewController
                                //           .add(inappcontroller);
                                //     }
                                //     controller.inAppWebViewController =
                                //         inappcontroller;
                                //   },
                                // )

                                // CachedNetworkImage(
                                //     imageUrl: controller.multipleurls[index]
                                //         // controller.multipleurls[index]
                                //         .toString()
                                //         .split("&url=")[1],
                                //     errorWidget: (context, url, error) {
                                //       print("---------error $error");
                                //       print("---------url $url");
                                //       return Center(child: Icon(Icons.error));
                                //     },
                                //     // fit: BoxFit.contain,
                                //   ),
                                // fit: BoxFit.cover,

                                // )),
                                //  SizedBox.expand(
                                //     child: FittedBox(
                                //         fit: BoxFit.cover,
                                //         child: SizedBox(
                                //             width: 300,
                                //             height: 300,
                                // child:
                                Obx(() => buildImage(index)),

                            //finalFiles.add(save);
                            // ))),
                          ),
                        ));
                },
              )),
          Obx(() => (testCurrentType.value != "FILTER" &&
                  ctr.selectedSlider.value == "Saturation")
              ? editAndSaturation()
              : (testCurrentType.value != "FILTER" &&
                      ctr.selectedSlider.value == "Brightness")
                  ? editAndBrightness()
                  : (testCurrentType.value != "FILTER" &&
                          ctr.selectedSlider.value == "Contrast")
                      ? editAndContrast()
                      : Container(
                          height: testCurrentType.value != "FILTER" ? 6.5.h : 0,
                        )),
          Obx(
            () => (testCurrentType.value == "FILTER")
                ? buildFilters()
                : editSlider(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    // controller.selectedTab.value = "FILTERR";

                    testCurrentType.value = "FILTER";
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.5.h),
                    child: Container(
                        color: Colors.transparent,
                        width: 40.0.w,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(
                              "FILTER",
                            ),
                            style: TextStyle(
                                color:
                                    //  controller.selectedTab.value ==
                                    //         "FILTERR"
                                    // ? Colors.black
                                    // :
                                    Colors.grey,
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    await saveImage();
                    // testCurrentType.value = "EDIT";
                    var images = controller.multipleurls.toSet().toList();
                    for (int i = 0; i < controller.multipleurls.length; i++) {
                      File save = new File("$dir/IMG${i}.jpg")
                        ..writeAsBytesSync(
                            img.encodeJpg(images[0], quality: 95));

                      editfinalFiles = [save];
                    }

                    // controller.selectedTab.value = "EDIT";
                    // print(
                    //     "finalFile changed ${controller.testfilteredImages[controller.filternamelist[controller.currentFilterIndex.value]]}");

                    // var filteruint8list = await controller
                    //     .inAppWebViewController
                    //     .takeScreenshot(
                    //         screenshotConfiguration:
                    //             ScreenshotConfiguration(
                    //                 compressFormat: CompressFormat.PNG,
                    //                 quality: 80));

                    // controller.finalFile =
                    //     controller.converListToFile(filteruint8list);

                    // print(
                    //     "finalFile changed current filter=${controller.filternamelist[controller.currentFilterIndex.value]}");

                    // var x = {};
                    // x['file'] = controller.finalFile;
                    // controller.finalFiles.value = x;
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.5.h),
                    child: Container(
                        color: Colors.transparent,
                        width: 40.0.w,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(
                              "EDIT",
                            ),
                            style: TextStyle(
                                color:
                                    //  controller.selectedTab.value ==
                                    //         "EDIT"
                                    // ? Colors.black
                                    // :
                                    Colors.grey,
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          //TESTEDIT
        ]),
      ),
    );
  }
}
