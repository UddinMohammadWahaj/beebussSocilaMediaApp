import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/models/uploaded_files_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:dio/dio.dart';
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
import 'package:bizbultest/widgets/Shortbuz/flexible_video_player.dart';

class UploadVideoFromStory extends StatefulWidget {
  final List<String>? finalFiles;
  final int? height;
  final int? width;
  final Function? clear;
  final Function? refresh;
  final String? from;
  final int? crop;
  final int? hasVideo;
  final FileElement? file;
  final bool? isSingleVideoFromStory;

  UploadVideoFromStory(
      {Key? key,
      this.finalFiles,
      this.clear,
      this.height,
      this.width,
      this.refresh,
      this.from,
      this.crop,
      this.hasVideo,
      this.file,
      this.isSingleVideoFromStory})
      : super(key: key);

  @override
  _UploadVideoFromStoryState createState() => _UploadVideoFromStoryState();
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

class _UploadVideoFromStoryState extends State<UploadVideoFromStory> {
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
                AppLocalizations.of("Who's this?"),
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
              AppLocalizations.of("Who's this?"),
              style: TextStyle(color: Colors.white, fontSize: 8.0.sp),
            ),
          ),
        ),
      );
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getPlaces(text) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_upload_photo.php?action=location_sugession&keywords=$text");

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/locationSuggestion?keywords=$text');
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!!);
    var client = Dio();
    var response = await client
        .postUri(newurl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }))
        .then((value) => value);
    //print(response.body);
    if (response.statusCode == 200) {
      // Places placeData = Places.fromJson(jsonDecode(response.body));
      print("Places suggestion response=${response}");
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
    setState(() {
      feedVideo = widget.hasVideo!;
    });
    print(feedVideo.toString() + " hassssssss videos");
  }

  Future<void> uploadVideoPost(String allTags, String allHashtags) async {
    bool isVideoFromStory = true;
    var request = mp.MultipartRequest();

    String url =
        "https://www.upload.bebuzee.com/video_upload_api.php?action=upload_feed_post_video&user_id=${CurrentUser().currentUser.memberID}&user=${CurrentUser().currentUser.memberID}&all_tagged_id_val=${onTapMentionedUsers.join(",")}&url_data=${_linkController.text}&all_tag=$allTags&location=$selectedSubLocation&lat=$lat&lng=$long&all_hastags=$allHashtags&img_width=${widget.width.toString()}&img_height=${widget.height.toString()}&all_mentioned=${mentionedUsersList.join(",")}&video_tagged_people=${videoTagsMemberID.join(",")}&video_tagged_people_string=${videoTagsShortcode.join("~~~")}&cropped=${crop.toString()}&feed_video=$feedVideo&video_height=$videoHeight&video_width=$videoWidth&description=${_controller.text.replaceAll("#", "~~~")}&video_url=${widget.file!.image}&post_id=${widget.file!.id}&story_id=${widget.file!.storyId}";
    widget.refresh!(request, url, isVideoFromStory);
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

  List<String> imgResponse = [];
  late UserTags tagList;
  UserTags videoTagsList = new UserTags([]);
  bool areTagsLoaded = false;

  Future<void> getUserTags(String searchedTag) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      UserTags tagsData = UserTags.fromJson(jsonDecode(response.body));

      if (mounted) {
        setState(() {
          tagList = tagsData;
          areTagsLoaded = true;
        });
      }
    }

    if (response.body == null || response.statusCode != 200) {
      setState(() {
        areTagsLoaded = false;
      });
    }
  }

  int crop = 0;

  @override
  void initState() {
    print(widget.width);
    print(widget.height);
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
    print(crop.toString() + " croppppppp");
    // uploadFiles();
    widget.finalFiles!.forEach((element) {
      setState(() {
        tagsList.add([]);
        stackWidgets.add([
          Image.network(
            element,
            fit: widget.crop == 1 ? BoxFit.cover : BoxFit.contain,
            height: 50.0.h,
            width: 100.0.w,
          ),
        ]);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            newPost
                ? AppLocalizations.of(
                    "New Post",
                  )
                : addLocation
                    ? AppLocalizations.of(
                        "Select a location",
                      )
                    : AppLocalizations.of(
                        "Tag people",
                      ),
            style: TextStyle(fontSize: 15.0.sp, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
              splashRadius: 20,
              padding: EdgeInsets.symmetric(horizontal: 5),
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
                    tagsList.clear();
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
                    if (widget.isSingleVideoFromStory!) {
                      uploadVideoPost(taggedUsers.join("~~~"),
                          hashtags.join(',').replaceAll("#", "~~~"));
                    } else {}
                    /*_scaffoldKey.currentState.showSnackBar(showSnackBar('Posting'));
                          Timer(Duration(seconds: 2), () {
                            uploadPost(taggedUsers.join("~~~"), hashtags.join(','));
                            _scaffoldKey.currentState.showSnackBar(showSnackBar('Posted Successfully'));
                          });*/

                    if (widget.from == "capture") {
                      // widget.refresh();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else if (widget.from == "direct") {
                      // widget.refresh();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else if (widget.from == "editor") {
                      // widget.refresh();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else if (widget.from == "stories") {
                      // widget.refresh();

                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      //widget.refresh();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                }),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (widget.clear != null) {
              widget.clear!();
            }
            Navigator.pop(context);
            return true;
          },
          child: SingleChildScrollView(
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
                                    Image.network(
                                      widget.finalFiles![0],
                                      height: 7.0.h,
                                      width: 15.0.w,
                                      fit: BoxFit.cover,
                                    ),
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
                                          tagList.userTags = [];
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
                                  tagList.userTags.length > 0 &&
                                  _controller.text.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.0.w, vertical: 1.5.h),
                                  child: Container(
                                    height: 80.0.h,
                                    child: SingleChildScrollView(
                                      child: Column(
                                          children: tagList.userTags.map((s) {
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
                                              String data = _controller.text;
                                              data = _controller.text.substring(
                                                  0,
                                                  data.length -
                                                      str!.length +
                                                      1);
                                              data += s.shortcode!;
                                              data += " ";
                                              setState(() {
                                                _controller.text = data;
                                                tagList.userTags = [];
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
                                                                        left: 1.0
                                                                            .w),
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
                                                          overflow: TextOverflow
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
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.0.w),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              newPost = false;
                                              tagPeople = true;
                                            });
                                          },
                                          child: Container(
                                            width: 100.0.w,
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.5.h),
                                              child: Text(
                                                AppLocalizations.of(
                                                  "Tag People",
                                                ),
                                                style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          )),
                                    ),
                                    Divider(
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.0.w),
                                      child: selectedSubLocation == "" &&
                                              selectedMainLocation == ""
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  addLocation = true;
                                                  newPost = false;
                                                });
                                                print(addLocation);
                                              },
                                              child: Container(
                                                width: 100.0.w,
                                                color: Colors.transparent,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.5.h),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      "Add Location",
                                                    ),
                                                    style: TextStyle(
                                                        fontSize: 12.0.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ))
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  addLocation = true;
                                                });
                                              },
                                              child: Container(
                                                width: 100.0.w,
                                                color: Colors.transparent,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.5.h),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 85.0.w,
                                                            child: Text(
                                                              selectedMainLocation,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 85.0.w,
                                                            child: Text(
                                                              selectedSubLocation,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          constraints:
                                                              BoxConstraints(),
                                                          icon: Icon(
                                                            Icons.close,
                                                            size: 3.5.h,
                                                            color: Colors.grey,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedSubLocation =
                                                                  "";
                                                              selectedMainLocation =
                                                                  "";
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    ),
                                    Divider(
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.0.w),
                                      child: destinationLink == ""
                                          ? InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: const Radius
                                                                .circular(20.0),
                                                            topRight: const Radius
                                                                    .circular(
                                                                20.0))),
                                                    //isScrollControlled:true,
                                                    context: context,
                                                    builder: (BuildContext bc) {
                                                      return Container(
                                                        child: Wrap(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3.0.w,
                                                                      vertical:
                                                                          2.0.h),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            destinationLink =
                                                                                _linkController.text;
                                                                          });

                                                                          print(
                                                                              destinationLink);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              4.5.h,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4.0.w,
                                                                      ),
                                                                      Text(
                                                                        AppLocalizations
                                                                            .of(
                                                                          "Destination Website",
                                                                        ),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.0.sp,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            destinationLink =
                                                                                _linkController.text;
                                                                          });

                                                                          print(
                                                                              destinationLink);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Container(
                                                                            color: Colors.black,
                                                                            child: Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.0.h),
                                                                              child: Text(
                                                                                AppLocalizations.of("Add"),
                                                                                style: whiteBold.copyWith(fontSize: 12.0.sp),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          2.0.h),
                                                              child:
                                                                  TextFormField(
                                                                onChanged:
                                                                    (val) {},
                                                                maxLines: null,
                                                                controller:
                                                                    _linkController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                decoration:
                                                                    InputDecoration(
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(12.0)),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            1),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  hintText:
                                                                      AppLocalizations
                                                                          .of(
                                                                    "Destination Link",
                                                                  ),
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          10.0.sp),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                width: 100.0.w,
                                                color: Colors.transparent,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.5.h),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      "Add Destination Link",
                                                    ),
                                                    style: TextStyle(
                                                        fontSize: 12.0.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ))
                                          : Text(
                                              destinationLink,
                                              style: blackBold.copyWith(
                                                  fontSize: 14.0.sp,
                                                  color: Colors.black),
                                            ),
                                    ),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    child: TextFormField(
                                      onChanged: (val) {
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
                                          itemCount: placesList!.places.length,
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
                                                    selectedMainLocation =
                                                        place!.name!;
                                                    selectedSubLocation = place!
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
                                                            horizontal: 3.0.w),
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
                                    child: Column(
                                  children: [
                                    showVideoKeyboard
                                        ? TextFormField(
                                            onTap: () {
                                              setState(() {
                                                showUsersList = true;
                                              });
                                            },
                                            onChanged: (val) {
                                              getUserTags(val);
                                              if (val == "") {
                                                setState(() {
                                                  showUsersList = false;
                                                });
                                              } else {
                                                setState(() {
                                                  showUsersList = true;
                                                });
                                              }
                                            },
                                            maxLines: null,
                                            controller:
                                                _videoUserSearchController,
                                            keyboardType: TextInputType.text,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.search,
                                                size: 3.5.h,
                                                color: Colors.black,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 1),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              hintText: AppLocalizations.of(
                                                "Search for a user",
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10.0.sp),
                                            ),
                                          )
                                        : Container(),
                                    tagList != null &&
                                            tagList.userTags.length > 0 &&
                                            _videoUserSearchController
                                                .text.isNotEmpty
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.0.w,
                                                vertical: 1.5.h),
                                            child: Container(
                                              height: 80.0.h,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                    children: tagList.userTags
                                                        .map((s) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0.8.h),
                                                    child: InkWell(
                                                      splashColor: Colors.grey
                                                          .withOpacity(0.3),
                                                      onTap: () {
                                                        var tag = s.image! +
                                                            " " +
                                                            s.name! +
                                                            " " +
                                                            s.shortcode!;
                                                        setState(() {
                                                          showVideoKeyboard =
                                                              false;
                                                          videoTagsShortcode.add(
                                                              "video_${index.toString()}" +
                                                                  "^^" +
                                                                  s.memberId!);
                                                          videoTagsMemberID
                                                              .add(s.memberId!);
                                                          tagList.userTags = [];
                                                          _videoUserSearchController
                                                              .clear();
                                                          videoTagsList.userTags
                                                              .add(s);
                                                          print(videoTagsList
                                                              .userTags.length);
                                                        });
                                                        print(videoTagsShortcode
                                                            .join("~~~"));
                                                      },
                                                      child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    new Border
                                                                        .all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 2.3.h,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
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
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 10.0.sp,
                                                                            fontWeight: FontWeight.bold),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      s.varifiedStatus ==
                                                                              1
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
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
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
                                                      height: 50.0.h,
                                                      width: 100.0.w,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            showVideoKeyboard =
                                                                true;
                                                          });
                                                        },
                                                        child: Container(
                                                            child:
                                                                Image.network(
                                                          widget.finalFiles![0],
                                                          fit: BoxFit.cover,
                                                        )),
                                                      )),
                                                ],
                                              ),
                                              videoTagsList.userTags.isNotEmpty
                                                  ? Container(
                                                      height: 42.0.h,
                                                      child: ListView.builder(
                                                          itemCount:
                                                              videoTagsList
                                                                  .userTags
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var user =
                                                                videoTagsList
                                                                        .userTags[
                                                                    index];
                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          1.5.h,
                                                                      horizontal:
                                                                          3.0.w),
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              new BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border:
                                                                                new Border.all(
                                                                              color: Colors.grey,
                                                                              width: 0.5,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                2.3.h,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            backgroundImage:
                                                                                NetworkImage(user.image!),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              3.0.w,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
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
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                0),
                                                                        constraints:
                                                                            BoxConstraints(),
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              3.5.h,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
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
                                                      height: 42.0.h,
                                                    )
                                            ],
                                          )
                                  ],
                                ));
                              }),
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
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.size?.width ?? 0,
                      height: controller.value.size?.height ?? 0,
                      child: VideoPlayer(controller),
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
