import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/FlickPlayer/flick_multi_manager.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/create_a_shortbuz.dart';
import 'package:bizbultest/widgets/PhotoFilters/filter_utils.dart';
import 'package:bizbultest/widgets/PhotoFilters/widget/filtered_image_list_widget.dart';
import 'package:bizbultest/widgets/PhotoFilters/widget/filtered_image_widget.dart';
import 'package:extended_image/extended_image.dart';

// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
// import 'package:html/dom.dart';
import 'package:screenshot/screenshot.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../Language/appLocalization.dart';
import '../PhotoFilters/testinstagramfilter.dart';
import 'feed_post_gallery.dart';

class EditMultipleFiles extends StatefulWidget {
  final List<AssetsCustom>? fileList;
  final List? files;
  final bool? crop;
  final Function? refresh;
  final List<Uint8List>? thumbs;

  EditMultipleFiles(
      {Key? key,
      this.fileList,
      this.crop=false,
      this.files,
      this.refresh,
      this.thumbs})
      : super(key: key);

  @override
  _EditMultipleFilesState createState() => _EditMultipleFilesState();
}

class _EditMultipleFilesState extends State<EditMultipleFiles> {
  FlickMultiManager? flickMultiManager;
  List<ScreenshotController> sshotcontroller = [
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
    ScreenshotController(),
  ];

  // List<GlobalObjectKey> listkeys = [];
  List<File> files = [];
  List<File> tempfiles = [];
  List<img.Image?>? images = [];
  List<File?>? finalFiles = [];
  List<File?> editfinalFiles = [];
  List<img.Image> finalImages = [];
  File? finalFile;
  bool dataLoaded = false;
  img.Image? image;
  Filter filter = presetFiltersList.first;
  Filter singleFilter = presetFiltersList.first;
  List<Filter> singleFilters = [];
  bool isEdit = false;
  int selectedIndex = 0;
  double sat = 1;
  double bright = 0;
  double con = 1;
  File? editFile;
  String? dir;
  img.Image? filterImage;

  String selectedTab = "FILTER";
  String selectedSlider = "";
  // List<GlobalKey> globalkeylist = [];
  List<Uint8List> testlist = [];
  String? newPath;
  File? originalFile;
  PreloadPageController? pagecontroller;
  ScreenshotController screenshotController = new ScreenshotController();
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  var testCurrentType = "FILTER".obs;
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

  var testeditimage = [].obs;

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

  var currentFilter = [
    1.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0
  ];
  var testfilterlist = {
    "nofilter": [
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ],
    "darken": [
      1.2,
      -0.1,
      0.3,
      0.3,
      -0.2,
      0.0,
      1.0,
      -0.2,
      0.0,
      0.0,
      0.0,
      0.0,
      0.9,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ],
    "lighten": [
      1.5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ],
    "lofi": [
      .5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      .5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      .5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ],
    "midgray": [
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ],
    "blueshade": [
      0.0,
      0.2,
      -0.1,
      -0.3,
      -0.1,
      0.3,
      0.4,
      0.1,
      0.0,
      0.0,
      0.0,
      -0.1,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      -0.04
    ],
    "vintage": [
      0.9,
      0.5,
      0.1,
      0.0,
      0.0,
      0.3,
      0.8,
      0.1,
      0.0,
      0.0,
      0.2,
      0.3,
      0.5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ],
    "magneta": [
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ],
    "elim-blue": [
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      -2.0,
      1.0,
      0.0
    ],
    "lime": [
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      2.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      .5,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ],
    "peachy": [
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      .5,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      .5,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ],
    "prepetua": [
      1.0,
      0.5,
      0.0,
      -0.3,
      0.0,
      0.4,
      1.0,
      -0.2,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      -0.04
    ],
    "earlybird": [
      1.000,
      -0.818,
      0.000,
      0.000,
      0.000,
      0.000,
      1.000,
      0.000,
      0.000,
      0.000,
      -0.316,
      0.023,
      1.000,
      0.000,
      0.000,
      10.40,
      -0.114,
      0.000,
      1.200,
      0.205
    ],
    "lumba": [
      1.080,
      0.233,
      -0.333,
      -0.022,
      0.000,
      -0.054,
      0.703,
      0.088,
      -0.053,
      0.000,
      0.145,
      -0.173,
      0.731,
      -0.241,
      0.000,
      0.000,
      0.000,
      0.000,
      1.000,
      0.000,
    ],
    "rise": [
      0.923,
      0.600,
      0.147,
      0.000,
      0.000,
      0.272,
      1.150,
      0.130,
      0.000,
      0.000,
      0.212,
      0.416,
      0.717,
      0.000,
      0.000,
      0.000,
      0.000,
      0.000,
      1.000,
      0.000,
    ],
    "shawty": [
      1.960,
      -0.659,
      0.016,
      0.000,
      -0.074,
      0.000,
      1.840,
      0.735,
      0.003,
      -0.172,
      0.817,
      0.521,
      1.700,
      0.000,
      -0.191,
      0.009,
      0.000,
      0.109,
      1.440,
      0.182,
    ],
    "zodona": [
      1.840,
      0.000,
      -0.009,
      0.000,
      -0.019,
      0.000,
      1.090,
      0.753,
      -0.009,
      -0.009,
      0.753,
      0.753,
      1.530,
      0.000,
      -0.019,
      0.000,
      0.000,
      0.000,
      1.410,
      0.000,
    ]
  };

