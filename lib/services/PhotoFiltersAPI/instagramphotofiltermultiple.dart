import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bizbultest/services/PhotoFiltersAPI/imageFilterApi.dart';
import 'package:bizbultest/utilities/FlickPlayer/flick_multi_manager.dart';
import 'package:bizbultest/view/Chat/audio_library.dart';
import 'package:bizbultest/widgets/FeedPosts/feed_post_gallery.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import 'package:sizer/sizer.dart';

class InstagramPhotoFiltersMultipleController extends GetxController {
  List<AssetsCustom?>? assetfilelist;
  var crop;
  FlickMultiManager? flickMultiManager;
  InAppWebViewController? inAppWebViewController;
  List<InAppWebViewController> listofinAppWebViewController = [];
  InstagramPhotoFiltersMultipleController({this.assetfilelist, this.crop});
  var isEdit = false.obs;
  var singleEditImage = ''.obs;
  var editIndex = -1.obs;
  var multipleurls = [].obs;
  var testlist = [].obs;
  var images = [].obs;
  img.Image? image;
  PreloadPageController? pagecontroller;

  void editSingleImage(int index) {
    editIndex = index;
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

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

  var currentFilterIndex = 0.obs;
  var filterlist = [].obs;
  void getImageFilterList(url) {
    try {
      filterlist.value = filternamelist
          .map((e) =>
              'https://bebuzee.com/api/filter/filter-set.php?type=$e&url=${url}'
                  .toString())
          .toList();
    } catch (e) {
      print("filterlist error =$e");
    }
    print("-----filterlist=${filterlist.value}");
  }

  File converListToFile(Uint8List list) {
    img.Image? data = img.decodeImage(list);
    File save = new File("${dir.value}/${generateRandomString(10)}.jpg")
      ..writeAsBytesSync(img.encodeJpg(data!, quality: 80));
    return save;
  }

  List<File> videofile = [];
  Future getMultipleLinks() async {
    File? file;
    List<File> filelisttoserver = [];
    List<Uint8List> temporarylist = [];
    List tempImages = [];
    for (int i = 0; i < this.assetfilelist!.length; i++) {
      if (this.assetfilelist![i]!.asset!.type.toString() != "AssetType.video") {
        file = await this.assetfilelist![i]!.asset!.file;

        File imageCopied = await file!.copy("$dir/${p.basename(file!.path)}");
        
        print("-----image copied == null ${imageCopied == null}" +
            imageCopied.path.toString());
        File rotatedImage =
            await FlutterExifRotation.rotateImage(path: imageCopied.path);
        var imageBytes = File(rotatedImage.path).readAsBytesSync();

        // var compimageBytes = await testComporessList(imageBytes);
        var newImage = img.decodeImage(imageBytes);
        final height = 40.h;
        //  newImage.height;
        final width = 100.w;
        // newImage.width;
        print("----- h-- $height ---w-- $width");
        img.Image? fixedImage;
        fixedImage = newImage;
        var resizedImageNormal = img.copyResize(
          fixedImage!,
          width: 600,
          // (height > 1500 && width > 1500)
          //     ? fixedImage.width ~/ 3
          //     : fixedImage.width ~/ 1,
          height: 400,
          // (height > 1500 && width > 1500)
          //     ? fixedImage.height ~/ 3
          //     : fixedImage.height ~/ 1,
        );
        print("----resizedimage==null ${resizedImageNormal}");
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
        print("----resizedimageCrop==null ${resizedImageCropped == null}");
        if (this.crop) {
          tempImages.add(resizedImageCropped);
          images.value = tempImages;
          image = image == null ? resizedImageCropped : image;
          temporarylist.add(img.encodePng(resizedImageCropped) as Uint8List);
          testlist.value = temporarylist;
        } else {
          images.add(fixedImage);
          image = image == null ? fixedImage : image;
          temporarylist.add(img.encodePng(resizedImageCropped) as Uint8List);
          testlist.value = temporarylist;
        }
        print("-----uplodable file=$i  ${temporarylist[i]}");
        File uploadablefile = converListToFile(temporarylist[i]);
        filelisttoserver.add(uploadablefile);
      } else {
        var file = await this.assetfilelist![i]!.asset!.file;
        filelisttoserver.add(file!);
      }
    }
    print(
        "-----fileto server length= 0->${filelisttoserver[0].path} 1=${filelisttoserver[1].path}");
    await imageFilterApi.postImages(filelisttoserver).then((value) {
      var tempurl = [];

      value.forEach((element) {
        var url =
            'https://bebuzee.com/api/filter/filter-set.php?type=nofilter&url=$element';
        print("---------yurl-- $url");
        tempurl.add(url);
        // multipleurls.add(tempurl)
      });
      getImageFilterList(value[0]);
      multipleurls.value = tempurl;
    });
    print("-----multiurl-- ${multipleurls.value.toString()}");
  }

  void getMultipleFilters() {}

//------------------------------------------

  var dir = ''.obs;

//--------------------------------
  Future saveImage() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/Cache';
    dir.value = myImagePath;
    final myImgDir = await new Directory(myImagePath).create();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    pagecontroller = PreloadPageController(
      viewportFraction: this.crop ? 0.8 : 0.6,
      initialPage: 0,
    );
    await saveImage();
    flickMultiManager = FlickMultiManager();
    await getMultipleLinks();
    await convertoimages();

    super.onInit();
  }

