import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as i;
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_category_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_country_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_language_model.dart';
import 'package:bizbultest/models/video_section/upload_custom_thumbnail_video_section_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../widgets/FeedPosts/record_video.dart';
import 'Buzzfeed/buzzfeedplayer.dart';
import 'create_a_shortbuz.dart';

class UploadVideo extends StatefulWidget {
  final Function? setNavbar;
  final Function? refresh;

  UploadVideo({Key? key, this.setNavbar, this.refresh}) : super(key: key);

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  // This will hold all the assets we fetched
  List<AssetEntity> assets = [];

  @override
  void initState() {
    _fetchAssets();
    getDeviceInfo();
    super.initState();
  }

  i.File? _video;
  var extension;

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.version.release} versionnnnnnnnnnnnnnnn');

    if (androidInfo.version.release == "10") {
      setState(() {
        extension = "/storage/emulated/0/";
      });
    } else {
      setState(() {
        extension = "";
      });
    }
  }

  _videoFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
print("dharmik ${result}");
    if (result != null) {
      setState(() {
        _video = i.File(result.files.single.path!);
      });
      print(_video!.path);
      // assets.add(value)
    } else {
    
      // User canceled the picker
    }
  }

/*

  void updateImageProgress() async {
    var request = mp.MultipartRequest();
    request.setUrl("https://www.upload.bebuzee.com/video_upload_api.php?action=upload_long_video");
    request.addFile("file1", _video.path);

    mp.Response response = request.send();

    response.onError = () {
      print("Error");
    };

    response.onComplete = (response) {
      print(response);

      response.progress.listen((int progress) {
        setState(() {});
        print("progress from response object " + progress.toString());
      });
    };
  }

  void uploadImage() async {
    final uri = Uri.parse("https://www.upload.bebuzee.com/video_upload_api.php?action=upload_long_video");
    final req = new http.MultipartRequest("POST", uri);

    final stream = http.ByteStream(Stream.castFrom(_video.openRead()));
    final length = await _video.length();

    final multipartFile = http.MultipartFile(
      'file1',
      stream,
      length,
      filename: p.basename(_video.path),
    );

    req.files.add(multipartFile);

    final res = await req.send();
    await for (var value in res.stream.transform(utf8.decoder)) {
      print(value);
    }

    print(res.statusCode);
    print(res.contentLength);

    print(res);
  }
*/

  _fetchAssets() async {
     print("dharmik ");
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.video);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    List<AssetCustom> data = [];
    recentAssets.forEach((element) {
      if (element.type.toString() == "AssetType.video" ||
          element.type.toString() == "AssetType.image") {
        data.add(AssetCustom(element, false));
      }
    });
    // Update the state and notify UI
    print("dharmik ${recentAssets}");
    if (recentAssets.isNotEmpty) {
      assets.add(AssetEntity(id: "1",   typeInt: 1, width: 1, height: 1));
      for (var element in recentAssets) {
        assets.add(element);
        setState(() {});
      }
      // setState(() => assets = recentAssets);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          brightness: Brightness.dark,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          widget.setNavbar!(false);
          return true;
        },
        child: Visibility(
          replacement: GestureDetector(
                child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              splashColor: Colors.grey.withOpacity(0.3),
                              onTap: () {
                                widget.setNavbar!(false);
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 2.0.h,
                                      left: 2.5.w,
                                      right: 3.0.w,
                                      bottom: 3.0.h),
                                  child: Icon(
                                    Icons.close,
                                    size: 4.0.h,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  // uploadImage();
                                  // _videoFromGallery();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 3.5.h,
                                  child: Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.black,
                                      size: 4.0.h,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              InkWell(
                                onTap: () {
                                  // _videoFromGallery();
                                },
                                child: Text(
                                  "Upload a video",
                                  style:
                                      whiteNormal.copyWith(fontSize: 16.0.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              )
          ,
          visible: assets.isNotEmpty,
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 6,
            itemCount: assets.length,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  child: Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: InkWell(
                                splashColor: Colors.grey.withOpacity(0.3),
                                onTap: () {
                                  widget.setNavbar!(false);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 2.0.h,
                                        left: 2.5.w,
                                        right: 3.0.w,
                                        bottom: 3.0.h),
                                    child: Icon(
                                      Icons.close,
                                      size: 4.0.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // uploadImage();
                                    _videoFromGallery();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 3.5.h,
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.black,
                                        size: 4.0.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    // _videoFromGallery();
                                  },
                                  child: Text(
                                    "Upload a video",
                                    style:
                                        whiteNormal.copyWith(fontSize: 16.0.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                );
             
              } else {
                print("dharmik ${assets[index]}");
                return AssetThumbnail(
                  // refresh: widget.refresh!,
                  // extension: extension,
                  asset: assets[index],
                  //setNavbar: widget.setNavbar!,
                );
              }
            },
            staggeredTileBuilder: (index) {
              if (index == 0) {
                return StaggeredTile.count(6, 4);
              } else {
                return StaggeredTile.count(2, 2);
              }
            },
          ),
        ),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  final String? extension;
  final Function? setNavbar;
  final Function? refresh;

  const AssetThumbnail({
    Key? key,
    required this.asset,
    this.setNavbar,
    this.extension,
    this.refresh,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(ThumbnailSize(640, 480), quality: 60),
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        print("dharmik    ${bytes}");
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
          onTap: () async {
            var file = await asset.file;

            if (asset.type == AssetType.image) {
                    // If this is an image, navigate to ImageScreen
                    Get.to(()=>ImageScreen(
                      imageFile: asset.file!,
                    ))
                     ;
                  } else {  Get.to(()=>VideoScreen(
                      refresh: refresh!,
                      extension: extension!,
                      setNavbar: setNavbar!,
                      videoFile: file!,
                      title: asset.title!,
                      height: asset.height,
                      width: asset.width,
                      path: extension! +
                          p.relative(asset.relativePath!) +
                          p.absolute(asset.title!),
                    ))
                     ;
                    
                  }
             
           
          },
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (asset.type == AssetType.video)
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
                            asset.videoDuration
                                .toString()
                                .split('.')
                                .first
                                .padLeft(8, "0"),
                            style: whiteBold.copyWith(fontSize: 10.0.sp),
                          ),
                        )),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  final Future<File?> imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: FutureBuilder<File?>(
        future: imageFile,
        builder: (_, snapshot) {
          final file = snapshot.data;
          if (file == null) return Container();
          return Column(
            children: [
              Container(height: 50.0.h, child: Image.file(file)),
              Text(
                file.path,
                style: whiteNormal.copyWith(fontSize: 50),
              )
            ],
          );
        },
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String? title;
  final int? height;
  final int? width;
  final String? path;
  final Function? setNavbar;
  final File? file;
  final String? extension;
  final Function? refresh;

  const VideoScreen({
    Key? key,
    required this.videoFile,
    this.title,
    this.height,
    this.width,
    this.path,
    this.setNavbar,
    this.file,
    this.extension,
    this.refresh,
  }) : super(key: key);

  final File videoFile;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool initialized = false;
  var selectedCategory = "";
  var selectedCountry = "";
  var selectedLanguage = "";
  var selectedCountryID = "";
  var selectedLanguageID = "";
  TextEditingController _tagsController = TextEditingController();
  List tagsList = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late ShortbuzzCategoryModel categoriesList;
  var dummycategoriesList = <ShortbuzzCategoryModel>[].obs;
  var categoryText = TextEditingController();
  bool areCategoriesLoaded = false;
  late ShortbuzzCountryModel countriesList;
  bool areCountriesLoaded = false;
  late ShortbuzzLanguageModel languagesList;
  bool areLanguagesLoaded = false;
  var thumbnail;
  int uploadProgress = 0;
  String thumb1 = "";
  String thumb2 = "";
  String thumb3 = "";
  String customThumb = "";
  late String videoUrl;
  late String selectedThumb = "";
  late i.File _thumbnail;
  var extension;

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.version.release} versionnnnnnnnnnnnnnnn');

    if (androidInfo.version.release == "10") {
      setState(() {
        extension = "/storage/emulated/0/";
      });
    } else {
      setState(() {
        extension = "";
      });
    }
  }

  //! api updated
  void uploadThumbnail() async {
    var client = new dio.Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    dio.FormData formData = new dio.FormData.fromMap({
      "file1": await dio.MultipartFile.fromFile(_thumbnail.path),
    });
    var res = await client.post(
        "https://www.bebuzee.com/api/create_custom_thumb.php?action=create_custom_thumb_net&file1=aaa",
        data: formData, onSendProgress: (int sent, int total) {
      final progress = (sent / total) * 100;
      print('progress: $progress');
    }, options: dio.Options(headers: head));

    //Logger().e("upload response" + res.data);

    setState(() {
      customThumb = jsonDecode(res.toString())['message'];
    });
  }

  //! api updated
  Future<void> saveResolution(String urls) async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var url =
        "https://www.bebuzee.com/api/videos_to_other_ratio_save.php?action=save_videos_to_other_ratio&user_id=${CurrentUser().currentUser.memberID}&video_height=${_controller.value.size.height.toInt()}&video_url=$urls&video_width=${_controller.value.size.width.toInt()}";
    var client = new dio.Dio();
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    if (response.statusCode == 200) {
      print(response.data);
    }

    /** response
     * {
  "success": 1,
  "status": 201,
  "message": "Thumb Created.",
  "response": "suceess",
  "vtt": "https://www.bebuzee.com/new_files/sprit/sprite_sdf.vtt",
  "vtt_png": "https://www.bebuzee.com/new_files/sprit/sprite_sdf.png",
  "video": "sdf",
  "gif": "https://www.bebuzee.com/new_files/video_gif/sdf.gif",
  "video_1080": "",
  "video_720": "",
  "video_480": "",
  "video_360": "",
  "video_240": "",
  "video_144": "",
  "video_1080_reso": "",
  "video_720_reso": "",
  "video_360_reso": "",
  "video_240_reso": "",
  "video_144_reso": ""
}
     * 
     */
  }

  List<dynamic> removeHashVidTags(List<dynamic> lstofvidtag) {
    for (int i = 0; i < lstofvidtag.length; i++) {
      lstofvidtag[i] = lstofvidtag[i].replaceAll('#', '@');
    }
    return lstofvidtag;
  }

  void removeHashFromDescription() {
    _descriptionController.text =
        _descriptionController.text.replaceAll('#', '~');
  }

  //! api updated
  Future<void> finalizeVideo() async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("token: $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var client = new dio.Dio();

    selectedCategory = selectedCategory.replaceFirst('&', '@');
    tagsList = removeHashVidTags(tagsList);
    print("video upload selectedCategory=${selectedCategory}");
    var url =
        "https://www.bebuzee.com/api/upload_video.php?action=video_post_data_call&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&video=$videoUrl&thumb_name=$selectedThumb&category=$selectedCategory&title_data=${_titleController.text}&video_country=$selectedCountryID&description=${_descriptionController.text}&vid_tags=${tagsList.join(",")}&language=$selectedLanguageID&video_height=${_controller.value.size.height.toInt()}&video_width=${_controller.value.size.width.toInt()}";

    print("video upload $url");
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );
    print("video upload response ${response.data}");
    Logger().e("video upload response: ${response.data}");

    /**
     * 
     * {
     * "success": 1,
     * "status": 201,
     * "message": "Video Uploaded.",
     "video": "dsafa",
     "post_id": "228817"
      }
     * 
     */
  }

  Future<void> publishVideo() async {
    var feedController = Get.put(FeedController());
    showDialog(
        context: context,
        builder: (BuildContext processingContext) {
          finalizeVideo().then((value) {
            Timer(Duration(seconds: 1), () {
              Navigator.pop(processingContext);
              Navigator.of(context).popUntil((route) => route.isFirst);
              widget.setNavbar!(false);
              feedController.refreshFeeds.updateRefresh(true);
              feedController.refreshProfile.updateRefresh(true);
            });
          });
          return ProcessingDialog(
            title: "Publishing your video...",
            heading: "",
          );
        });
  }

  void thumbFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _thumbnail = i.File(result.files.single.path!);
      });
      uploadThumbnail();
    } else {
      // User canceled the picker
    }
  }

  Future<void> uploadCustomThumbnail(String url) async {}

  //! api updated
  void uploadVideo() async {
    // Logger().e("upload video");

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    //print("token: $token");

    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    var client = new dio.Dio();
    dio.FormData formData = new dio.FormData.fromMap({
      "file1": await dio.MultipartFile.fromFile(widget.videoFile.path),
    });

    var res = await client.post(
      "https://www.bebuzee.com/api/upload_long_video.php?action=upload_long_video",
      data: formData,
      options: Options(
        headers: head,
      ),
      onSendProgress: (int sent, int total) {
        final progress = sent / total;
        print("progress ${(progress * 100).toInt()}");
        setState(() {
          uploadProgress = (progress * 100).toInt();
        });
      },
    );

    // Logger().e("response : $res");

    //print(res.toString());
    print("video response ${res.data}");

    UploadCustomThumbnailVideoSectionModel _customThumbnail =
        UploadCustomThumbnailVideoSectionModel.fromJson(res.data);

    saveResolution(_customThumbnail.data!.video!);

    setState(() {
      uploadProgress = 100;
      thumb1 = _customThumbnail.data!.imageOne!;
      thumb2 = _customThumbnail.data!.imageTwo!;
      thumb3 = _customThumbnail.data!.imageThree!;
      videoUrl = _customThumbnail.data!.video!;
    });
  }

  //! api updated
  Future<void> getCategories() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/video_category.php?action=video_category_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      ShortbuzzCategoryModel categoriesData =
          ShortbuzzCategoryModel.fromJson(jsonDecode(response.body));
      // await Future.wait(videoData.videos.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        setState(() {
          // dummycategoriesList = categoriesData;
          categoriesList = categoriesData;
          areCategoriesLoaded = true;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areCategoriesLoaded = false;
        });
      }
    }
  }

  //! api updated
  Future<void> getCountryList() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/localized_countries.php?action=video_country_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      ShortbuzzCountryModel countryData =
          ShortbuzzCountryModel.fromJson(jsonDecode(response.body));
      // await Future.wait(videoData.videos.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        setState(() {
          countriesList = countryData;
          areCountriesLoaded = true;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areCountriesLoaded = false;
        });
      }
    }
  }

  //! api updated
  Future<void> getLanguageList() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/video_language.php?action=video_language_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      ShortbuzzLanguageModel languageData =
          ShortbuzzLanguageModel.fromJson(jsonDecode(response.body));
      // await Future.wait(videoData.videos.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        setState(() {
          languagesList = languageData;
          areLanguagesLoaded = true;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areLanguagesLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    //print(p.basename(widget.path));
    //print(p.basename(widget.videoFile.toString()));

    getDeviceInfo();

    print(widget.videoFile.path + " paaaaaaaaath");
    uploadVideo();

    if (widget.title != null) {
      setState(() {
        _titleController.text = widget.title!;
      });
    }
    _initVideo();
    getCategories();
    getCountryList();
    getLanguageList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _initVideo() async {
    final video = widget.videoFile;
    print("the video filel=${widget.videoFile}");
    _controller = VideoPlayerController.file(video)
      // Play the video again when it ends
      ..setLooping(true)
      // initialize the controller and notify UI when done
      ..initialize().then((_) => setState(() => initialized = true));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialized
          // If the video is initialized, display it
          ? Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                brightness: Brightness.dark,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.grey.withOpacity(0.3),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_backspace,
                              size: 4.0.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 6.0.w,
                            ),
                            Text(
                              AppLocalizations.of(
                                "Enter details",
                              ),
                              style: whiteBold.copyWith(fontSize: 16.0.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (selectedThumb == "") {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(blackSnackBar(
                                AppLocalizations.of(
                                  "Select a thumbnail",
                                ),
                              ));
                            } else if (_titleController.text.isEmpty) {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(blackSnackBar(
                                AppLocalizations.of(
                                  'Please enter a title',
                                ),
                              ));
                            } else if (selectedCategory == "") {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(blackSnackBar(
                                AppLocalizations.of(
                                  'Please select a category',
                                ),
                              ));
                            } else if (selectedCountry == "") {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(blackSnackBar(
                                AppLocalizations.of(
                                  'Please select a country',
                                ),
                              ));
                            } else {
                              publishVideo();
                            }
                          },
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.w, vertical: 1.0.h),
                              child: Text(
                                AppLocalizations.of(
                                  "Publish",
                                ),
                                style: TextStyle(
                                    fontSize: 12.0.sp, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey[900],
              ),
              backgroundColor: Colors.grey[900],
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: SamplePlayer(
                        url: widget.videoFile,
                      ),
                    ),
                    // AspectRatio(
                    //   aspectRatio: _controller.value.aspectRatio,
                    //   // Use the VideoPlayer widget to display the video.
                    //   child: VideoPlayer(_controller),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.0.w, vertical: 2.0.h),
                      child: Text(
                        uploadProgress < 100
                            ? AppLocalizations.of("Processing")
                            : AppLocalizations.of(
                                "Processing Done!",
                              ),
                        style:
                            TextStyle(fontSize: 12.0.sp, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0.0.h, left: 1.0.w, right: 1.0.w),
                      child: new LinearPercentIndicator(
                        backgroundColor: Colors.white.withOpacity(0.5),
                        //width: 90.0.w,
                        animation: false,
                        lineHeight: 2.5.h,
                        animationDuration: 2500,
                        percent: uploadProgress / 100,
                        center: Text(
                          uploadProgress.toString() + "%",
                          style: TextStyle(fontSize: 12.0.sp),
                        ),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Colors.white,
                      ),
                    ),
                    thumb1 != "" && thumb2 != "" && thumb3 != ""
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0.w, vertical: 2.0.h),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0.h),
                                  child: Text(
                                    AppLocalizations.of(
                                      "Select a thumbnail",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 14.0.sp),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedThumb = thumb1;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.5.w, vertical: 0.2.h),
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          shape: BoxShape.rectangle,
                                          border: new Border.all(
                                            color: selectedThumb == thumb1
                                                ? Colors.white
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                        height: 10.0.h,
                                        width: 28.0.w,
                                        child: Image.network(
                                          thumb1,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedThumb = thumb2;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.5.w, vertical: 0.2.h),
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          shape: BoxShape.rectangle,
                                          border: new Border.all(
                                            color: selectedThumb == thumb2
                                                ? Colors.white
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                        height: 10.0.h,
                                        width: 28.0.w,
                                        child: Image.network(
                                          thumb2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedThumb = thumb3;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.5.w, vertical: 0.2.h),
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          shape: BoxShape.rectangle,
                                          border: new Border.all(
                                            color: selectedThumb == thumb3
                                                ? Colors.white
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                        height: 10.0.h,
                                        width: 28.0.w,
                                        child: Image.network(
                                          thumb3,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: Text(
                                    AppLocalizations.of(
                                      "or",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 14.0.sp),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: InkWell(
                                    onTap: () {
                                      thumbFromGallery();
                                    },
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        shape: BoxShape.rectangle,
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0.w, vertical: 1.0.h),
                                        child: Text(
                                          AppLocalizations.of(
                                            "Add a custom thumbnail",
                                          ),
                                          style: whiteNormal.copyWith(
                                              fontSize: 14.0.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                customThumb != null && customThumb != ""
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 2.0.h),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedThumb = customThumb;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0.5.w,
                                                vertical: 0.2.h),
                                            decoration: new BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              shape: BoxShape.rectangle,
                                              border: new Border.all(
                                                color:
                                                    selectedThumb == customThumb
                                                        ? Colors.white
                                                        : Colors.transparent,
                                                width: 1.5,
                                              ),
                                            ),
                                            height: 10.0.h,
                                            width: 28.0.w,
                                            child: Image.network(
                                              customThumb,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h),
                            child: Text(
                              AppLocalizations.of(
                                "Title",
                              ),
                              style: whiteNormal.copyWith(fontSize: 12.0.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Container(
                              height: 5.0.h,
                              child: TextFormField(
                                onChanged: (val) {},
                                maxLines: 1,
                                controller: _titleController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.grey),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: AppLocalizations.of(
                                    "Title",
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0.sp),
                                  contentPadding: EdgeInsets.only(left: 2.0.w),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0))),
                                    //isScrollControlled:true,
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.0.w)),
                                          child: Column(
                                            children: [
                                              // Container(
                                              //   decoration: BoxDecoration(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               3.0.w)),
                                              //   height: 5.0.h,
                                              //   width: 100.0.w,
                                              //   child: TextField(
                                              //     onChanged: (value) {
                                              //       print(
                                              //           'search category=$value');
                                              //       ShortbuzzCategoryModel
                                              //           tstcat = categoriesList;
                                              //       // dummycategoriesList.value=

                                              //       tstcat.category =
                                              //           categoriesList.category
                                              //               .where((element) {
                                              //         print(
                                              //             "searcha category=${element.cateName.toLowerCase()}contains ${categoryText.text.toString().toLowerCase()}  ${element.cateName.toLowerCase.toString().contains(categoryText.text.toString().toLowerCase())}");
                                              //         return element
                                              //             .cateName.toLowerCase
                                              //             .toString()
                                              //             .contains(categoryText
                                              //                 .text
                                              //                 .toString()
                                              //                 .toLowerCase());
                                              //       }).toList();
                                              //       dummycategoriesList.value =
                                              //           [tstcat];
                                              //       dummycategoriesList
                                              //           .refresh();
                                              //       print(
                                              //           "search category=${dummycategoriesList}");
                                              //     },
                                              //     decoration: InputDecoration(
                                              //         fillColor: Colors.white,
                                              //         focusColor: Colors.white,
                                              //         icon: Icon(
                                              //           Icons.search,
                                              //           color: Colors.grey,
                                              //         )),
                                              //     controller: categoryText,
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Container(
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: categoryText
                                                                  .text ==
                                                              ''
                                                          ? categoriesList
                                                              .category!.length
                                                          : dummycategoriesList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var category = categoryText
                                                                    .text !=
                                                                ''
                                                            ? dummycategoriesList[
                                                                        0]
                                                                    .category![
                                                                index]
                                                            : categoriesList
                                                                    .category![
                                                                index];
                                                        // var category =
                                                        //     categoriesList
                                                        //             .category[
                                                        //         index];
                                                        if (dummycategoriesList
                                                                .length !=
                                                            0)
                                                          return Container(
                                                              child: ListTile(
                                                            title: Text(
                                                                dummycategoriesList[
                                                                        0]
                                                                    .category![
                                                                        index]
                                                                    .cateName
                                                                    .toString()),
                                                          ));
                                                        return Container(
                                                          child: ListTile(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                selectedCategory =
                                                                    category
                                                                        .cateName!;
                                                              });
                                                            },
                                                            leading:
                                                                selectedCategory ==
                                                                        category
                                                                            .cateName
                                                                    ? Icon(
                                                                        Icons
                                                                            .check,
                                                                        size: 3.0
                                                                            .h,
                                                                        color: Colors
                                                                            .white,
                                                                      )
                                                                    : Container(
                                                                        height:
                                                                            0,
                                                                        width:
                                                                            0,
                                                                      ),
                                                            title: Text(
                                                              category
                                                                  .cateName!,
                                                              style: whiteNormal
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12.0.sp),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              )
                                            ],
                                          ));
                                    });
                              },
                              splashColor: Colors.grey.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      "Select Video Category",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 12.0.sp),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 3.0.h,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          selectedCategory != ""
                              ? Padding(
                                  padding: EdgeInsets.only(top: 0.5.h),
                                  child: Container(
                                    child: Text(
                                      selectedCategory,
                                      style: whiteNormal.copyWith(
                                          fontSize: 10.0.sp),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0))),
                                    //isScrollControlled:true,
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return Container(
                                        child: ListView.builder(
                                            itemCount:
                                                countriesList.country!.length,
                                            itemBuilder: (context, index) {
                                              var country =
                                                  countriesList.country![index];
                                              return Container(
                                                child: ListTile(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      selectedCountry =
                                                          country.countryName!;
                                                      selectedCountryID =
                                                          country.id!;
                                                    });
                                                  },
                                                  leading: selectedCountry ==
                                                          country.countryName
                                                      ? Icon(
                                                          Icons.check,
                                                          size: 3.0.h,
                                                          color: Colors.white,
                                                        )
                                                      : Container(
                                                          height: 0,
                                                          width: 0,
                                                        ),
                                                  title: Text(
                                                    country.countryName!,
                                                    style: whiteNormal.copyWith(
                                                        fontSize: 12.0.sp),
                                                  ),
                                                ),
                                              );
                                            }),
                                      );
                                    });
                              },
                              splashColor: Colors.grey.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      "Select a Country",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 12.0.sp),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 3.0.h,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          selectedCountry != ""
                              ? Padding(
                                  padding: EdgeInsets.only(top: 0.5.h),
                                  child: Container(
                                    child: Text(
                                      selectedCountry,
                                      style: whiteNormal.copyWith(
                                          fontSize: 10.0.sp),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0))),
                                    //isScrollControlled:true,
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return Container(
                                        child: ListView.builder(
                                            itemCount:
                                                languagesList.language!.length,
                                            itemBuilder: (context, index) {
                                              var language = languagesList
                                                  .language![index];

                                              return Container(
                                                child: ListTile(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      selectedLanguage =
                                                          language
                                                              .languageName!;
                                                      selectedLanguageID =
                                                          language.id!;
                                                    });
                                                  },
                                                  leading: selectedLanguage ==
                                                          language.languageName
                                                      ? Icon(
                                                          Icons.check,
                                                          size: 3.0.h,
                                                          color: Colors.white,
                                                        )
                                                      : Container(
                                                          height: 0,
                                                          width: 0,
                                                        ),
                                                  title: Text(
                                                    language.languageName!,
                                                    style: whiteNormal.copyWith(
                                                        fontSize: 12.0.sp),
                                                  ),
                                                ),
                                              );
                                            }),
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      "Select a Language",
                                    ),
                                    style:
                                        whiteNormal.copyWith(fontSize: 12.0.sp),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 3.0.h,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          selectedLanguage != ""
                              ? Padding(
                                  padding: EdgeInsets.only(top: 0.5.h),
                                  child: Container(
                                    child: Text(
                                      selectedLanguage,
                                      style: whiteNormal.copyWith(
                                          fontSize: 10.0.sp),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 4.5.h),
                            child: Text(
                              AppLocalizations.of(
                                "Description",
                              ),
                              style: whiteNormal.copyWith(fontSize: 12.0.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Container(
                              child: TextFormField(
                                onChanged: (val) {},
                                maxLines: 5,
                                controller: _descriptionController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.grey),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: AppLocalizations.of(
                                    "Description",
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0.sp),
                                  contentPadding:
                                      EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h),
                            child: Text(
                              AppLocalizations.of("Tags"),
                              style: whiteNormal.copyWith(fontSize: 12.0.sp),
                            ),
                          ),
                          tagsList.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: Container(
                                    height: 3.7.h,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tagsList.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(right: 1.5.w),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  tagsList.removeAt(index);
                                                });
                                              },
                                              splashColor:
                                                  Colors.grey.withOpacity(0.3),
                                              child: Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2.0.w,
                                                      vertical: 1.0.w),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        tagsList[index],
                                                        style: TextStyle(
                                                            fontSize: 12.0.sp),
                                                      ),
                                                      SizedBox(
                                                        width: 0.5.w,
                                                      ),
                                                      Icon(
                                                        Icons.cancel,
                                                        size: 2.5.h,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h, bottom: 3.0.h),
                            child: Container(
                              child: TextFormField(
                                onChanged: (val) {},
                                maxLines: 1,
                                controller: _tagsController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    hintText: AppLocalizations.of(
                                      "Enter tags",
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0.sp),
                                    //contentPadding: EdgeInsets.only(right: 2.0.w,),
                                    suffixIcon: FloatingActionButton(
                                      onPressed: () {
                                        setState(() {
                                          tagsList.add(_tagsController.text
                                              .replaceAll(" ", ""));
                                        });
                                        _tagsController.clear();
                                        print(tagsList.join(","));
                                      },
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.transparent,
                                      child: Text(
                                        AppLocalizations.of("Add"),
                                        style: whiteNormal.copyWith(
                                            fontSize: 10.0.sp),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          /*     Padding(
                            padding: EdgeInsets.only(right: 3.0.w, top: 2.0.h, bottom: 2.0.h),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: RaisedButton(
                                color: Colors.white,
                                focusColor: Colors.white,
                                onPressed: () {
                                  */ /* widget.refreshChannel();
                                  updateVideoDetails();*/ /*
                                  if (selectedThumb == "") {
                                    _scaffoldKey.currentState.showSnackBar(blackSnackBar('Please select a thumbnail'));
                                  }
                                 else if (_titleController.text.isEmpty) {
                                    _scaffoldKey.currentState.showSnackBar(blackSnackBar('Please enter a title'));
                                  } else if (selectedCategory == null) {
                                    _scaffoldKey.currentState.showSnackBar(blackSnackBar('Please select a category'));
                                  } else if (selectedCountry == null) {
                                    _scaffoldKey.currentState.showSnackBar(blackSnackBar('Please select a country'));
                                  } else {
                                    _scaffoldKey.currentState.showSnackBar(blackSnackBar('Publishing'));
                                  }
                                },
                                child: Text(
                                  "Publish",
                                  style: TextStyle(fontSize: 10.0.sp),
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          // If the video is not yet initialized, display a spinner
          : Container(
              color: Colors.grey[900],
            ),
    );
  }
}