  // convertWidgetsToImageFinal(index) async {
  //   RenderRepaintBoundary repaintBoundary =
  //       listkeys[index].currentContext.findRenderObject();
  //   print("global list object xxx=${repaintBoundary.child.debugNeedsPaint}");
  //   if (repaintBoundary.child.debugNeedsPaint) {
  //     await Future.delayed(Duration(milliseconds: 20));
  //   }
  //   var boxImage = await repaintBoundary.toImage(pixelRatio: 1.0);

  //   ByteData byteData = await boxImage.toByteData(format: ImageByteFormat.png);

  //   Uint8List uint8list = byteData.buffer.asUint8List();

  //   img.Image data = img.decodeImage(uint8list);

  //   File save = new File("$dir/${generateRandomString(12)}.png")
  //     ..writeAsBytesSync(img.encodeJpg(data, quality: 50));
  //   tempfiles[index] = save;
  //   print("$index saved success");
  //   // return save;
  // }

  // convertWidgetsToImage() async {
  //   // print(
  //   //     "entered convertWidgetsToImage globalkey=${globalkeylist[0].currentWidget}");
  //   RenderRepaintBoundary repaintBoundary =
  //       listkeys[0].currentContext.findRenderObject();
  //   print("global list object xx=${repaintBoundary.child.debugNeedsPaint}");
  //   var boxImage = await repaintBoundary.toImage(pixelRatio: 1.0);

  //   ByteData byteData = await boxImage.toByteData(format: ImageByteFormat.png);

  //   Uint8List uint8list = byteData.buffer.asUint8List();

  //   img.Image data = img.decodeImage(uint8list);

  //   File save = new File("$dir/${generateRandomString(10)}.png")
  //     ..writeAsBytesSync(img.encodeJpg(data, quality: 50));

  //   return save;
  // }

  // convertWidgetsToImage2() async {
  //   RenderRepaintBoundary repaintBoundary1 =
  //       listkeys[1].currentContext.findRenderObject();
  //   print("global list object=${repaintBoundary1.child.isRepaintBoundary}");
  //   var boxImage1 = await repaintBoundary1.toImage(pixelRatio: 1);
  //   ByteData byteData1 =
  //       await boxImage1.toByteData(format: ImageByteFormat.png);
  //   Uint8List uint8list1 = byteData1.buffer.asUint8List();
  //   img.Image data1 = img.decodeImage(uint8list1);
  //   File save1 = new File("$dir/${generateRandomString(11)}aa.png")
  //     ..writeAsBytesSync(img.encodeJpg(data1, quality: 50));
  //   return save1;
  // }

  // Future<List<File>> convertoimages() async {
  //   List<RenderRepaintBoundary> repaintBoundary = [];

