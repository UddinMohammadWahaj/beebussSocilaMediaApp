import 'dart:async';
import 'dart:io';
import 'dart:io' as i;
import 'dart:math';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/PhotoFiltersAPI/imageFilterApi.dart';
import 'package:bizbultest/services/PhotoFiltersAPI/testinstagramvideofilter.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedvideoplayer.dart';
import 'package:bizbultest/widgets/FeedPosts/edit_multiple_files.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:bizbultest/widgets/PhotoFilters/filter.dart';
import 'package:bizbultest/widgets/PhotoFilters/testinstagramfilter.dart';
import 'package:bizbultest/widgets/PhotoFilters/testinstagramfiltersmultiple.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:photo_manager/photo_manager.dart';
// import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class FeedPostGallery extends StatefulWidget {
  final Function? setNavbar;
  final Function? refresh;

  FeedPostGallery({Key? key, this.setNavbar, this.refresh}) : super(key: key);

  @override
  _FeedPostGalleryState createState() => _FeedPostGalleryState();
}

class AssetsCustom {
  AssetEntity? asset;
  bool selected = false;
  int? selectedNumber = 0;
  int? assetIndex;
  int? indexNumber;
  bool? isCropped = false;
  File? croppedFile;

  AssetsCustom(asset, selected) {
    this.asset = asset;
    this.selected = selected;
  }
}

class _FeedPostGalleryState extends State<FeedPostGallery>
    with AutomaticKeepAliveClientMixin {
  // This will hold all the assets we fetched
  List<AssetsCustom> assets = [];
  final itemKey = GlobalKey();

  void scrollToItem(currentContext) async {
    final contextTest = currentContext;
    await Scrollable.ensureVisible(contextTest);
  }

  @override
  void initState() {
    scrollController2.addListener(() {
      print(
          "scroll =${scrollController2.positions.first} ${scrollController2.position}");
      if (scrollController2.positions.first.userScrollDirection
                  .toString()
                  .trim() ==
              'ScrollDirection.reverse' &&
          scrollController2.offset >= 300.0) {
        print("scroll =============Rev");
        scrollController.animateTo(30.0.h,
            duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      }
      if (scrollController2.offset == 0.0) {
        print("scroll =entered here ");
        scrollController.jumpTo(0.0);
      }
    });
    scrollController.addListener(() {
      print("scroll =scrool2== ${scrollController.offset}");
    });

    _fetchAssets();

    super.initState();
  }

  i.File? _video;
  var extension;
  String path = "";
  String type = "";
  bool crop = true;

  List<Uint8List> thumbsList = [];

  void _generateThumbnail(File? file) async {
    // thumbsList = [];
    print("generating");
    Uint8List? unit8list;
    unit8list = await VideoThumbnail.thumbnailData(
      video: file!.path,
      imageFormat: ImageFormat
          .JPEG, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 50,
    );
    thumbsList.add(unit8list!);
  }

  // final imgCropKey = GlobalKey<ImgCropState>();

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.all);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    List<AssetsCustom> data = [];
    recentAssets.forEach((element) {
      if (element.type.toString() == "AssetType.video" ||
          element.type.toString() == "AssetType.image") {
        data.add(AssetsCustom(element, false));
      }
    });

    // Update the state and notify UI
    setState(() => assets = data);

    var file = await assets[0].asset!.file;
    var fileType = assets[0].asset!.type.toString();
    if (fileType == "AssetType.video") {
      setState(() {
        type = "video";
      });
      setState(() {
        flickManager = new FlickManager(
          autoInitialize: true,
          autoPlay: true,
          videoPlayerController: VideoPlayerController.file(file!)
            ..setLooping(true),
        );
        isDisposed = false;
      });
      setState(() {
        currentFile = file!;
      });
    } else {
      setState(() {
        type = "image";
        currentFile = file;
      });
    }
  }

  wr() {
    return Text(
      "you",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
    );
  }
