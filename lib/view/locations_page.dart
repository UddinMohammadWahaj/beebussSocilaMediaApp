import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:dio/dio.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'expanded_feed.dart';
import 'package:latlong2/latlong.dart' as latlng;

class LocationPage extends StatefulWidget {
  final String? logo;
  final String? locationName;
  final String? country;
  final String? memberID;
  final NewsFeedModel? feed;
  final String? latitude;
  final String? longitude;
  final String? memberImage;

  LocationPage(
      {Key? key,
      this.logo,
      this.memberID,
      this.feed,
      this.country,
      this.locationName,
      this.latitude,
      this.longitude,
      this.memberImage})
      : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late AllFeeds locationsList;
  bool arePostsLoaded = false;
  bool coordinatesLoaded = false;
  late bool showDialogue;

  Future<void> getCoordinates() async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/locationLetLong?location=${widget.locationName}');

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
        "https://www.bebuzee.com/app_devlope.php?action=get_latlong_location_data&location=${widget.locationName}");

    // var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {});
    }

    if (response.data == null || response.statusCode != 200) {
      setState(() {
        coordinatesLoaded = false;
      });
    }
  }

  Future<void> getPosts() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/location_data_api_call.php?action=fetch_post_data_location&location_name=${widget.feed.postHeaderLocation}&user_id=${CurrentUser().currentUser.memberID}");
    // print("getPosts= ${widget.feed}");

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/newsfeed/list?location_name=${widget.locationName}&user_id=${CurrentUser().currentUser.memberID}&country=${widget.country}');
    print("getPosts called");
    var client = Dio();
    print("getPosts of Location page called ${newurl}");

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

    if (response.data == null ||
        response.statusCode != 200 ||
        response.data['success'] == 0) {
      setState(() {
        arePostsLoaded = false;
      });
    }
    // print(
    //       "response of location page=${response.data} s= ${locationsList.feeds.length}");
    if (response.statusCode == 200) {
      AllFeeds locationsData = AllFeeds.fromJson(response.data['data']);
      // print(locationsData.feeds[0].postId);
      if (mounted) {
        setState(() {
          print("loc have data");
          locationsList = locationsData;
          arePostsLoaded = true;
        });
      }
    }
  }

  var url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";

  @override
  void initState() {
    setState(() {
      url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
    });
    print(url);
    getPosts();

    Timer(Duration(seconds: 4), () async {
      print("value of dialog is " + showDialogue.toString());
      if (arePostsLoaded == false) {
        setState(() {
          showDialogue = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.0.w, top: 5.0.h, right: 3.0.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_backspace_outlined,
                          size: 27,
                        )),
                    SizedBox(
                      width: 4.0.w,
                    ),
                    Container(
                        width: 80.0.w,
                        child: Text(
                          widget.locationName!,
                          style: blackBold.copyWith(fontSize: 18),
                        ))
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 3.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.black.withOpacity(0.6),
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2.4.w),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                    Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: new Border.all(
                            color: Colors.black.withOpacity(0.6),
                            width: 0.5,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.w, horizontal: 15.0.w),
                          child: Text(
                            AppLocalizations.of(
                              "More Information",
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    center: latlng.LatLng(double.parse(widget.latitude!),
                        double.parse(widget.longitude!)),
                    zoom: 14.0,
                  ),
                  // layers: [
                  //   new TileLayerOptions(
                  //       urlTemplate: url, subdomains: ['a', 'b', 'c']),
                  //   new MarkerLayerOptions(
                  //     markers: [
                  //       new Marker(
                  //         width: 80.0,
                  //         height: 80.0,
                  //         point: latlng.LatLng(double.parse(widget.latitude!),
                  //             double.parse(widget.longitude!)),
                  //         builder: (ctx) => new Container(
                  //           child: Icon(
                  //             CustomIcons.pointer,
                  //             color: Colors.lightBlue[900],
                  //             size: 25,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ],
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              showDialogue == true
                  ? Container(
                      child: Text(
                        AppLocalizations.of(
                          "No posts for this location yet",
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : arePostsLoaded == false
                      ? Center(
                          child: Container(
                              height: 50.0.h,
                              width: 50.0.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  loadingAnimation(),
                                ],
                              )))
                      : arePostsLoaded == true
                          ? StaggeredGridView.countBuilder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              itemCount: locationsList.feeds.length,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // print(locationsList.feeds[index].postType);
                                    // print(locationsList.feeds[index].postId);
                                    //print(locationsList.feeds[index].postMemberId);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ExpandedFeed(
                                                  currentMemberImage:
                                                      widget.memberImage!,
                                                  from: "Location",
                                                  postImgData: locationsList
                                                      .feeds[index].postImgData,
                                                  postMultiImage: locationsList
                                                      .feeds[index]
                                                      .postMultiImage,
                                                  postHeaderLocation:
                                                      locationsList.feeds[index]
                                                          .postHeaderLocation,
                                                  timeStamp: locationsList
                                                      .feeds[index].timeStamp,
                                                  postRebuzData: locationsList
                                                      .feeds[index]
                                                      .postRebuzData,
                                                  postContent: locationsList
                                                      .feeds[index].postContent,
                                                  postUserPicture: locationsList
                                                      .feeds[index]
                                                      .postUserPicture,
                                                  postShortcode: locationsList
                                                      .feeds[index]
                                                      .postShortcode,
                                                  feed: locationsList
                                                      .feeds[index],
                                                  postType: locationsList
                                                      .feeds[index].postType,
                                                  postID: locationsList
                                                      .feeds[index].postId,
                                                  postUserId: locationsList
                                                      .feeds[index].postUserId,
                                                  logo: widget.logo!,
                                                  country: widget.country!,
                                                  memberID: widget.memberID!,
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: (locationsList.feeds[index].postImgData!
                                                        .endsWith(".mp4") ||
                                                    locationsList.feeds[index].postImgData!
                                                        .endsWith(".m3u8")) &&
                                                locationsList.feeds[index].postMultiImage ==
                                                    0
                                            ? Image.network(
                                                locationsList
                                                    .feeds[index].postImgData!
                                                    .replaceAll(".mp4", ".jpg"),
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext? context,
                                                        Widget? child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child!;
                                                  return Center(
                                                      child: Container(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                  ));
                                                },
                                              )
                                            : locationsList.feeds[index].postMultiImage == 1 &&
                                                    (locationsList.feeds[index]
                                                            .postImgData!
                                                            .split("~~")[0]
                                                            .toString()
                                                            .endsWith(".mp4") ||
                                                        locationsList
                                                            .feeds[index]
                                                            .postImgData!
                                                            .split("~~")[0]
                                                            .toString()
                                                            .endsWith(".m3u8"))
                                                ? Image.network(
                                                    locationsList.feeds[index]
                                                        .postImgData!
                                                        .split("~~")[0]
                                                        .toString()
                                                        .replaceAll(
                                                            ".mp4", ".jpg"),
                                                    fit: BoxFit.cover,
                                                    loadingBuilder:
                                                        (BuildContext? context,
                                                            Widget? child,
                                                            ImageChunkEvent?
                                                                loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child!;
                                                      return Center(
                                                          child: Container(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                      ));
                                                    },
                                                  )
                                                : locationsList.feeds[index].postMultiImage == 1 &&
                                                        (locationsList.feeds[index].postImgData!.split("~~")[0].toString().endsWith(".mp4") ||
                                                            locationsList
                                                                .feeds[index]
                                                                .postImgData!
                                                                .split("~~")[0]
                                                                .toString()
                                                                .endsWith(".m3u8"))
                                                    ? Image.network(
                                                        locationsList
                                                            .feeds[index]
                                                            .postImgData!
                                                            .split("~~")[0]
                                                            .toString()
                                                            .replaceAll(
                                                                ".mp4", ".jpg"),
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (BuildContext?
                                                                    context,
                                                                Widget? child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child!;
                                                          return Center(
                                                              child: Container(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                          ));
                                                        },
                                                      )
                                                    : Image.network(
                                                        locationsList
                                                                    .feeds[
                                                                        index]
                                                                    .postMultiImage! ==
                                                                1
                                                            ? locationsList
                                                                .feeds[index]
                                                                .postImgData!
                                                                .split("~~")[0]!
                                                            : locationsList
                                                                .feeds[index]
                                                                .postImgData!,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (BuildContext?
                                                                    context,
                                                                Widget? child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child!;
                                                          return Center(
                                                              child: Container(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                          ));
                                                        },
                                                      ),
                                      ),
                                      locationsList.feeds[index]
                                                  .postMultiImage ==
                                              1
                                          ? Positioned.fill(
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 3.0, right: 3),
                                                    child: Image.asset(
                                                      "assets/images/multiple.png",
                                                      height: 1.0.h,
                                                    ),
                                                  )),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              },
                              staggeredTileBuilder: (index) {
                                return StaggeredTile.fit(1);
                              },
                            )
                          : Container()
            ],
          ),
        ),
      ),
    );
  }
}
