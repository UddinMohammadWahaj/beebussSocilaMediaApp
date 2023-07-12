import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Newsfeeds/feeds_menu_otherMember.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:bizbultest/models/insights_model.dart';
import 'dart:convert';

class InsightsPage extends StatefulWidget {
  final String? memberID;
  final String? postID;
  final String? postType;

  InsightsPage({Key? key, this.memberID, this.postID, this.postType})
      : super(key: key);

  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  bool areInsightsLoaded = false;
  var postLikes;
  var postComments;
  var postShares;
  var reach;
  var visits;
  var actions;
  var discovery;
  var impression;
  var follows;

  Future<void> getInsights() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=view_insight_data&post_type=${widget.postType}&post_id=${widget.postID}&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);
    var newurl =
        'https://www.bebuzee.com/api/member_view_insight.php?post_type=${widget.postType}&post_id=${widget.postID}&user_id=${CurrentUser().currentUser.memberID}';
    print("INIGTHS URL=${newurl}");
    var response = await ApiProvider().fireApi(newurl);
    print('insights data= ${response.data}');
    if (response.statusCode == 200) {
      setState(() {
        postComments = (response.data)['data']['total_comments'];
        postLikes = (response.data)['data']['total_likes'];
        postShares = (response.data)['data']['no_of_share'];
        visits = (response.data)['data']['profile_visit'];
        reach = (response.data)['data']['total_reach'];
        actions = (response.data)['data']['action_taken_feom_post'];
        discovery = (response.data)['data']['discovery'];
        impression = (response.data)['data']['impression'];
        follows = (response.data)['data']['follow_count'];

        print("post comments= ${postComments}");

        areInsightsLoaded = true;
      });

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          areInsightsLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    print(widget.postType);
    print(widget.postID);
    print(widget.memberID);
    getInsights();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 7.0.h, horizontal: 4.0.h),
          child: Container(
            width: 90.0.w,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Text(
                      AppLocalizations.of(
                        "Post Insights",
                      ),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                Divider(
                  thickness: 1,
                ),
                areInsightsLoaded
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.0.h),
                        child: Container(
                            child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        CustomIcons.heart,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(postLikes.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        CustomIcons.speech_bubble,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(postComments.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        CustomIcons.send_4007,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        postShares.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.0.h, horizontal: 7.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(visits.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        AppLocalizations.of(
                                          "Profile Visits",
                                        ),
                                        style:
                                            greyNormal.copyWith(fontSize: 17),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(reach.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        AppLocalizations.of(
                                          "Reach",
                                        ),
                                        style:
                                            greyNormal.copyWith(fontSize: 17),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 3.0.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          AppLocalizations.of(
                                            "Interaction",
                                          ),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return InsightsInteraction();
                                                });
                                          },
                                          child: Icon(
                                            Icons.info,
                                            size: 17,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(actions.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  AppLocalizations.of(
                                    "Actions taken from the post",
                                  ),
                                  style: greyNormal.copyWith(fontSize: 17),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          "Profile Visits",
                                        ),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(visits.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          AppLocalizations.of(
                                            "Discovery",
                                          ),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return InsightsDiscovery();
                                              });
                                        },
                                        child: Icon(
                                          Icons.info,
                                          size: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(reach.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  AppLocalizations.of(
                                    "Accounts reached",
                                  ),
                                  style: greyNormal.copyWith(fontSize: 17),
                                ),
                                Text(
                                  discovery.toString() +
                                      "%" " " +
                                      AppLocalizations.of(
                                        "weren't following you",
                                      ),
                                  style: greyNormal.copyWith(fontSize: 17),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.0.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          AppLocalizations.of(
                                            "Impression",
                                          ),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1.5.h),
                                  child: Text(impression.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(1.5.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          "Follows",
                                        ),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(follows.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        AppLocalizations.of(
                                          "Reach",
                                        ),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(reach.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
