import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/PhotoFiltersAPI/imageFilterApi.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/PhotoFilters/widget/filtered_image_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_editor/image_editor.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'filter_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class SinglePhotoFilter extends StatefulWidget {
  SinglePhotoFilter(
      {Key? key,
      this.title,
      this.filePath,
      this.flip,
      this.refresh,
      this.from,
      this.webimages = const [],
      this.crop})
      : super(key: key);

  final String? title;
  final String? filePath;
  final bool? flip;
  final Function? refresh;
  final String? from;
  final bool? crop;
  List webimages = [];

  @override
  _SinglePhotoFilterState createState() => _SinglePhotoFilterState();
}

class _SinglePhotoFilterState extends State<SinglePhotoFilter> {
  img.Image? image;
  Filter filter = presetFiltersList.first;

  String? imageFilePath;
  double sat = 1;
  double bright = 0;
  double con = 1;
  final GlobalKey _globalKey = GlobalKey();

  void convertWidgetToImage() async {
    print("convert image called");
    // RenderObject? repaintBoundary =
    //     _globalKey.currentContext!.findRenderObject();
    RenderRepaintBoundary? box =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var boxImage = await box.toImage(pixelRatio: 1);
    ByteData? byteData = await boxImage.toByteData(format: ImageByteFormat.png);
    Uint8List? uint8list = byteData!.buffer.asUint8List();

    img.Image? data = img.decodeImage(uint8list!);
    File save = new File("$dir/${generateRandomString(10)}.png")
      ..writeAsBytesSync(img.encodeJpg(data!, quality: 50));
    changeImage(save);

    // You can now use this to save the Image to Local Storage or upload it to a Remote Server.
  }