  //   for (int i = 0; i < 1; i++) {
  //     repaintBoundary.add(listkeys[i].currentContext.findRenderObject());
  //   }
  //   // listkeys.forEach((GlobalObjectKey element) {
  //   //   repaintBoundary.add(element.currentContext.findRenderObject());
  //   // });
  //   print("convert to images repaint boundry=${repaintBoundary.length}");
  //   List boxImage = [];
  //   // repaintBoundary.forEach((element) async {
  //   //   var item = await element.toImage(pixelRatio: 1);
  //   //   boxImage.add(item);
  //   // });
  //   try {
  //     for (int i = 0; i < repaintBoundary.length; i++) {
  //       var item = await repaintBoundary[i].toImage(pixelRatio: 1);
  //       boxImage.add(item);
  //     }
  //   } catch (e) {
  //     print("convert to images boxImage =$e");
  //   }
  //   // await Future.forEach(repaintBoundary, (element) async {
  //   //   var item = await element.toImage(pixelRatio: 1);
  //   //   boxImage.add(item);
  //   // });
  //   print("convert to images boxImage =${boxImage.length}");
  //   List<ByteData> byteData = [];
  //   try {
  //     for (int i = 0; i < byteData.length; i++) {
  //       var element = await boxImage[i].toByteData(format: ImageByteFormat.png);
  //       byteData.add(element);
  //     }
  //   } catch (e) {
  //     print("convert to image $e");
  //   }
  //   // boxImage.forEach((element) async {
  //   //   byteData.add(await element.toByteData(format: ImageByteFormat.png));
  //   // });
  //   print("convert to images byteData =${byteData.length}");
  //   List<Uint8List> uint8list = [];
  //   byteData.forEach((element) {
  //     uint8list.add(element.buffer.asUint8List());
  //   });
  //   print("convert to images uint8List =${uint8list.length}");
  //   List<img.Image> datalist = [];
  //   uint8list.forEach((element) {
  //     img.Image data = img.decodeImage(element);
  //     datalist.add(data);
  //   });
  //   List<File> savedFiles = [];
  //   datalist.forEach((element) {
  //     File save = new File("$dir/${generateRandomString(10)}.png")
  //       ..writeAsBytesSync(img.encodeJpg(element, quality: 95));
  //     savedFiles.add(save);
  //   });
  //   print("convert to images success ${savedFiles.length}");
  //   return savedFiles;
  //   //  var boxImage = await repaintBoundary.toImage(pixelRatio: 1);
  // }