// we (){
//   Html(
//               data: "<p>My normal text <b>with bold part</b> in any place</p>",
//               style: {
//                 "p": Style(
//                     fontSize: FontSize.large,
//                     fontWeight: FontWeight.normal),
//                 "b": Style(
//                   fontWeight: FontWeight.bold,
//                 ),)
// }

  List<File> finalFiles = [];
  bool floating = true;
  bool pinned = false;
  ScrollController scrollController = new ScrollController();
  ScrollController scrollController2 = new ScrollController();
  bool initialized = false;
  List<AssetsCustom>? multiSelectList = [];
  List<AssetsCustom> singleList1 = [];
  List<File> files = [];

  File? currentFile;
  bool isDisposed = true;
  var videoThumb;
  FlickManager? flickManager;
  bool isMultiSelection = false;
  int selectedIndex = 0;
  bool cropvideo = true;
  final cropKey = GlobalKey<CropState>();
// bool cropvideo =true;
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  void dispose() {
    print("disposeeeeeeeeee");
    if (flickManager != null) {
      flickManager!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.setNavbar!(false);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.close,
                      size: 4.0.h,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Text(
                      AppLocalizations.of(
                        "Gallery",
                      ),
                      style: TextStyle(fontSize: 14.0.sp, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (multiSelectList!.isEmpty) {
                        print("dharmik");
                        setState(() {
                          multiSelectList!.add(assets[0]);
                        });
                      }

                      if (multiSelectList!.length > 1) {
                        bool allVideos = false;
                        bool allIamges = false;
                        for (int i = 0; i < multiSelectList!.length; i++) {
                          if (multiSelectList![i].asset!.type.toString() !=
                              "AssetType.video") {
                            allIamges = true;
                          }
                          if (multiSelectList![i].asset!.type.toString() !=
                              "AssetType.image") {
                            allVideos = true;
                          }
                        }
                        print("--------video $allVideos ----image $allIamges");
                        if (allVideos && !allIamges) {
                          Get.dialog(ProcessingDialog(
                            title: AppLocalizations.of(
                              "Processing...",
                            ),
                            heading: AppLocalizations.of(
                              "Please wait",
                            ),
                          ));
                          List<File?> finalFiles1 = [];
                          multiSelectList!.forEach((element) async {
                            _generateThumbnail(await element.asset!.file);
                            finalFiles1.add(await element.asset!.file);
                          });
                          Timer(Duration(seconds: 1), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    // InstagramFiltersMultiple(
                                    //   refresh: widget.refresh,
                                    //   fileList: multiSelectList,
                                    //   crop: true,
                                    // files: multiSelectList[i].asset.file,
                                    // )

                                    UploadPost(
                                  thumbs: thumbsList,
                                  isSingleVideoFromStory: false,
                                  clear: () {
                                    setState(() {
                                      finalFiles.clear();
                                    });
                                  },
                                  crop: crop ? 1 : 0,
                                  hasVideo: 1,
                                  from: 'direct',
                                  refresh: widget.refresh!,
                                  finalFiles: finalFiles1,
                                  height: 0,
                                  width: 0,
                                  videoHeight: flickManager!.flickVideoManager!
                                      .videoPlayerController!.value.size.height
                                      .toInt(),
                                  videoWidth: flickManager!.flickVideoManager!
                                      .videoPlayerController!.value.size.height
                                      .toInt(),
                                ),
                              ),
                            );
                          });
                          Get.back();
                        }
                        if (allIamges && !allVideos) {
                          Get.dialog(ProcessingDialog(
                            title: AppLocalizations.of(
                              "Processing...",
                            ),
                            heading: AppLocalizations.of(
                              "Please wait",
                            ),
                          ));
                          // List<File> finalFiles = [];
                          // multiSelectList.forEach((element) async {
                          //   _generateThumbnail(await element.asset.file);
                          //   finalFiles.add(await element.asset.file);
                          // });
                          Timer(Duration(seconds: 1), () {
Get.back();
Get.to(()=>EditMultipleFiles(
                                          refresh: widget.refresh,
                                          fileList: multiSelectList,
                                          crop: crop ? true : false,
                                          thumbs: thumbsList,
                                        ));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             // InstagramFiltersMultiple(
                            //             //   refresh: widget.refresh,
                            //             //   fileList: multiSelectList,
                            //             //   crop: true,
                            //             // files: multiSelectList[i].asset.file,
                            //             // )

                            //             EditMultipleFiles(
                            //               refresh: widget.refresh,
                            //               fileList: multiSelectList,
                            //               crop: crop ? true : false,
                            //               thumbs: thumbsList,
                            //             )));
                            
                          });
                        }
                        if (allIamges && allVideos) {
                          // else {
                          //   errorDialog(context,
                          //       "You can’t upload multiple item when you select video , only 1 video or muliple images are allow to upload");
                          // }
                          List<File?> finalFiles = [];
                          multiSelectList!.forEach((element) async {
                            _generateThumbnail(await element.asset!.file);
                            finalFiles.add(await element.asset!.file);
                          });
                          Timer(Duration(seconds: 1), () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditMultipleFiles(
                                        refresh: widget.refresh,
                                        fileList: multiSelectList,
                                        crop: crop ? true : false,
                                        thumbs: thumbsList,
                                        // files: [rotatedImage],
                                        // )/
                                        // UploadPost(
                                        //   thumbs: thumbsList,
                                        //   unit8list: thumbsList[0],
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
                                        // UploadPost(
                                        // thumbs: thumbsList,
                                        // isSingleVideoFromStory: false,
                                        // clear: () {
                                        //   setState(() {
                                        //     finalFiles.clear();
                                        //   });
                                        // },
                                        // crop: crop ? 1 : 0,
                                        // from: 'editor',
                                        // refresh: widget.refresh,
                                        // finalFiles: finalFiles,
                                        // height: 0,
                                        // width: 0,
                                        // videoHeight: flickManager.flickVideoManager
                                        //     .videoPlayerController.value.size.height
                                        //     .toInt(),
                                        // videoWidth: flickManager.flickVideoManager
                                        //     .videoPlayerController.value.size.height
                                        //     .toInt(),
                                        // ),
                                        // InstagramFiltersMultiple(
                                        //   refresh: widget.refresh,
                                        //   fileList: multiSelectList,
                                        //   crop: crop ? true : false,
                                      )),
                            );
                          });
                        }
                      } else {
                        if (multiSelectList![0].asset!.type.toString() ==
                            "AssetType.video") {
                          // SchedulerBinding.instance
                          //     .addPostFrameCallback((_) async {
                          Get.dialog(ProcessingDialog(
                            title: AppLocalizations.of(
                              "Processing your video...",
                            ),
                            heading: AppLocalizations.of(
                              "Please wait",
                            ),
                          ));
                          var video = await multiSelectList![0].asset!.file;
                          List<File> finalFiles = [];
                          finalFiles.add(video!);
                          Uint8List? unit8list;
                          unit8list = await VideoThumbnail.thumbnailData(
                            video: video.path,
                            imageFormat: ImageFormat.JPEG,
                            // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                            quality: 50,
                          );

                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedPostVideoEditor(
                                        from: "editor",
                                        refresh: widget.refresh,
                                        file: singleVideo,
                                      )));*/
                          Timer(Duration(seconds: 1), () async {
                            print(
                                "${flickManager!.flickVideoManager!.videoPlayerController!.value}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // InstagramSingleVideoFilter(
                                      //   crop: false,
                                      //   refresh: widget.refresh,
                                      //   filePath: video,
                                      //   flip: false,
                                      //   from: "editor",
                                      //   heightV: flickManager
                                      //       .flickVideoManager
                                      //       .videoPlayerController
                                      //       .value
                                      //       .size
                                      //       .height
                                      //       .toInt(),
                                      //   widthV: flickManager
                                      //       .flickVideoManager
                                      //       .videoPlayerController
                                      //       .value
                                      //       .size
                                      //       .height
                                      //       .toInt(),
                                      //   unitList: unit8list,
                                      // )
                                      UploadPost(
                                    thumbs: [unit8list!],
                                    isSingleVideoFromStory: false,
                                    unit8list: unit8list,
                                    crop: 1,
                                    hasVideo: 1,
                                    from: 'editor',
                                    refresh: widget.refresh!,
                                    finalFiles: finalFiles,
                                    clear: () {
                                      setState(() {
                                        finalFiles.clear();
                                      });
                                    },
                                    height: 0,
                                    width: 0,
                                    videoHeight: flickManager!
                                        .flickVideoManager!
                                        .videoPlayerController!
                                        .value!
                                        .size
                                        .height
                                        .toInt(),
                                    videoWidth: flickManager!
                                        .flickVideoManager!
                                        .videoPlayerController!
                                        .value
                                        .size
                                        .height
                                        .toInt(),
                                  ),
                                ));
                            Get.back();
                          });
                          // });
                        } else {
                          Get.dialog(ProcessingDialog(
                            title: AppLocalizations.of(
                              "Processing your photo...",
                            ),
                            heading: AppLocalizations.of(
                              "Please wait",
                            ),
                          ));
                          final _dir = await p.getTemporaryDirectory();
                          File imageCopied = await currentFile!.copy(
                              "${_dir.path}/${basename(currentFile!.path)}");
                          print(imageCopied.path.toString());
                          File rotatedImage =
                              await FlutterExifRotation.rotateImage(
                                  path: imageCopied.path);
                          print(
                              "image selected=${imageCopied.path}, singlelist ${singleList1}");
                          Timer(Duration(seconds: 1), () async {
                            if (singleList1.length == 0) {
                              singleList1 = [assets[0]];
                           
                            }


                            Get.back();
                            Get.to(()=>EditMultipleFiles(
                                          refresh: widget.refresh,
                                          fileList: singleList1,
                                          crop: crop ? true : false,

                                          // thumbs: thumbsList,
                                          // files: [rotatedImage],
                                        ));
                         
                            
                          });
                        }
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 4.0.w, top: 10, bottom: 10),
                        child: Icon(
                          Icons.check,
                          size: 4.0.h,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            widget.setNavbar!(false);
            Navigator.pop(context);
            return true;
          },
          child: NestedScrollView(
            controller: scrollController,
            dragStartBehavior: DragStartBehavior.start,
            floatHeaderSlivers: true,
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.grey.withOpacity(.8),
                  floating: true,
                  snap: true,
                  expandedHeight: 45.0.h,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: currentFile == null
                        ? Container(
                            color: Colors.transparent,
                          )
                        : Container(
                            child: Stack(
                            children: [
                              type == "" || type == "image"
                                  ? Container(
                                      width: 100.0.w,
                                      height: 45.0.h,
                                      child: !crop
                                          ? Image.file(
                                              currentFile!,
                                              fit: BoxFit.contain,
                                            )
                                          : Image.file(currentFile!,
                                              fit: BoxFit.cover)
                                      //  ImgCrop(
                                      //     handleSize: 1,
                                      //     key: imgCropKey,
                                      //     chipRadius: 26.0.h,
                                      //     // crop area radius
                                      //     chipShape: ChipShape.rect,
                                      //     // crop type "circle" or "rect"
                                      //     image: FileImage(currentFile), // you selected image file
                                      //   ),
                                      )
                                  : InkWell(
                                      onTap: () {
                                        print(
                                            'flickr status=${flickManager!.flickVideoManager!.isPlaying} ${CurrentUser().currentUser.isPlaying}');
                                        if (flickManager!
                                                .flickVideoManager!.isPlaying ==
                                            true) {
                                          setState(() {
                                            CurrentUser()
                                                .currentUser
                                                .isPlaying = false;
                                            flickManager!.flickVideoManager!
                                                .videoPlayerController!
                                              ..pause()
                                              ..setLooping(true);
                                          });
                                        }
                                      },
                                      child: Container(
                                          color: Colors.transparent,
                                          width: 100.0.w,
                                          height: 45.0.h,
                                          child: !isDisposed
                                              ? Stack(
                                                  children: [
                                                    VisibilityDetector(
                                                      key: ObjectKey(
                                                          flickManager),
                                                      onVisibilityChanged:
                                                          (visibility) {
                                                        if (visibility
                                                                .visibleFraction <
                                                            0.8) {
                                                          flickManager!
                                                              .flickVideoManager!
                                                              .videoPlayerController!
                                                            ..pause()
                                                            ..setLooping(true);
                                                        } else {
                                                          flickManager!
                                                              .flickVideoManager!
                                                              .videoPlayerController!
                                                            ..play()
                                                            ..setLooping(true);
                                                        }
                                                      },
                                                      child:

                                                          // Container(
                                                          //   height: 50.0.h,
                                                          //   width: 90.0.w,
                                                          //   color: Colors.pink,
                                                          //   child:
                                                          //       BuzzerfeedVideoPlayer(
                                                          //           url: currentFile
                                                          //               .path),
                                                          // )
                                                          Container(
                                                              child: !cropvideo
                                                                  ? FlickVideoPlayer(
                                                                      wakelockEnabled:
                                                                          false,
                                                                      wakelockEnabledFullscreen:
                                                                          false,
                                                                      flickManager:
                                                                          flickManager!,
                                                                      flickVideoWithControls:
                                                                          FlickVideoWithControls(
                                                                        videoFit:
                                                                            BoxFit.contain,
                                                                        playerLoadingFallback:
                                                                            Center(
                                                                                child: Container(
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                      ),
                                                                    )
                                                                  : FlickVideoPlayer(
                                                                      wakelockEnabled:
                                                                          false,
                                                                      wakelockEnabledFullscreen:
                                                                          false,
                                                                      flickManager:
                                                                          flickManager!,
                                                                      flickVideoWithControls:
                                                                          FlickVideoWithControls(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        videoFit:
                                                                            BoxFit.contain,
                                                                        playerLoadingFallback:
                                                                            Center(
                                                                                child: Container(
                                                                          color:
                                                                              Colors.transparent,
                                                                        )),
                                                                      ),
                                                                    )

                                                              // :FlickVideoPlayer(
                                                              //   wakelockEnabled:
                                                              //       false,
                                                              //   wakelockEnabledFullscreen:
                                                              //       false,
                                                              //   flickManager:
                                                              //       flickManager,
                                                              //   flickVideoWithControls:
                                                              //       FlickVideoWithControls(
                                                              //     backgroundColor:
                                                              //         Colors.white,
                                                              //     videoFit:
                                                              //         BoxFit.cover,
                                                              //     playerLoadingFallback:
                                                              //         Center(
                                                              //             child:
                                                              //                 Container(
                                                              //       color: Colors
                                                              //           .white,
                                                              //     )),
                                                              //   ),
                                                              // ),
                                                              ),
                                                    ),
                                                    CurrentUser()
                                                                .currentUser
                                                                .isPlaying ==
                                                            false
                                                        ? Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  size: 8.0.h,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    CurrentUser()
                                                                        .currentUser
                                                                        .isPlaying = true;
                                                                    //flickManager.flickDisplayManager.obs;
                                                                  });
                                                                  flickManager!
                                                                      .flickVideoManager!
                                                                      .videoPlayerController!
                                                                    ..play()
                                                                    ..setLooping(
                                                                        true);
                                                                }),
                                                          )
                                                        : Container()
                                                  ],
                                                )
                                              : Container()),
                                    ),
                              Positioned.fill(
                                bottom: 2.0.h,
                                right: 2.0.h,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      multiSelectList!.forEach((element) {
                                        setState(() {
                                          assets[element.assetIndex!].selected =
                                              false;
                                        });
                                      });
                                      if (isMultiSelection) {
                                        setState(() {
                                          isMultiSelection = !isMultiSelection;
                                          multiSelectList = [
                                            assets[selectedIndex]
                                          ];
                                          multiSelectList![0].assetIndex =
                                              selectedIndex;
                                          assets[selectedIndex].indexNumber = 1;
                                        });
                                      } else {
                                        setState(() {
                                          isMultiSelection = !isMultiSelection;
                                          assets[selectedIndex].selected = true;
                                          multiSelectList = [
                                            assets[selectedIndex]
                                          ];
                                          multiSelectList![0].assetIndex =
                                              selectedIndex;
                                          assets[selectedIndex].indexNumber = 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                        child: CircleAvatar(
                                      backgroundColor: !isMultiSelection
                                          ? Colors.black38
                                          : Colors.blue,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 1.0.w,
                                              top: 0.5.h,
                                              bottom: 1.0.h,
                                              right: 2.0.w),
                                          child: Stack(
                                            children: [
                                              Icon(
                                                Icons.crop_square_sharp,
                                                color: Colors.white,
                                                size: 3.0.h,
                                              ),
                                              Positioned.fill(
                                                top: 1.0.w,
                                                left: 1.0.w,
                                                child: Icon(
                                                  Icons.crop_square_sharp,
                                                  color: Colors.white,
                                                  size: 3.0.h,
                                                ),
                                              ),
                                            ],
                                          )),
                                    )),
                                  ),
                                ),
                              ),
                              isMultiSelection || type == "video"
                                  ? Positioned.fill(
                                      bottom: 2.0.h,
                                      left: 2.0.h,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              cropvideo = !cropvideo;
                                            });
                                          },
                                          child: Container(
                                              child: CircleAvatar(
                                            backgroundColor: !isMultiSelection
                                                ? Colors.black38
                                                : Colors.blue,
                                            child: Icon(
                                              Icons.unfold_more,
                                              color: Colors.white,
                                              size: 3.0.h,
                                            ),
                                          )),
                                        ),
                                      ),
                                    )
                                  : Positioned.fill(
                                      bottom: 2.0.h,
                                      left: 2.0.h,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              crop = !crop;
                                            });
                                          },
                                          child: Container(
                                              child: CircleAvatar(
                                            backgroundColor: !isMultiSelection
                                                ? Colors.black38
                                                : Colors.blue,
                                            child: Icon(
                                              Icons.unfold_more,
                                              color: Colors.white,
                                              size: 0.0.h,
                                            ),
                                          )),
                                        ),
                                      ),
                                    )
                            ],
                          )),
                  ),
                ),
              ];
            },
            body: Stack(
              children: [
                Container(
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 6,
                    controller: scrollController2,
                    itemCount: assets.length,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: LayoutBuilder(builder: (context, boxcontext) {
                          var child = AssetThumbnail(
                            isMultiOpen: isMultiSelection,
                            onTap: () async {
                              print(
                                  "------scroll height selected --> ${scrollController2.offset}");
                              var prev = scrollController.offset;
                              // scrollController.animateTo(
                              //     scrollController.offset / 9 / 16,
                              //     duration: Duration(milliseconds: 500),
                              //     curve: Curves.decelerate);
                              // scrollController.jumpTo(0.0);
                              // scrollController2
                              //     .jumpTo(scrollController2.offset + 45.0.h);
                              // print(
                              //     "jumped to current off ${scrollController.offset} ${prev / 9 / 16 + prev}");

                              // print("jumped to  final ${scrollController.offset}");
                              print("scroll jump index =${index}");
                              // if (index == 11) {
                              //   scrollToItem();
                              //   return;
                              // }

                              if (scrollController2.offset >= 0.0) {
                                var height =
                                    scrollController.position.maxScrollExtent +
                                        context.size!.height;
                                var newItemCount = (assets.length / 6).round();
                                var value = (index / assets.length) *
                                    scrollController.position.maxScrollExtent;
                                print("scroll jump=${value} index =${index}");

                                print(
                                    "current off of top=${scrollController.offset}  ");
                                print(
                                    "current off of bottom=${scrollController2.offset} ");
                                scrollToItem(context);
                                scrollController.jumpTo(0.0);
                                // scrollController2.animateTo(value,
                                //     duration: Duration(milliseconds: 1200),
                                //     curve: Curves.decelerate);
                                // Timer(Duration(milliseconds: 500), () {
                                //   print(
                                //       "scroll height---> ${scrollController2.offset} index=${index / 3}");
                                //   scrollController2.animateTo(
                                //       // scrollController2.offset +
                                //       //     2.5 * (index / 3).roundToDouble()
                                //       value,
                                //       duration: Duration(milliseconds: 500),
                                //       curve: Curves.easeIn);

                                // });
                              }

                              var file = await assets[index].asset!.file;
                              print('filepath=' + file!.path);
                              if (isMultiSelection) {
                                var file = await assets[index].asset!.file;
                                var thumb =
                                    await assets[index].asset!.thumbnailData;
                                if (assets[index].selected) {
                                  int ind =
                                      multiSelectList!.indexOf(assets[index]);

                                  multiSelectList!.removeAt(ind);
                                } else {
                                  if (multiSelectList!.length < 15) {
                                    multiSelectList!.add(assets[index]);

                                    multiSelectList![
                                            multiSelectList!.length - 1]
                                        .assetIndex = index;
                                  }
                                }
                                int cnt = 0;
                                multiSelectList!.forEach((element) {
                                  cnt++;
                                  setState(() {
                                    assets[element.assetIndex!].indexNumber =
                                        cnt;
                                  });
                                });
                                print(multiSelectList!.length);
                                setState(() {
                                  type = assets[index].asset!.type.toString() ==
                                          "AssetType.video"
                                      ? "video"
                                      : "image";
                                  currentFile = file;
                                  print("new flick=${file!.path}");
                                  videoThumb = thumb;
                                  selectedIndex = index;
                                  assets[index].selected =
                                      !assets[index].selected;
                                });
                                if (assets[index].asset!.type.toString() ==
                                    "AssetType.video") {
                                  setState(() {
                                    isDisposed = true;
                                  });
                                  Timer(Duration(seconds: 1), () {
                                    if (flickManager != null) {
                                      flickManager!.flickVideoManager!
                                          .dispose();
                                    }
                                    setState(() {
                                      print("new flick=${file!.path}");
                                      flickManager = new FlickManager(
                                        autoInitialize: true,
                                        autoPlay: false,
                                        videoPlayerController:
                                            VideoPlayerController.file(file),
                                      );
                                      isDisposed = false;
                                    });
                                  });

                                  // _initVideo(assets[index].asset.file);
                                }
                              } else {
                                var file = await assets[index].asset!.file;
                                var thumb =
                                    await assets[index].asset!.thumbnailData;
                                setState(() {
                                  type = assets[index].asset!.type.toString() ==
                                          "AssetType.video"
                                      ? "video"
                                      : "image";
                                  print("file type=$type");
                                  currentFile = file;

                                  singleList1 = [assets[index]];

                                  //_controller.dispose();
                                  selectedIndex = index;
                                  videoThumb = thumb;
                                  multiSelectList = [assets[index]];
                                  multiSelectList![0].assetIndex = index;
                                  multiSelectList![0].indexNumber = 1;
                                });
                                if (assets[index].asset!.type.toString() ==
                                    "AssetType.video") {
                                  // _initVideo(assets[index].asset.file);

                                  setState(() {
                                    multiSelectList = [assets[index]];
                                    multiSelectList![0].assetIndex = index;
                                    multiSelectList![0].indexNumber = 1;
                                    isDisposed = true;
                                  });

                                  Timer(Duration(seconds: 1), () {
                                    if (flickManager != null) {
                                      flickManager!.flickVideoManager!
                                          .dispose();
                                    }
                                    setState(() {
                                      print("new flick=${file!.path}");
                                      flickManager = new FlickManager(
                                        autoInitialize: true,
                                        autoPlay: false,
                                        videoPlayerController:
                                            VideoPlayerController.file(file),
                                      );
                                      isDisposed = false;
                                    });
                                  });
                                }
                              }
                            },
                            extension: extension,
                            asset: assets[index],
                            setNavbar: widget.setNavbar!,
                          );

                          if (index == 11) {
                            return Container(
                              key: itemKey,
                              child: child,
                            );
                          }

                          return child;
                        }),
                      );
                    },
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.count(2, 2);
                    },
                  ),
                ),
                multiSelectList!.length > 14
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          height: 4.0.h,
                          width: 100.0.w,
                          child: Center(
                              child: Text(
                            AppLocalizations.of(
                              "The limit is 15 Photos or Videos",
                            ),
                            style: TextStyle(
                                color: Colors.grey, fontSize: 11.0.sp),
                          )),
                        ),
                      )
                    : Container()
              ],
            ),
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class AssetThumbnail extends StatefulWidget {
  final String? extension;
  final Function? setNavbar;
  final VoidCallback? onTap;
  final bool? isMultiOpen;

  const AssetThumbnail({
    Key? key,
    required this.asset,
    this.setNavbar,
    this.extension,
    this.onTap,
    this.isMultiOpen,
  }) : super(key: key);

  final AssetsCustom asset;

  @override
  _AssetThumbnailState createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
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
      future: future!,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null)
          return Container(
              color: Colors.black,
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))));
        // If there's data, display it as an image
        return InkWell(
          onTap: widget.onTap ?? () {},
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (widget.asset.asset!.type == AssetType.video)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 1.0.w, bottom: 1.0.w),
                    child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.5.w,
                          ),
                          child: Text(
                            widget.asset.asset!.videoDuration
                                .toString()
                                .split('.')
                                .first
                                .padLeft(8, "0"),
                            style: whiteBold.copyWith(fontSize: 10.0.sp),
                          ),
                        )),
                  ),
                ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 1.5.w, top: 1.5.w),
                    child: CircleAvatar(
                      radius: 1.0.h,
                      foregroundColor: Colors.white,
                      backgroundColor: widget.isMultiOpen!
                          ? widget.asset.selected &&
                                  widget.asset.assetIndex != null
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.5)
                          : Colors.transparent,
                      child: widget.isMultiOpen!
                          ? widget.asset.selected &&
                                  widget.asset.assetIndex != null
                              ? Center(
                                  child: Text(
                                      widget.asset.indexNumber.toString(),
                                      style: whiteNormal.copyWith(
                                          fontSize: 8.0.sp)))
                              : Text("")
                          : Text(""),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