  List<File> finalFiles = [];
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
    ]
  };

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

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  late File finalFile;
  late File editFile;
  late String dir;
  late img.Image filterImage;
  String selectedTab = "FILTER";
  String selectedSlider = "";

  late String newPath;
  late File originalFile;
  late Uint8List testlist;
  @override
  void initState() {
    saveImage();
    imageFilePath = widget.filePath!;
    // testloadImage();
    loadImage();
    super.initState();
  }

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  Future saveImage() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/MyImages';
    setState(() {
      dir = myImagePath;
    });
    final myImgDir = await new Directory(myImagePath).create();
  }

  Future<void> crop() async {
    final ExtendedImageEditorState state = editorKey.currentState!;
    final Uint8List img = state.rawImageData;
    final ImageEditorOption option = ImageEditorOption();
    option.addOption(ColorOption.saturation(sat));
    option.addOption(ColorOption.brightness(bright + 1));
    option.addOption(ColorOption.contrast(con));
    option.outputFormat = const OutputFormat.jpeg(100);

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    final Duration diff = DateTime.now().difference(start);
    finalFile.writeAsBytesSync(result!);
    File save = new File("$dir/${generateRandomString(10) + "edited"}.jpg")
      ..writeAsBytesSync((result));
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(list, quality: 20);
    print(list.length);
    print('image length compressed=${result.length}');
    return result;
  }

  void callFilterApi(Uint8List uint8list) async {
    img.Image? data = img.decodeImage(uint8list!);
    File save = new File("$dir/${generateRandomString(13)}.png")
      ..writeAsBytesSync(img.encodeJpg(data!, quality: 50));
    var result = await imageFilterApi.postImages([save]);
    if (result != null)
      setState(() {
        widget.webimages = result;
      });
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 80,
    );
    print(file.lengthSync());
    print(result!.lengthSync());
    return result;
  }

  Future loadImage() async {
    print("loading image");
    // final compressedImage =await compressFile(File(imageFilePath) ;
    // final imageBytes = await compressFile(File(imageFilePath))
    //     .then((value) => value.readAsBytesSync());
    final imageBytes = File(imageFilePath!).readAsBytesSync();
    print('image length uncompressed=${imageBytes.length}');
    // final compimageBytes = await testComporessList(imageBytes);

    final newImage = img.decodeImage(imageBytes);
    print("image length new image=${newImage!.getBytes().length}");
    final height = newImage!.height!;
    final width = newImage.width;

    var resizedImageNormal = img.copyResize(newImage,
        width: (height > 1500 && width > 1500)
            ? newImage.width ~/ 3
            : newImage.width ~/ 1,
        height: (height > 1500 && width > 1500)
            ? newImage.height ~/ 3
            : newImage.height ~/ 1);
    var cropSize = min(newImage.width, newImage.height);
    int offsetX = (newImage.width - min(newImage.width, newImage.height)) ~/ 2;
    int offsetY = widget.from == "capture"
        ? 0
        : (newImage.height - min(newImage.width, newImage.height)) ~/ 2;
    img.Image destImage =
        img.copyCrop(newImage, offsetX, offsetY, cropSize, cropSize);
    var resizedImageCropped = img.copyResize(destImage,
        width: (height > 1500 && width > 1500)
            ? destImage.width ~/ 3
            : destImage.width ~/ 1,
        height: (height > 1500 && width > 1500)
            ? destImage.height ~/ 3
            : destImage.height ~/ 1);

    if (widget.flip!) {
      resizedImageCropped = img.flipHorizontal(destImage);
      testlist = img.encodePng(resizedImageCropped) as Uint8List;
    }
    if (widget.crop!) {
      setState(() {
        this.image = resizedImageCropped;
        final imageBytesTest = this.image!.getBytes();
        testlist = img.encodePng(this.image!) as Uint8List;

        print('image length setstate ${this.image!.getBytes().length}');
      });
    } else {
      setState(() {
        this.image = resizedImageNormal;
        testlist = img.encodePng(this.image!) as Uint8List;
      });
    }
    FilterUtils.clearCache();
    print('image length load image completed');
  }

  Future testloadImage() async {
    print("loading image");
    // final compressedImage =await compressFile(File(imageFilePath) ;
    // final imageBytes = await compressFile(File(imageFilePath))
    //     .then((value) => value.readAsBytesSync());
    final imageBytes = File(imageFilePath!).readAsBytesSync();
    print('image length uncompressed=${imageBytes.length}');
    // final compimageBytes = await testComporessList(imageBytes);

    final newImage = img.decodeImage(imageBytes);
    print("image length new image=${newImage!.getBytes().length}");
    final height = newImage.height;
    final width = newImage.width;

    var resizedImageNormal = img.copyResize(newImage,
        width: (height > 1500 && width > 1500)
            ? newImage.width ~/ 3
            : newImage.width ~/ 1,
        height: (height > 1500 && width > 1500)
            ? newImage.height ~/ 3
            : newImage.height ~/ 1);
    var cropSize = min(newImage.width, newImage.height);
    int offsetX = (newImage.width - min(newImage.width, newImage.height)) ~/ 2;
    int offsetY = widget.from == "capture"
        ? 0
        : (newImage.height - min(newImage.width, newImage.height)) ~/ 2;
    img.Image destImage =
        img.copyCrop(newImage, offsetX, offsetY, cropSize, cropSize);
    var resizedImageCropped = img.copyResize(destImage,
        width: (height > 1500 && width > 1500)
            ? destImage.width ~/ 3
            : destImage.width ~/ 1,
        height: (height > 1500 && width > 1500)
            ? destImage.height ~/ 3
            : destImage.height ~/ 1);

    if (widget.flip!) {
      resizedImageCropped = img.flipHorizontal(destImage);
      testlist = img.encodePng(resizedImageCropped) as Uint8List;
    }
    if (widget.crop!) {
      setState(() {
        this.image = resizedImageCropped;
        final imageBytesTest = this.image!.getBytes();
        testlist = img.encodePng(this.image!) as Uint8List;
      });

      print('image length setstate ${this.image!.getBytes().length}');
    } else {
      setState(() {
        this.image = resizedImageNormal;
        testlist = img.encodePng(this.image!) as Uint8List;
        print('image length setstate ${this.image!.getBytes()}');
      });
    }

    FilterUtils.clearCache();
    print('image length load image completed');
  }

  Widget editImage() {
    // final imageBytes = File(imageFilePath).readAsBytesSync();
    // print('image length uncompressed=${imageBytes.length}');
    // // final compimageBytes = await testComporessList(imageBytes);

    // final newImage = img.decodeImage(imageBytes);
    // print("image length new image=${newImage.getBytes().length}");
    finalFile == null ? finalFile = File(imageFilePath!) : finalFile;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(calculateSaturationMatrix(sat)),
        child: ExtendedImage(
          color: bright > 0
              ? Colors.white.withOpacity(bright)
              : Colors.black.withOpacity(-bright),
          colorBlendMode: bright > 0 ? BlendMode.lighten : BlendMode.darken,
          image: ExtendedFileImageProvider(finalFile),
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          extendedImageEditorKey: editorKey,
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
    );
  }

  Widget _buildSat() {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSlider = "Saturation";
        });
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

  Widget _buildBrightness() {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSlider = "Brightness";
        });
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
        setState(() {
          selectedSlider = "Contrast";
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Navigator.pop(context);
                    },
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
                    selectedSlider,
                    style: TextStyle(color: Colors.black, fontSize: 15.0.sp),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
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
                  crop();
                  // saveImage();
                  // convertWidgetToImage();
                  print("____________@ $editFile");
                  setState(() {
                    finalFiles.add(editFile);
                  });
                  print("____________@@ $finalFiles");

                  print("____________@@@ ${File(imageFilePath!)}");

                  Timer(Duration(seconds: 2), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadPost(
                                  isSingleVideoFromStory: false,
                                  width: image!.width,
                                  height: image!.height,
                                  crop: widget.crop! ? 1 : 0,
                                  from: widget.from!,
                                  refresh: widget.refresh!,
                                  clear: () {
                                    setState(() {
                                      finalFiles.clear();
                                    });
                                  },
                                  finalFiles: [File(imageFilePath!)],
                                )));
                  });
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
              // GestureDetector(
              //   onTap: () {
              //     Fluttertoast.showToast(
              //       msg: AppLocalizations.of(
              //         "Processing",
              //       ),
              //       toastLength: Toast.LENGTH_SHORT,
              //       gravity: ToastGravity.CENTER,
              //       backgroundColor: Colors.black.withOpacity(0.7),
              //       textColor: Colors.white,
              //       fontSize: 16.0,
              //     );
              //     crop();
              //     //saveImage();
              //     convertWidgetToImage();
              //     // setState(() {
              //     //   finalFiles.add(editFile);
              //     // });
              //   },
              //   child: Container(
              //     color: Colors.transparent,
              //     child: Padding(
              //       padding:
              //           EdgeInsets.only(left: 4.0.w, top: 10, bottom: 10),
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.coronavirus,
              //             size: 3.5.h,
              //             color: Colors.red,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              selectedTab == "FILTER"
                  ? buildImage()
                  : Container(height: 50.0.h, child: editImage()),
              SizedBox(height: 10.0.h),
              selectedTab == "EDIT" && selectedSlider == "Saturation"
                  ? Padding(
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
                              setState(() {
                                sat = value;
                              });
                            },
                            divisions: 50,
                            value: sat,
                            min: 0,
                            max: 2,
                          ),
                        ),
                      ),
                    )
                  : selectedTab == "EDIT" && selectedSlider == "Brightness"
                      ? Padding(
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
                                  setState(() {
                                    bright = value;
                                  });
                                },
                                divisions: 50,
                                value: bright,
                                min: -1,
                                max: 1,
                              ),
                            ),
                          ),
                        )
                      : selectedTab == "EDIT" && selectedSlider == "Contrast"
                          ? Padding(
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
                                      setState(() {
                                        con = value;
                                      });
                                    },
                                    divisions: 50,
                                    value: con,
                                    min: 0,
                                    max: 4,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: selectedTab == "EDIT" ? 6.5.h : 0,
                            ),
              selectedTab == "FILTER"
                  ? buildFilters()
                  : SliderTheme(
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
                    ),
              SizedBox(height: selectedSlider == "" ? 4.8.h : 3.6.h),
            ],
          ),
          Column(
            children: [
              selectedTab == "EDIT" && selectedSlider != ""
                  ? Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              selectedSlider = "";
                              sat = 1;
                              con = 1;
                              bright = 0;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.5.h),
                            child: Container(
                                color: Colors.transparent,
                                width: 50.0.w,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      "CANCEL",
                                    ),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              selectedSlider = "";
                              editFile = finalFile;
                              print(
                                  "______________###__Done__ $editFile -- $finalFile");
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 2.5.h),
                            child: Container(
                                color: Colors.transparent,
                                width: 50.0.w,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      "DONE",
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              selectedTab = "FILTER";

                              finalFiles.clear();
                            });
                          },
                          child: Padding(
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
                                        color: selectedTab == "FILTER"
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
                          onTap: () {
                            setState(() {
                              selectedTab = "EDIT";
                              finalFile = editFile;
                              print("_____________### $finalFile -- $editFile");

                              finalFiles.clear();
                            });
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
                                        color: selectedTab == "EDIT"
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
            ],
          )
        ],
      )),
    );
  }

  void changeImage(File file) {
    editFile = file;
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  List<ColorFilter> colorFilters = [
    ColorFilter.mode(Colors.red.withOpacity(0.4), BlendMode.difference),
    ColorFilter.mode(Colors.red.withOpacity(0.4), BlendMode.colorBurn),
  ];
  Widget buildImage() {
    double height = 50.0.h;
    if (image == null) return Container();

    print("filter= ${testfilterlist[1]}");
    Timer(Duration(milliseconds: 250), () async {
      // callFilterApi(testlist);
      // convertWidgetToImage();
    });
    print("webimage2=${widget.webimages}");
    return
        // child: Stack(
        //   children: [
        //     ImageFiltered(
        //         imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        //         child: ShaderMask(
        //             shaderCallback: (rect) {
        //               return RadialGradient(
        //                 center: Alignment(-0.8, -0.6),
        //                 colors: [
        //                   Color.fromRGBO(3, 235, 255, 1),
        //                   Color.fromRGBO(152, 70, 242, 1)
        //                 ],
        //                 radius: 1.0,
        //               ).createShader(rect);
        //             },
        //             child: Image.memory(
        //               testlist,
        //               height: height,
        //               fit: BoxFit.contain,
        //             )))
        //   ],
        // ),

        RepaintBoundary(
      key: _globalKey,
      child: Container(
        height: height,
        color: Colors.white,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(currentFilter),
          child: widget.webimages.length != 0
              ? WebView(
                  initialUrl: '${widget.webimages[0]}',
                )
              : Image.memory(
                  testlist,
                  height: height,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );

    // return RepaintBoundary(
    //   key: _globalKey,
    //   child: ColorFiltered(
    //       colorFilter: ColorFilter.matrix(currentFilter),
    //       child: Image.memory(testlist, height: height, fit: BoxFit.contain)),
    // );

    // return FilteredImageWidget(
    //   filter: filter,
    //   image: image,
    //   path: "fhiadhiadja",
    //   successBuilder: (imageBytes) {
    //     print("image length filter=${imageBytes.length}");
    //     img.Image data = img.decodeImage(imageBytes);
    //     File save = new File("$dir/${generateRandomString(10)}.jpg")
    //       ..writeAsBytesSync(img.encodeJpg(data, quality: 50));
    //     changeImage(save);
    //     return Image.memory(imageBytes, height: height, fit: BoxFit.contain);
    //   },
    //   errorBuilder: () => Container(height: height),
    //   loadingBuilder: () => Container(
    //     height: height,
    //     child: Center(
    //         child: CircularProgressIndicator(
    //       valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    //       strokeWidth: 0.5,
    //     )),
    //   ),
    // );
  }

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
              var initialUrl =
                  'https://bebuzee.com/api/filter/filter-set.php?type=moon&url=${widget.webimages[0]}';
              print("initial url=$initialUrl");
              setState(() {
                // currentFilter = filter[index];
                widget.webimages = [initialUrl];
                print("webimage=${widget.webimages}");
                finalFile = editFile;
                print("_____________## $finalFile");
                finalFiles.clear();
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
                        testlist,
                        cacheHeight: image!.height ~/ 4,
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

    // return FilteredImageListWidget(
    //   filters: presetFiltersList,
    //   image: image,
    //   path: "asasasa",
    //   onChangedFilter: (filter) {
    //     setState(() {
    //       this.filter = filter;
    //       finalFile = editFile;
    //       finalFiles.clear();
    //     });
    //   },
    // );
  }
}