  Future<List<File>> convertoimages() async {
    List<RenderRepaintBoundary> repaintBoundary = [];

    for (int i = 0; i < 1; i++) {
      repaintBoundary.add(multipleurls[i].currentContext.findRenderObject());
    }
    // listkeys.forEach((GlobalObjectKey element) {
    //   repaintBoundary.add(element.currentContext.findRenderObject());
    // });
    print("convert to images repaint boundry=${repaintBoundary.length}");
    List boxImage = [];
    // repaintBoundary.forEach((element) async {
    //   var item = await element.toImage(pixelRatio: 1);
    //   boxImage.add(item);
    // });
    try {
      for (int i = 0; i < repaintBoundary.length; i++) {
        var item = await repaintBoundary[i].toImage(pixelRatio: 1);
        boxImage.add(item);
      }
    } catch (e) {
      print("convert to images boxImage =$e");
    }
    // await Future.forEach(repaintBoundary, (element) async {
    //   var item = await element.toImage(pixelRatio: 1);
    //   boxImage.add(item);
    // });
    print("convert to images boxImage =${boxImage.length}");
    List<ByteData> byteData = [];
    try {
      for (int i = 0; i < byteData.length; i++) {
        var element = await boxImage[i].toByteData(format: ImageByteFormat.png);
        byteData.add(element);
      }
    } catch (e) {
      print("---convert to image $e");
    }
    // boxImage.forEach((element) async {
    //   byteData.add(await element.toByteData(format: ImageByteFormat.png));
    // });
    print("---convert to images byteData =${byteData.length}");
    List<Uint8List> uint8list = [];
    byteData.forEach((element) {
      uint8list.add(element.buffer.asUint8List());
    });
    print("---convert to images uint8List =${uint8list.length}");
    List<img.Image> datalist = [];
    uint8list.forEach((element) {
      img.Image? data = img.decodeImage(element);
      datalist.add(data!);
    });
    List<File> savedFiles = [];
    datalist.forEach((element) {
      File save = new File("$dir/${generateRandomString(10)}.png")
        ..writeAsBytesSync(img.encodeJpg(element, quality: 95));
      savedFiles.add(save);
    });
    print("---convert to images success ${savedFiles.length}");
    return savedFiles;
    //  var boxImage = await repaintBoundary.toImage(pixelRatio: 1);
  }
}
