import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bizbultest/services/PhotoFiltersAPI/imageFilterApi.dart';
import 'package:bizbultest/widgets/FeedPosts/feed_post_gallery.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image/image.dart' as img;

class InstagramPhotoFilterController extends GetxController {
  img.Image? image;
  late List<img.Image?> multipleimage;
  var imageHeight = 0.obs;
  var imageWidth = 0.obs;
  var listofmainurl = [].obs;
  InstagramPhotoFilterController(
      {this.file,
      this.from,
      this.crop,
      this.flip,
      this.path = '',
      this.multiplefileList,
      this.multiplefiles});
  List<AssetsCustom?>? multiplefileList = [];
  List<File?>? multiplefiles = [];
  File? file = File('aa');
  String? from = '';
  var path = '';
  late bool? crop;
  late bool? flip;
  late Uint8List? testlist;
  late List<Uint8List> multipletestlist;
  GlobalKey globalKey = GlobalKey();
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  late WebViewController? webviewcontroller;
  late InAppWebViewController? inAppWebViewController;
  RxMap filteredImages = {}.obs;
  Map testfilteredImages = {}.obs;
  RxMap finalFiles = {}.obs;
  var listurl = [];
  var dir = ''.obs;
  var selectedTab = 'FILTER'.obs;
  var selectedSlider = "".obs;
  var sat = 1.0.obs;
  var bright = 0.0.obs;
  var con = 1.0.obs;
  RxMap testfinalFile = {}.obs;
  var filternamelist = [
    'nofilter',
    'aden',
    '1977',
    'amaro',
    'ashby',
    'brannan',
    'brooklyn',
    'charmes',
    'caledron',
    'crema',
    'dogpatch',
    'earlybird',
    'gingham',
    'ginza',
    'hudson',
    'inkwell',
    'maven',
    'mayfair',
    'moon',
    'nashville'
  ];
  ScreenshotController scontroller = ScreenshotController();
  late File finalFile;
  var currentFilterIndex = 0.obs;
  var mainurl = ''.obs;
  var suburl = ''.obs;
  void switchFilter(type, index) {
    var baseurl =
        //"${mainurl.value}";
        'https://bebuzee.com/api/filter/filter-set.php?type=$type&url=${mainurl.value}';
    print("baseurl=$baseurl");
    suburl.value = baseurl;
    mainurl.value = baseurl;
    currentFilterIndex.value = index;

    print("main base=$mainurl");
  }

  var mainimage = [].obs;
  var filterlist = [].obs;
//-------------------------------------------
  RxMap<dynamic, dynamic> filteredImageMap = {}.obs;
  RxMap<dynamic, dynamic> editedImageMap = {}.obs;

  Uint8List? getcurrentfilteredImage() {
    var currentFilterName = filternamelist[currentFilterIndex.value];
    if (filteredImageMap.containsKey(currentFilterName))
      return filteredImageMap[currentFilterName];

    return null;
  }

  displayKeys({insertType: ""}) {
    filteredImageMap.value.forEach((key, value) {
      print(
          "map -> ${insertType} $key and  current filter${filternamelist[currentFilterIndex.value]}length=${filteredImageMap.length} widget= ${(mainurl.value != '' && getcurrentfilteredImage() == null)} onno contain key ${filteredImageMap.containsKey(filternamelist[currentFilterIndex.value])} onno current imag=${getcurrentfilteredImage()}");
    });
    ;
  }

  Future setCurrentfilteredImage() async {
    var currentFilterName = filternamelist[currentFilterIndex.value];
    // print("map -> before insert");
    displayKeys(insertType: "before insert");
    print(
        "url load ${filternamelist[currentFilterIndex.value]} ${!filteredImageMap.containsKey(currentFilterName)}");
    if (!filteredImageMap.containsKey(currentFilterName)) {
      print("url loading");

      var filteruint8list = await inAppWebViewController!
          .loadUrl(urlRequest: URLRequest(url: Uri.parse(mainurl.value)))
          .then((value) async {
        return await inAppWebViewController!.takeScreenshot(
            screenshotConfiguration: ScreenshotConfiguration(
                compressFormat: CompressFormat.PNG, quality: 80));
      });

      print("map -> conversion to uint success");

      Map<dynamic, dynamic> temp = {};
      temp.addAll(filteredImageMap.value);
      print("map -> temporaty length before=${temp.length}");

      temp[currentFilterName] = filteruint8list;
      print("map -> temporaty length after=${temp.length}");
      print("url load ${currentFilterName}:${filteruint8list} ");
      filteredImageMap.value = temp;
    }

    displayKeys(insertType: "after insert");
  }

//-------------------------------------
  void getImageFilterList() {
    List filternamelist = [
      'nofilter',
      'aden',
      '1977',
      'amaro',
      'ashby',
      'brannan',
      'brooklyn',
      'charmes',
      'caledron',
      'crema',
      'dogpatch',
      'earlybird',
      'gingham',
      'ginza',
      'hudson',
      'inkwell',
      'maven',
      'mayfair',
      'moon',
      'nashville'
    ];

    filterlist.value = filternamelist
        .map((e) =>
            'https://bebuzee.com/api/filter/filter-set.php?type=$e&url=${mainurl.value}'
                .toString())
        .toList();
    print("filterlist=${filterlist.value}");
  }

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