  Widget buildFilters() {
    if (image == null) return Container();
    // return Container();
    print("build filter called");
    List<List<double>> filter = [];
    List<String> filtername = [];
    testfilterlist.forEach((key, value) {
      filter.add(value);
      filtername.add(key);
    });

    return Container(
      height: 20.0.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filter.length,
        itemBuilder: (context, index) {
          // final filter = filters[index];

          return InkWell(
            onTap: () {
              setState(() {
                currentFilter = filter[index];
                finalFile = editFile;
                finalFiles!.clear();
              });
            },
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${filtername[index]}',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 10.0.sp),
                  ),
                  SizedBox(height: 1.0.h),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ColorFiltered(
                      colorFilter:
                          ColorFilter.matrix(filter[index] as List<double>),
                      child: Container(
                          child: Image.memory(
                        File(files[0].path).readAsBytesSync(),
                        cacheHeight: image!.height! ~/ 4,
                        cacheWidth: image!.width ~/ 4,
                        height: (image!.height ~/ 4).toDouble(),
                        width: (image!.width ~/ 4).toDouble(),
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget buildImage(index) {
  //   print("image build $index");
  //   var imageBytes = File(files[index].path).readAsBytesSync();
  //   // print("imagebytes=$imageBytes");
  //   img.Image data = img.decodeImage(imageBytes);
  //   finalImages.add(data);

  //   // Timer(Duration(milliseconds: 250), () {

  //   // });

  //   return Stack(
  //     children: [
  //       imageBytes != null
  //           ? Container(
  //               child: Center(
  //                   child:
  //                       //        EditMultipleScreenPhoto(
  //                       //   imageBytes: imageBytes,
  //                       //   length: files.length,
  //                       //   keylength: globalkeylist.length,
  //                       //   screenshotController: screenshotController,
  //                       //   uploadImages: (key) {
  //                       //     // screenshotController.capture(pixelRatio: 1.0);
  //                       //     // screenshotController.captureFromWidget(widget).then((value) => value.)
  //                       //     globalkeylist.add(key);
  //                       //     print("global key list length=${globalkeylist.length}");
  //                       //   },
  //                       //   colorFilter: ColorFilter.matrix(currentFilter),
  //                       // )

  //                       Screenshot(
  //               child: Container(
  //                 key: Key('$index'),
  //                 child: ColorFiltered(
  //                   colorFilter: ColorFilter.matrix(currentFilter),
  //                   child: Image.memory(
  //                     imageBytes,
  //                     fit: widget.crop ? BoxFit.cover : BoxFit.contain,
  //                     height: 40.0.h,
  //                   ),
  //                 ),
  //               ),
  //               controller: sshotcontroller[index],
  //             )

  //                   //     RepaintBoundary(
  //                   //   // key: josKeys1,
  //                   //   key: listkeys[index],
  //                   //   child: Container(
  //                   //     key: Key(listkeys[index].toString() + '$index'),
  //                   //     child: ColorFiltered(
  //                   //       colorFilter: ColorFilter.matrix(currentFilter),
  //                   //       child: Image.memory(
  //                   //         imageBytes,
  //                   //         fit: widget.crop ? BoxFit.cover : BoxFit.contain,
  //                   //         height: 40.0.h,
  //                   //       ),
  //                   //     ),
  //                   //   ),
  //                   // ),

  //                   ))
  //           : Container(),

/*
            
        widget.fileList.length > 1
            ? Positioned.fill(
                left: 1.5.w,
                bottom: 1.5.w,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: !widget.crop ? Colors.black : Colors.transparent,
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
                              setState(() {
                                isEdit = true;
                                selectedIndex = index;
                                image = images[index];

                                finalFiles.clear();
                                finalImages.clear();
                              });
                            })),
                  ),
                ),
              )
            : Container()   
            */
  //     ],
  //   );
  // }

  var controller = Get.put(InstagramEditController());

  Future saveImage() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/Cache';
    final myImgDir = await new Directory(myImagePath).create();
    setState(() {
      dir = myImagePath;
    });
    addFiles();
  }

  bool showCropped = false;
  List<img.Image> checkImageList = [];

  Future<void> read() async {
    print("entered read() ");
    for (int i = 0; i < widget.fileList!.length; i++) {
      var file = await widget.fileList![i].asset!.file;
      tempfiles[i] = File(file!.path);
      print("------file.path" + file.path);
      print("------tempfiles" + tempfiles[i].toString());
      try {
        print("--------files length=${files.length} ${files[i].path}");
      } catch (e) {
        print("------files of $i error");
      }
    }
  }

  bool hasVideos = false;
  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(list, quality: 80);
    print(list.length);
    print('----image length compressed=${result.length}');

    return result;
  }

  Widget editImage() {
    // print(
    //     "current selected filter=${controller.filternamelist[controller.currentFilterIndex.value]}");

    return Obx(
      () => Screenshot(
        controller: screenshotController,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(
              controller.calculateContrastMatrix(controller.con.value)),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(
                controller.calculateSaturationMatrix(controller.sat.value)),
            child: ExtendedImage(
              afterPaintImage: (canvas, rect, image, paint) async {
                print("image operation done");
              },
              color: controller.bright.value > 0
                  ? Colors.white.withOpacity(controller.bright.value)
                  : Colors.black.withOpacity(-controller.bright.value),
              colorBlendMode: controller.bright.value > 0
                  ? BlendMode.lighten
                  : BlendMode.darken,
              image: ExtendedFileImageProvider(
                editfinalFiles[0]!,
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
      ),
    );
  }

  Future<void> addFiles() async {
    print("entered addFiles() ");
    for (int i = 0; i < widget.fileList!.length; i++) {
      var file = await widget.fileList![i].asset!.file;

      tempfiles.add(File('aa'));
      if (widget.fileList![i].asset!.type.toString() == "AssetType.video") {
        setState(() {
          hasVideos = true;
          files.add(file!);
          images!.add(null);
          singleFilters.add(presetFiltersList.first);
        });
      } else {
        File imageCopied = await file!.copy("$dir/${p.basename(file.path)}");
        File rotatedImage =
            await FlutterExifRotation.rotateImage(path: imageCopied.path);
        var imageBytes = File(rotatedImage.path).readAsBytesSync();
        testlist.add(imageBytes);
        var compimageBytes = await testComporessList(imageBytes);
        var newImage = img.decodeImage(imageBytes);
        final height = newImage!.height;
        final width = newImage.width;
        checkImageList.add(newImage);
        img.Image fixedImage;
        fixedImage = newImage;
        var resizedImageNormal = img.copyResize(fixedImage,
            width: (height > 1500 && width > 1500)
                ? fixedImage.width ~/ 3
                : fixedImage.width ~/ 1,
            height: (height > 1500 && width > 1500)
                ? fixedImage.height ~/ 3
                : fixedImage.height ~/ 1);

        var cropSize = min(fixedImage.width, fixedImage.height);
        int offsetX =
            (fixedImage.width - min(fixedImage.width, fixedImage.height)) ~/ 2;
        int offsetY =
            (fixedImage.height - min(fixedImage.width, fixedImage.height)) ~/ 2;
        img.Image destImage =
            img.copyCrop(fixedImage, offsetX, offsetY, cropSize, cropSize);
        var resizedImageCropped = img.copyResize(destImage,
            width: (height > 1500 && width > 1500)
                ? destImage.width ~/ 3
                : destImage.width ~/ 1,
            height: (height > 1500 && width > 1500)
                ? destImage.height ~/ 3
                : destImage.height ~/ 1);

        setState(() {
          print("-----globalobject key setstate");

          files.add(rotatedImage);
          singleFilters.add(presetFiltersList.first);
        });

        if (widget.crop!) {
          setState(() {
            images!.add(resizedImageCropped);
            image = image == null ? resizedImageCropped : image;
          });
        } else {
          setState(() {
            images!.add(resizedImageNormal);
            image = image == null ? resizedImageNormal : image;
          });
        }
        print("----###--entered add files length=${files.length} ${files}");

        // var file1 = await widget.fileList[i].asset.file;
        // tempfiles[i] = File(file1.path);
        // print("----entered add files length=${files.length} ${file1}");≥
      }
    }
    // setState(() {
    //   dataLoaded = true;
    // });

    // read();
  }

  void changeImage(File file) {
    finalFile = file;
  }

  var res;

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  void initState() {
    print("entered mul image screen");
    finalImages.clear();
    // images = null;
    pagecontroller = PreloadPageController(
      viewportFraction: widget.crop! ? 0.8 : 0.6,
      initialPage: 0,
    );
    saveImage();
    // newm();
    super.initState();
  }

  Future newm() async {
    await saveImage();
    // read();
    flickMultiManager = FlickMultiManager();
    // ignore: await_only_futures
    await addFiles();
    // await read();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {});
    // });
  }

  // File converListToFile(Uint8List list) {
  //   img.Image data = img.decodeImage(list);
  //   File save = new File("${dir.value}/${generateRandomString(10)}.jpg")
  //     ..writeAsBytesSync(img.encodeJpg(data, quality: 80));

  //   return save;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 12.h,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    FilterUtils.clearCache();
                    image = null;
                  });
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
                  print("now click check");
                  if (isEdit) {
                    setState(() {
                      isEdit = false;
                    });
                  } else {
                    Get.dialog(ProcessingDialog(
                      title: "Processing...",
                      heading: "Please wait",
                    ));
                    //final dirt = Directory(dir);
                    //dirt.deleteSync(recursive: true);
                    // setState(() {

//TEST FOR EDITED IMAGES

//TEST FOR EDITED IMAGES END

                    finalFiles!.clear();
                    // });
                    var images = finalImages.toSet().toList();
                    print(images.length.toString() + " final images");
                    print(finalImages.length.toString() + " ----final images");

                    int itr = 0;
                    for (int i = 0; i < widget.fileList!.length; i++) {
                      if (widget.fileList![i].asset!.type.toString() ==
                          "AssetType.video") {
                        finalFiles!.add(await widget.fileList![i].asset!.file);
                      } else {
                        if (testCurrentType.value != 'FILTER') {
                          // var data =
                          //     controller.editorKey.currentState.rawImageData;
                          var x = await screenshotController.capture();
                          img.Image data = await img.decodeImage(x!)!;

                          File save =
                              new File("$dir/${generateRandomString(12)}.png")
                                ..writeAsBytesSync(
                                    img.encodeJpg(data, quality: 50));

                          // print("edit save path=$x");
                          // File save = File.fromRawPath(x);
                          // await finalFiles.add(save);
                          finalFiles = [save];
                        } else {
                          File save = await new File("$dir/img$i.jpg")
                            ..writeAsBytesSync(
                                img.encodeJpg(images[itr++], quality: 95));
                          finalFiles!.add(save);
                        }
                      }
                    }
                    //-----------
                    for (int i = 0; i < files.length; i++) {
                      await sshotcontroller[i].capture().then((value) async {
                        img.Image? data = img.decodeImage(value!);
                        File save = await new File("$dir/imggg${i + 1}.png")
                          ..writeAsBytesSync(img.encodeJpg(data!, quality: 50));
                        tempfiles[i] = save;
                        finalFiles!.add(tempfiles[i]);
                      }).catchError((onError) {
                        print("error on index $i ${onError}");
                      });
                      pagecontroller!
                          .jumpTo(pagecontroller!.position.extentAfter);
                    }
//----------------
                    // finalFiles.addAll(tempfiles);
                    finalFiles!.forEach((element) {
                      print(element!.path.toString() + " pathbia");
                    });

                    Timer(Duration(seconds: 2), () {
                      Get.back();
                     print("objectdharmik");
                      Get.to(()=>UploadPost(
                                    unit8list: hasVideos
                                        ? widget.thumbs![0]
                                        : testlist[0],
                                    isSingleVideoFromStory: false,
                                    thumbs:
                                        hasVideos ? widget.thumbs! : testlist,
                                    hasVideo: hasVideos ? 1 : 0,
                                     crop: widget.crop! ? 1 : 0,
                                    // refresh: widget.refresh!,
                                    clear: () {
                                      finalFiles!.clear();
                                    },
                                    finalFiles: finalFiles!,
                                    videoHeight: 500,
                                    videoWidth: 500,
                                    height: 0,
                                    // // images[0] == null
                                    // //     ? image.height
                                    // //     : images[0].height,
                                    width: 0,
                                    // // from: "",
                                    from: hasVideos ? "editor" : "",
                                    // images[0] == null
                                    //     ? image.height
                                    //     : images[0].width,
                                  ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => UploadPost(
                      //               unit8list: hasVideos
                      //                   ? widget.thumbs![0]
                      //                   : testlist[0],
                      //               isSingleVideoFromStory: false,
                      //               thumbs:
                      //                   hasVideos ? widget.thumbs! : testlist,
                      //               hasVideo: hasVideos ? 1 : 0,
                      //               crop: widget.crop! ? 1 : 0,
                      //               refresh: widget.refresh!,
                      //               clear: () {
                      //                 finalFiles!.clear();
                      //               },
                      //               finalFiles: finalFiles!,
                      //               videoHeight: 500,
                      //               videoWidth: 500,
                      //               height: 0,
                      //               // images[0] == null
                      //               //     ? image.height
                      //               //     : images[0].height,
                      //               width: 0,
                      //               // from: "",
                      //               from: hasVideos ? "editor" : "",
                      //               // images[0] == null
                      //               //     ? image.height
                      //               //     : images[0].width,
                      //             ))).then((value) => setState(() {
                      //       finalImages.clear();
                      //     }));
                    });
                  }
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
        body: image == null
            ? Container()
            : WillPopScope(
                onWillPop: () async {
                  Navigator.pop(context);

                  setState(() {
                    FilterUtils.clearCache();
                    image = null;
                  });

                  return true;
                },
                child: !isEdit
                    ? Column(
                        children: [
                          Container(
                            color: Colors.grey.shade200,
                            height: 40.0.h,
                            // width: 70.w,
                            child: files.length == widget.fileList!.length
                                ? PreloadPageView.builder(
                                    preloadPagesCount: widget.fileList!.length,
                                    onPageChanged: (val) {},
                                    controller: pagecontroller,
                                    itemCount: widget.fileList!.length,
                                    itemBuilder: (context, index) {
                                      // finalImages.clear();
                                      print(
                                          "----built pageloader $index ${widget.fileList!.length}");
                                      return Padding(
                                          padding:
                                              EdgeInsets.only(right: 2.0.w),
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              child:
                                                  widget.fileList![index].asset!
                                                              .type
                                                              .toString() ==
                                                          "AssetType.video"
                                                      ? FittedVideoPlayer(
                                                          video: files[index],
                                                          image: 0,
                                                        )
                                                      :
                                                      //  buildImage(index)
                                                      Obx(
                                                          () => testCurrentType
                                                                      .value !=
                                                                  'FILTER'
                                                              ? editImage()
                                                              : FilteredImageWidget(
                                                                  filter:
                                                                      singleFilters[
                                                                          index],
                                                                  path: files[
                                                                          index]
                                                                      .path,
                                                                  image: images![
                                                                      index]!,
                                                                  successBuilder:
                                                                      (imageBytes) {
                                                                    img.Image?
                                                                        data =
                                                                        img.decodeImage(
                                                                            imageBytes);

                                                                    finalImages
                                                                        .add(
                                                                            data!);
                                                                    // : null;

                                                                    // finalFiles.add(save);
                                                                    print("--------lenthhhh" +
                                                                        finalImages
                                                                            .length
                                                                            .toString());
                                                                    return Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      children: [
                                                                        Container(
                                                                            child:
                                                                                Center(
                                                                          child: Image
                                                                              //   .file(
                                                                              // files[
                                                                              // index],
                                                                              .memory(
                                                                            imageBytes
                                                                                as Uint8List,
                                                                            fit: widget.crop!
                                                                                ? BoxFit.cover
                                                                                : BoxFit.contain,
                                                                            height:
                                                                                40.0.h,
                                                                          ),
                                                                        )),
                                                                        widget.fileList!.length >
                                                                                1
                                                                            ? Positioned.fill(
                                                                                left: 1.5.w,
                                                                                bottom: 1.5.w,
                                                                                child: Align(
                                                                                  alignment: Alignment.bottomLeft,
                                                                                  child: Container(
                                                                                    decoration: new BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      border: new Border.all(
                                                                                        color: !widget.crop! ? Colors.black : Colors.transparent,
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
                                                                                              setState(() {
                                                                                                isEdit = true;
                                                                                                selectedIndex = index;
                                                                                                image = images![index];

                                                                                                finalFiles!.clear();
                                                                                                finalImages.clear();
                                                                                              });
                                                                                            })),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container()
                                                                      ],
                                                                    );
                                                                  },
                                                                  errorBuilder:
                                                                      () =>
                                                                          Container(
                                                                    height:
                                                                        40.0.h,
                                                                    child: Text(
                                                                        "errorrrr"),
                                                                  ),
                                                                  loadingBuilder:
                                                                      () =>
                                                                          Container(
                                                                    height:
                                                                        40.0.h,
                                                                    child: Center(
                                                                        child: CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .black),
                                                                      strokeWidth:
                                                                          0.5,
                                                                    )),
                                                                  ),
                                                                ),
                                                          // )
                                                          // ),
                                                        )));
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 15.0.h,
                          ),
                          Obx(() => (testCurrentType.value != "FILTER" &&
                                  controller.selectedSlider.value ==
                                      "Saturation")
                              ? editAndSaturation()
                              : (testCurrentType.value != "FILTER" &&
                                      controller.selectedSlider.value ==
                                          "Brightness")
                                  ? editAndBrightness()
                                  : (testCurrentType.value != "FILTER" &&
                                          controller.selectedSlider.value ==
                                              "Contrast")
                                      ? editAndContrast()
                                      : Container(
                                          height:
                                              testCurrentType.value != "FILTER"
                                                  ? 6.5.h
                                                  : 0,
                                        )),
                          Obx(
                            () => testCurrentType.value == "FILTER"
                                ? Container(
                                    color: Colors.grey.shade200,
                                    child:
                                        // buildFilters()
                                        FilteredImageListWidget(
                                      path: "wwaa",
                                      filters: presetFiltersList,
                                      image: image!,
                                      onChangedFilter: (filter) {
                                        print(
                                            "current image filter-${image!.data}");
                                        setState(() {
                                          for (int i = 0;
                                              i < images!.length;
                                              i++) {
                                            setState(() {
                                              singleFilters[i] = filter;
                                            });
                                          }

                                          finalImages.clear();
                                          finalFiles!.clear();
                                        });
                                      },
                                    ))
                                : editSlider(),
                          ),

                          //     //EDITSLIDER

                          //     //EDITSLIDEREND
                          //     //TEST EDIT

                          widget.fileList!.length <= 1
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          // controller.selectedTab.value = "FILTERR";

                                          testCurrentType.value = "FILTER";
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 2.5.h),
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
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () async {
                                          testCurrentType.value = "EDIT";
                                          var images =
                                              finalImages.toSet().toList();
                                          File save = new File(
                                              "$dir/${generateRandomString(10)}.jpg")
                                            ..writeAsBytesSync(img.encodeJpg(
                                                images[0],
                                                quality: 95));
                                          editfinalFiles = [save];

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
                                          padding:
                                              EdgeInsets.only(bottom: 2.5.h),
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
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          //TESTEDIT
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              FilteredImageWidget(
                                filter: singleFilters[selectedIndex],
                                path: selectedIndex.toString(),
                                image: image!,
                                successBuilder: (imageBytes) {
                                  img.Image? data = img.decodeImage(imageBytes);

                                  //File save = new File("$dir/${singleFilter.name}.jpg")..writeAsBytesSync(img.encodeJpg(data, quality: 25));

                                  return Container(
                                      child: Stack(
                                    children: [
                                      Image.memory(imageBytes as Uint8List,
                                          height: 40.0.h, fit: BoxFit.cover),
                                    ],
                                  ));
                                },
                                errorBuilder: () => Container(height: 50.0.h),
                                loadingBuilder: () => Container(
                                  height: 40.0.h,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                    strokeWidth: 0.5,
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: 10.0.h,
                              ),
                              FilteredImageListWidget(
                                path: files[selectedIndex].path,
                                filters: presetFiltersList,
                                image: image!,
                                onChangedFilter: (filter) {
                                  setState(() {
                                    this.singleFilters[selectedIndex] = filter;
                                    editFile = finalFile;
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
              ));
  }
}

class VideoPlayerMain extends StatefulWidget {
  final File video;

  const VideoPlayerMain({Key? key, required this.video}) : super(key: key);

  @override
  _VideoPlayerMainState createState() => _VideoPlayerMainState();
}

class _VideoPlayerMainState extends State<VideoPlayerMain> {
  FlickManager? flickManager;

  @override
  void initState() {
    flickManager = new FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.file(widget.video),
    );

    super.initState();
  }

  @override
  void dispose() {
    print("disppppp");
    flickManager!.flickVideoManager!.videoPlayerController!.dispose();
    flickManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: flickManager!.flickVideoManager!.videoPlayerController != null
            ? VisibilityDetector(
                key: ObjectKey(flickManager),
                onVisibilityChanged: (visibility) {
                  if (visibility.visibleFraction < 0.9) {
                    flickManager!.flickVideoManager!.videoPlayerController!
                        .pause();
                  } else {
                    flickManager!.flickVideoManager!.videoPlayerController!
                        .play();
                    flickManager!.flickVideoManager!.videoPlayerController!
                        .setLooping(true);
                  }
                },
                child: Container(
                  child: FlickVideoPlayer(
                    wakelockEnabled: false,
                    wakelockEnabledFullscreen: false,
                    flickManager: flickManager!,
                    flickVideoWithControls: FlickVideoWithControls(
                      videoFit: BoxFit.cover,
                      playerLoadingFallback: Center(child: Container()),
                    ),
                  ),
                ),
              )
            : Container());
  }
}

class FittedVideoPlayer extends StatefulWidget {
  FittedVideoPlayer({Key? key, required this.video, this.image})
      : super(key: key);

  final File video;
  final int? image;

  @override
  _FittedVideoPlayerState createState() => _FittedVideoPlayerState();
}

class _FittedVideoPlayerState extends State<FittedVideoPlayer> {
  VideoPlayerController? controller;

  @override
  void initState() {
    controller = VideoPlayerController.file(widget.video);
    controller!.initialize().then((_) {
      setState(() {});
      controller!.pause();
      controller!.setLooping(true);
    });

    super.initState();
  }

  @override
  void dispose() {
    print("dispppppp multiiiiiiiii");
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      body: Center(
          child: controller!.value != null && controller!.value.isInitialized
              ? VisibilityDetector(
                  key: ObjectKey(controller),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction > 0.9) {
                      controller!.play();
                    } else {
                      controller!.pause();
                    }
                  },
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller!.value.size?.width ?? 0,
                        height: controller!.value.size?.height ?? 0,
                        child: VideoPlayer(controller!),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 50.0.h,
                  width: 100.0.w,
                  color: Colors.black,
                )),
    );
  }
}

class InstagramEditController extends GetxController {
  var sat = 1.0.obs;
  var bright = 0.0.obs;
  var con = 1.0.obs;
  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  var selectedSlider = "".obs;

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final defaultColorMatrix = const <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];
  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat;
    final G = 0.715 * invSat;
    final B = 0.072 * invSat;

    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }
}
