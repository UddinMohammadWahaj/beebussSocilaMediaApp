import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/models/uploaded_files_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/PhotoFiltersAPI/instagramphotofiltercontroller.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:http/http.dart' as http;
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:bizbultest/models/open_street_model.dart';
import 'package:bizbultest/models/place_model.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class UploadPost extends StatefulWidget {
  final List<File?>? finalFiles;
  final List<Uint8List>? thumbs;
  final int? height;
  final int? width;
  final int? videoHeight;
  final int? videoWidth;
  final Function? clear;
  final Function? refresh;
  final String? from;
  final int? crop;
  final int? hasVideo;
  final FileElement? file;
  final bool? isSingleVideoFromStory;
  final Uint8List? unit8list;

  UploadPost(
      {Key? key,
      this.finalFiles,
      this.clear,
      this.height,
      this.width,
      this.refresh,
      this.from,
      this.crop=0,
      this.hasVideo=0,
      this.file,
      this.isSingleVideoFromStory,
      this.unit8list,
      this.videoHeight,
      this.videoWidth,
      this.thumbs})
      : super(key: key);

  @override
  _UploadPostState createState() => _UploadPostState();
}

class Tags {
  double? posx;
  double? posy;
  String? name;
  int? index;
  bool? showClose = false;

  Tags(posx, posy, name, index) {
    this.posx = posx;
    this.posy = posy;
    this.name = name;
    this.index = index;
  }
}

