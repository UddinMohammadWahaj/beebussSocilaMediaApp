import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/Adverts/videoad_overview.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:bizbultest/models/video_advertisements_model.dart';

import '../Streaming/preview_video_player.dart';

class UserAdvertisements extends StatefulWidget {
  @override
  _UserAdvertisementsState createState() => _UserAdvertisementsState();
}

class _UserAdvertisementsState extends State<UserAdvertisements> {
  late VideoAdvertisements advertList;
  bool areAdvertsLoaded = false;
  late FlickManager _flickManager;
  Future<void> getAdverts() async {
    var url =
        "https://www.bebuzee.com/api/video_advertisment.php?action=user_advertisment&user_id=${CurrentUser().currentUser.memberID}&all_data_ids=";

    var response = await ApiProvider().fireApi(url).then((value) => value);
    print("response of get adverts=$url");
    if (response.statusCode == 200) {
      VideoAdvertisements advertData =
          VideoAdvertisements.fromJson(response.data['data']);
      //await Future.wait(advertData.adverts.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        Timer(Duration(milliseconds: 50), () {
          setState(() {
            advertList = advertData;
            areAdvertsLoaded = true;
          });
        });
      }
    }
  }

  @override
  void initState() {
    getAdverts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: areAdvertsLoaded
          ? ListView.builder(
              itemCount: advertList.adverts.length,
              itemBuilder: (context, index) {
                var advert = advertList.adverts[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            advert.imageVideo!,
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.0.w, vertical: 2.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              advert.linkTitle!,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0.sp),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0.h),
                              child: Text(
                                AppLocalizations.of(
                                      "Published on",
                                    ) +
                                    " " +
                                    advert.date!,
                                style: TextStyle(fontSize: 10.0.sp),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                          "Views",
                                        ) +
                                        "   " +
                                        advert.totalViews!,
                                    style: TextStyle(fontSize: 12.0.sp),
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                          "Clicks",
                                        ) +
                                        "   " +
                                        advert.totalClicks!,
                                    style: TextStyle(fontSize: 12.0.sp),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print("tapped on view ad");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          appBar: AppBar(
                                              title: Text('Your AD'),
                                              backgroundColor: Colors.black),
                                          body: PreviewVideoPlayer(
                                            flickManager: _flickManager,
                                            url: advert.video,
                                          ),
                                        )));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                child: Center(
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: primaryBlueColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.5.w, vertical: 1.0.h),
                                        child: Text(
                                          AppLocalizations.of(
                                            "View Ad",
                                          ),
                                          style: whiteNormal.copyWith(
                                              fontSize: 12.0.sp),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print("tapped on view ad ${advert.dataId}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoAdsOverview(
                                            // bannerImages: [advert.imageVideo],
                                            dataID: advert.dataId)));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => Scaffold(
                                //           appBar: AppBar(
                                //               title: Text('Your AD'),
                                //               backgroundColor: Colors.black),
                                //           body: PreviewVideoPlayer(
                                //             flickManager: _flickManager,
                                //             url: advert.video,
                                //           ),
                                //         )));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                child: Center(
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: primaryBlueColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.5.w, vertical: 1.0.h),
                                        child: Text(
                                          AppLocalizations.of(
                                            "View Details",
                                          ),
                                          style: whiteNormal.copyWith(
                                              fontSize: 12.0.sp),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                      )
                    ],
                  )),
                );
              },
            )
          : Container(),
    );
  }
}