  Future<File> cropImage() async {
    final ExtendedImageEditorState state = editorKey.currentState!;

    final Uint8List img = state.rawImageData;
    final ImageEditorOption option = ImageEditorOption();
    option.addOption(ColorOption.saturation(sat.value));
    option.addOption(ColorOption.brightness(bright.value + 1));
    option.addOption(ColorOption.contrast(con.value));
    option.outputFormat = const OutputFormat.png(80);

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    final Duration diff = DateTime.now().difference(start);
    finalFile.writeAsBytesSync(result!);
    File save = new File("$dir/${generateRandomString(10) + "edited"}.jpg")
      ..writeAsBytesSync((result));
    return save;
  }

  getImageLink() async {
    var data = await imageFilterApi.postImages([this.file!]).then((value) {
      mainurl.value = value[0];
      listofmainurl.value = value;
      testfilteredImages.assign("nofilter", this.file!.readAsBytesSync());
      filteredImages.value = testfilteredImages;
      getImageFilterList();
    });
  }

  void loadMultipleImage() async {
    print("loading multiple image");

    // final compressedImage =await compressFile(File(imageFilePath) ;
    // final imageBytes = await compressFile(File(imageFilePath))
    //     .then((value) => value.readAsBytesSync());
    late List<File?> finalFile;
    for (int i = 0; i < this.multiplefileList!.length; i++) {
      var file = await this.multiplefileList![i]!.asset!.file;
      var imageBytes = File(file!.path).readAsBytesSync();
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
      int offsetX =
          (newImage.width - min(newImage.width, newImage.height)) ~/ 2;
      int offsetY = this.from == "capture"
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

      if (this.flip!) {
        resizedImageCropped = img.flipHorizontal(destImage);

        multipletestlist[i] = img.encodePng(resizedImageCropped) as Uint8List;
      }
      if (this.crop!) {
        this.multipleimage.add(resizedImageCropped);

        multipletestlist[i] = img.encodePng(this.image!) as Uint8List;
      } else {
        this.image = resizedImageNormal;
        multipletestlist[i] = img.encodePng(this.image!) as Uint8List;

        print('image length setstate ${this.image!.getBytes()}');
      }
      imageHeight.value = this.image!.height;
      imageWidth.value = this.image!.width;
      // FilterUtils.clearCache();
      print('image length load image completed');
      finalFile = converListToMultipleFile(multipletestlist);
    }
    this.multiplefiles = finalFile;
  }

  Future<void> loadImage() async {
    print("loading image");
    // final compressedImage =await compressFile(File(imageFilePath) ;
    // final imageBytes = await compressFile(File(imageFilePath))
    //     .then((value) => value.readAsBytesSync());
    final imageBytes = File(this.path).readAsBytesSync();
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
    int offsetY = this.from == "capture"
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

    if (this.flip!) {
      resizedImageCropped = img.flipHorizontal(destImage);
      testlist = img.encodePng(resizedImageCropped) as Uint8List?;
    }
    if (this.crop!) {
      this.image = resizedImageCropped;
      final imageBytesTest = this.image!.getBytes();
      testlist = img.encodePng(this.image!) as Uint8List?;
    } else {
      this.image = resizedImageNormal;
      testlist = img.encodePng(this.image!) as Uint8List?;

      print('image length setstate ${this.image!.getBytes()}');
    }
    imageHeight.value = this.image!.height;
    imageWidth.value = this.image!.width;
    // FilterUtils.clearCache();
    print('image length load image completed');
    File finalFile = await converListToFile(testlist!);
    this.finalFile = finalFile;
    finalFiles.value = {"file": this.finalFile};
    this.file = finalFile;
  }

  Future convertWidgetToImage() async {
    print("convert image called");
    // RenderObject? renderObject = globalKey.currentContext!.findRenderObject();
    final RenderRepaintBoundary? box =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    var boxImage = await box!.toImage(pixelRatio: 1);
    ByteData? byteData = await boxImage.toByteData(format: ImageByteFormat.png);
    Uint8List uint8list = byteData!.buffer.asUint8List();

    img.Image? data = img.decodeImage(uint8list);
    File save = new File("$dir/${generateRandomString(10)}.png")
      ..writeAsBytesSync(
        img.encodeJpg(data!, quality: 50),
      );
    print("saved with filter");
    return save;

    // You can now use this to save the Image to Local Storage or upload it to a Remote Server.
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  File converListToFile(Uint8List list)  {
    img.Image? data = img.decodeImage(list);
    File save =  File("${dir.value}/${generateRandomString(10)}.jpg")
      ..writeAsBytesSync(img.encodeJpg(data!, quality: 80));
    return save;
  }

  List<File> converListToMultipleFile(List<Uint8List> list) {
    List<File> save = [];
    for (int i = 0; i < list.length; i++) {
      img.Image? data = img.decodeImage(list[i]);
      save.add(new File("${dir.value}/${generateRandomString(i)}.jpg")
        ..writeAsBytesSync(img.encodeJpg(data!, quality: 80)));
    }
    return save;
  }

  Future saveImage() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/MyImages';

    dir.value = myImagePath;

    final myImgDir = await new Directory(myImagePath).create();
  }

  @override
  void onInit() async {
    await saveImage();
    loadImage();
    await getImageLink();
    super.onInit();
  }
}