class _UploadPostState extends State<UploadPost> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _userSearchController = TextEditingController();
  TextEditingController _videoUserSearchController = TextEditingController();

  bool addLocation = false;
  bool tagPeople = false;
  bool newPost = true;
  String selectedMainLocation = "";
  String selectedSubLocation = "";
  String destinationLink = "";
  Places? placesList;
  bool hasPlaces = false;
  double posX = 100.0;
  double posY = 100.0;
  bool showUsersList = false;
  OpenStreet? coordinatesList;
  bool areCoordinateLoaded = false;
  List<List<Tags>> tagsList = [];
  List<List<Widget>> stackWidgets = [];
  List<String> mentionedUsersList = [];
  List<String> onTapMentionedUsers = [];
  List<String> videoTagsShortcode = [];
  List<String> videoTagsMemberID = [];
  int feedVideo = 0;
  bool showVideoKeyboard = false;
  String lat = "43.64701";
  String long = "-79.39425";
  UploadedFiles? filesList;
  bool areFilesLoaded = false;
  bool whoseThis = false;
  int videoHeight = 0;
  int videoWidth = 0;
  int crop = 0;
  List<String> imgResponse = [];
  UserTags? tagList;
  UserTags videoTagsList = new UserTags([]);
  bool areTagsLoaded = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _imageCheck() {
    if (widget.finalFiles![0]!.path.endsWith(".png") ||
        widget.finalFiles![0]!.path.endsWith(".jpg") ||
        widget.finalFiles![0]!.path.endsWith(".PNG") ||
        widget.finalFiles![0]!.path.endsWith(".JPG")) {
      return true;
    } else {
      return false;
    }
  }

  _onTapDown(TapDownDetails details, index) {
    var x = details.localPosition.dx;
    var y = details.localPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());
    setState(() {
      posX = x;
      posY = y;
    });
    if (tagsList[index].length == stackWidgets[index].length - 1) {
      setState(() {
        whoseThis = true;
      });
      setState(() {
        stackWidgets[index].add(Positioned(
          left: posX,
          top: posY,
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
              child: Text(
                AppLocalizations.of(
                  "Who's this?",
                ),
                style: TextStyle(color: Colors.white, fontSize: 8.0.sp),
              ),
            ),
          ),
        ));
      });
    } else {
      setState(() {
        whoseThis = true;
      });
      stackWidgets[index][stackWidgets[index].length - 1] = Positioned(
        left: posX,
        top: posY,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
            child: Text(
              AppLocalizations.of(
                "Who's this?",
              ),
              style: TextStyle(color: Colors.white, fontSize: 8.0.sp),
            ),
          ),
        ),
      );
    }
  }

  Future<void> getPlaces(text) async {
    var url =
        "https://www.bebuzee.com/api/other/locationSuggestion?action=location_sugession&keywords=$text";
    print("getplace called");
    var response = await ApiProvider().fireApi(url);

    //print(response.body); https://www.bebuzee.com/api/other/locationSuggestion?action=location_sugession&keywords=$search
    if (response.statusCode == 200) {
      Places placeData = Places.fromJson(response.data['data']);
      if (mounted) {
        setState(() {
          placesList = placeData;
          hasPlaces = true;
        });
      }

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          hasPlaces = false;
        });
      }
    }
  }

  void checkVideos() {
    print(widget.hasVideo.toString());
    setState(() {
      feedVideo = int.parse(widget.hasVideo.toString());

    });
   
  }

  Future<void> uploadMultiplePost(String allTags, String allHashtags) async {
    String url =
        'https://www.bebuzee.com/api/upload/feedPostUpload?user_id=${CurrentUser().currentUser.memberID}&user=${CurrentUser().currentUser.memberID}&all_tagged_id_val=${onTapMentionedUsers.join(",")}&url_data=${destinationLink}&all_tag=$allTags&location=$selectedSubLocation&lat=$lat&lng=$long&all_hastags=$allHashtags&img_width=${widget.width.toString()}&img_height=${widget.height.toString()}&all_mentioned=${mentionedUsersList.join(",")}&video_tagged_people=${videoTagsMemberID.join(",")}&video_tagged_people_string=${videoTagsShortcode.join("~~~")}&cropped=${crop.toString()}&feed_video=$feedVideo&video_height=$videoHeight&video_width=$videoWidth&description=${_controller.text.replaceAll("#", "~~~")}';

    // String url =
    //     "https://www.upload.bebuzee.com/video_upload_api.php?action=upload_feed_post&user_id=${CurrentUser().currentUser.memberID}&user=${CurrentUser().currentUser.memberID}&all_tagged_id_val=${onTapMentionedUsers.join(",")}&url_data=${_linkController.text}&all_tag=$allTags&location=$selectedSubLocation&lat=$lat&lng=$long&all_hastags=$allHashtags&img_width=${widget.width.toString()}&img_height=${widget.height.toString()}&all_mentioned=${mentionedUsersList.join(",")}&video_tagged_people=${videoTagsMemberID.join(",")}&video_tagged_people_string=${videoTagsShortcode.join("~~~")}&cropped=${crop.toString()}&feed_video=$feedVideo&video_height=$videoHeight&video_width=$videoWidth&description=${_controller.text.replaceAll("#", "~~~")}";
    var feedController = Get.put(FeedController());
    print("feedposturl=${url}");
    print("feedpost files =${widget.finalFiles!.length}");
    widget.finalFiles!.forEach((element) {
      print(element!.path.toString() + " thispathtoserver");
    });

    feedController.uploadFeedPost(widget.finalFiles!, url, {});
  }

  Future<void> getCoordinates(text) async {
    var url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?format=json&q=$text");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      OpenStreet coordinatesData =
          OpenStreet.fromJson(jsonDecode(response.body));
      print(coordinatesData.coordinates[0].lat! +
          "  " +
          coordinatesData.coordinates[0].lon!);
      if (mounted) {
        if (coordinatesData.coordinates[0].lat != "" &&
            coordinatesData.coordinates[0].lon != "") {
          setState(() {
            lat = coordinatesData.coordinates[0].lat!;
            long = coordinatesData.coordinates[0].lon!;
          });
        }
        setState(() {
          coordinatesList = coordinatesData;
          areCoordinateLoaded = true;
        });
      }
    }

    if (response.body == null || response.statusCode != 200) {
      setState(() {
        areCoordinateLoaded = false;
      });
    }
  }

  Future<void> getUserTags(String searchedTag) async {
    print("get User tags Called");

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/user/userSearchFollowers?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag');
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await client
        .postUri(
          newurl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);

    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag");

    // var response = await http.get(url);

    // print(response.body);
    if (response.statusCode == 200) {
      print("get user taglist response= ${response.data}");
      UserTags tagsData = UserTags.fromJson(response.data['data']);

      if (mounted) {
        setState(() {
          tagList = tagsData;
          areTagsLoaded = true;
        });
      }
    }

    if (response.data == null || response.statusCode != 200) {
      setState(() {
        areTagsLoaded = false;
      });
    }
  }

  Widget _commonListTile(String text, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      onTap: onTap,
      dense: true,
      title: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _locationListTile() {
    return ListTile(
      trailing: Icon(
        Icons.close,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
      visualDensity: VisualDensity(horizontal: 0, vertical: -3),
      onTap: () {
        setState(() {
          selectedSubLocation = "";
          selectedMainLocation = "";
        });
      },
      dense: true,
      title: Text(
        selectedMainLocation,
        style: TextStyle(fontSize: 16, color: Colors.blue),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        selectedSubLocation,
        style: TextStyle(fontSize: 16, color: Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _destinationBottomSheet() {
    return Container(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _linkController.clear();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(
                        "Destination Website",
                      ),
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      destinationLink = _linkController.text;
                    });
                    _linkController.clear();
                    print(destinationLink);
                    Navigator.pop(context);
                  },
                  child: Container(
                      color: Colors.black,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          AppLocalizations.of("Add"),
                          style: whiteBold.copyWith(fontSize: 15),
                        ),
                      )),
                )
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 1.0.h),
            child: TextFormField(
              onChanged: (val) {},
              maxLines: null,
              controller: _linkController,
              cursorColor: Colors.grey,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black, fontSize: 15),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: AppLocalizations.of(
                  "Destination Link",
                ),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkListTile() {
    return ListTile(
      trailing: Icon(
        Icons.close,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
      visualDensity: VisualDensity(horizontal: 0, vertical: -3),
      onTap: () {
        setState(() {
          destinationLink = "";
        });
      },
      dense: true,
      title: Text(
        AppLocalizations.of(
          "Destination Link",
        ),
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        destinationLink,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void initState() {
    print("objectdharmik1");
    videoHeight = widget.videoHeight??0;
    videoWidth = widget.videoWidth??0;

    checkVideos();
    if (widget.crop != null) {
      setState(() {
        crop = widget.crop!;
      });
    } else {
      setState(() {
        crop = 0;
      });
    }
    print("objectdharmik33 ${widget.finalFiles}");
    // uploadFiles();
    widget.finalFiles!.forEach((element) {
      log("final fileee${element.toString()}");
      setState(() {
        tagsList.add([]);
        stackWidgets.add([
          Image.file(
            element!,
            fit: widget.crop == 1 ? BoxFit.cover : BoxFit.contain,
            height: 50.0.h,
            width: 100.0.w,
          ),
        ]);
      });
    });
        print("objectdharmik44");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              splashRadius: 20,
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.keyboard_backspace,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {
                if (tagPeople) {
                  setState(() {
                    newPost = true;
                    tagPeople = false;
                    //tagsList.clear();
                  });
                } else if (addLocation) {
                  newPost = true;
                  addLocation = false;
                  selectedSubLocation = "";
                  selectedMainLocation = "";
                } else {
                  if (widget.clear != null) {
                    widget.clear!();
                  }
                  Navigator.pop(context);
                }
              }),
          title: Text(
            newPost
                ? AppLocalizations.of("New Post")
                : addLocation
                    ? AppLocalizations.of("Select a location")
                    : AppLocalizations.of(
                        "Tag People",
                      ),
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
          actions: [
            IconButton(
                splashRadius: 20,
                padding: EdgeInsets.symmetric(horizontal: 15),
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.green,
                ),
                onPressed: () {
                  List<String> taggedUsers = [];
                  for (int i = 0; i < tagsList.length; i++) {
                    for (int j = 0; j < tagsList[i].length; j++) {
                      taggedUsers.add("img_response_" +
                          (i + 1).toString() +
                          "^^" +
                          tagsList[i][j].posx!.toStringAsFixed(5) +
                          "^^" +
                          tagsList[i][j].posy!.toStringAsFixed(5) +
                          "^^" +
                          tagsList[i][j].name!);
                    }
                    print(taggedUsers.join("~~~"));
                  }

                  List<String> hashtags = [];
                  _controller.text.split(" ").forEach((element) {
                    if (element.startsWith("#")) {
                      hashtags.add(element);
                      print(hashtags);
                      print(hashtags.join(','));
                    }
                  });
                  if (addLocation || tagPeople) {
                    setState(() {
                      newPost = true;
                      addLocation = false;
                      tagPeople = false;
                    });
                  } else {
                    widget.finalFiles!.forEach((element) {
                      print(element!.path.toString() + " pathnanibia");
                    });

                    Get.delete<InstagramPhotoFilterController>();
                    uploadMultiplePost(taggedUsers.join("~~~"),
                        hashtags.join(',').replaceAll("#", "~~~"));
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                }),
          
          ],
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
      
        body: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: WillPopScope(
            onWillPop: () async {
              if (widget.clear != null) {
                widget.clear!();
              }
              Navigator.pop(context);
              return true;
            },
            child: 
            SingleChildScrollView(
              child: Container(
                child: newPost
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      _imageCheck() == true
                                          ? Image.file(
                                              widget.finalFiles![0]as File,
                                              height: 7.0.h,
                                              width: 15.0.w,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              height: 7.0.h,
                                              width: 15.0.w,
                                              child: widget.from == "editor"
                                                  ? Container(
                                                      color: Colors.white,
                                                      height: 7.0.h,
                                                      width: 15.0.w,
                                                      child: Image.memory(
                                                        widget.unit8list!,
                                                        fit: BoxFit.cover,
                                                      ))
                                                  : Image.memory(
                                                      widget.thumbs![0],
                                                      fit: BoxFit.cover,
                                                    )),
                                      widget.finalFiles!.length > 1
                                          ? Positioned.fill(
                                              top: 0.5.w,
                                              right: 0.5.w,
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Image.asset(
                                                    "assets/images/multiple.png",
                                                    height: 2.0.h,
                                                  )),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2.0.w,
                                  ),
                                  Container(
                                    width: 75.0.w,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        if (val == "") {
                                          setState(() {
                                            mentionedUsersList.clear();
                                          });
                                          print(mentionedUsersList);
                                        }

                                        print(val);
                                        String str = "";
                                        List<String> words = val.split(" ");
                                        if (words[words.length - 1]
                                            .startsWith("@")) {
                                          getUserTags(words[words.length - 1]
                                              .replaceAll("@", ""));
                                        } else {
                                          setState(() {
                                            tagList!.userTags = [];
                                          });
                                        }
                                      },
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      controller: _controller,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        hintText: AppLocalizations.of(
                                          "Description",
                                        ),
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10.0.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            tagList != null &&
                                    tagList!.userTags.length > 0 &&
                                    _controller.text.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.0.w, vertical: 1.5.h),
                                    child: Container(
                                      height: 80.0.h,
                                      child: SingleChildScrollView(
                                        child: Column(
                                            children:
                                                tagList!.userTags.map((s) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 0.8.h),
                                            child: InkWell(
                                              splashColor:
                                                  Colors.grey.withOpacity(0.3),
                                              onTap: () {
                                                mentionedUsersList
                                                    .add(s.memberId!);
                                                print(mentionedUsersList);
                                                String? str;
                                                _controller.text
                                                    .split(" ")
                                                    .forEach((element) {
                                                  if (element.startsWith("@")) {
                                                    str = element;
                                                  }
                                                });
                                                String? data = _controller.text;
                                                data = _controller.text
                                                    .substring(
                                                        0,
                                                        data.length -
                                                            str!.length +
                                                            1);
                                                data += s.shortcode!;
                                                data += " ";
                                                setState(() {
                                                  _controller.text = data!;
                                                  tagList!.userTags = [];
                                                });
                                                _controller.selection =
                                                    TextSelection.fromPosition(
                                                        TextPosition(
                                                            offset: _controller
                                                                .text.length));
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: new Border.all(
                                                          color: Colors.grey,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 2.3.h,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                s.image!),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3.0.w,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 70.0.w,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                s.name!,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              s.varifiedStatus ==
                                                                      1
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              1.0.w),
                                                                      child: Image
                                                                          .network(
                                                                        s.varifiedImage!,
                                                                        height:
                                                                            1.5.h,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 0.2.h,
                                                        ),
                                                        Container(
                                                          width: 70.0.w,
                                                          child: Text(
                                                            s.shortcode!,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize:
                                                                    10.0.sp),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList()),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Divider(
                                        thickness: 0.3,
                                        color: Colors.grey,
                                      ),
                                      _commonListTile(
                                          AppLocalizations.of(
                                            "Tag People",
                                          ), () {
                                        setState(() {
                                          newPost = false;
                                          tagPeople = true;
                                        });
                                      }),
                                      Divider(
                                        thickness: 0.3,
                                        color: Colors.grey,
                                      ),
                                      selectedSubLocation == "" &&
                                              selectedMainLocation == ""
                                          ? _commonListTile(
                                              AppLocalizations.of(
                                                "Add Location",
                                              ), () {
                                              setState(() {
                                                addLocation = true;
                                                newPost = false;
                                              });
                                              print(addLocation);
                                            })
                                          : _locationListTile(),
                                      Divider(
                                        thickness: 0.3,
                                        color: Colors.grey,
                                      ),
                                      destinationLink == ""
                                          ? _commonListTile(
                                              AppLocalizations.of(
                                                "Add Destination Link",
                                              ), () {
                                              showModalBottomSheet(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(15.0),
                                                          topRight: const Radius
                                                              .circular(15.0))),
                                                  //isScrollControlled:true,
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return _destinationBottomSheet();
                                                  });
                                            })
                                          : _linkListTile(),
                                      Divider(
                                        thickness: 0.3,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      )
                    : addLocation
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.0.h,
                            ),
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.0.w),
                                      child: TextFormField(
                                        onChanged: (val) {
                                          print("called");
                                          getPlaces(_searchController.text);
                                        },
                                        maxLines: null,
                                        controller: _searchController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                            size: 3.5.h,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              _searchController.clear();
                                            },
                                            padding: EdgeInsets.all(0),
                                            constraints: BoxConstraints(),
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.grey,
                                              size: 3.5.h,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 0.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 0.5),
                                          ),
                                          hintText: AppLocalizations.of(
                                            "Find a location...",
                                          ),
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10.0.sp),
                                        ),
                                      ),
                                    ),
                                    hasPlaces != null &&
                                            _searchController.text.isNotEmpty
                                        ? ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                placesList!.places.length,
                                            itemBuilder: (context, index) {
                                              var place =
                                                  placesList!.places[index];

                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.5.h),
                                                child: InkWell(
                                                  onTap: () {
                                                    getCoordinates(
                                                        place.formattedAddress);
                                                    setState(() {
                                                      selectedMainLocation !=
                                                          place.name;
                                                      selectedSubLocation = place
                                                          .formattedAddress!;
                                                      addLocation = false;
                                                      newPost = true;
                                                    });
                                                    _searchController.clear();
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  3.0.w),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 92.0.w,
                                                            child: Text(
                                                              place.name!,
                                                              style: blackBold
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11.0.sp),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 92.0.w,
                                                            child: Text(
                                                              place
                                                                  .formattedAddress!,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      11.0.sp,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.transparent,
                            height: 100.0.h,
                            child: PageView.builder(
                                onPageChanged: (val) {
                                  _userSearchController.clear();
                                },
                                itemCount: widget.finalFiles!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      child:
                                          widget.finalFiles![index]!.path
                                                      .endsWith(".png") ||
                                                  widget
                                                      .finalFiles![index]!.path
                                                      .endsWith(".jpg") ||
                                                  widget
                                                      .finalFiles![index]!.path
                                                      .endsWith(".PNG") ||
                                                  widget
                                                      .finalFiles![index]!.path
                                                      .endsWith(".JPG")
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    whoseThis
                                                        ? TextFormField(
                                                            onTap: () {
                                                              setState(() {
                                                                showUsersList =
                                                                    true;
                                                              });
                                                            },
                                                            onChanged: (val) {
                                                              getUserTags(val);
                                                              if (val == "") {
                                                                setState(() {
                                                                  showUsersList =
                                                                      false;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showUsersList =
                                                                      true;
                                                                });
                                                              }
                                                            },
                                                            maxLines: null,
                                                            controller:
                                                                _userSearchController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon: Icon(
                                                                Icons.search,
                                                                size: 3.5.h,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              hintText:
                                                                  AppLocalizations
                                                                      .of(
                                                                "Search for a user",
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      10.0.sp),
                                                            ),
                                                          )
                                                        : Container(),
                                                    _userSearchController
                                                                    .text !=
                                                                "" &&
                                                            showUsersList ==
                                                                true
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        3.0.w,
                                                                    vertical:
                                                                        1.0.h),
                                                            child: Container(
                                                              height: 80.0.h,
                                                              child: areTagsLoaded
                                                                  ? SingleChildScrollView(
                                                                      child: Column(
                                                                          children: tagList!.userTags.map((s) {
                                                                        return Padding(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: 0.8.h),
                                                                          child:
                                                                              InkWell(
                                                                            splashColor:
                                                                                Colors.grey.withOpacity(0.3),
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                onTapMentionedUsers.add(s.memberId!);
                                                                                whoseThis = false;
                                                                              });

                                                                              _userSearchController.clear();

                                                                              setState(() {
                                                                                tagsList[index].add(new Tags(posX, posY, s.shortcode, stackWidgets[index].length - 1));
                                                                                stackWidgets[index][stackWidgets[index].length - 1] = Positioned(
                                                                                    left: tagsList[index][tagsList[index].length - 1].posx,
                                                                                    top: tagsList[index][tagsList[index].length - 1].posy,
                                                                                    child: ElevatedButton(
                                                                                      // elevation: 0,
                                                                                      style: ButtonStyle(
                                                                                        elevation: MaterialStateProperty.all(0),
                                                                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                                                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                                                      ),
                                                                                      // splashColor: Colors.transparent,
                                                                                      // disabledColor: Colors.transparent,
                                                                                      // padding: EdgeInsets.zero,
                                                                                      // color: Colors.transparent,
                                                                                      onPressed: () {
                                                                                        for (int i = 0; i < tagsList[index].length; i++) {
                                                                                          if (tagsList[index][i].name == s.shortcode) {
                                                                                            setState(() {
                                                                                              stackWidgets[index][i + 1] = Positioned(
                                                                                                left: tagsList[index][tagsList[index].length - 1].posx,
                                                                                                top: tagsList[index][tagsList[index].length - 1].posy,
                                                                                                child: Container(
                                                                                                  decoration: new BoxDecoration(
                                                                                                    color: Colors.black87,
                                                                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                                    shape: BoxShape.rectangle,
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          tagsList[index][tagsList[index].length - 1].name!,
                                                                                                          style: TextStyle(color: Colors.white, fontSize: 8.0.sp),
                                                                                                        ),
                                                                                                        SizedBox(width: 6),
                                                                                                        IconButton(
                                                                                                          icon: Icon(
                                                                                                            Icons.close,
                                                                                                            color: Colors.white,
                                                                                                            size: 20,
                                                                                                          ),
                                                                                                          onPressed: () {
                                                                                                            for (int i = 0; i < tagsList[index].length; i++) {
                                                                                                              if (tagsList[index][i].name == s.shortcode) {
                                                                                                                setState(() {
                                                                                                                  stackWidgets[index].removeAt(i + 1);
                                                                                                                  tagsList[index].removeAt(i);
                                                                                                                });
                                                                                                              }
                                                                                                            }
                                                                                                            setState(() {
                                                                                                              whoseThis = false;
                                                                                                            });
                                                                                                          },
                                                                                                          padding: EdgeInsets.all(0),
                                                                                                          constraints: BoxConstraints(),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                        setState(() {
                                                                                          whoseThis = false;
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: new BoxDecoration(
                                                                                          color: Colors.black54,
                                                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                          shape: BoxShape.rectangle,
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
                                                                                          child: Text(
                                                                                            tagsList[index][tagsList[index].length - 1].name!,
                                                                                            style: TextStyle(color: Colors.white, fontSize: 8.0.sp),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ));
                                                                                showUsersList = false;
                                                                                tagList!.userTags.clear();
                                                                              });

                                                                              for (int j = 0; j < tagsList[index].length; j++) {
                                                                                print("img_response_" + (index + 1).toString() + "^^" + tagsList[index][j].posx!.toStringAsFixed(2) + "^^" + tagsList[index][j].posy!.toStringAsFixed(2) + "^^" + tagsList[index][j].name!);
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              color: Colors.transparent,
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: new BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      border: new Border.all(
                                                                                        color: Colors.grey,
                                                                                        width: 0.5,
                                                                                      ),
                                                                                    ),
                                                                                    child: CircleAvatar(
                                                                                      radius: 2.3.h,
                                                                                      backgroundColor: Colors.transparent,
                                                                                      backgroundImage: NetworkImage(s.image!),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 3.0.w,
                                                                                  ),
                                                                                  Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 70.0.w,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              s.name!,
                                                                                              style: TextStyle(color: Colors.black, fontSize: 10.0.sp, fontWeight: FontWeight.bold),
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                            ),
                                                                                            s.varifiedStatus == 1
                                                                                                ? Padding(
                                                                                                    padding: EdgeInsets.only(left: 1.0.w),
                                                                                                    child: Image.network(
                                                                                                      s.varifiedImage!,
                                                                                                      height: 1.5.h,
                                                                                                    ),
                                                                                                  )
                                                                                                : Container()
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 0.2.h,
                                                                                      ),
                                                                                      Container(
                                                                                        width: 70.0.w,
                                                                                        child: Text(
                                                                                          s.shortcode!,
                                                                                          style: TextStyle(color: Colors.grey, fontSize: 10.0.sp),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList()),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTapDown:
                                                                (TapDownDetails
                                                                        details) =>
                                                                    _onTapDown(
                                                                        details,
                                                                        index),
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              height: 50.0.h,
                                                              child: Stack(
                                                                children:
                                                                    stackWidgets[
                                                                        index],
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    showVideoKeyboard
                                                        ? TextFormField(
                                                            onTap: () {
                                                              setState(() {
                                                                showUsersList =
                                                                    true;
                                                              });
                                                            },
                                                            onChanged: (val) {
                                                              getUserTags(val);
                                                              if (val == "") {
                                                                setState(() {
                                                                  showUsersList =
                                                                      false;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showUsersList =
                                                                      true;
                                                                });
                                                              }
                                                            },
                                                            maxLines: null,
                                                            controller:
                                                                _videoUserSearchController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon: Icon(
                                                                Icons.search,
                                                                size: 3.5.h,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              hintText:
                                                                  AppLocalizations
                                                                      .of(
                                                                "Search for a user",
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      10.0.sp),
                                                            ),
                                                          )
                                                        : Container(),
                                                    tagList != null &&
                                                            tagList!.userTags
                                                                    .length >
                                                                0 &&
                                                            _videoUserSearchController
                                                                .text.isNotEmpty
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        3.0.w,
                                                                    vertical:
                                                                        1.5.h),
                                                            child: Container(
                                                              height: 80.0.h,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                    children: tagList!
                                                                        .userTags
                                                                        .map(
                                                                            (s) {
                                                                  return Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            0.8.h),
                                                                    child:
                                                                        InkWell(
                                                                      splashColor: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
                                                                      onTap:
                                                                          () {
                                                                        var tag = s.image! +
                                                                            " " +
                                                                            s.name! +
                                                                            " " +
                                                                            s.shortcode!;
                                                                        setState(
                                                                            () {
                                                                          showVideoKeyboard =
                                                                              false;
                                                                          videoTagsShortcode.add("video_${index.toString()}" +
                                                                              "^^" +
                                                                              s.memberId!);
                                                                          videoTagsMemberID
                                                                              .add(s.memberId!);
                                                                          tagList!.userTags =
                                                                              [];
                                                                          _videoUserSearchController
                                                                              .clear();
                                                                          videoTagsList
                                                                              .userTags
                                                                              .add(s);
                                                                          print(videoTagsList
                                                                              .userTags
                                                                              .length);
                                                                        });
                                                                        print(videoTagsShortcode
                                                                            .join("~~~"));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              decoration: new BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                border: new Border.all(
                                                                                  color: Colors.grey,
                                                                                  width: 0.5,
                                                                                ),
                                                                              ),
                                                                              child: CircleAvatar(
                                                                                radius: 2.3.h,
                                                                                backgroundColor: Colors.transparent,
                                                                                backgroundImage: NetworkImage(s.image!),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 3.0.w,
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                Container(
                                                                                  width: 70.0.w,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        s.name!,
                                                                                        style: TextStyle(color: Colors.black, fontSize: 10.0.sp, fontWeight: FontWeight.bold),
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                      s.varifiedStatus == 1
                                                                                          ? Padding(
                                                                                              padding: EdgeInsets.only(left: 1.0.w),
                                                                                              child: Image.network(
                                                                                                s.varifiedImage!,
                                                                                                height: 1.5.h,
                                                                                              ),
                                                                                            )
                                                                                          : Container()
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 0.2.h,
                                                                                ),
                                                                                Container(
                                                                                  width: 70.0.w,
                                                                                  child: Text(
                                                                                    s.shortcode!,
                                                                                    style: TextStyle(color: Colors.grey, fontSize: 10.0.sp),
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList()),
                                                              ),
                                                            ),
                                                          )
                                                        : Column(
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  /*Positioned(
                                                                child: Align(
                                                                    alignment: Alignment.center,
                                                                    child: Container(

                                                                      height: 50.0.h,
                                                                      width: 100.0.w,
                                                                      color: Colors.black,)),
                                                              ),*/
                                                                  Container(
                                                                      height:
                                                                          50.0
                                                                              .h,
                                                                      width:
                                                                          100.0
                                                                              .w,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            showVideoKeyboard =
                                                                                true;
                                                                          });
                                                                        },
                                                                        child: Container(
                                                                            child: widget.from == "editor"
                                                                                ? Container(
                                                                                    color: Colors.white,
                                                                                    height: 50.0.h,
                                                                                    width: 100.0.w,
                                                                                    child: Image.memory(
                                                                                      widget.unit8list!,
                                                                                      fit: BoxFit.cover,
                                                                                    ))
                                                                                : Image.memory(
                                                                                    widget.thumbs![index],
                                                                                    fit: BoxFit.cover,
                                                                                  )),
                                                                      )),
                                                                ],
                                                              ),
                                                              videoTagsList
                                                                      .userTags
                                                                      .isNotEmpty
                                                                  ? Container(
                                                                      height:
                                                                          42.0.h,
                                                                      child: ListView.builder(
                                                                          itemCount: videoTagsList.userTags.length,
                                                                          itemBuilder: (context, index) {
                                                                            var user =
                                                                                videoTagsList.userTags[index];
                                                                            return Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.0.w),
                                                                              child: Container(
                                                                                color: Colors.transparent,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: new BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            border: new Border.all(
                                                                                              color: Colors.grey,
                                                                                              width: 0.5,
                                                                                            ),
                                                                                          ),
                                                                                          child: CircleAvatar(
                                                                                            radius: 2.3.h,
                                                                                            backgroundColor: Colors.transparent,
                                                                                            backgroundImage: NetworkImage(user.image!),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 3.0.w,
                                                                                        ),
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                              width: 70.0.w,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    user.name!,
                                                                                                    style: TextStyle(color: Colors.black, fontSize: 10.0.sp, fontWeight: FontWeight.bold),
                                                                                                    maxLines: 1,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                  ),
                                                                                                  user.varifiedStatus == 1
                                                                                                      ? Padding(
                                                                                                          padding: EdgeInsets.only(left: 1.0.w),
                                                                                                          child: Image.network(
                                                                                                            user.varifiedImage!,
                                                                                                            height: 1.5.h,
                                                                                                          ),
                                                                                                        )
                                                                                                      : Container()
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 0.2.h,
                                                                                            ),
                                                                                            Container(
                                                                                              width: 75.0.w,
                                                                                              child: Text(
                                                                                                user.shortcode!,
                                                                                                style: TextStyle(color: Colors.grey, fontSize: 10.0.sp),
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    IconButton(
                                                                                        padding: EdgeInsets.all(0),
                                                                                        constraints: BoxConstraints(),
                                                                                        icon: Icon(
                                                                                          Icons.close,
                                                                                          color: Colors.grey,
                                                                                          size: 3.5.h,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            videoTagsList.userTags.removeAt(index);
                                                                                            videoTagsShortcode.removeAt(index);
                                                                                            videoTagsMemberID.removeAt(index);
                                                                                          });
                                                                                        })
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          42.0.h,
                                                                    )
                                                            ],
                                                          )
                                                  ],
                                                ));
                                }),
                          ),
              ),
            ),
          ),
        ));
  
  }
}

class FittedVideoPlayerThumbnail extends StatefulWidget {
  FittedVideoPlayerThumbnail({Key? key, this.video, this.image})
      : super(key: key);

  final File? video;
  final int? image;

  @override
  _FittedVideoPlayerThumbnailState createState() =>
      _FittedVideoPlayerThumbnailState();
}

class _FittedVideoPlayerThumbnailState
    extends State<FittedVideoPlayerThumbnail> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.file(widget.video!);
    controller.initialize().then((_) {
      setState(() {});
      controller.pause();
      controller.setLooping(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispppppposeeeeeee");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      body: Center(
          child: controller.value != null && controller.value.isInitialized
              ? ClipRRect(
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: controller.value.size.height,
                        width: controller.value.size.width,
                        child: VideoPlayer(controller),
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
